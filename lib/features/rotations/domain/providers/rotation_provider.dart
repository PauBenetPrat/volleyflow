import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/rotation_positions.dart';
import '../../../../core/constants/rotation_validator.dart';

class RotationState {
  final int rotation; // CourtPosition.position1-6
  final Phase phase;
  final List<String> positions; // Positions for current rotation and phase
  final Map<String, PositionCoord>? customPositions; // Override positions for drag & drop
  final RotationValidationResult? validationResult; // Resultat de la validació de regles

  RotationState({
    required this.rotation,
    required this.phase,
    required this.positions,
    this.customPositions,
    this.validationResult,
  });

  RotationState copyWith({
    int? rotation,
    Phase? phase,
    List<String>? positions,
    Map<String, PositionCoord>? customPositions,
    RotationValidationResult? validationResult,
    bool clearCustomPositions = false,
    bool clearValidation = false,
  }) {
    return RotationState(
      rotation: rotation ?? this.rotation,
      phase: phase ?? this.phase,
      positions: positions ?? this.positions,
      customPositions: clearCustomPositions 
          ? null 
          : (customPositions ?? this.customPositions),
      validationResult: clearValidation 
          ? null 
          : (validationResult ?? this.validationResult),
    );
  }
}

class RotationNotifier extends StateNotifier<RotationState> {
  RotationNotifier()
      : super(RotationState(
          rotation: CourtPosition.position1,
          phase: Phase.base,
          positions: RotationPositions.getPositions(CourtPosition.position1, Phase.base),
        ));

  void rotateClockwise() {
    // Move to next rotation in clockwise direction (1->6->5->4->3->2->1) and set phase to BASE
    final newRotation = state.rotation <= CourtPosition.position1 
        ? CourtPosition.position6 
        : state.rotation - 1;
    final newPositions = RotationPositions.getPositions(newRotation, Phase.base);
    
    state = state.copyWith(
      rotation: newRotation,
      phase: Phase.base,
      positions: newPositions,
      clearCustomPositions: true, // Clear custom positions when rotating
      clearValidation: true, // Clear validation when rotating
    );
  }

  void rotateCounterClockwise() {
    // Move to previous rotation in counter-clockwise direction (1->2->3->4->5->6->1) and set phase to BASE
    final newRotation = state.rotation >= CourtPosition.position6 
        ? CourtPosition.position1 
        : state.rotation + 1;
    final newPositions = RotationPositions.getPositions(newRotation, Phase.base);
    
    state = state.copyWith(
      rotation: newRotation,
      phase: Phase.base,
      positions: newPositions,
      clearCustomPositions: true, // Clear custom positions when rotating
      clearValidation: true, // Clear validation when rotating
    );
  }

  void setPhase(Phase phase) {
    final newPositions = RotationPositions.getPositions(state.rotation, phase);
    state = state.copyWith(
      phase: phase,
      positions: newPositions,
      clearCustomPositions: true, // Clear custom positions when changing phase
      clearValidation: true, // Clear validation when changing phase
    );
  }

  void reset() {
    state = RotationState(
      rotation: CourtPosition.position1,
      phase: Phase.base,
      positions: RotationPositions.getPositions(CourtPosition.position1, Phase.base),
      customPositions: null,
      validationResult: null,
    );
  }

  void updatePlayerPosition(String playerRole, PositionCoord newPosition) {
    // Create or update custom positions map
    final updatedCustomPositions = Map<String, PositionCoord>.from(
      state.customPositions ?? {},
    );
    updatedCustomPositions[playerRole] = newPosition;
    
    // Obtenir totes les posicions actuals (base + custom)
    final basePositions = RotationPositions.getPositionCoords(
      state.rotation,
      state.phase,
    );
    final allPositions = Map<String, PositionCoord>.from(basePositions);
    allPositions.addAll(updatedCustomPositions);
    
    // Validar només si estem en fase de recepció
    RotationValidationResult? validationResult;
    if (state.phase == Phase.recepcio) {
      validationResult = RotationValidator.validateReceptionPositions(
        state.rotation,
        allPositions,
      );
    }
    
    state = state.copyWith(
      customPositions: updatedCustomPositions,
      validationResult: validationResult,
    );
  }

  /// Actualitza la posició d'un jugador sense fer validació
  /// Utilitzat durant el drag per mantenir el moviment fluid
  void updatePlayerPositionWithoutValidation(String playerRole, PositionCoord newPosition) {
    // Create or update custom positions map
    final updatedCustomPositions = Map<String, PositionCoord>.from(
      state.customPositions ?? {},
    );
    updatedCustomPositions[playerRole] = newPosition;
    
    // Actualitzar només la posició, mantenint el resultat de validació anterior
    state = state.copyWith(
      customPositions: updatedCustomPositions,
      // No canviem validationResult per evitar flickering
    );
  }

  void clearCustomPositions() {
    state = state.copyWith(clearCustomPositions: true);
  }
}

final rotationProvider = StateNotifierProvider.autoDispose<RotationNotifier, RotationState>((ref) {
  return RotationNotifier();
});

