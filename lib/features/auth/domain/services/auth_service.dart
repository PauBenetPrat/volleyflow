import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:volleyball_coaching_app/core/config/supabase_config.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Get auth state stream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: fullName != null ? {'full_name': fullName} : null,
    );
    return response;
  }

  // Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  }

  // Sign in with Google
  Future<AuthResponse> signInWithGoogle() async {
    /// Web Client ID that you registered with Google Cloud.
    /// This is required for web, but not for mobile.
    const webClientId = SupabaseConfig.googleWebClientId;

    /// iOS Client ID that you registered with Google Cloud.
    const iosClientId = SupabaseConfig.googleIosClientId;

    final GoogleSignIn googleSignIn = kIsWeb
        ? GoogleSignIn(
            clientId: webClientId,
            scopes: ['openid', 'email', 'profile'],
          )
        : GoogleSignIn(
            clientId: iosClientId,
            serverClientId: webClientId,
            scopes: ['openid', 'email', 'profile'],
          );
    
    final googleUser = await googleSignIn.signIn();
    
    if (googleUser == null) {
      throw 'Google Sign-In canceled by user.';
    }
    
    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    return _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  // Sign out
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }
    await _supabase.auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  // Update user data
  Future<UserResponse> updateUser({
    String? fullName,
    String? avatarUrl,
  }) async {
    final updates = <String, dynamic>{};
    if (fullName != null) updates['full_name'] = fullName;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

    return await _supabase.auth.updateUser(
      UserAttributes(data: updates),
    );
  }
}
