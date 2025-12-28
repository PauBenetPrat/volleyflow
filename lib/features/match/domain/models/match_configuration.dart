class MatchConfiguration {
  final int maxPoints;
  final int lastSetMaxPoints;
  final int totalSets;
  final bool winByTwo;

  const MatchConfiguration({
    required this.maxPoints,
    required this.lastSetMaxPoints,
    required this.totalSets,
    required this.winByTwo,
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
  }) {
    return MatchConfiguration(
      maxPoints: maxPoints ?? this.maxPoints,
      lastSetMaxPoints: lastSetMaxPoints ?? this.lastSetMaxPoints,
      totalSets: totalSets ?? this.totalSets,
      winByTwo: winByTwo ?? this.winByTwo,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'maxPoints': maxPoints,
      'lastSetMaxPoints': lastSetMaxPoints,
      'totalSets': totalSets,
      'winByTwo': winByTwo,
    };
  }

  /// Create from JSON
  factory MatchConfiguration.fromJson(Map<String, dynamic> json) {
    return MatchConfiguration(
      maxPoints: json['maxPoints'] as int? ?? defaultConfig.maxPoints,
      lastSetMaxPoints: json['lastSetMaxPoints'] as int? ?? defaultConfig.lastSetMaxPoints,
      totalSets: json['totalSets'] as int? ?? defaultConfig.totalSets,
      winByTwo: json['winByTwo'] as bool? ?? defaultConfig.winByTwo,
    );
  }
}
