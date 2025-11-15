import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/rotation_positions.dart';

class RotationState {
  final int rotation; // 1-6
  final Phase phase;
  final List<String> positions; // Positions for current rotation and phase

  RotationState({
    required this.rotation,
    required this.phase,
    required this.positions,
  });

  RotationState copyWith({
    int? rotation,
    Phase? phase,
    List<String>? positions,
  }) {
    return RotationState(
      rotation: rotation ?? this.rotation,
      phase: phase ?? this.phase,
      positions: positions ?? this.positions,
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
    // Move to next rotation (1->2->3->4->5->6->1) and set phase to BASE
    final newRotation = state.rotation >= 6 ? 1 : state.rotation + 1;
    final newPositions = RotationPositions.getPositions(newRotation, Phase.base);
    
    state = state.copyWith(
      rotation: newRotation,
      phase: Phase.base,
      positions: newPositions,
    );
  }

  void setPhase(Phase phase) {
    final newPositions = RotationPositions.getPositions(state.rotation, phase);
    state = state.copyWith(
      phase: phase,
      positions: newPositions,
    );
  }

  void reset() {
    state = RotationState(
      rotation: 1,
      phase: Phase.base,
      positions: RotationPositions.getPositions(1, Phase.base),
    );
  }
}

final rotationProvider = StateNotifierProvider<RotationNotifier, RotationState>((ref) {
  return RotationNotifier();
});

