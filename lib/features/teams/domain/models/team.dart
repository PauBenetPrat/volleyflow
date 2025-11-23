import 'player.dart';
import 'coach.dart';

class Team {
  final String id;
  final String name;
  final List<Player> players;
  final List<Coach> coaches;
  final String? userId; // null = equip local, no sincronitzat
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? syncedAt;

  Team({
    required this.id,
    required this.name,
    List<Player>? players,
    List<Coach>? coaches,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.syncedAt,
  })  : players = players ?? [],
        coaches = coaches ?? [];

  Team copyWith({
    String? id,
    String? name,
    List<Player>? players,
    List<Coach>? coaches,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? syncedAt,
    bool clearUserId = false,
    bool clearSyncedAt = false,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      players: players ?? this.players,
      coaches: coaches ?? this.coaches,
      userId: clearUserId ? null : (userId ?? this.userId),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: clearSyncedAt ? null : (syncedAt ?? this.syncedAt),
    );
  }

  String getInitials() {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  bool canAddPlayer() {
    return players.length < 18;
  }

  bool canAddCoach() {
    return coaches.length < 2;
  }

  /// Indica si l'equip és només local (no associat a cap usuari)
  bool get isLocal => userId == null;

  /// Indica si l'equip ha estat sincronitzat amb el backend
  bool get isSynced => syncedAt != null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'players': players.map((p) => p.toJson()).toList(),
      'coaches': coaches.map((c) => c.toJson()).toList(),
      'userId': userId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'syncedAt': syncedAt?.toIso8601String(),
    };
  }

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] as String,
      name: json['name'] as String,
      players: (json['players'] as List<dynamic>?)
              ?.map((p) => Player.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
      coaches: (json['coaches'] as List<dynamic>?)
              ?.map((c) => Coach.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
      userId: json['userId'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      syncedAt: json['syncedAt'] != null
          ? DateTime.parse(json['syncedAt'] as String)
          : null,
    );
  }
}

