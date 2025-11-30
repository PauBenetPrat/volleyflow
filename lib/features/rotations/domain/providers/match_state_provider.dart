import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../teams/domain/models/match_roster.dart';
import '../../../../core/database/database_helper.dart';
import '../models/match_state.dart';

export '../models/match_state.dart';

class MatchStateNotifier extends Notifier<MatchState?> {
  @override
  MatchState? build() {
    // Attempt to load state asynchronously? 
    // Notifiers build synchronously. We should trigger a load.
    // For now, return null and let the UI trigger initialization/loading.
    return null; 
  }

  Future<void> loadFromDatabase() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final savedJson = await dbHelper.getMatchState();
      
      if (savedJson != null) {
        var loadedState = MatchState.fromJson(savedJson);
        
        // Load logs
        final logs = await dbHelper.getPointLogs(loadedState.matchRoster?.id);
        loadedState = loadedState.copyWith(logs: logs);
        
        state = loadedState;
      }
    } catch (e) {
      print('Error loading match state: $e');
    }
  }

  void initializeMatch(MatchRoster? matchRoster) {
    state = MatchState(matchRoster: matchRoster);
    _saveToDatabase();
  }

  void updateState(MatchState newState) {
    state = newState;
    _saveToDatabase();
  }

  void updateOpponentPlayerNumber(String ghostId, int number) {
    if (state == null) return;
    final updatedNumbers = Map<String, int>.from(state!.opponentPlayerNumbers);
    updatedNumbers[ghostId] = number;
    state = state!.copyWith(opponentPlayerNumbers: updatedNumbers);
    _saveToDatabase();
  }

  void addLog(PointLog log) {
    if (state == null) return;
    state = state!.copyWith(logs: [...state!.logs, log]);
    
    // Save log to SQL table
    DatabaseHelper.instance.addPointLog(log, state!.matchRoster?.id);
    // Also save state to update scores etc
    _saveToDatabase();
  }

  void resetMatch() {
    state = null;
    DatabaseHelper.instance.clearMatchState();
    DatabaseHelper.instance.clearLogs();
  }
  
  void _saveToDatabase() {
    if (state != null) {
      DatabaseHelper.instance.saveMatchState(state!.toJson());
    }
  }
}

final matchStateProvider = NotifierProvider<MatchStateNotifier, MatchState?>(() {
  return MatchStateNotifier();
});
