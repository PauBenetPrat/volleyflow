import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../teams/domain/models/match_roster.dart';
import '../../../teams/domain/models/player.dart';
import 'dart:ui' as ui;

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
  })  : playerPositions = playerPositions ?? {},
        players = players ?? {},
        playerLogicalPositions = playerLogicalPositions ?? {},
        homeBench = homeBench ?? [],
        opponentBench = opponentBench ?? [],
        opponentPlayerNumbers = opponentPlayerNumbers ?? {};

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
    );
  }
}

class MatchStateNotifier extends Notifier<MatchState?> {
  @override
  MatchState? build() {
    return null; // No active match by default
  }

  void initializeMatch(MatchRoster? matchRoster) {
    state = MatchState(matchRoster: matchRoster);
  }

  void updateState(MatchState newState) {
    state = newState;
  }

  void updateOpponentPlayerNumber(String ghostId, int number) {
    if (state == null) return;
    final updatedNumbers = Map<String, int>.from(state!.opponentPlayerNumbers);
    updatedNumbers[ghostId] = number;
    state = state!.copyWith(opponentPlayerNumbers: updatedNumbers);
  }

  void resetMatch() {
    state = null;
  }
}

final matchStateProvider = NotifierProvider<MatchStateNotifier, MatchState?>(() {
  return MatchStateNotifier();
});

