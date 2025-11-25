import '../../l10n/app_localizations.dart';

// Player role abbreviations and descriptions
class PlayerRole {
  // Internal role keys (used in data)
  static const String setter = 'Co';
  static const String middleBlocker1 = 'C1';
  static const String middleBlocker2 = 'C2';
  static const String opposite = 'O';
  static const String outsideHitter1 = 'R1';
  static const String outsideHitter2 = 'R2';
  static const String libero = 'L'; // For future use
  
  // Display abbreviations (fallback for when AppLocalizations is not available)
  static const String setterAbbr = 'S';
  static const String middleBlockerAbbr = 'MB';
  static const String oppositeAbbr = 'OP';
  static const String outsideHitterAbbr = 'OH';
  static const String liberoAbbr = 'L';
  
  // Map internal role to display abbreviation using translations
  // If l10n is provided, uses translations; otherwise falls back to English abbreviations
  static String getDisplayAbbreviation(String internalRole, [AppLocalizations? l10n]) {
    switch (internalRole) {
      case setter:
        return l10n?.roleSetterAbbr ?? setterAbbr;
      case middleBlocker1:
      case middleBlocker2:
        return l10n?.roleMiddleBlockerAbbr ?? middleBlockerAbbr;
      case opposite:
        return l10n?.roleOppositeAbbr ?? oppositeAbbr;
      case outsideHitter1:
      case outsideHitter2:
        return l10n?.roleOutsideHitterAbbr ?? outsideHitterAbbr;
      case libero:
        return l10n?.roleLiberoAbbr ?? liberoAbbr;
      default:
        return internalRole; // Fallback to original
    }
  }
  
  // Get role description key for translations
  static String getRoleDescriptionKey(String internalRole) {
    switch (internalRole) {
      case setter:
        return 'roleSetter';
      case middleBlocker1:
      case middleBlocker2:
        return 'roleMiddleBlocker';
      case opposite:
        return 'roleOpposite';
      case outsideHitter1:
      case outsideHitter2:
        return 'roleOutsideHitter';
      case libero:
        return 'roleLibero';
      default:
        return 'roleUnknown';
    }
  }
  
  // Get full role name key for translations
  static String getRoleNameKey(String internalRole) {
    switch (internalRole) {
      case setter:
        return 'roleSetterName';
      case middleBlocker1:
      case middleBlocker2:
        return 'roleMiddleBlockerName';
      case opposite:
        return 'roleOppositeName';
      case outsideHitter1:
      case outsideHitter2:
        return 'roleOutsideHitterName';
      case libero:
        return 'roleLiberoName';
      default:
        return 'roleUnknownName';
    }
  }
  
  // All internal roles
  static const List<String> allRoles = [setter, middleBlocker1, middleBlocker2, opposite, outsideHitter1, outsideHitter2];
}

