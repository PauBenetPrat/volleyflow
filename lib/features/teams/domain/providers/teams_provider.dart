import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/team.dart';
import '../models/player.dart';
import '../models/coach.dart';
import '../models/player_position.dart';

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
  static const String _storageKey = 'teams_storage';

  @override
  TeamsState build() {
    // Carregar equips des de local storage al inicialitzar
    _loadFromLocal();
    return TeamsState(teams: [], isLoading: true);
  }

  /// Carrega els equips des de local storage
  Future<void> _loadFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final teamsJson = prefs.getString(_storageKey);
      
      if (teamsJson != null) {
        final List<dynamic> teamsList = json.decode(teamsJson);
        final teams = teamsList
            .map((json) => Team.fromJson(json as Map<String, dynamic>))
            .toList();
        
        state = state.copyWith(teams: teams, isLoading: false);
      } else {
        // If no teams found, seed default team
        _seedDefaultTeam();
      }
    } catch (e) {
      // Si hi ha error en carregar, continuar amb llista buida
      print('Error loading teams from local storage: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  /// Guarda els equips a local storage
  Future<void> _saveToLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final teamsJson = json.encode(
        state.teams.map((team) => team.toJson()).toList(),
      );
      await prefs.setString(_storageKey, teamsJson);
    } catch (e) {
      print('Error saving teams to local storage: $e');
    }
  }

  void addTeam(Team team) {
    if (state.canCreateTeam()) {
      final now = DateTime.now();
      final teamWithTimestamps = team.copyWith(
        createdAt: team.createdAt ?? now,
        updatedAt: now,
      );
      state = state.copyWith(
        teams: [...state.teams, teamWithTimestamps],
      );
      _saveToLocal();
    }
  }

  void updateTeam(Team team) {
    final index = state.teams.indexWhere((t) => t.id == team.id);
    if (index != -1) {
      final updatedTeams = List<Team>.from(state.teams);
      final teamWithTimestamp = team.copyWith(
        updatedAt: DateTime.now(),
      );
      updatedTeams[index] = teamWithTimestamp;
      state = state.copyWith(teams: updatedTeams);
      _saveToLocal();
    }
  }

  void deleteTeam(String teamId) {
    state = state.copyWith(
      teams: state.teams.where((t) => t.id != teamId).toList(),
    );
    _saveToLocal();
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

  void _seedDefaultTeam() {
    final uuid = Uuid();
    final defaultTeam = Team(
      id: uuid.v4(),
      name: 'VolleyFlow Demo',
      players: [
        Player(id: uuid.v4(), name: 'Alex Johnson', number: 1, age: 22, height: 195, mainPosition: PlayerPosition.setter, gender: PlayerGender.male),
        Player(id: uuid.v4(), name: 'Sam Smith', number: 2, age: 24, height: 188, mainPosition: PlayerPosition.attack, gender: PlayerGender.male),
        Player(id: uuid.v4(), name: 'Chris Davis', number: 3, age: 23, height: 202, mainPosition: PlayerPosition.middleBlock, gender: PlayerGender.male),
        Player(id: uuid.v4(), name: 'Pat Wilson', number: 4, age: 21, height: 198, mainPosition: PlayerPosition.opposite, gender: PlayerGender.male),
        Player(id: uuid.v4(), name: 'Taylor Brown', number: 5, age: 25, height: 190, mainPosition: PlayerPosition.attack, gender: PlayerGender.male),
        Player(id: uuid.v4(), name: 'Jordan Miller', number: 6, age: 22, height: 205, mainPosition: PlayerPosition.middleBlock, gender: PlayerGender.male),
        Player(id: uuid.v4(), name: 'Casey Jones', number: 7, age: 20, height: 175, mainPosition: PlayerPosition.libero, gender: PlayerGender.male),
        Player(id: uuid.v4(), name: 'Jamie White', number: 8, age: 26, height: 192, mainPosition: PlayerPosition.setter, gender: PlayerGender.male),
        Player(id: uuid.v4(), name: 'Morgan Green', number: 9, age: 23, height: 189, mainPosition: PlayerPosition.attack, gender: PlayerGender.male),
        Player(id: uuid.v4(), name: 'Drew Black', number: 10, age: 24, height: 200, mainPosition: PlayerPosition.middleBlock, gender: PlayerGender.male),
        Player(id: uuid.v4(), name: 'Riley King', number: 11, age: 22, height: 196, mainPosition: PlayerPosition.opposite, gender: PlayerGender.male),
        Player(id: uuid.v4(), name: 'Avery Scott', number: 12, age: 21, height: 191, mainPosition: PlayerPosition.attack, gender: PlayerGender.male),
        Player(id: uuid.v4(), name: 'Quinn Hall', number: 13, age: 25, height: 203, mainPosition: PlayerPosition.middleBlock, gender: PlayerGender.male),
        Player(id: uuid.v4(), name: 'Reese Adams', number: 14, age: 20, height: 178, mainPosition: PlayerPosition.libero, gender: PlayerGender.male),
        Player(id: uuid.v4(), name: 'Skyler Clark', number: 15, age: 23, height: 194, mainPosition: PlayerPosition.setter, gender: PlayerGender.male),
        Player(id: uuid.v4(), name: 'Cameron Lewis', number: 16, age: 24, height: 190, mainPosition: PlayerPosition.attack, gender: PlayerGender.male),
        Player(id: uuid.v4(), name: 'Parker Young', number: 17, age: 22, height: 201, mainPosition: PlayerPosition.middleBlock, gender: PlayerGender.male),
        Player(id: uuid.v4(), name: 'Dakota Hill', number: 18, age: 21, height: 197, mainPosition: PlayerPosition.opposite, gender: PlayerGender.male),
      ],
      coaches: [
        Coach(id: uuid.v4(), name: 'Coach Carter', isPrimary: true),
        Coach(id: uuid.v4(), name: 'Assistant Lee', isPrimary: false),
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    state = state.copyWith(teams: [defaultTeam], isLoading: false);
    _saveToLocal();
  }
}

final teamsProvider = NotifierProvider<TeamsNotifier, TeamsState>(() {
  return TeamsNotifier();
});

