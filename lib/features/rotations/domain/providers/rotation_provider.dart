import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/rotation_positions.dart';

class RotationState {
  final int rotation; // 1-6
  final Phase phase;
  final List<String> positions; // Positions for current rotation and phase
  final Map<String, PositionCoord>? customPositions; // Override positions for drag & drop

  RotationState({
    required this.rotation,
    required this.phase,
    required this.positions,
    this.customPositions,
  });

  RotationState copyWith({
    int? rotation,
    Phase? phase,
    List<String>? positions,
    Map<String, PositionCoord>? customPositions,
    bool clearCustomPositions = false,
  }) {
    return RotationState(
      rotation: rotation ?? this.rotation,
      phase: phase ?? this.phase,
      positions: positions ?? this.positions,
      customPositions: clearCustomPositions 
          ? null 
          : (customPositions ?? this.customPositions),
    );
  }
}

class RotationNotifier extends StateNotifier<RotationState> {
  RotationNotifier()
      : super(RotationState(
          rotation: 1,
          phase: Phase.base,
          positions: RotationPositions.getPositions(1, Phase.base),
        ));

  void rotateClockwise() {
    // Move to next rotation in clockwise direction (1->6->5->4->3->2->1) and set phase to BASE
    final newRotation = state.rotation <= 1 ? 6 : state.rotation - 1;
    final newPositions = RotationPositions.getPositions(newRotation, Phase.base);
    
    state = state.copyWith(
      rotation: newRotation,
      phase: Phase.base,
      positions: newPositions,
      clearCustomPositions: true, // Clear custom positions when rotating
    );
  }

  void rotateCounterClockwise() {
    // Move to previous rotation in counter-clockwise direction (1->2->3->4->5->6->1) and set phase to BASE
    final newRotation = state.rotation >= 6 ? 1 : state.rotation + 1;
    final newPositions = RotationPositions.getPositions(newRotation, Phase.base);
    
    state = state.copyWith(
      rotation: newRotation,
      phase: Phase.base,
      positions: newPositions,
      clearCustomPositions: true, // Clear custom positions when rotating
    );
  }

  void setPhase(Phase phase) {
    final newPositions = RotationPositions.getPositions(state.rotation, phase);
    state = state.copyWith(
      phase: phase,
      positions: newPositions,
      clearCustomPositions: true, // Clear custom positions when changing phase
    );
  }

  void reset() {
    state = RotationState(
      rotation: 1,
      phase: Phase.base,
      positions: RotationPositions.getPositions(1, Phase.base),
      customPositions: null,
    );
  }

  void updatePlayerPosition(String playerRole, PositionCoord newPosition) {
    // Create or update custom positions map
    final updatedCustomPositions = Map<String, PositionCoord>.from(
      state.customPositions ?? {},
    );
    updatedCustomPositions[playerRole] = newPosition;
    
    state = state.copyWith(
      customPositions: updatedCustomPositions,
    );
  }

  void clearCustomPositions() {
    state = state.copyWith(clearCustomPositions: true);
  }
}

final rotationProvider = StateNotifierProvider.autoDispose<RotationNotifier, RotationState>((ref) {
  return RotationNotifier();
});

