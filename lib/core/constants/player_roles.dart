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
  
  // Display abbreviations
  static const String setterAbbr = 'S';
  static const String middleBlockerAbbr = 'MB';
  static const String oppositeAbbr = 'OP';
  static const String outsideHitterAbbr = 'OH';
  static const String liberoAbbr = 'L';
  
  // Map internal role to display abbreviation
  static String getDisplayAbbreviation(String internalRole) {
    switch (internalRole) {
      case setter:
        return setterAbbr;
      case middleBlocker1:
      case middleBlocker2:
        return middleBlockerAbbr;
      case opposite:
        return oppositeAbbr;
      case outsideHitter1:
      case outsideHitter2:
        return outsideHitterAbbr;
      case libero:
        return liberoAbbr;
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

