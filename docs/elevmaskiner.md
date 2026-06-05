# Hvordan fungerer elevmaskiner?

Vi bruker i dag to systemer for å distribuere innstillinger til elevmaskinene våre: **CD4Intune** (egenutviklet) og **Intune**. Dette dokumentet forklarer hvordan de henger sammen, hva som ligger hvor, og hvor helpdesk bør lete når noe ikke virker.

## Oversikt

| System | Distribuerer |
|--------|--------------|
| **Intune** | Autopilot-enrollment, baseline-policyer (Applocker, BitLocker, certs, Wi-Fi, Edge/Chrome ADMX, Start-layout, eksamensbegrensninger), applikasjoner via Firmaportal, oppdateringer via Winget AutoUpdate |
| **CD4Intune** | Skrivebordsikoner og snarveier, registry-innstillinger (HKLM + HKCU), tjeneste-oppstart/stopp, maskinnavn basert på serienummer, OEM-aktivering, eksamensbruker-deteksjon, custom installers, PowerShell-snippets |

Tommelfingerregel: Intune håndterer **policy og apper**, CD4Intune håndterer **det Intune ikke kan eller gjør for tregt**.

---

## CD4Intune

CD4Intune ligger i GitHub: https://github.com/Hortenkommune/ContinuousDelivery4Intune

Dette er en egenutviklet scriptprosess som bruker innstillinger lagret i GitHub til å sette disse på maskinen. Grunnen til at vi laget dette var at da vi begynte å bruke Intune var det mange mangler og ting tok for lang tid, så vi måtte løse det selv. I senere tid har vi flyttet mer og mer over til Intune, men vi ser en del utfordringer rundt ustabilitet og uforutsette hendelser, så vi har fortsatt ikke flyttet alt over – og kommer trolig ikke til å gjøre det heller.

### Branches (én per skole/segment)

Hver maskin er knyttet til én branch i repoet via installasjonsscriptet som dyttes ut fra Intune. Branchen bestemmer hvilken config maskinen henter.

| Branch | Skole/segment |
|--------|---------------|
| `prod.us` | Ungdomsskole |
| `prod.bs` | Barneskole |
| `prod.hovos` | HOVOS |
| `prod.bhg` | Barnehage |
| `prod.bakk` | Bakk |
| `beta` | Test/utvikling |

Configene per branch ligger i `configs/<branch>/` og er delt opp i: `IconsCfg`, `Shortcuts`, `Regedit`, `Services`, `PowerShell`, `Custom Execution`, `Choco` (deaktivert per i dag).

### Versjonering og selv-oppdatering

Ved hver pålogging gjør scriptet først en versjonssjekk mot `versioncontrol/config.json` i repoet. Hvis lokal versjon er eldre, lastes `Install-CDforIntune.ps1` ned og kjøres på nytt, som registrerer Scheduled Task'en på nytt med ny versjon i beskrivelsen. Det betyr at oppdateringer ruller ut automatisk ved neste pålogging – helpdesk trenger ikke gjøre noe manuelt for å få ny config ut.

### Hovedscriptet og Scheduled Task

Selve hovedscriptet dyttes ut via Intune som et **Platform script** per branch:

- `Install-CDforIntune.prod.us.ps1`
- `Install-CDforIntune.prod.bs.ps1`
- `Install-CDforIntune.prod.hovos.ps1`
- `Install-CDforIntune.prod.bhg.ps1`
- `Install-CDforIntune.prod.bakk.ps1`
- `Install-CDforIntune.beta.ps1`

Når dette har kjørt første gang, ligger:
- Hovedscriptet på `C:\Windows\Scripts\Start-ContinuousDelivery.ps1`
- En Scheduled Task med navn **"Continuous delivery for Intune"**, som kjører som SYSTEM med Highest privilege, trigger **AtLogOn**

Ved hver pålogging av en brukerkonto kjøres dermed scriptet automatisk.

### Hva scriptet gjør per pålogging (rekkefølge)

1. **Versjonssjekk** + evt. selv-oppdatering (over)
2. **Eksamensbruker-deteksjon** – hvis brukernavnet inneholder `eksamen`, skrives `EksamenRegSettings.reg` inn i brukerens HKU-hive (restricted mode)
3. **Tjenester** start/stopp ifølge `Services/config.json`
4. **Maskinnavn** settes basert på serienummer (Acer har egen håndtering)
5. **OEM-aktivering** hvis Windows ikke er aktivert
6. **Ikoner** lastes ned til `C:\Windows\ICO\` (`IconsCfg/config.json`)
7. **Custom Execution** – installers med detection rules (`Custom Execution/config.json`)
8. **PowerShell-snippets** med detection (`PowerShell/config.json`)
9. **Skrivebords-snarveier** under `C:\Users\Public\Desktop` (`Shortcuts/config.json`)
10. **Registry-filer** (HKLM og HKCU – HKCU itereres over alle hiver) (`Regedit/config.json`)
11. **Aktiverer Windows-feature** `Printing-Foundation-LPRPortMonitor`

### Eksamensmodus

Brukerkontoer som har `eksamen` i brukernavnet får automatisk anvendt restricted registry-innstillinger fra `resources/regfiles/EksamenRegSettings.reg`. Dette skjer ved pålogging via Scheduled Task'en – ingen ekstra handling kreves fra helpdesk.

### Loggsti

`C:\Windows\Logs\CD4Intune.log`

Formatet er CMTrace-kompatibelt. Åpne med **CMTrace** eller **OneTrace** for fargekoding på severity. Loggen er den viktigste kilden for feilsøking når noe ikke kommer ut på maskinen – den viser hva scriptet faktisk forsøkte å gjøre ved pålogging.

---

## Intune

Elevmaskinene er enrollet via **Autopilot**, og elevene har **cloud-only kontoer**. Dette betyr at maskinene konfigureres fra null mot Intune ved første oppstart, uten on-prem AD.

### Konfigurasjonsprofiler

Profilene følger navnekonvensjonen `Windows - Student - <område>`. Grovsortert etter funksjon:

**Nettverk og sertifikater**
- DNS Client
- V-MAN WiFi, Test WiFi
- Block hotspot
- Trusted Certificate ROOT CA, Trusted Certificate Issuing CA, Digicert Root G2
- Device Cert SCEP

**Sikkerhet og enhetsbeskyttelse**
- BitLocker
- Applocker, Applocker - Beta, Applocker Disable
- Disable WHfB (Windows Hello for Business)
- Local Policies
- Device Lock (under eksamen)

**Skrivebord og brukeropplevelse**
- Start layout (Windows 10)
- Device Restrictions
- Misc. Settings
- Disable fast user switching
- Disable Start Menu Web Search
- Disable News and Interests
- Deny Store

**Office, browsere og kontoer**
- Office365 - BlockMacrosFromInternet
- Administrative Templates - Edge Browser Settings
- Administrative Templates - Chrome Browser Settings
- Administrative Templates - Microsoft account

**Eksamensspesifikke**
- Eksamen - Disable Translator
- Eksamen - Disable share button
- Eksamen - Device Lock

**System**
- Time Zone
- Location Services
- Delivery Optimization + Delivery Optimization (Connected Cache)

### Applikasjoner

Apper distribueres via **Firmaportalen**. Elever installerer selv det de trenger derfra, mens kritiske apper pushes som required.

### Oppdateringer

Oppdateringer av installerte apper håndteres av **Winget AutoUpdate** – https://github.com/Romanitho/Winget-AutoUpdate. Unntak (apper vi ikke vil at skal autooppdateres) konfigureres som en konfigurasjonsprofil i Intune.

### Platform scripts

I tillegg til konfigurasjonsprofilene dyttes CD4Intune-installasjonsscriptene ut som platform scripts (se [CD4Intune – Hovedscriptet og Scheduled Task](#hovedscriptet-og-scheduled-task) over).

---

## Feilsøking – hvor begynner helpdesk?

Når noe mangler eller ikke virker på en elevmaskin:

1. **Sjekk CD4Intune-loggen** først: `C:\Windows\Logs\CD4Intune.log` (med CMTrace/OneTrace). Her ser du om scriptet i det hele tatt har kjørt ved siste pålogging, og om noe feilet.
2. **Sjekk Scheduled Task** "Continuous delivery for Intune" – status, siste kjøring, og beskrivelsen som inneholder branch + versjon (f.eks. `prod.us 1.0.13.8`).
3. **Finn riktig branch** for maskinen og åpne configen i GitHub: `configs/<branch>/...` for å verifisere at innstillingen faktisk er definert.
4. **Hvis det er en policy-greie** (BitLocker, Applocker, Wi-Fi, certs, eksamensbegrensning, app-installasjon): sjekk Intune Sync-status og Configuration Profile-assignment på enheten i Intune Admin Center.
5. **Hvis det er en app-oppdatering som ikke kommer**: sjekk Winget AutoUpdate-loggen lokalt og kontroller om appen står i unntakslisten.
