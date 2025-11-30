class MatchRoster {
  final String id;
  final String teamId;
  final String rivalName;
  final DateTime matchDate;
  final List<String>? playerIds; // Up to 14, optional
  final String? location;
  final DateTime createdAt;
  final int? setsHome;
  final int? setsOpponent;
  final bool matchCompleted;
  final DateTime? completedAt;

  const MatchRoster({
    required this.id,
    required this.teamId,
    required this.rivalName,
    required this.matchDate,
    this.playerIds,
    this.location,
    required this.createdAt,
    this.setsHome,
    this.setsOpponent,
    this.matchCompleted = false,
    this.completedAt,
  });

  factory MatchRoster.fromJson(Map<String, dynamic> json) {
    // Handle player_ids - can be null, empty array, or array with values
    final playerIdsList = json['player_ids'];
    List<String>? playerIds;
    if (playerIdsList != null && playerIdsList is List) {
      final list = playerIdsList as List<dynamic>;
      playerIds = list.isEmpty ? null : list.map((e) => e.toString()).toList();
    }
    
    // Validate required fields
    final id = json['id']?.toString();
    if (id == null) throw Exception('MatchRoster id is required');
    
    final teamId = json['team_id']?.toString();
    if (teamId == null) throw Exception('MatchRoster team_id is required');
    
    final rivalName = json['rival_name']?.toString();
    if (rivalName == null) throw Exception('MatchRoster rival_name is required');
    
    // Handle match_date - required but might be null in old data
    DateTime matchDate;
    if (json['match_date'] != null) {
      matchDate = DateTime.parse(json['match_date'].toString());
    } else {
      // Fallback to created_at if match_date is missing (for old data)
      matchDate = json['created_at'] != null 
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now();
    }
    
    // Handle created_at
    DateTime createdAt;
    if (json['created_at'] != null) {
      createdAt = DateTime.parse(json['created_at'].toString());
    } else {
      createdAt = DateTime.now();
    }
    
    return MatchRoster(
      id: id,
      teamId: teamId,
      rivalName: rivalName,
      matchDate: matchDate,
      playerIds: playerIds,
      location: json['location']?.toString(),
      createdAt: createdAt,
      setsHome: json['sets_home'] as int?,
      setsOpponent: json['sets_opponent'] as int?,
      matchCompleted: json['match_completed'] as bool? ?? false,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'team_id': teamId,
      'rival_name': rivalName,
      'match_date': matchDate.toIso8601String(),
      'player_ids': playerIds?.isNotEmpty == true ? playerIds : <String>[], // Empty array instead of null for Supabase
      'location': location,
      'created_at': createdAt.toIso8601String(),
      'sets_home': setsHome,
      'sets_opponent': setsOpponent,
      'match_completed': matchCompleted,
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  MatchRoster copyWith({
    String? id,
    String? teamId,
    String? rivalName,
    DateTime? matchDate,
    List<String>? playerIds,
    String? location,
    DateTime? createdAt,
    int? setsHome,
    int? setsOpponent,
    bool? matchCompleted,
    DateTime? completedAt,
  }) {
    return MatchRoster(
      id: id ?? this.id,
      teamId: teamId ?? this.teamId,
      rivalName: rivalName ?? this.rivalName,
      matchDate: matchDate ?? this.matchDate,
      playerIds: playerIds ?? this.playerIds,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      setsHome: setsHome ?? this.setsHome,
      setsOpponent: setsOpponent ?? this.setsOpponent,
      matchCompleted: matchCompleted ?? this.matchCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
