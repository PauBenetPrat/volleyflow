import 'package:flutter/foundation.dart';

class SupabaseConfig {
  // TODO: Move these to environment variables for production
  static const String supabaseUrl = 'https://khiqbugmrfyyiyebgacn.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtoaXFidWdtcmZ5eWl5ZWJnYWNuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQwMTc2OTgsImV4cCI6MjA3OTU5MzY5OH0.Jnzgb903eRoSXoDU285UBUm1I2ckXg99-fnxqkg7OuM';
  
  // Google Sign In Configuration
  // TODO: Replace with your actual client IDs from Google Cloud Console
  static const String googleWebClientId = '852455624120-jhtuhhhh1nee6sqi1a8u19uc6dr1t2v1.apps.googleusercontent.com';
  static const String googleIosClientId = 'YOUR_IOS_CLIENT_ID.apps.googleusercontent.com';
  
  static void logConfig() {
    if (kDebugMode) {
      print('Supabase URL: $supabaseUrl');
      print('Supabase Key configured: ${supabaseAnonKey.isNotEmpty}');
    }
  }
}
