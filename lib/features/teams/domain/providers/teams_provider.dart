import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/team.dart';
import '../models/player.dart';
import '../models/coach.dart';

class TeamsState {
  final List<Team> teams;
  final bool isLoading;

  TeamsState({
    required this.teams,
    this.isLoading = false,
  });

  TeamsState copyWith({
    List<Team>? teams,
    bool? isLoading,
  }) {
    return TeamsState(
      teams: teams ?? this.teams,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  bool canCreateTeam() {
    // For now, only allow 1 team
    return teams.length < 1;
  }
}

class TeamsNotifier extends Notifier<TeamsState> {
  @override
  TeamsState build() {
    return TeamsState(teams: []);
  }

  void addTeam(Team team) {
    if (state.canCreateTeam()) {
      state = state.copyWith(
        teams: [...state.teams, team],
      );
    }
  }

  void updateTeam(Team team) {
    final index = state.teams.indexWhere((t) => t.id == team.id);
    if (index != -1) {
      final updatedTeams = List<Team>.from(state.teams);
      updatedTeams[index] = team;
      state = state.copyWith(teams: updatedTeams);
    }
  }

  void deleteTeam(String teamId) {
    state = state.copyWith(
      teams: state.teams.where((t) => t.id != teamId).toList(),
    );
  }

  void addPlayerToTeam(String teamId, Player player) {
    final team = state.teams.firstWhere((t) => t.id == teamId);
    if (team.canAddPlayer()) {
      final updatedTeam = team.copyWith(
        players: [...team.players, player],
      );
      updateTeam(updatedTeam);
    }
  }

  void updatePlayerInTeam(String teamId, Player player) {
    final team = state.teams.firstWhere((t) => t.id == teamId);
    final index = team.players.indexWhere((p) => p.id == player.id);
    if (index != -1) {
      final updatedPlayers = List<Player>.from(team.players);
      updatedPlayers[index] = player;
      final updatedTeam = team.copyWith(players: updatedPlayers);
      updateTeam(updatedTeam);
    }
  }

  void deletePlayerFromTeam(String teamId, String playerId) {
    final team = state.teams.firstWhere((t) => t.id == teamId);
    final updatedTeam = team.copyWith(
      players: team.players.where((p) => p.id != playerId).toList(),
    );
    updateTeam(updatedTeam);
  }

  void addCoachToTeam(String teamId, Coach coach) {
    final team = state.teams.firstWhere((t) => t.id == teamId);
    if (team.canAddCoach()) {
      final updatedTeam = team.copyWith(
        coaches: [...team.coaches, coach],
      );
      updateTeam(updatedTeam);
    }
  }

  void updateCoachInTeam(String teamId, Coach coach) {
    final team = state.teams.firstWhere((t) => t.id == teamId);
    final index = team.coaches.indexWhere((c) => c.id == coach.id);
    if (index != -1) {
      final updatedCoaches = List<Coach>.from(team.coaches);
      updatedCoaches[index] = coach;
      final updatedTeam = team.copyWith(coaches: updatedCoaches);
      updateTeam(updatedTeam);
    }
  }

  void deleteCoachFromTeam(String teamId, String coachId) {
    final team = state.teams.firstWhere((t) => t.id == teamId);
    final updatedTeam = team.copyWith(
      coaches: team.coaches.where((c) => c.id != coachId).toList(),
    );
    updateTeam(updatedTeam);
  }
}

final teamsProvider = NotifierProvider<TeamsNotifier, TeamsState>(() {
  return TeamsNotifier();
});

