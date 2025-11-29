import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/match_roster.dart';

class MatchRostersState {
  final List<MatchRoster> rosters;
  final bool isLoading;
  final String? error;

  MatchRostersState({
    required this.rosters,
    this.isLoading = false,
    this.error,
  });

  MatchRostersState copyWith({
    List<MatchRoster>? rosters,
    bool? isLoading,
    String? error,
  }) {
    return MatchRostersState(
      rosters: rosters ?? this.rosters,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class MatchRostersNotifier extends Notifier<MatchRostersState> {
  final _supabase = Supabase.instance.client;

  @override
  MatchRostersState build() {
    // Don't call loadRosters here to avoid accessing state before initialization
    // Instead, load will be triggered when provider is first accessed
    Future.microtask(() => loadRosters());
    return MatchRostersState(rosters: [], isLoading: true);
  }

  Future<void> loadRosters() async {
    final currentState = state;
    state = currentState.copyWith(isLoading: true, error: null);
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        state = state.copyWith(rosters: [], isLoading: false);
        return;
      }

      final response = await _supabase
          .from('match_rosters')
          .select()
          .eq('user_id', userId)
          .order('match_date', ascending: false);

      final rosters = <MatchRoster>[];
      for (final item in (response as List)) {
        try {
          final roster = MatchRoster.fromJson(item as Map<String, dynamic>);
          rosters.add(roster);
        } catch (e) {
          print('Error parsing roster: $e');
          print('Roster data: $item');
          // Skip invalid rosters but continue loading others
        }
      }

      state = state.copyWith(rosters: rosters, isLoading: false);
    } catch (e) {
      print('Error loading rosters: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load match rosters: ${e.toString()}',
      );
    }
  }

  Future<void> addRoster(MatchRoster roster) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final data = roster.toJson();
      data['user_id'] = userId;

      await _supabase.from('match_rosters').insert(data);

      // Reload rosters
      await loadRosters();
    } catch (e) {
      print('Error adding roster: $e');
      state = state.copyWith(error: 'Failed to create match roster');
      rethrow;
    }
  }

  Future<void> updateRoster(MatchRoster roster) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final data = roster.toJson();
      data['user_id'] = userId;
      data['updated_at'] = DateTime.now().toIso8601String();

      await _supabase
          .from('match_rosters')
          .update(data)
          .eq('id', roster.id)
          .eq('user_id', userId);

      // Reload rosters
      await loadRosters();
    } catch (e) {
      print('Error updating roster: $e');
      state = state.copyWith(error: 'Failed to update match roster');
      rethrow;
    }
  }

  Future<void> deleteRoster(String rosterId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await _supabase
          .from('match_rosters')
          .delete()
          .eq('id', rosterId)
          .eq('user_id', userId);

      // Reload rosters
      await loadRosters();
    } catch (e) {
      print('Error deleting roster: $e');
      state = state.copyWith(error: 'Failed to delete match roster');
      rethrow;
    }
  }

  List<MatchRoster> getRostersByTeam(String teamId) {
    return state.rosters.where((r) => r.teamId == teamId).toList();
  }
}

final matchRostersProvider = NotifierProvider<MatchRostersNotifier, MatchRostersState>(() {
  return MatchRostersNotifier();
});
