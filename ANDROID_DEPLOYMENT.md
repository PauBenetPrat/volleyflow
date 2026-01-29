# Android Deployment Guide

This guide explains how to build and distribute the VolleyFlow Android app.

## Configuration

The app is configured with:
- **Package Name**: `com.paubenetprat.volleyflow`
- **App Name**: VolleyFlow
- **Version**: Managed in `pubspec.yaml` (e.g. 1.0.0+4)

### Versioning

- Version is defined only in `pubspec.yaml` as `X.Y.Z+N` (version name + build number).
- The build number `N` must increase for every Play Store upload; never reuse or decrease it.
- Version name `X.Y.Z` follows semantic versioning (patch for fixes, minor for features, major for breaking changes).

## Building the APK

### Debug APK (for testing)

```bash
flutter build apk --debug
```

The APK will be at: `build/app/outputs/flutter-apk/app-debug.apk`

### Release APK (for distribution)

```bash
flutter build apk --release
```

The APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

### Split APKs by Architecture (smaller files)

This creates separate APKs for different CPU architectures:

```bash
flutter build apk --split-per-abi
```

This generates:
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM - most common)
- `app-x86_64-release.apk` (64-bit x86)

**Note**: Most modern Android devices use `arm64-v8a`.

## Building App Bundle (for Google Play Store)

For Google Play Store, you should use App Bundle (AAB) instead of APK:

```bash
flutter build appbundle --release
```

The AAB will be at: `build/app/outputs/bundle/release/app-release.aab`

## Distribution Options

### Option 1: Google Play Store (Recommended)

1. **Create a Google Play Developer Account**:
   - Go to https://play.google.com/console
   - Pay the one-time registration fee (~€25)
   - Complete your developer profile

2. **Create a New App**:
   - Click "Create app"
   - Fill in app details (name, default language, etc.)
   - Choose "Free" or "Paid"

3. **Upload the App Bundle**:
   - Go to "Production" → "Create new release"
   - Upload the `app-release.aab` file
   - Add release notes
   - Review and roll out

4. **Complete Store Listing**:
   - App icon (512x512 PNG)
   - Feature graphic (1024x500 PNG)
   - Screenshots (at least 2, up to 8)
   - Short description (80 characters)
   - Full description (4000 characters)
   - Privacy policy URL (required for some apps)

5. **Content Rating**:
   - Complete the content rating questionnaire
   - Get your rating certificate

6. **Submit for Review**:
   - Review can take 1-7 days
   - You'll receive email notifications

### Option 2: Direct APK Distribution

1. **Share the APK file**:
   - Upload to a file sharing service (Google Drive, Dropbox, etc.)
   - Or host on your website
   - Share the download link

2. **User Instructions**:
   - Users need to enable "Install from unknown sources" in Android settings
   - Download and install the APK
   - **Limitation**: Limited to 100 installations per APK

### Option 3: Firebase App Distribution (Beta Testing)

1. **Set up Firebase**:
   - Go to https://console.firebase.google.com/
   - Create a project
   - Add Android app to the project
   - Download `google-services.json` and place it in `android/app/`

2. **Install Firebase CLI**:
   ```bash
   npm install -g firebase-tools
   ```

3. **Upload APK**:
   ```bash
   firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk \
     --app YOUR_APP_ID \
     --groups testers
   ```

4. **Invite Testers**:
   - Add tester emails in Firebase Console
   - They'll receive an email with download link

## App Icon

To update the app icon:

1. Generate icons using a tool like:
   - https://appicon.co/
   - https://icon.kitchen/

2. Replace icons in:
   - `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` (72x72)
   - `android/app/src/main/res/mipmap-mdpi/ic_launcher.png` (48x48)
   - `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png` (96x96)
   - `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png` (144x144)
   - `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` (192x192)

3. Also update the adaptive icon (if using):
   - `android/app/src/main/res/mipmap-*/ic_launcher_foreground.png`
   - `android/app/src/main/res/mipmap-*/ic_launcher_background.png`

## Signing the App (for Release)

For Google Play Store, you need to sign your app. Flutter handles this automatically when building an App Bundle, but for direct APK distribution:

1. **Generate a keystore**:
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. **Create `android/key.properties`**:
   ```properties
   storePassword=<password>
   keyPassword=<password>
   keyAlias=upload
   storeFile=<path-to-keystore>
   ```

3. **Update `android/app/build.gradle.kts`** to use the keystore (see Flutter documentation)

## Troubleshooting

### Build fails with "Gradle sync failed"
- Make sure Android SDK is properly installed
- Run `flutter doctor` to check Android toolchain
- Try `flutter clean` and rebuild

### APK is too large
- Use `--split-per-abi` to create separate APKs
- Use App Bundle (AAB) for Play Store (smaller than APK)
- Check for large assets that can be optimized

### App crashes on launch
- Check logcat: `adb logcat`
- Verify all dependencies are compatible
- Test on a physical device if emulator has issues

## Resources

- [Flutter Android Deployment](https://docs.flutter.dev/deployment/android)
- [Google Play Console](https://play.google.com/console)
- [Firebase App Distribution](https://firebase.google.com/docs/app-distribution)

