import 'dart:ui' as ui;
import '../../../teams/domain/models/match_roster.dart';
import '../../../teams/domain/models/player.dart';

enum PointType {
  normal,
  aceHome,
  aceOpponent,
}

class PointLog {
  final int homeScore;
  final int opponentScore;
  final int setNumber;
  final PointType type;
  final List<String> homePlayerIds; // Players on court
  final DateTime timestamp;
  final int homeRotation;
  final int opponentRotation;

  PointLog({
    required this.homeScore,
    required this.opponentScore,
    required this.setNumber,
    required this.type,
    required this.homePlayerIds,
    required this.timestamp,
    required this.homeRotation,
    required this.opponentRotation,
  });

  @override
  String toString() {
    return 'Set $setNumber | $homeScore-$opponentScore | ${type.name} | R$homeRotation vs R$opponentRotation';
  }
}

class MatchState {
  final MatchRoster? matchRoster;
  final Map<String, ui.Offset> playerPositions;
  final Map<String, Player> players;
  final Map<String, int> playerLogicalPositions;
  final List<Player> homeBench;
  final List<Player> opponentBench;
  final Map<String, int> opponentPlayerNumbers; // ghost_id -> number
  final int homeScore;
  final int opponentScore;
  final int homeSets;
  final int opponentSets;
  final int currentSet;
  final bool isHomeServing;
  final ui.Offset? ballPosition;
  final bool matchStarted;
  final bool isMatchSetupMode;
  final bool? firstServerOfSet;
  final int homeRotation;
  final int opponentRotation;
  final List<PointLog> logs;

  MatchState({
    this.matchRoster,
    Map<String, ui.Offset>? playerPositions,
    Map<String, Player>? players,
    Map<String, int>? playerLogicalPositions,
    List<Player>? homeBench,
    List<Player>? opponentBench,
    Map<String, int>? opponentPlayerNumbers,
    this.homeScore = 0,
    this.opponentScore = 0,
    this.homeSets = 0,
    this.opponentSets = 0,
    this.currentSet = 1,
    this.isHomeServing = true,
    this.ballPosition,
    this.matchStarted = false,
    this.isMatchSetupMode = true,
    this.firstServerOfSet,
    this.homeRotation = 1,
    this.opponentRotation = 1,
    List<PointLog>? logs,
  })  : playerPositions = playerPositions ?? {},
        players = players ?? {},
        playerLogicalPositions = playerLogicalPositions ?? {},
        homeBench = homeBench ?? [],
        opponentBench = opponentBench ?? [],
        opponentPlayerNumbers = opponentPlayerNumbers ?? {},
        logs = logs ?? [];

  MatchState copyWith({
    MatchRoster? matchRoster,
    Map<String, ui.Offset>? playerPositions,
    Map<String, Player>? players,
    Map<String, int>? playerLogicalPositions,
    List<Player>? homeBench,
    List<Player>? opponentBench,
    Map<String, int>? opponentPlayerNumbers,
    int? homeScore,
    int? opponentScore,
    int? homeSets,
    int? opponentSets,
    int? currentSet,
    bool? isHomeServing,
    ui.Offset? ballPosition,
    bool? matchStarted,
    bool? isMatchSetupMode,
    bool? firstServerOfSet,
    int? homeRotation,
    int? opponentRotation,
    List<PointLog>? logs,
    bool clearMatchRoster = false,
    bool clearBallPosition = false,
  }) {
    return MatchState(
      matchRoster: clearMatchRoster ? null : (matchRoster ?? this.matchRoster),
      playerPositions: playerPositions ?? this.playerPositions,
      players: players ?? this.players,
      playerLogicalPositions: playerLogicalPositions ?? this.playerLogicalPositions,
      homeBench: homeBench ?? this.homeBench,
      opponentBench: opponentBench ?? this.opponentBench,
      opponentPlayerNumbers: opponentPlayerNumbers ?? this.opponentPlayerNumbers,
      homeScore: homeScore ?? this.homeScore,
      opponentScore: opponentScore ?? this.opponentScore,
      homeSets: homeSets ?? this.homeSets,
      opponentSets: opponentSets ?? this.opponentSets,
      currentSet: currentSet ?? this.currentSet,
      isHomeServing: isHomeServing ?? this.isHomeServing,
      ballPosition: clearBallPosition ? null : (ballPosition ?? this.ballPosition),
      matchStarted: matchStarted ?? this.matchStarted,
      isMatchSetupMode: isMatchSetupMode ?? this.isMatchSetupMode,
      firstServerOfSet: firstServerOfSet ?? this.firstServerOfSet,
      homeRotation: homeRotation ?? this.homeRotation,
      opponentRotation: opponentRotation ?? this.opponentRotation,
      logs: logs ?? this.logs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matchRoster': matchRoster?.toJson(),
      'playerPositions': playerPositions.map((k, v) => MapEntry(k, {'dx': v.dx, 'dy': v.dy})),
      'players': players.map((k, v) => MapEntry(k, v.toJson())),
      'playerLogicalPositions': playerLogicalPositions,
      'homeBench': homeBench.map((p) => p.toJson()).toList(),
      'opponentBench': opponentBench.map((p) => p.toJson()).toList(),
      'opponentPlayerNumbers': opponentPlayerNumbers,
      'homeScore': homeScore,
      'opponentScore': opponentScore,
      'homeSets': homeSets,
      'opponentSets': opponentSets,
      'currentSet': currentSet,
      'isHomeServing': isHomeServing,
      'ballPosition': ballPosition != null ? {'dx': ballPosition!.dx, 'dy': ballPosition!.dy} : null,
      'matchStarted': matchStarted,
      'isMatchSetupMode': isMatchSetupMode,
      'firstServerOfSet': firstServerOfSet,
      'homeRotation': homeRotation,
      'opponentRotation': opponentRotation,
    };
  }

  factory MatchState.fromJson(Map<String, dynamic> json) {
    return MatchState(
      matchRoster: json['matchRoster'] != null ? MatchRoster.fromJson(json['matchRoster']) : null,
      playerPositions: (json['playerPositions'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, ui.Offset((v['dx'] as num).toDouble(), (v['dy'] as num).toDouble())),
      ),
      players: (json['players'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, Player.fromJson(v)),
      ),
      playerLogicalPositions: Map<String, int>.from(json['playerLogicalPositions']),
      homeBench: (json['homeBench'] as List).map((e) => Player.fromJson(e)).toList(),
      opponentBench: (json['opponentBench'] as List).map((e) => Player.fromJson(e)).toList(),
      opponentPlayerNumbers: Map<String, int>.from(json['opponentPlayerNumbers']),
      homeScore: json['homeScore'],
      opponentScore: json['opponentScore'],
      homeSets: json['homeSets'],
      opponentSets: json['opponentSets'],
      currentSet: json['currentSet'],
      isHomeServing: json['isHomeServing'],
      ballPosition: json['ballPosition'] != null 
          ? ui.Offset((json['ballPosition']['dx'] as num).toDouble(), (json['ballPosition']['dy'] as num).toDouble())
          : null,
      matchStarted: json['matchStarted'],
      isMatchSetupMode: json['isMatchSetupMode'],
      firstServerOfSet: json['firstServerOfSet'],
      homeRotation: json['homeRotation'],
      opponentRotation: json['opponentRotation'],
      logs: [], // Logs will be loaded separately
    );
  }
}
