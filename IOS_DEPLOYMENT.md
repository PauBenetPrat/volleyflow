# Guia de Deployment per iOS

Aquesta guia explica com generar i distribuir l'app per iOS.

## Requisits Previs

1. **Mac amb macOS** (necessari per compilar per iOS)
2. **Xcode** instal·lat (ja el tens: Xcode 16.2)
3. **Apple Developer Account** (99€/any) per distribuir a l'App Store
   - Per proves al teu propi dispositiu, pots usar un compte gratuït amb limitacions

## Configuració Inicial

### 1. Configurar el Bundle Identifier

El Bundle ID identifica únicament la teva app. Obre el projecte a Xcode:

```bash
open ios/Runner.xcworkspace
```

A Xcode:
1. Selecciona el projecte "Runner" al navegador
2. Ves a la pestanya "Signing & Capabilities"
3. Canvia el **Bundle Identifier** a alguna cosa única, per exemple:
   - `com.paubenetprat.volleyflow`
   - O el que prefereixis (ha de ser únic)

### 2. Configurar el Team de Signing

1. A la mateixa secció "Signing & Capabilities"
2. Selecciona el teu **Team** (el teu compte d'Apple Developer)
3. Si no tens compte, pots crear un compte gratuït però tindràs limitacions

## Compilar l'App

### Per Proves al Simulador

```bash
# Llistar simuladors disponibles
flutter devices

# Executar al simulador
flutter run -d "iPhone 15 Pro"  # o el nom del simulador que vulguis
```

### Per Proves en Dispositiu Físic

1. Connecta el teu iPhone/iPad via USB
2. Confia en l'ordinador al dispositiu
3. Executa:
```bash
flutter devices  # per veure el dispositiu connectat
flutter run      # executarà al dispositiu connectat
```

### Compilar per Release

#### Opció 1: Via Flutter (més fàcil)

```bash
# Compilar per iOS
flutter build ios --release
```

Això genera un `.app` a `build/ios/iphoneos/Runner.app`

#### Opció 2: Via Xcode (per distribuir)

1. Obre el projecte:
```bash
open ios/Runner.xcworkspace
```

2. A Xcode:
   - Selecciona "Any iOS Device" o el teu dispositiu
   - Ves a **Product** → **Archive**
   - Espera que compili (pot trigar uns minuts)

3. Quan acabi, s'obrirà l'**Organizer**:
   - Selecciona l'archive que acabes de crear
   - Clica **Distribute App**
   - Tria l'opció que vulguis (TestFlight, App Store, o Ad Hoc)

## Distribuir l'App

### Opció 1: TestFlight (Beta Testing)

1. **Crear Archive** a Xcode (Product → Archive)
2. A l'Organizer, selecciona l'archive i clica **Distribute App**
3. Selecciona **App Store Connect**
4. Segueix l'assistent:
   - Upload automàtic
   - Export per a distribució manual (si prefereixes)
5. Ves a [App Store Connect](https://appstoreconnect.apple.com/)
6. Crea una nova app si encara no existeix
7. Puja la build i espera que Apple la revisi (pot trigar 1-2 hores)
8. Quan estigui aprovada, podràs afegir testers a TestFlight

### Opció 2: App Store

1. Segueix els mateixos passos que TestFlight
2. A App Store Connect, completa:
   - Informació de l'app (descripció, screenshots, etc.)
   - Preu i disponibilitat
   - Informació de privacitat
3. Envia per revisió
4. Apple revisarà l'app (pot trigar 1-7 dies)

### Opció 3: Distribució Ad Hoc (per a usuaris específics)

1. A Xcode, crea l'Archive
2. Distribueix com **Ad Hoc**
3. Exporta l'IPA
4. Distribueix l'IPA als usuaris (màxim 100 dispositius registrats)

### Opció 4: Desenvolupament (només per proves)

Per instal·lar directament al teu dispositiu sense App Store:

```bash
# Compilar
flutter build ios --release

# Obrir a Xcode
open ios/Runner.xcworkspace

# A Xcode, selecciona el teu dispositiu i prem Run (▶️)
```

## Configurar la Versió de l'App

Edita `pubspec.yaml`:

```yaml
version: 1.0.0+1  # 1.0.0 és la versió visible, +1 és el build number
```

O edita directament a Xcode:
- `ios/Flutter/AppFrameworkInfo.plist` per la versió de Flutter
- O al projecte Xcode: Target Runner → General → Version i Build

## Configurar Icona i Launch Screen

### Icona de l'App

1. Genera les icones en diferents mides (pots usar una eina com [AppIcon.co](https://www.appicon.co/))
2. Obre `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
3. Substitueix les imatges per les teves

### Launch Screen

Edita `ios/Runner/Base.lproj/LaunchScreen.storyboard` a Xcode per personalitzar la pantalla de càrrega.

## Troubleshooting

### Error: "No signing certificate found"
- Ves a Xcode → Preferences → Accounts
- Afegeix el teu compte d'Apple
- Clica "Download Manual Profiles"

### Error: "Provisioning profile doesn't match"
- A Xcode, ves a Signing & Capabilities
- Clica "Automatically manage signing"
- Xcode crearà els perfils automàticament

### Error: "Device not registered"
- Per dispositius físics, registra'ls a [Apple Developer Portal](https://developer.apple.com/account/resources/devices/list)
- O deixa que Xcode ho faci automàticament

### L'app no s'instal·la al dispositiu
- Assegura't que el Bundle ID és únic
- Verifica que el Team està configurat correctament
- Comprova que el dispositiu està desbloquejat i confia en l'ordinador

## Comandaments Útils

```bash
# Llistar dispositius disponibles
flutter devices

# Executar al simulador
flutter run -d "iPhone 15 Pro"

# Compilar per release
flutter build ios --release

# Netejar build anterior
flutter clean
flutter pub get

# Verificar configuració
flutter doctor
```

## Recursos Addicionals

- [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)
- [App Store Connect](https://appstoreconnect.apple.com/)
- [Apple Developer Portal](https://developer.apple.com/account/)

