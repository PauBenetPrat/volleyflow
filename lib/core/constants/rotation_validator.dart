import 'rotation_positions.dart';

/// Resultat de la validació de les regles de rotació
class RotationValidationResult {
  final bool isValid;
  final List<String> errors;
  
  const RotationValidationResult({
    required this.isValid,
    required this.errors,
  });
  
  static const RotationValidationResult valid = RotationValidationResult(
    isValid: true,
    errors: [],
  );
}

/// Validador de regles de rotació per a la fase de recepció
class RotationValidator {
  /// Retorna la posició lateral (left, center, right) segons la posició del camp
  static String _getLateralPosition(int position) {
    if (position == CourtPosition.position1 || position == CourtPosition.position2) {
      return 'right';
    } else if (position == CourtPosition.position3 || position == CourtPosition.position6) {
      return 'center';
    } else if (position == CourtPosition.position4 || position == CourtPosition.position5) {
      return 'left';
    }
    return 'center';
  }
  /// Valida les posicions dels jugadors segons les regles de rotació
  /// 
  /// Regla 1: Jugadors davanters davant dels posteriors
  /// Regla 2: Jugadors dreta/centre/esquerra correctes
  static RotationValidationResult validateReceptionPositions(
    int rotation,
    Map<String, PositionCoord> playerPositions,
  ) {
    final errors = <String>[];
    
    // IMPORTANT: Utilitzar les posicions BASE (no recepció) per determinar 
    // quins jugadors són davanters/posteriors segons la rotació real
    final basePhasePositions = RotationPositions.getPositionCoords(
      rotation,
      Phase.base,
    );
    
    // Determinar quins jugadors són davanters i quins són posteriors
    // segons la seva posició BASE a la rotació
    final frontRowPlayers = <String>[];
    final backRowPlayers = <String>[];
    final playerBasePositions = <String, int>{};
    
    // Trobar la posició base més propera per a cada jugador
    for (final entry in basePhasePositions.entries) {
      final playerRole = entry.key;
      final baseCoord = entry.value;
      
      // Trobar la posició estàndard més propera
      int closestPos = CourtPosition.position1;
      double minDist = double.infinity;
      for (final pos in CourtPosition.allPositions) {
        final stdCoord = PositionCoord.fromStandardPosition(pos);
        final dist = (baseCoord.x - stdCoord.x).abs() + (baseCoord.y - stdCoord.y).abs();
        if (dist < minDist) {
          minDist = dist;
          closestPos = pos;
        }
      }
      
      playerBasePositions[playerRole] = closestPos;
      
      // Determinar si és davanter o posterior segons la posició BASE
      if (CourtPosition.isFrontRow(closestPos)) {
        frontRowPlayers.add(playerRole);
      } else {
        backRowPlayers.add(playerRole);
      }
    }
    
    // Crear mapa invers: posició -> jugador
    final positionToPlayer = <int, String>{};
    for (final entry in playerBasePositions.entries) {
      positionToPlayer[entry.value] = entry.key;
    }
    
    // Ordre circular de les posicions (1-2-3-4-5-6)
    // Cada jugador només pot estar en falta amb el jugador abans i després
    for (int pos = 1; pos <= 6; pos++) {
      final currentPlayer = positionToPlayer[pos];
      if (currentPlayer == null) continue;
      
      // Trobar jugadors adjacents (abans i després en l'ordre circular)
      final previousPos = pos == 1 ? 6 : pos - 1;
      final nextPos = pos == 6 ? 1 : pos + 1;
      
      final previousPlayer = positionToPlayer[previousPos];
      final nextPlayer = positionToPlayer[nextPos];
      
      final currentX = playerPositions[currentPlayer]?.x ?? 0.0;
      final currentY = playerPositions[currentPlayer]?.y ?? 0.0;
      
      // Regla 1: Comprovar amb el jugador anterior (X - davant/darrere)
      if (previousPlayer != null) {
        final previousX = playerPositions[previousPlayer]?.x ?? 0.0;
        
        // Si el jugador actual és davanter i l'anterior és posterior,
        // el davanter no pot estar per darrere del posterior
        final currentIsFront = CourtPosition.isFrontRow(pos);
        final previousIsBack = CourtPosition.isBackRow(previousPos);
        
        if (currentIsFront && previousIsBack && currentX < previousX) {
          errors.add(
            'Regla 1: $currentPlayer (davanter, pos $pos) està per darrere de $previousPlayer (posterior, pos $previousPos)',
          );
        }
        
        // Si el jugador actual és posterior i l'anterior és davanter,
        // el posterior no pot estar davant del davanter
        final currentIsBack = CourtPosition.isBackRow(pos);
        final previousIsFront = CourtPosition.isFrontRow(previousPos);
        
        if (currentIsBack && previousIsFront && currentX > previousX) {
          errors.add(
            'Regla 1: $currentPlayer (posterior, pos $pos) està davant de $previousPlayer (davanter, pos $previousPos)',
          );
        }
      }
      
      // Regla 1: Comprovar amb el jugador següent (X - davant/darrere)
      if (nextPlayer != null) {
        final nextX = playerPositions[nextPlayer]?.x ?? 0.0;
        
        // Si el jugador actual és davanter i el següent és posterior,
        // el davanter no pot estar per darrere del posterior
        final currentIsFront = CourtPosition.isFrontRow(pos);
        final nextIsBack = CourtPosition.isBackRow(nextPos);
        
        if (currentIsFront && nextIsBack && currentX < nextX) {
          errors.add(
            'Regla 1: $currentPlayer (davanter, pos $pos) està per darrere de $nextPlayer (posterior, pos $nextPos)',
          );
        }
        
        // Si el jugador actual és posterior i el següent és davanter,
        // el posterior no pot estar davant del davanter
        final currentIsBack = CourtPosition.isBackRow(pos);
        final nextIsFront = CourtPosition.isFrontRow(nextPos);
        
        if (currentIsBack && nextIsFront && currentX > nextX) {
          errors.add(
            'Regla 1: $currentPlayer (posterior, pos $pos) està davant de $nextPlayer (davanter, pos $nextPos)',
          );
        }
      }
      
      // Regla 2: Comprovar amb el jugador anterior (Y - dreta/esquerra)
      if (previousPlayer != null) {
        final previousY = playerPositions[previousPlayer]?.y ?? 0.0;
        
        // Determinar posició lateral de cada jugador
        final currentLateral = _getLateralPosition(pos);
        final previousLateral = _getLateralPosition(previousPos);
        
        // Si el jugador actual hauria d'estar a la dreta i l'anterior a l'esquerra,
        // el de dreta no pot estar a l'esquerra del d'esquerra
        if (currentLateral == 'right' && previousLateral == 'left' && currentY < previousY) {
          errors.add(
            'Regla 2: $currentPlayer (dreta, pos $pos) està a l\'esquerra de $previousPlayer (esquerra, pos $previousPos)',
          );
        }
        
        if (currentLateral == 'right' && previousLateral == 'center' && currentY < previousY) {
          errors.add(
            'Regla 2: $currentPlayer (dreta, pos $pos) està a l\'esquerra de $previousPlayer (centre, pos $previousPos)',
          );
        }
        
        if (currentLateral == 'center' && previousLateral == 'left' && currentY < previousY) {
          errors.add(
            'Regla 2: $currentPlayer (centre, pos $pos) està a l\'esquerra de $previousPlayer (esquerra, pos $previousPos)',
          );
        }
      }
      
      // Regla 2: Comprovar amb el jugador següent (Y - dreta/esquerra)
      if (nextPlayer != null) {
        final nextY = playerPositions[nextPlayer]?.y ?? 0.0;
        
        // Determinar posició lateral de cada jugador
        final currentLateral = _getLateralPosition(pos);
        final nextLateral = _getLateralPosition(nextPos);
        
        // Si el jugador actual hauria d'estar a la dreta i el següent a l'esquerra,
        // el de dreta no pot estar a l'esquerra del d'esquerra
        if (currentLateral == 'right' && nextLateral == 'left' && currentY < nextY) {
          errors.add(
            'Regla 2: $currentPlayer (dreta, pos $pos) està a l\'esquerra de $nextPlayer (esquerra, pos $nextPos)',
          );
        }
        
        if (currentLateral == 'right' && nextLateral == 'center' && currentY < nextY) {
          errors.add(
            'Regla 2: $currentPlayer (dreta, pos $pos) està a l\'esquerra de $nextPlayer (centre, pos $nextPos)',
          );
        }
        
        if (currentLateral == 'center' && nextLateral == 'left' && currentY < nextY) {
          errors.add(
            'Regla 2: $currentPlayer (centre, pos $pos) està a l\'esquerra de $nextPlayer (esquerra, pos $nextPos)',
          );
        }
      }
    }
    
    return RotationValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
}

