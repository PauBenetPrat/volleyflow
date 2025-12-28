class MatchConfiguration {
  final int maxPoints;
  final int lastSetMaxPoints;
  final int totalSets;
  final bool winByTwo;
  final bool highContrastColors;

  const MatchConfiguration({
    required this.maxPoints,
    required this.lastSetMaxPoints,
    required this.totalSets,
    required this.winByTwo,
    this.highContrastColors = false,
  });

  /// Default volleyball configuration (25 points, 15 in last set, best of 5)
  static const defaultConfig = MatchConfiguration(
    maxPoints: 25,
    lastSetMaxPoints: 15,
    totalSets: 5,
    winByTwo: true,
  );

  /// Calculate how many sets a team needs to win the match
  int get setsToWin => (totalSets ~/ 2) + 1;

  /// Check if the current set is the last/deciding set
  bool isLastSet(int teamASets, int teamBSets) {
    if (totalSets == 1) return false; // If only 1 set, it usually follows normal rules unless specified otherwise, but 'last set' usually implies tie-break rules.
    // Actually, if totalSets is 1, it is the only set. If the user wants specific points for 'last set' it might be confusing.
    // However, usually 'last set' means the tie-break set (5th set in 5-set match).
    // Let's keep logic simple: if it's the final possible set, it's the 'last set'.
    return (teamASets + teamBSets) == (totalSets - 1);
  }

  /// Get the maximum points for a specific set
  int getMaxPointsForSet(int teamASets, int teamBSets) {
    return isLastSet(teamASets, teamBSets) ? lastSetMaxPoints : maxPoints;
  }

  MatchConfiguration copyWith({
    int? maxPoints,
    int? lastSetMaxPoints,
    int? totalSets,
    bool? winByTwo,
    bool? highContrastColors,
  }) {
    return MatchConfiguration(
      maxPoints: maxPoints ?? this.maxPoints,
      lastSetMaxPoints: lastSetMaxPoints ?? this.lastSetMaxPoints,
      totalSets: totalSets ?? this.totalSets,
      winByTwo: winByTwo ?? this.winByTwo,
      highContrastColors: highContrastColors ?? this.highContrastColors,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'maxPoints': maxPoints,
      'lastSetMaxPoints': lastSetMaxPoints,
      'totalSets': totalSets,
      'winByTwo': winByTwo,
      'highContrastColors': highContrastColors,
    };
  }

  /// Create from JSON
  factory MatchConfiguration.fromJson(Map<String, dynamic> json) {
    return MatchConfiguration(
      maxPoints: json['maxPoints'] as int? ?? defaultConfig.maxPoints,
      lastSetMaxPoints: json['lastSetMaxPoints'] as int? ?? defaultConfig.lastSetMaxPoints,
      totalSets: json['totalSets'] as int? ?? defaultConfig.totalSets,
      winByTwo: json['winByTwo'] as bool? ?? defaultConfig.winByTwo,
      highContrastColors: json['highContrastColors'] as bool? ?? false,
    );
  }
}
