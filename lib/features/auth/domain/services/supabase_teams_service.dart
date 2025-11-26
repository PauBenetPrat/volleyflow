import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../teams/domain/models/team.dart';
import '../../../teams/domain/models/player.dart';
import '../../../teams/domain/models/coach.dart';

class SupabaseTeamsService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Fetch all teams for the current user
  Future<List<Team>> fetchTeams() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _supabase
        .from('teams')
        .select('*, players(*), coaches(*)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((teamData) {
      final players = (teamData['players'] as List?)
              ?.map((p) => Player.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [];

      final coaches = (teamData['coaches'] as List?)
              ?.map((c) => Coach.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [];

      return Team(
        id: teamData['id'],
        name: teamData['name'],
        players: players,
        coaches: coaches,
        createdAt: DateTime.parse(teamData['created_at']),
        updatedAt: DateTime.parse(teamData['updated_at']),
      );
    }).toList();
  }

  // Create a new team
  Future<Team> createTeam(Team team) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    // Insert team
    final teamResponse = await _supabase.from('teams').insert({
      'id': team.id,
      'user_id': userId,
      'name': team.name,
    }).select().single();

    // Insert players
    if (team.players.isNotEmpty) {
      await _supabase.from('players').insert(
            team.players.map((p) => {
                  'id': p.id,
                  'team_id': team.id,
                  'name': p.name,
                  'alias': p.alias,
                  'number': p.number,
                  'age': p.age,
                  'height': p.height,
                  'main_position': p.mainPosition?.name,
                  'is_captain': p.isCaptain,
                  'gender': p.gender?.name,
                }).toList(),
          );
    }

    // Insert coaches
    if (team.coaches.isNotEmpty) {
      await _supabase.from('coaches').insert(
            team.coaches.map((c) => {
                  'id': c.id,
                  'team_id': team.id,
                  'name': c.name,
                  'is_primary': c.isPrimary,
                }).toList(),
          );
    }

    return team;
  }

  // Update a team
  Future<void> updateTeam(Team team) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    // Update team
    await _supabase.from('teams').update({
      'name': team.name,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', team.id).eq('user_id', userId);

    // Delete existing players and coaches
    await _supabase.from('players').delete().eq('team_id', team.id);
    await _supabase.from('coaches').delete().eq('team_id', team.id);

    // Insert updated players
    if (team.players.isNotEmpty) {
      await _supabase.from('players').insert(
            team.players.map((p) => {
                  'id': p.id,
                  'team_id': team.id,
                  'name': p.name,
                  'alias': p.alias,
                  'number': p.number,
                  'age': p.age,
                  'height': p.height,
                  'main_position': p.mainPosition?.name,
                  'is_captain': p.isCaptain,
                  'gender': p.gender?.name,
                }).toList(),
          );
    }

    // Insert updated coaches
    if (team.coaches.isNotEmpty) {
      await _supabase.from('coaches').insert(
            team.coaches.map((c) => {
                  'id': c.id,
                  'team_id': team.id,
                  'name': c.name,
                  'is_primary': c.isPrimary,
                }).toList(),
          );
    }
  }

  // Delete a team
  Future<void> deleteTeam(String teamId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    await _supabase
        .from('teams')
        .delete()
        .eq('id', teamId)
        .eq('user_id', userId);
  }
}
