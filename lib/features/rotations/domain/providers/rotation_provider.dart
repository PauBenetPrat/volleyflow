import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/rotation_positions_4_2_no_libero.dart';
import '../../../../core/constants/rotation_positions_4_2.dart' as rotation_42;
import '../../../../core/constants/rotation_validator.dart';

class RotationState {
  final int rotation; // CourtPosition.position1-6
  final Phase phase;
  final List<String> positions; // Positions for current rotation and phase
  final Map<String, PositionCoord>? customPositions; // Override positions for drag & drop
  final RotationValidationResult? validationResult; // Resultat de la validació de regles
  final bool isEditMode; // Mode d'edició per extreure coordenades
  final bool isPhaseLocked; // Si la fase està bloquejada, es manté en rotar
  final bool isDrawingMode; // Mode de dibuix sobre el camp
  final List<List<Offset>> drawings; // Llista de traços (cada traç és una llista de punts)
  final bool showGrid; // Mostrar/amagar la graella del camp
  final String? rotationSystem; // Sistema de rotació seleccionat: '4-2', '4-2-no-libero', '5-1', 'Players'

  RotationState({
    required this.rotation,
    required this.phase,
    required this.positions,
    this.customPositions,
    this.validationResult,
    this.isEditMode = false,
    this.isPhaseLocked = false,
    this.isDrawingMode = false,
    this.drawings = const [],
    this.showGrid = false,
    this.rotationSystem,
  });

  RotationState copyWith({
    int? rotation,
    Phase? phase,
    List<String>? positions,
    Map<String, PositionCoord>? customPositions,
    RotationValidationResult? validationResult,
    bool? isEditMode,
    bool? isPhaseLocked,
    bool? isDrawingMode,
    List<List<Offset>>? drawings,
    bool? showGrid,
    String? rotationSystem,
    bool clearCustomPositions = false,
    bool clearValidation = false,
    bool clearDrawings = false,
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
      isDrawingMode: isDrawingMode ?? this.isDrawingMode,
      drawings: clearDrawings ? [] : (drawings ?? this.drawings),
      showGrid: showGrid ?? this.showGrid,
      rotationSystem: rotationSystem ?? this.rotationSystem,
    );
  }
}

class RotationNotifier extends Notifier<RotationState> {
  // Guarda les modificacions per a totes les rotacions i fases
  // Format: rotation -> phase -> playerRole -> PositionCoord
  final Map<int, Map<Phase, Map<String, PositionCoord>>> _savedModifications = {};

  // Helper function to get positions
  List<String> _getPositions(int rotation, Phase phase, [String? rotationSystem]) {
    // Use state.rotationSystem if rotationSystem parameter is null
    final system = rotationSystem ?? state.rotationSystem;
    if (system == '4-2') {
      return rotation_42.RotationPositions42.getPositions(rotation, phase);
    }
    // Default to RotationPositions42NoLibero (4-2-no-libero)
    return RotationPositions42NoLibero.getPositions(rotation, phase);
  }

  // Helper function to get position coordinates
  Map<String, PositionCoord> _getPositionCoords(int rotation, Phase phase, [String? rotationSystem]) {
    // Use state.rotationSystem if rotationSystem parameter is null
    final system = rotationSystem ?? state.rotationSystem;
    if (system == '4-2') {
      return rotation_42.RotationPositions42.getPositionCoords(rotation, phase);
    }
    // Default to RotationPositions42NoLibero (4-2-no-libero)
    return RotationPositions42NoLibero.getPositionCoords(rotation, phase);
  }

  @override
  RotationState build() {
    // Use default rotation system (4-2-no-libero) for initial build
    return RotationState(
      rotation: CourtPosition.position1,
      phase: Phase.base,
      positions: _getPositions(CourtPosition.position1, Phase.base, '4-2-no-libero'),
      isEditMode: false,
      isPhaseLocked: false,
      isDrawingMode: false,
      drawings: [],
      showGrid: false,
    );
  }

  /// Guarda les modificacions actuals abans de canviar de rotació/fase
  /// Només guarda les modificacions que són diferents de les posicions base
  void _saveCurrentModifications() {
    if (state.customPositions != null && state.customPositions!.isNotEmpty) {
      // Obtenir posicions base per comparar
      final basePositions = _getPositionCoords(
        state.rotation,
        state.phase,
        state.rotationSystem,
      );
      
      // Filtrar només les modificacions que són diferents de les posicions base
      final realModifications = <String, PositionCoord>{};
      for (final entry in state.customPositions!.entries) {
        final baseCoord = basePositions[entry.key];
        // Només guardar si és diferent de la base
        if (baseCoord == null || 
            (baseCoord.x != entry.value.x || baseCoord.y != entry.value.y)) {
          realModifications[entry.key] = entry.value;
        }
      }
      
      // Guardar només si hi ha modificacions reals
      if (realModifications.isNotEmpty) {
        _savedModifications.putIfAbsent(state.rotation, () => {});
        _savedModifications[state.rotation]!.putIfAbsent(state.phase, () => {});
        _savedModifications[state.rotation]![state.phase] = realModifications;
      } else {
        // Si no hi ha modificacions reals, eliminar l'entrada
        if (_savedModifications.containsKey(state.rotation)) {
          _savedModifications[state.rotation]!.remove(state.phase);
          if (_savedModifications[state.rotation]!.isEmpty) {
            _savedModifications.remove(state.rotation);
          }
        }
      }
    } else {
      // Si no hi ha customPositions, eliminar l'entrada per aquesta rotació/fase
      if (_savedModifications.containsKey(state.rotation)) {
        _savedModifications[state.rotation]!.remove(state.phase);
        if (_savedModifications[state.rotation]!.isEmpty) {
          _savedModifications.remove(state.rotation);
        }
      }
    }
  }

  /// Carrega les modificacions guardades per la rotació i fase actuals
  Map<String, PositionCoord>? _loadModifications(int rotation, Phase phase) {
    return _savedModifications[rotation]?[phase];
  }

  void rotateClockwise({bool maintainPhase = true}) {
    // Guardar modificacions actuals abans de canviar
    _saveCurrentModifications();
    
    // Move to next rotation in clockwise direction (1->6->5->4->3->2->1)
    final newRotation = state.rotation <= CourtPosition.position1 
        ? CourtPosition.position6 
        : state.rotation - 1;
    
    // Si maintainPhase és true, mantenir la fase; si no, tornar a BASE
    final newPhase = maintainPhase ? state.phase : Phase.base;
    final newPositions = _getPositions(newRotation, newPhase, state.rotationSystem ?? '4-2-no-libero');
    
    // Carregar modificacions guardades per la nova rotació/fase
    final savedMods = _loadModifications(newRotation, newPhase);
    
    // Validar si la nova fase és base o recepció
    RotationValidationResult? validationResult;
    if (newPhase == Phase.base || newPhase == Phase.recepcio) {
      final basePositions = _getPositionCoords(newRotation, newPhase, state.rotationSystem ?? '4-2-no-libero');
      final allPositions = Map<String, PositionCoord>.from(basePositions);
      if (savedMods != null) {
        allPositions.addAll(savedMods);
      }
      validationResult = RotationValidator.validateReceptionPositions(
        newRotation,
        allPositions,
        rotationSystem: state.rotationSystem,
      );
    }
    
    state = state.copyWith(
      rotation: newRotation,
      phase: newPhase,
      positions: newPositions,
      customPositions: savedMods, // Pot ser null si no hi ha modificacions
      clearCustomPositions: savedMods == null, // Netejar si no hi ha modificacions
      validationResult: validationResult,
    );
  }

  void rotateCounterClockwise({bool maintainPhase = true}) {
    // Guardar modificacions actuals abans de canviar
    _saveCurrentModifications();
    
    // Move to previous rotation in counter-clockwise direction (1->2->3->4->5->6->1)
    final newRotation = state.rotation >= CourtPosition.position6 
        ? CourtPosition.position1 
        : state.rotation + 1;
    
    // Si maintainPhase és true, mantenir la fase; si no, tornar a BASE
    final newPhase = maintainPhase ? state.phase : Phase.base;
    final newPositions = _getPositions(newRotation, newPhase, state.rotationSystem ?? '4-2-no-libero');
    
    // Carregar modificacions guardades per la nova rotació/fase
    final savedMods = _loadModifications(newRotation, newPhase);
    
    // Validar si la nova fase és base o recepció
    RotationValidationResult? validationResult;
    if (newPhase == Phase.base || newPhase == Phase.recepcio) {
      final basePositions = _getPositionCoords(newRotation, newPhase, state.rotationSystem ?? '4-2-no-libero');
      final allPositions = Map<String, PositionCoord>.from(basePositions);
      if (savedMods != null) {
        allPositions.addAll(savedMods);
      }
      validationResult = RotationValidator.validateReceptionPositions(
        newRotation,
        allPositions,
        rotationSystem: state.rotationSystem,
      );
    }
    
    state = state.copyWith(
      rotation: newRotation,
      phase: newPhase,
      positions: newPositions,
      customPositions: savedMods, // Pot ser null si no hi ha modificacions
      clearCustomPositions: savedMods == null, // Netejar si no hi ha modificacions
      validationResult: validationResult,
    );
  }

  void setPhase(Phase phase) {
    // Guardar modificacions actuals abans de canviar
    _saveCurrentModifications();
    
    final newPositions = _getPositions(state.rotation, phase, state.rotationSystem ?? '4-2-no-libero');
    
    // Carregar modificacions guardades per la nova fase
    final savedMods = _loadModifications(state.rotation, phase);
    
    // Validar si la nova fase és base o recepció
    RotationValidationResult? validationResult;
    if (phase == Phase.base || phase == Phase.recepcio) {
      final basePositions = _getPositionCoords(state.rotation, phase, state.rotationSystem ?? '4-2-no-libero');
      final allPositions = Map<String, PositionCoord>.from(basePositions);
      if (savedMods != null) {
        allPositions.addAll(savedMods);
      }
      validationResult = RotationValidator.validateReceptionPositions(
        state.rotation,
        allPositions,
        rotationSystem: state.rotationSystem,
      );
    }
    
    state = state.copyWith(
      phase: phase,
      positions: newPositions,
      customPositions: savedMods, // Pot ser null si no hi ha modificacions
      clearCustomPositions: savedMods == null, // Netejar si no hi ha modificacions
      validationResult: validationResult,
    );
  }

  void reset() {
    // Netejar totes les modificacions guardades
    _savedModifications.clear();
    
    state = RotationState(
      rotation: CourtPosition.position1,
      phase: Phase.base,
      positions: _getPositions(CourtPosition.position1, Phase.base, state.rotationSystem ?? '4-2-no-libero'),
      customPositions: null,
      validationResult: null,
      isEditMode: false,
      isPhaseLocked: false,
      isDrawingMode: false,
      drawings: [],
      showGrid: state.showGrid, // Mantenir l'estat de la graella al reset
    );
  }

  void updatePlayerPosition(String playerRole, PositionCoord newPosition) {
    // Obtenir posicions base per comparar
    final basePositions = _getPositionCoords(
      state.rotation,
      state.phase,
      state.rotationSystem ?? '4-2-no-libero',
    );
    
    // Crear map de custom positions només amb jugadors que han estat modificats
    // (és a dir, que la seva posició és diferent de la base)
    final updatedCustomPositions = <String, PositionCoord>{};
    
    // Mantenir les modificacions existents que encara són vàlides
    if (state.customPositions != null) {
      for (final entry in state.customPositions!.entries) {
        final baseCoord = basePositions[entry.key];
        // Només mantenir si és diferent de la base
        if (baseCoord == null || 
            (baseCoord.x != entry.value.x || baseCoord.y != entry.value.y)) {
          updatedCustomPositions[entry.key] = entry.value;
        }
      }
    }
    
    // Afegir/actualitzar el jugador que s'ha mogut
    final baseCoord = basePositions[playerRole];
    // Només guardar si és diferent de la base
    if (baseCoord == null || 
        (baseCoord.x != newPosition.x || baseCoord.y != newPosition.y)) {
      updatedCustomPositions[playerRole] = newPosition;
    }
    
    // Guardar a les modificacions persistents (només si hi ha modificacions)
    if (updatedCustomPositions.isNotEmpty) {
      _savedModifications.putIfAbsent(state.rotation, () => {});
      _savedModifications[state.rotation]!.putIfAbsent(state.phase, () => {});
      _savedModifications[state.rotation]![state.phase] = Map<String, PositionCoord>.from(updatedCustomPositions);
    } else {
      // Si no hi ha modificacions, eliminar l'entrada
      if (_savedModifications.containsKey(state.rotation)) {
        _savedModifications[state.rotation]!.remove(state.phase);
        if (_savedModifications[state.rotation]!.isEmpty) {
          _savedModifications.remove(state.rotation);
        }
      }
    }
    
    // Obtenir totes les posicions actuals (base + custom) per validació
    final allPositions = Map<String, PositionCoord>.from(basePositions);
    allPositions.addAll(updatedCustomPositions);
    
    // Validar si estem en fase base o recepció
    RotationValidationResult? validationResult;
    if (state.phase == Phase.base || state.phase == Phase.recepcio) {
      validationResult = RotationValidator.validateReceptionPositions(
        state.rotation,
        allPositions,
        rotationSystem: state.rotationSystem,
      );
    }
    
    state = state.copyWith(
      customPositions: updatedCustomPositions.isNotEmpty ? updatedCustomPositions : null,
      validationResult: validationResult,
    );
  }

  /// Actualitza la posició d'un jugador sense fer validació
  /// Utilitzat durant el drag per mantenir el moviment fluid
  void updatePlayerPositionWithoutValidation(String playerRole, PositionCoord newPosition) {
    // Obtenir posicions base per comparar
    final basePositions = _getPositionCoords(
      state.rotation,
      state.phase,
      state.rotationSystem ?? '4-2-no-libero',
    );
    
    // Crear map de custom positions només amb jugadors que han estat modificats
    final updatedCustomPositions = <String, PositionCoord>{};
    
    // Mantenir les modificacions existents que encara són vàlides
    if (state.customPositions != null) {
      for (final entry in state.customPositions!.entries) {
        final baseCoord = basePositions[entry.key];
        // Només mantenir si és diferent de la base
        if (baseCoord == null || 
            (baseCoord.x != entry.value.x || baseCoord.y != entry.value.y)) {
          updatedCustomPositions[entry.key] = entry.value;
        }
      }
    }
    
    // Afegir/actualitzar el jugador que s'ha mogut
    final baseCoord = basePositions[playerRole];
    // Només guardar si és diferent de la base
    if (baseCoord == null || 
        (baseCoord.x != newPosition.x || baseCoord.y != newPosition.y)) {
      updatedCustomPositions[playerRole] = newPosition;
    }
    
    // Guardar a les modificacions persistents (només si hi ha modificacions)
    // Sense validació per evitar flickering durant el drag
    if (updatedCustomPositions.isNotEmpty) {
      _savedModifications.putIfAbsent(state.rotation, () => {});
      _savedModifications[state.rotation]!.putIfAbsent(state.phase, () => {});
      _savedModifications[state.rotation]![state.phase] = Map<String, PositionCoord>.from(updatedCustomPositions);
    } else {
      // Si no hi ha modificacions, eliminar l'entrada
      if (_savedModifications.containsKey(state.rotation)) {
        _savedModifications[state.rotation]!.remove(state.phase);
        if (_savedModifications[state.rotation]!.isEmpty) {
          _savedModifications.remove(state.rotation);
        }
      }
    }
    
    // Actualitzar només la posició, mantenint el resultat de validació anterior
    state = state.copyWith(
      customPositions: updatedCustomPositions.isNotEmpty ? updatedCustomPositions : null,
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

  void clearValidation() {
    state = state.copyWith(clearValidation: true);
  }

  void toggleDrawingMode() {
    state = state.copyWith(isDrawingMode: !state.isDrawingMode);
  }

  void toggleGrid() {
    state = state.copyWith(showGrid: !state.showGrid);
  }

  void setRotationSystem(String system) {
    // Get positions with the new system
    final newPositions = _getPositions(state.rotation, state.phase, system);
    // Load saved modifications for current rotation/phase
    final savedMods = _loadModifications(state.rotation, state.phase);
    
    // Validar si la fase actual és base o recepció
    RotationValidationResult? validationResult;
    if (state.phase == Phase.base || state.phase == Phase.recepcio) {
      final basePositions = _getPositionCoords(state.rotation, state.phase, system);
      final allPositions = Map<String, PositionCoord>.from(basePositions);
      if (savedMods != null) {
        allPositions.addAll(savedMods);
      }
      validationResult = RotationValidator.validateReceptionPositions(
        state.rotation,
        allPositions,
        rotationSystem: system,
      );
    }
    
    state = state.copyWith(
      rotationSystem: system,
      positions: newPositions,
      customPositions: savedMods,
      clearCustomPositions: savedMods == null,
      validationResult: validationResult,
    );
  }

  void addDrawingPoint(Offset point) {
    final currentDrawings = state.drawings.map((stroke) => List<Offset>.from(stroke)).toList();
    if (currentDrawings.isEmpty) {
      // Començar un nou traç
      currentDrawings.add([point]);
    } else {
      // Afegir punt al traç actual
      currentDrawings.last.add(point);
    }
    state = state.copyWith(drawings: currentDrawings);
  }

  void startNewDrawing(Offset point) {
    final currentDrawings = state.drawings.map((stroke) => List<Offset>.from(stroke)).toList();
    currentDrawings.add([point]);
    state = state.copyWith(drawings: currentDrawings);
  }

  void clearDrawings() {
    state = state.copyWith(clearDrawings: true);
  }

  void undoLastDrawing() {
    if (state.drawings.isEmpty) return;
    final currentDrawings = state.drawings.map((stroke) => List<Offset>.from(stroke)).toList();
    currentDrawings.removeLast();
    state = state.copyWith(drawings: currentDrawings);
  }

  /// Obté totes les coordenades modificades en format JSON per copiar
  /// Retorna el format complet amb totes les rotacions i fases que tenen modificacions
  /// Format útil per definir les posicions per defecte
  String getAllCoordinatesJson() {
    // Primer, guardar les modificacions actuals
    _saveCurrentModifications();
    
    // Si no hi ha modificacions, retornar només la rotació i fase actuals
    if (_savedModifications.isEmpty) {
      return _getCurrentRotationPhaseJson();
    }
    
    final buffer = StringBuffer();
    buffer.writeln('{');
    
    // Ordenar rotacions (1-6)
    final sortedRotations = _savedModifications.keys.toList()..sort();
    
    for (int r = 0; r < sortedRotations.length; r++) {
      final rotation = sortedRotations[r];
      final isLastRotation = r == sortedRotations.length - 1;
      
      buffer.writeln('  "$rotation": {');
      
      // Ordenar fases: base, sac, recepcio, defensa
      final phaseOrder = [Phase.base, Phase.sac, Phase.recepcio, Phase.defensa];
      final phases = _savedModifications[rotation]!;
      
      // Filtrar només les fases que existeixen
      final existingPhases = phaseOrder.where((phase) => phases.containsKey(phase)).toList();
      
      for (int p = 0; p < existingPhases.length; p++) {
        final phase = existingPhases[p];
        final isLastPhase = p == existingPhases.length - 1;
        final phaseMods = phases[phase]!;
        
        buffer.writeln('    "${phase.name}": {');
        
        // Ordenar jugadors: Co, C1, C2, R1, R2, O
        final playerOrder = ['Co', 'C1', 'C2', 'R1', 'R2', 'O'];
        final entries = phaseMods.entries.toList();
        final sortedEntries = <MapEntry<String, PositionCoord>>[];
        
        for (final player in playerOrder) {
          final entry = entries.firstWhere(
            (e) => e.key == player,
            orElse: () => MapEntry('', PositionCoord(x: 0, y: 0)),
          );
          if (entry.key.isNotEmpty) {
            sortedEntries.add(entry);
          }
        }
        
        for (int i = 0; i < sortedEntries.length; i++) {
          final entry = sortedEntries[i];
          final isLastPlayer = i == sortedEntries.length - 1;
          buffer.writeln('      "${entry.key}": {');
          buffer.writeln('        "x": ${entry.value.x},');
          buffer.writeln('        "y": ${entry.value.y}');
          buffer.writeln('      }${isLastPlayer ? '' : ','}');
        }
        
        buffer.writeln('    }${isLastPhase ? '' : ','}');
      }
      
      buffer.writeln('  }${isLastRotation ? '' : ','}');
    }
    
    buffer.writeln('}');
    return buffer.toString();
  }
  
  /// Obté les coordenades de la rotació i fase actuals en format JSON
  String _getCurrentRotationPhaseJson() {
    final basePositions = _getPositionCoords(
      state.rotation,
      state.phase,
      state.rotationSystem ?? '4-2-no-libero',
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
    buffer.writeln('{');
    buffer.writeln('  "$state.rotation": {');
    buffer.writeln('    "${state.phase.name}": {');
    
    // Ordenar jugadors: Co, C1, C2, R1, R2, O
    final playerOrder = ['Co', 'C1', 'C2', 'R1', 'R2', 'O'];
    final sortedEntries = <MapEntry<String, Map<String, double>>>[];
    
    for (final player in playerOrder) {
      if (jsonMap.containsKey(player)) {
        sortedEntries.add(MapEntry(player, jsonMap[player]!));
      }
    }
    
    for (int i = 0; i < sortedEntries.length; i++) {
      final entry = sortedEntries[i];
      final isLast = i == sortedEntries.length - 1;
      buffer.writeln('      "${entry.key}": {');
      buffer.writeln('        "x": ${entry.value['x']},');
      buffer.writeln('        "y": ${entry.value['y']}');
      buffer.writeln('      }${isLast ? '' : ','}');
    }
    
    buffer.writeln('    }');
    buffer.writeln('  }');
    buffer.writeln('}');
    
    return buffer.toString();
  }
  
  /// Mètode legacy per compatibilitat
  @Deprecated('Use getAllCoordinatesJson() instead')
  String getCurrentCoordinatesJson() {
    return _getCurrentRotationPhaseJson();
  }
}

final rotationProvider = NotifierProvider.autoDispose<RotationNotifier, RotationState>(() {
  return RotationNotifier();
});

