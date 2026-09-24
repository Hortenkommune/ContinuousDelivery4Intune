#Requires -RunAsAdministrator
# Remove OEM McAfee (WPS + WebAdvisor) to zero trace. Idempotent, runs at every logon via
# CD4Intune; self-completes across the reboot the boot-driver removal needs. PS 5.1 safe.
$ErrorActionPreference = 'Stop'
$LogFile = 'C:\Windows\Temp\Remove-McAfee.log'
function Log([string]$m) { $line = "{0}  {1}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $m; Add-Content -Path $LogFile -Value $line; Write-Host $line }

$Url = 'https://files.horten.kommune.no/cd4intune/mcpr-oem-20220323.zip'
$Sha = '8C37D1CD9CD7A24259E0B655BEC657FEB80CEBC7CC976A76536FCE1C43F7F0DE'
$Zip = Join-Path $env:TEMP 'mcpr-oem.zip'
$Dir = Join-Path $env:TEMP ('mcpr-oem-' + [Guid]::NewGuid().ToString('N').Substring(0, 8))
$Products = 'StopServices,MFSY,PEF,MXD,CSP,Sustainability,MOCP,MFP,APPSTATS,Auth,EMproxy,FWdiver,HW,MAS,MAT,MBK,MCPR,McProxy,McSvcHost,VUL,MHN,MNA,MOBK,MPFP,MPFPCU,MPS,SHRED,MPSCU,MQC,MQCCU,MSAD,MSHR,MSK,MSKCU,MWL,NMC,RedirSvc,VS,REMEDIATION,MSC,YAP,TRUEKEY,LAM,PCB,Symlink,SafeConnect,MGS,WMIRemover,RESIDUE,WPS,MSSPlus'
$WpsUninstall = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\McAfee.wps'

# --- take-ownership helper: enable privileges once, then hard-remove TrustedInstaller-locked keys ---
if (-not ('Priv' -as [type])) {
    Add-Type @'
using System; using System.Runtime.InteropServices;
public class Priv {
  [DllImport("advapi32.dll", SetLastError=true)] static extern bool OpenProcessToken(IntPtr h, int a, out IntPtr t);
  [DllImport("advapi32.dll", SetLastError=true)] static extern bool LookupPrivilegeValue(string s, string n, out long l);
  [StructLayout(LayoutKind.Sequential, Pack=1)] struct TP { public int Count; public long Luid; public int Attr; }
  [DllImport("advapi32.dll", SetLastError=true)] static extern bool AdjustTokenPrivileges(IntPtr t, bool d, ref TP n, int l, IntPtr p, IntPtr r);
  public static void Enable(string name) {
    IntPtr t; OpenProcessToken(System.Diagnostics.Process.GetCurrentProcess().Handle, 0x28, out t);
    TP tp; tp.Count = 1; tp.Attr = 2; LookupPrivilegeValue(null, name, out tp.Luid);
    AdjustTokenPrivileges(t, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero);
  }
}
'@
}
$script:HKLM = [Microsoft.Win32.Registry]::LocalMachine
$script:Admins = New-Object System.Security.Principal.SecurityIdentifier 'S-1-5-32-544'
$script:System = New-Object System.Security.Principal.SecurityIdentifier 'S-1-5-18'
$script:RW = [Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree
$script:RR = [System.Security.AccessControl.RegistryRights]

function Reset-KeyAcl([string]$path) {
    $k = $HKLM.OpenSubKey($path, $RW, $RR::TakeOwnership); if (-not $k) { return }
    $s = New-Object System.Security.AccessControl.RegistrySecurity
    $s.SetOwner($Admins); $k.SetAccessControl($s); $k.Close()
    $k = $HKLM.OpenSubKey($path, $RW, $RR::ChangePermissions)
    $s = New-Object System.Security.AccessControl.RegistrySecurity
    $s.SetAccessRuleProtection($true, $false)
    foreach ($id in $Admins, $System) {
        $s.AddAccessRule((New-Object System.Security.AccessControl.RegistryAccessRule($id, 'FullControl', 'ContainerInherit', 'None', 'Allow')))
    }
    $k.SetAccessControl($s); $k.Close()
    $k = $HKLM.OpenSubKey($path)
    if ($k) { foreach ($sub in $k.GetSubKeyNames()) { Reset-KeyAcl "$path\$sub" }; $k.Close() }
}
function Remove-KeyHard([string]$path) {
    if (Test-Path "HKLM:\$path") {
        try { Remove-Item "HKLM:\$path" -Recurse -Force -ErrorAction Stop; Log "removed key $path" }
        catch { try { Reset-KeyAcl $path; Remove-Item "HKLM:\$path" -Recurse -Force -ErrorAction Stop; Log "removed key (took ownership) $path" } catch { Log "could not remove key $path : $($_.Exception.Message)" } }
    }
}

try {
    # 1. run the engine only while the product is still registered (skip the ~7 min once gone)
    if (Test-Path $WpsUninstall) {
        Log 'McAfee WPS present - downloading engine'
        $ProgressPreference = 'SilentlyContinue'
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $Url -OutFile $Zip -UseBasicParsing
        if ((Get-FileHash -Path $Zip -Algorithm SHA256).Hash -ne $Sha) { throw 'hash mismatch on MCPR zip' }
        Expand-Archive -Path $Zip -DestinationPath $Dir
        $exe = Join-Path $Dir 'mccleanup.exe'
        $sig = Get-AuthenticodeSignature -FilePath $exe
        if ($sig.Status -ne 'Valid' -or $sig.SignerCertificate.Subject -notmatch 'McAfee') { throw "engine not McAfee-signed (status $($sig.Status))" }
        Log ("engine {0}, signature {1}" -f (Get-Item $exe).VersionInfo.FileVersion, $sig.Status)
        foreach ($pass in 1, 2) {
            $p = Start-Process -FilePath $exe -WorkingDirectory $Dir -ArgumentList "-p $Products -v -s" -PassThru -NoNewWindow -Wait
            Log "mccleanup pass $pass exit code $($p.ExitCode)"
        }
    }
    else { Log 'McAfee WPS uninstall entry absent - skipping engine, cleaning remnants only' }

    $wa = 'C:\Program Files\McAfee\WebAdvisor\Uninstaller.exe'
    if (Test-Path $wa) { Log 'removing WebAdvisor'; Start-Process -FilePath $wa -ArgumentList '-s' -Wait }

    # 2. teardown remnants - best-effort, take-ownership for TrustedInstaller-locked keys
    $ErrorActionPreference = 'SilentlyContinue'
    Set-Location $env:SystemRoot
    $unprot = Get-ChildItem -Path $Dir -Recurse -Filter 'mc-sec-unprotector.exe' | Select-Object -First 1
    if ($unprot) { Log 'running tamper unprotector'; Start-Process -FilePath $unprot.FullName -WorkingDirectory $unprot.DirectoryName -Wait }

    $mcTasks = @(Get-ScheduledTask | Where-Object { $_.TaskPath -like '*McAfee*' })
    foreach ($tk in $mcTasks) { Unregister-ScheduledTask -TaskName $tk.TaskName -TaskPath $tk.TaskPath -Confirm:$false }
    if ($mcTasks.Count -gt 0) { Log "removed $($mcTasks.Count) scheduled task(s)" }

    Remove-KeyHard 'SYSTEM\CurrentControlSet\Services\mc-fw-host'
    Remove-KeyHard 'SYSTEM\CurrentControlSet\Services\mc-wps-update'
    Remove-KeyHard 'SYSTEM\CurrentControlSet\Services\mfesec'
    Remove-KeyHard 'SYSTEM\CurrentControlSet\Services\mfeelam'
    Remove-KeyHard 'SOFTWARE\McAfee'
    Remove-KeyHard 'SOFTWARE\WOW6432Node\McAfee'

    Get-CimInstance -Namespace root\SecurityCenter2 -ClassName AntiVirusProduct |
        Where-Object { $_.displayName -like '*McAfee*' } | Remove-CimInstance

    Remove-Item -Path $Dir -Recurse -Force
    $ErrorActionPreference = 'Stop'

    $stillWps = Test-Path $WpsUninstall
    $stillSvc = [bool](Get-Service mc-fw-host -ErrorAction SilentlyContinue)
    $stillDrv = [bool](Get-CimInstance Win32_SystemDriver -Filter "Name='mfesec'" -ErrorAction SilentlyContinue)
    $stillKey = Test-Path 'HKLM:\SOFTWARE\McAfee'
    if ($stillWps -or $stillSvc -or $stillDrv -or $stillKey) {
        Log ("incomplete this pass (wps=$stillWps svc=$stillSvc drv=$stillDrv key=$stillKey) - reboot; next logon finishes it")
    }
    else { Log 'CLEAN - McAfee fully removed' }
    exit 0
}
catch {
    Log "ERROR: $($_.Exception.Message)"
    exit 1
}
