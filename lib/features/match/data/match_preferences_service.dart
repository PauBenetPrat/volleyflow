import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volleyball_coaching_app/features/match/domain/models/match_configuration.dart';

class MatchPreferencesService {
  static const String _matchConfigKey = 'match_configuration';

  /// Save match configuration to local storage
  Future<void> saveMatchConfiguration(MatchConfiguration config) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(config.toJson());
    await prefs.setString(_matchConfigKey, jsonString);
  }

  /// Load match configuration from local storage
  /// Returns default configuration if none is saved
  Future<MatchConfiguration> loadMatchConfiguration() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_matchConfigKey);
    
    if (jsonString == null) {
      return MatchConfiguration.defaultConfig;
    }
    
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return MatchConfiguration.fromJson(json);
    } catch (e) {
      // If there's an error parsing, return default config
      return MatchConfiguration.defaultConfig;
    }
  }

  /// Clear saved match configuration
  Future<void> clearMatchConfiguration() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_matchConfigKey);
  }
}
