import 'package:flutter/foundation.dart';

class SupabaseConfig {
  // TODO: Move these to environment variables for production
  static const String supabaseUrl = 'https://khiqbugmrfyyiyebgacn.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtoaXFidWdtcmZ5eWl5ZWJnYWNuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQwMTc2OTgsImV4cCI6MjA3OTU5MzY5OH0.Jnzgb903eRoSXoDU285UBUm1I2ckXg99-fnxqkg7OuM';
  
  static void logConfig() {
    if (kDebugMode) {
      print('Supabase URL: $supabaseUrl');
      print('Supabase Key configured: ${supabaseAnonKey.isNotEmpty}');
    }
  }
}
