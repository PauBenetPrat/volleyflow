# Configuració de Fastlane per a VolleyFlow

Aquest projecte utilitza Fastlane per generar archives iOS sense signar que l'admin pot signar després.

## Instal·lació

### 1. Instal·lar Fastlane

```bash
# Amb Homebrew (recomanat)
brew install fastlane

# O amb RubyGems
sudo gem install fastlane
```

### 2. Verificar Instal·lació

```bash
fastlane --version
```

## Ús

### Generar Archive Sense Signar

Des del directori `ios/`:

```bash
cd ios
fastlane build_unsigned
```

Això farà:
1. Netejar builds anteriors
2. Obtenir dependències de Flutter
3. Compilar Flutter per iOS (sense signar)
4. Generar un `.xcarchive` a `ios/build/Runner.xcarchive`

### Lanes Disponibles

#### Per Desenvolupadors sense Permisos de Signatura:
- `fastlane build_unsigned` - Genera archive sense signar per a l'admin (recomanat)
- `fastlane build_unsigned_alt` - Versió alternativa
- `fastlane signing_info` - Mostra informació per a l'admin
- `fastlane generate_export_options` - Genera ExportOptions.plist

#### Per Desenvolupadors amb Permisos o Admin amb Flutter:
- `fastlane beta` - Compila, signa i puja directament a TestFlight 🚀
- `fastlane build_signed` - Compila i genera IPA signat (sense pujar)
- `fastlane upload_existing` - Puja un IPA ja generat a TestFlight

## Compartir l'Archive amb l'Admin

Després de generar l'archive, comparteix la carpeta:

```
ios/build/Runner.xcarchive
```

Amb l'admin. Pots:
- Comprimir-la i enviar-la per email/Dropbox
- Pujar-la a un servidor compartit
- Commitar-la temporalment al repositori (si és petit)

## Configuració

### Appfile

El fitxer `ios/fastlane/Appfile` conté:
- Bundle ID: `com.paubenetprat.volleyflow`

Si necessites canviar el Bundle ID, edita aquest fitxer.

### ExportOptions.plist

El fitxer `ios/fastlane/ExportOptions.plist` conté les opcions d'exportació per a l'admin.

**Important:** L'admin ha de canviar `YOUR_TEAM_ID` pel seu Team ID real abans d'utilitzar-lo.

## Troubleshooting

### Error: "xcodebuild: command not found"
- Assegura't que tens Xcode instal·lat
- Executa `xcode-select --install` si cal

### Error: "xcpretty: command not found"
- Instal·la xcpretty: `gem install xcpretty`
- O elimina `| xcpretty` del Fastfile

### Error: "Flutter: command not found"
- Assegura't que estàs executant des del directori correcte
- Verifica que Flutter està al PATH

### Error: "Workspace not found"
- Assegura't que estàs dins del directori `ios/`
- Verifica que `Runner.xcworkspace` existeix

### Archive no es genera
- Verifica que Flutter compila correctament: `flutter build ios --release --no-codesign`
- Revisa els logs per errors
- Assegura't que tens suficients permisos d'escriptura

## Estructura de Fitxers

```
ios/
├── fastlane/
│   ├── Appfile              # Configuració bàsica
│   ├── Fastfile             # Lanes de Fastlane
│   └── ExportOptions.plist  # Opcions d'exportació
└── build/
    └── Runner.xcarchive     # Archive generat (no commitejat)
```

## Pujar Directament a TestFlight

Si tens permisos de signatura o l'admin té Flutter instal·lat, pots pujar directament:

### Opció 1: Tot en un pas (Recomanat)

```bash
cd ios
fastlane beta
```

Això farà:
1. Netejar i compilar Flutter
2. Generar l'archive signat
3. Pujar directament a TestFlight

### Opció 2: En dos passos

```bash
# 1. Generar IPA signat
cd ios
fastlane build_signed

# 2. Pujar després (si cal)
fastlane upload_existing
```

### Configuració Necessària

Abans d'utilitzar `beta` o `build_signed`, assegura't de tenir:

1. **Appfile configurat:**
   - Obre `ios/fastlane/Appfile`
   - Descomenta i afegeix el teu `apple_id` i `team_id`

2. **Certificats i Perfils:**
   - Fastlane utilitzarà la signatura automàtica
   - O configura Match si utilitzes certificats compartits

3. **Autenticació App Store Connect:**
   - Fastlane necessitarà autenticació per pujar
   - Pots utilitzar App Store Connect API Key o Apple ID

### Autenticació amb App Store Connect API Key (Recomanat)

1. Crea una API Key a [App Store Connect](https://appstoreconnect.apple.com/access/api)
2. Descarrega el fitxer `.p8`
3. Configura les variables d'entorn:

```bash
export APP_STORE_CONNECT_API_KEY_PATH="/path/to/AuthKey.p8"
export APP_STORE_CONNECT_API_KEY_ISSUER_ID="your-issuer-id"
export APP_STORE_CONNECT_API_KEY_KEY_ID="your-key-id"
```

O afegeix al `Appfile`:

```ruby
app_store_connect_api_key(
  key_id: "your-key-id",
  issuer_id: "your-issuer-id",
  key_filepath: "./AuthKey.p8"
)
```

### Autenticació amb Apple ID (Alternativa)

Si prefereixes utilitzar Apple ID:

```bash
# Primer cop, Fastlane et demanarà les credencials
fastlane beta

# O configura a l'Appfile:
apple_id("your-email@example.com")
```

## Pròxims Passos

### Si NO tens permisos:
1. Genera l'archive amb `fastlane build_unsigned`
2. Comparteix l'archive amb l'admin
3. L'admin signa l'archive seguint `ADMIN_SIGNING_GUIDE.md`
4. L'admin puja l'app a App Store Connect

### Si tens permisos o l'admin té Flutter:
1. Configura l'`Appfile` amb les teves credencials
2. Executa `fastlane beta` per pujar directament
3. Espera que TestFlight processi l'app

## Referències

- [Fastlane Documentation](https://docs.fastlane.tools/)
- [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)
- [ADMIN_SIGNING_GUIDE.md](../ADMIN_SIGNING_GUIDE.md) - Guia per a l'admin

