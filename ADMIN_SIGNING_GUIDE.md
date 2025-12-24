# Guia per a l'Admin: Signar l'App Flutter

Aquesta guia explica com signar l'app Flutter compilada sense necessitat de tenir Flutter instal·lat.

## Procés

### 1. El Desenvolupador genera l'Archive

El desenvolupador executa:

```bash
cd ios
fastlane build_unsigned
```

Això genera un fitxer `.xcarchive` a: `ios/build/Runner.xcarchive`

### 2. L'Admin rep l'Archive

El desenvolupador ha de compartir la carpeta `ios/build/Runner.xcarchive` amb l'admin (via Git, Dropbox, etc.)

### 3. L'Admin signa l'Archive amb Xcode

#### Opció A: Utilitzant Xcode Organizer (Recomanat)

1. **Obre Xcode**

2. **Obre Organizer:**
   - Menú: `Window` > `Organizer` (o `Cmd+Shift+O`)

3. **Importa l'Archive:**
   - Fes clic a `+` (Add Archives)
   - Navega a `Runner.xcarchive`
   - Selecciona'l i fes clic a `Open`

4. **Distribueix l'App:**
   - Selecciona l'archive a la llista
   - Fes clic a `Distribute App...`
   - Selecciona `App Store Connect`
   - Fes clic a `Next`

5. **Selecciona opcions de distribució:**
   - `Upload`: Per pujar directament a App Store Connect
   - `Export`: Per generar un .ipa que puguis pujar després
   - Recomanat: `Upload` per simplicitat

6. **Signatura automàtica:**
   - Selecciona `Automatically manage signing`
   - Xcode utilitzarà els certificats i perfils del teu compte
   - Fes clic a `Next`

7. **Revisa i puja:**
   - Revisa la informació
   - Fes clic a `Upload`
   - Espera que es completi

#### Opció B: Utilitzant la línia de comandes

Si prefereixes utilitzar la terminal:

1. **Actualitza ExportOptions.plist:**
   - Obre `ios/fastlane/ExportOptions.plist`
   - Canvia `YOUR_TEAM_ID` pel teu Team ID real

2. **Exporta l'archive:**
   ```bash
   cd ios
   xcodebuild -exportArchive \
     -archivePath build/Runner.xcarchive \
     -exportPath build/export \
     -exportOptionsPlist fastlane/ExportOptions.plist
   ```

3. **Puja a App Store Connect:**
   ```bash
   xcrun altool --upload-app \
     --type ios \
     --file build/export/Runner.ipa \
     --username "your-apple-id@example.com" \
     --password "@keychain:Application-Specific-Password"
   ```

   O utilitza Transporter app (més fàcil):
   - Obre Transporter app
   - Arrossega el fitxer `.ipa` generat
   - Fes clic a `Deliver`

## Requisits per a l'Admin

- ✅ Xcode instal·lat (versió recent)
- ✅ Compte d'Apple Developer amb permisos d'admin
- ✅ Certificats i perfils de distribució configurats
- ❌ **NO** necessita Flutter instal·lat

## Troubleshooting

### Error: "No signing certificate found"
- Assegura't que tens un certificat de distribució vàlid al teu compte
- Vés a Apple Developer Portal i verifica els certificats

### Error: "No provisioning profile found"
- Assegura't que tens un perfil de distribució per a l'App Store
- El Bundle ID ha de ser: `com.paubenetprat.volleyflow`

### Error: "Archive is invalid"
- Assegura't que l'archive s'ha generat correctament
- Verifica que no està corrupte
- Demana al desenvolupador que el regeneri

### L'archive no apareix a Organizer
- Assegura't que estàs obrint el fitxer `.xcarchive` (no una carpeta)
- Prova a fer doble clic directament al fitxer

## Notes Importants

- L'archive generat **NO** està signat, per això l'admin ha de signar-lo
- L'archive conté tots els binaris de Flutter compilats
- No cal tenir Flutter instal·lat per signar l'archive
- El procés de signatura és idèntic a una app iOS nativa

## Estructura de l'Archive

```
Runner.xcarchive/
├── Info.plist
├── Products/
│   └── Applications/
│       └── Runner.app
└── dSYMs/
    └── Runner.app.dSYM
```

## Contacte

Si tens problemes, contacta amb el desenvolupador per:
- Regenerar l'archive si està corrupte
- Actualitzar la versió/build number
- Resoldre problemes de compilació

