import 'player.dart';
import 'coach.dart';

class Team {
  final String id;
  final String name;
  final List<Player> players;
  final List<Coach> coaches;

  Team({
    required this.id,
    required this.name,
    List<Player>? players,
    List<Coach>? coaches,
  })  : players = players ?? [],
        coaches = coaches ?? [];

  Team copyWith({
    String? id,
    String? name,
    List<Player>? players,
    List<Coach>? coaches,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      players: players ?? this.players,
      coaches: coaches ?? this.coaches,
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'players': players.map((p) => p.toJson()).toList(),
      'coaches': coaches.map((c) => c.toJson()).toList(),
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
    );
  }
}

