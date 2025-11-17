import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/rotation_positions.dart';
import '../../../../core/constants/rotation_validator.dart';

class RotationState {
  final int rotation; // CourtPosition.position1-6
  final Phase phase;
  final List<String> positions; // Positions for current rotation and phase
  final Map<String, PositionCoord>? customPositions; // Override positions for drag & drop
  final RotationValidationResult? validationResult; // Resultat de la validació de regles
  final bool isEditMode; // Mode d'edició per extreure coordenades
  final bool isPhaseLocked; // Si la fase està bloquejada, es manté en rotar

  RotationState({
    required this.rotation,
    required this.phase,
    required this.positions,
    this.customPositions,
    this.validationResult,
    this.isEditMode = false,
    this.isPhaseLocked = false,
  });

  RotationState copyWith({
    int? rotation,
    Phase? phase,
    List<String>? positions,
    Map<String, PositionCoord>? customPositions,
    RotationValidationResult? validationResult,
    bool? isEditMode,
    bool? isPhaseLocked,
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
      isEditMode: isEditMode ?? this.isEditMode,
      isPhaseLocked: isPhaseLocked ?? this.isPhaseLocked,
    );
  }
}

class RotationNotifier extends StateNotifier<RotationState> {
  RotationNotifier()
      : super(RotationState(
          rotation: CourtPosition.position1,
          phase: Phase.base,
          positions: RotationPositions.getPositions(CourtPosition.position1, Phase.base),
          isEditMode: false,
          isPhaseLocked: false,
        ));

  void rotateClockwise() {
    // Move to next rotation in clockwise direction (1->6->5->4->3->2->1)
    final newRotation = state.rotation <= CourtPosition.position1 
        ? CourtPosition.position6 
        : state.rotation - 1;
    
    // Si la fase està bloquejada, mantenir-la; si no, tornar a BASE
    final newPhase = state.isPhaseLocked ? state.phase : Phase.base;
    final newPositions = RotationPositions.getPositions(newRotation, newPhase);
    
    state = state.copyWith(
      rotation: newRotation,
      phase: newPhase,
      positions: newPositions,
      clearCustomPositions: true, // Clear custom positions when rotating
      clearValidation: true, // Clear validation when rotating
    );
  }

  void rotateCounterClockwise() {
    // Move to previous rotation in counter-clockwise direction (1->2->3->4->5->6->1)
    final newRotation = state.rotation >= CourtPosition.position6 
        ? CourtPosition.position1 
        : state.rotation + 1;
    
    // Si la fase està bloquejada, mantenir-la; si no, tornar a BASE
    final newPhase = state.isPhaseLocked ? state.phase : Phase.base;
    final newPositions = RotationPositions.getPositions(newRotation, newPhase);
    
    state = state.copyWith(
      rotation: newRotation,
      phase: newPhase,
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
      isEditMode: false,
      isPhaseLocked: false,
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

  void toggleEditMode() {
    state = state.copyWith(isEditMode: !state.isEditMode);
  }

  void togglePhaseLock() {
    state = state.copyWith(isPhaseLocked: !state.isPhaseLocked);
  }

  /// Obté les coordenades actuals en format JSON per copiar
  /// Retorna el format complet amb rotació i fase
  String getCurrentCoordinatesJson() {
    final basePositions = RotationPositions.getPositionCoords(
      state.rotation,
      state.phase,
    );
    
    // Merge base positions with custom positions
    final allPositions = Map<String, PositionCoord>.from(basePositions);
    if (state.customPositions != null) {
      allPositions.addAll(state.customPositions!);
    }
    
    // Convert to JSON format
    final jsonMap = <String, Map<String, double>>{};
    allPositions.forEach((role, coord) {
      jsonMap[role] = {
        'x': coord.x,
        'y': coord.y,
      };
    });
    
    // Format as JSON string with rotation and phase
    final buffer = StringBuffer();
    buffer.writeln('"${state.rotation}": {');
    buffer.writeln('  "${state.phase.name}": {');
    
    final entries = jsonMap.entries.toList();
    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final isLast = i == entries.length - 1;
      buffer.writeln('    "${entry.key}": {');
      buffer.writeln('      "x": ${entry.value['x']},');
      buffer.writeln('      "y": ${entry.value['y']}');
      buffer.writeln('    }${isLast ? '' : ','}');
    }
    
    buffer.writeln('  }');
    buffer.writeln('}');
    
    return buffer.toString();
  }
}

final rotationProvider = StateNotifierProvider.autoDispose<RotationNotifier, RotationState>((ref) {
  return RotationNotifier();
});

