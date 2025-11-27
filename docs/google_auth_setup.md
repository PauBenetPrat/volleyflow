# Google Sign-In Configuration Guide

This guide details how to configure Google Cloud Platform (GCP) and Supabase to enable Google Sign-In for your Flutter application `volleyball_coaching_app`.

## Prerequisites

- A Google Cloud Platform account.
- A Supabase project.
- Your Flutter project `volleyball_coaching_app`.

## 1. Google Cloud Platform (GCP) Configuration

### 1.1. Create a Project
1. Go to the [Google Cloud Console](https://console.cloud.google.com/).
2. Click the project dropdown at the top and select **New Project**.
3. Name it `VolleyFlow` (or similar) and create it.

### 1.2. Configure OAuth Consent Screen
1. In the left sidebar, navigate to **APIs & Services > OAuth consent screen**.
2. Select **External** (unless you are a G Suite user and want internal only, but usually External is correct for apps).
3. Click **Create**.
4. Fill in the required fields:
   - **App name**: VolleyFlow
   - **User support email**: Your email.
   - **Developer contact information**: Your email.
5. Click **Save and Continue**.
6. (Optional) Add scopes if needed, but for basic sign-in, the defaults (`email`, `profile`, `openid`) are usually sufficient.
7. **Test Users**: While in "Testing" status, add your own email to test the login.

### 1.3. Create Credentials

You need credentials for each platform (Web, Android, iOS).

#### A. Web Client ID (Required for Supabase)
1. Go to **APIs & Services > Credentials**.
2. Click **Create Credentials > OAuth client ID**.
3. Application type: **Web application**.
4. Name: `Supabase Auth`.
5. **Authorized redirect URIs**:
   - Go to your Supabase Project Dashboard > Authentication > Providers > Google.
   - Copy the **Callback URL (for OAuth)** (it looks like `https://<project-ref>.supabase.co/auth/v1/callback`).
   - Paste it into the "Authorized redirect URIs" field in GCP.
6. Click **Create**.
7. **Copy the Client ID and Client Secret**. You will need these for Supabase.

#### B. Android Client ID
1. Click **Create Credentials > OAuth client ID**.
2. Application type: **Android**.
3. Name: `Android Client`.
4. **Package name**: `com.paubenetprat.volleyflow` (found in your `AndroidManifest.xml`).
5. **SHA-1 Certificate fingerprint**:
   - Run the following command in your terminal to get the debug SHA-1:
     ```bash
     keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
     ```
   - Copy the `SHA1` fingerprint and paste it in GCP.
6. Click **Create**.
7. **Note**: You do *not* need the Client Secret for Android.

#### C. iOS Client ID
1. Click **Create Credentials > OAuth client ID**.
2. Application type: **iOS**.
3. Name: `iOS Client`.
4. **Bundle ID**: `com.paubenetprat.volleyflow` (Confirm this in Xcode or `ios/Runner/Info.plist`).
5. Click **Create**.
6. **Copy the iOS Client ID**.

## 2. Supabase Configuration

1. Go to your Supabase Project Dashboard.
2. Navigate to **Authentication > Providers**.
3. Select **Google**.
4. Enable **Google enabled**.
5. Paste the **Web Client ID** (from Step 1.3.A) into "Client ID".
6. Paste the **Web Client Secret** (from Step 1.3.A) into "Client Secret".
7. (Optional) Toggle "Skip nonce check" if you encounter issues, but usually keep it off for security.
8. Click **Save**.

## 3. Flutter Project Configuration

### 3.1. iOS (`ios/Runner/Info.plist`)
Open `ios/Runner/Info.plist` and add the following configuration to allow the Google Sign-In URL scheme:

```xml
<key>CFBundleURLTypes</key>
<array>
	<dict>
		<key>CFBundleTypeRole</key>
		<string>Editor</string>
		<key>CFBundleURLSchemes</key>
		<array>
			<!-- TODO: Replace this with your REVERSED iOS Client ID -->
			<string>com.googleusercontent.apps.YOUR-IOS-CLIENT-ID</string>
		</array>
	</dict>
</array>
```
*Note: The reversed client ID is just your iOS Client ID with the parts reversed (e.g., if ID is `123-abc.apps.googleusercontent.com`, the scheme is `com.googleusercontent.apps.123-abc`).*

### 3.2. Android (`android/app/build.gradle.kts` or `build.gradle`)
Ensure your `minSdkVersion` is at least 19 (Supabase usually requires higher, e.g., 21 is recommended).

### 3.3. Code Implementation
In your `AuthProvider` or login logic, use the `google_sign_in` package or `supabase_flutter`'s native sign-in.

**Example using Supabase Native Google Sign-In:**

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<AuthResponse> signInWithGoogle() async {
  /// Web Client ID that you registered with Google Cloud.
  const webClientId = 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';

  /// iOS Client ID that you registered with Google Cloud.
  const iosClientId = 'YOUR_IOS_CLIENT_ID.apps.googleusercontent.com';

  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: iosClientId,
    serverClientId: webClientId,
  );

  final googleUser = await googleSignIn.signIn();
  final googleAuth = await googleUser!.authentication;
  final accessToken = googleAuth.accessToken;
  final idToken = googleAuth.idToken;

  if (accessToken == null) {
    throw 'No Access Token found.';
  }
  if (idToken == null) {
    throw 'No ID Token found.';
  }

  return Supabase.instance.client.auth.signInWithIdToken(
    provider: OAuthProvider.google,
    idToken: idToken,
    accessToken: accessToken,
  );
}
```

## Troubleshooting

- **Error: 403: access_denied**: Make sure you added your email to "Test Users" in the OAuth Consent Screen.
- **PlatformException(sign_in_failed, ...)**: Check your SHA-1 fingerprint (Android) or URL Scheme (iOS).
- **Supabase Redirects**: Ensure the Supabase Callback URL is exactly what is in GCP Authorized Redirect URIs.
