// Rotation positions data structure
// Each rotation (R1-R6) has 4 phases: BASE, SAC, RECEPCIÓ, DEFENSA
// Each phase defines where each player role (Co, C1, C2, R1, R2, O) is positioned
// Positions can be either:
//   - int (1-6): Standard court position
//   - Map with 'x' and 'y': Specific coordinates as percentages (0.0-1.0)
//     where x=0.0 is back (left), x=1.0 is front (right/near net)
//     and y=0.0 is top, y=1.0 is bottom

enum Phase {
  base,
  sac,
  recepcio,
  defensa,
}

// Court position constants (1-6)
class CourtPosition {
  // Standard volleyball court positions
  static const int position1 = 1; // Back right
  static const int position2 = 2; // Front right
  static const int position3 = 3; // Front center
  static const int position4 = 4; // Front left
  static const int position5 = 5; // Back left
  static const int position6 = 6; // Back center
  
  // All positions
  static const List<int> allPositions = [1, 2, 3, 4, 5, 6];
  
  // Front row positions (davanters - prop de la xarxa)
  static const List<int> frontRowPositions = [2, 3, 4];
  
  // Back row positions (posteriors - lluny de la xarxa)
  static const List<int> backRowPositions = [1, 5, 6];
  
  // Check if a position is in front row
  static bool isFrontRow(int position) {
    return frontRowPositions.contains(position);
  }
  
  // Check if a position is in back row
  static bool isBackRow(int position) {
    return backRowPositions.contains(position);
  }
  
  // Validate position is between 1-6
  static bool isValid(int position) {
    return position >= 1 && position <= 6;
  }
}

// Helper class for position coordinates
class PositionCoord {
  final double x; // 0.0 = back, 1.0 = front (near net)
  final double y; // 0.0 = top, 1.0 = bottom
  
  const PositionCoord({required this.x, required this.y});
  
  // Create from standard position (1-6)
  static PositionCoord fromStandardPosition(int position) {
    switch (position) {
      case CourtPosition.position1: return const PositionCoord(x: 0.25, y: 0.75); // back right
      case CourtPosition.position2: return const PositionCoord(x: 0.75, y: 0.75); // front right
      case CourtPosition.position3: return const PositionCoord(x: 0.75, y: 0.5); // front center
      case CourtPosition.position4: return const PositionCoord(x: 0.75, y: 0.25); // front left
      case CourtPosition.position5: return const PositionCoord(x: 0.25, y: 0.25); // back left
      case CourtPosition.position6: return const PositionCoord(x: 0.25, y: 0.5); // back center
      default: return const PositionCoord(x: 0.5, y: 0.5);
    }
  }
}

class RotationPositions {
  // Map: Rotation (1-6) -> Phase -> Player Role -> Position (int 1-6 or Map with x,y)
  // Format: [Rotation][Phase][PlayerRole] = Position (int or Map with 'x' and 'y' keys)
  static final Map<int, Map<Phase, Map<String, dynamic>>> positions = {
    // Rotación 1
    1: {
      Phase.base: {
        'Co': {'x': 0.25, 'y': 0.75}, // Position 1: back right
        'R1': {'x': 0.75, 'y': 0.75}, // Position 2: front right
        'C2': {'x': 0.75, 'y': 0.5}, // Position 3: front center
        'O': {'x': 0.75, 'y': 0.25},  // Position 4: front left
        'R2': {'x': 0.25, 'y': 0.25}, // Position 5: back left
        'C1': {'x': 0.25, 'y': 0.5}, // Position 6: back center
      },
      Phase.sac: {
        'Co': {'x': 0.15, 'y': 0.85}, // Serves from back right corner
        'R1': {'x': 0.75, 'y': 0.75},
        'C2': {'x': 0.75, 'y': 0.5},
        'O': {'x': 0.75, 'y': 0.25},
        'R2': {'x': 0.25, 'y': 0.25},
        'C1': {'x': 0.25, 'y': 0.5},
      },
      Phase.recepcio: {
        'Co': {'x': 0.15, 'y': 0.85}, // Back right corner to receive
        'R1': {'x': 0.24, 'y': 0.75}, // Slightly forward to receive
        'C2': {'x': 0.75, 'y': 0.5},
        'O': {'x': 0.75, 'y': 0.25},
        'R2': {'x': 0.25, 'y': 0.25},
        'C1': {'x': 0.25, 'y': 0.5},
      },
      Phase.defensa: {
        'Co': {'x': 0.75, 'y': 0.75}, // At net (front right)
        'R1': {'x': 0.25, 'y': 0.75}, // Back right
        'C2': {'x': 0.75, 'y': 0.5}, // Front center
        'O': {'x': 0.75, 'y': 0.25}, // Front left
        'R2': {'x': 0.25, 'y': 0.25}, // Back left
        'C1': {'x': 0.25, 'y': 0.5}, // Back center
      },
    },
    // Rotación 2
    2: {
      Phase.base: {
        'Co': {'x': 0.75, 'y': 0.75}, // Front right
        'R1': {'x': 0.75, 'y': 0.5}, // Front center
        'C2': {'x': 0.75, 'y': 0.25}, // Front left
        'O': {'x': 0.25, 'y': 0.25},  // Back left
        'R2': {'x': 0.25, 'y': 0.5}, // Back center
        'C1': {'x': 0.25, 'y': 0.75}, // Back right
      },
      Phase.sac: {
        'Co': {'x': 0.75, 'y': 0.75}, // Front right
        'R1': {'x': 0.75, 'y': 0.5}, // Front center
        'C2': {'x': 0.75, 'y': 0.25}, // Front left
        'O': {'x': 0.15, 'y': 0.85}, // Serves from back right corner
        'R2': {'x': 0.25, 'y': 0.5}, // Back center
        'C1': {'x': 0.25, 'y': 0.25}, // Back left
      },
      Phase.recepcio: {
        'Co': {'x': 0.75, 'y': 0.75}, // At net (front right)
        'R1': {'x': 0.75, 'y': 0.5}, // Front center
        'C2': {'x': 0.75, 'y': 0.25}, // Front left
        'O': {'x': 0.15, 'y': 0.85}, // Back right corner to receive
        'R2': {'x': 0.24, 'y': 0.75}, // Slightly forward to receive
        'C1': {'x': 0.25, 'y': 0.25}, // Back left
      },
      Phase.defensa: {
        'Co': {'x': 0.75, 'y': 0.75}, // At net (front right)
        'R1': {'x': 0.75, 'y': 0.5}, // Front center
        'C2': {'x': 0.75, 'y': 0.25}, // Front left
        'O': {'x': 0.25, 'y': 0.75}, // Back right
        'R2': {'x': 0.25, 'y': 0.5}, // Back center
        'C1': {'x': 0.25, 'y': 0.25}, // Back left
      },
    },
    // Rotación 3
    3: {
      Phase.base: {
        'Co': {'x': 0.75, 'y': 0.5}, // Front center
        'R1': {'x': 0.75, 'y': 0.25}, // Front left
        'C2': {'x': 0.25, 'y': 0.25}, // Back left
        'O': {'x': 0.25, 'y': 0.5},  // Back center
        'R2': {'x': 0.25, 'y': 0.75}, // Back right
        'C1': {'x': 0.75, 'y': 0.75}, // Front right
      },
      Phase.sac: {
        'Co': {'x': 0.75, 'y': 0.5}, // Front center
        'R1': {'x': 0.75, 'y': 0.25}, // Front left
        'C2': {'x': 0.25, 'y': 0.25}, // Back left
        'O': {'x': 0.15, 'y': 0.85}, // Serves from back right corner
        'R2': {'x': 0.25, 'y': 0.5}, // Back center
        'C1': {'x': 0.75, 'y': 0.75}, // Front right
      },
      Phase.recepcio: {
        'Co': {'x': 0.75, 'y': 0.75}, // Moves to net (front right)
        'R1': {'x': 0.75, 'y': 0.25}, // Front left
        'C2': {'x': 0.25, 'y': 0.25}, // Back left
        'O': {'x': 0.15, 'y': 0.85}, // Back right corner to receive
        'R2': {'x': 0.24, 'y': 0.75}, // Slightly forward to receive
        'C1': {'x': 0.75, 'y': 0.5}, // Drops back (front center)
      },
      Phase.defensa: {
        'Co': {'x': 0.75, 'y': 0.75}, // At net (front right)
        'R1': {'x': 0.75, 'y': 0.25}, // Front left
        'C2': {'x': 0.25, 'y': 0.25}, // Back left
        'O': {'x': 0.25, 'y': 0.75}, // Back right
        'R2': {'x': 0.25, 'y': 0.5}, // Back center
        'C1': {'x': 0.75, 'y': 0.5}, // Front center
      },
    },
    // Rotación 4
    4: {
      Phase.base: {
        'Co': {'x': 0.75, 'y': 0.25}, // Front left
        'R1': {'x': 0.25, 'y': 0.25}, // Back left
        'C2': {'x': 0.25, 'y': 0.5}, // Back center
        'O': {'x': 0.25, 'y': 0.75},  // Back right
        'R2': {'x': 0.75, 'y': 0.75}, // Front right
        'C1': {'x': 0.75, 'y': 0.5}, // Front center
      },
      Phase.sac: {
        'Co': {'x': 0.75, 'y': 0.25}, // Front left
        'R1': {'x': 0.25, 'y': 0.25}, // Back left
        'C2': {'x': 0.25, 'y': 0.5}, // Back center
        'O': {'x': 0.15, 'y': 0.85}, // Serves from back right corner
        'R2': {'x': 0.75, 'y': 0.75}, // Front right
        'C1': {'x': 0.75, 'y': 0.5}, // Front center
      },
      Phase.recepcio: {
        'Co': {'x': 0.75, 'y': 0.75}, // Moves to net (front right)
        'R1': {'x': 0.25, 'y': 0.25}, // Back left
        'C2': {'x': 0.25, 'y': 0.5}, // Back center
        'O': {'x': 0.15, 'y': 0.85}, // Back right corner to receive
        'R2': {'x': 0.75, 'y': 0.25}, // Drops back (front left)
        'C1': {'x': 0.75, 'y': 0.5}, // Front center
      },
      Phase.defensa: {
        'Co': {'x': 0.75, 'y': 0.75}, // At net (front right)
        'R1': {'x': 0.25, 'y': 0.25}, // Back left
        'C2': {'x': 0.25, 'y': 0.5}, // Back center
        'O': {'x': 0.25, 'y': 0.75}, // Back right
        'R2': {'x': 0.75, 'y': 0.25}, // Front left
        'C1': {'x': 0.75, 'y': 0.5}, // Front center
      },
    },
    // Rotación 5
    5: {
      Phase.base: {
        'Co': {'x': 0.25, 'y': 0.25}, // Back left
        'R1': {'x': 0.25, 'y': 0.5}, // Back center
        'C2': {'x': 0.25, 'y': 0.75}, // Back right
        'O': {'x': 0.75, 'y': 0.75},  // Front right
        'R2': {'x': 0.75, 'y': 0.5}, // Front center
        'C1': {'x': 0.75, 'y': 0.25}, // Front left
      },
      Phase.sac: {
        'Co': {'x': 0.25, 'y': 0.25}, // Back left
        'R1': {'x': 0.25, 'y': 0.5}, // Back center
        'C2': {'x': 0.25, 'y': 0.75}, // Back right
        'O': {'x': 0.15, 'y': 0.85}, // Serves from back right corner
        'R2': {'x': 0.75, 'y': 0.5}, // Front center
        'C1': {'x': 0.75, 'y': 0.25}, // Front left
      },
      Phase.recepcio: {
        'Co': {'x': 0.75, 'y': 0.75}, // Moves to net (front right)
        'R1': {'x': 0.25, 'y': 0.5}, // Back center
        'C2': {'x': 0.15, 'y': 0.85}, // Back right corner to receive
        'O': {'x': 0.24, 'y': 0.75}, // Slightly forward to receive
        'R2': {'x': 0.75, 'y': 0.5}, // Front center
        'C1': {'x': 0.75, 'y': 0.25}, // Front left
      },
      Phase.defensa: {
        'Co': {'x': 0.75, 'y': 0.75}, // At net (front right)
        'R1': {'x': 0.25, 'y': 0.5}, // Back center
        'C2': {'x': 0.25, 'y': 0.75}, // Back right
        'O': {'x': 0.25, 'y': 0.25}, // Back left
        'R2': {'x': 0.75, 'y': 0.5}, // Front center
        'C1': {'x': 0.75, 'y': 0.25}, // Front left
      },
    },
    // Rotación 6
    6: {
      Phase.base: {
        'Co': {'x': 0.25, 'y': 0.5}, // Back center
        'R1': {'x': 0.25, 'y': 0.75}, // Back right
        'C2': {'x': 0.75, 'y': 0.75}, // Front right
        'O': {'x': 0.75, 'y': 0.5},  // Front center
        'R2': {'x': 0.75, 'y': 0.25}, // Front left
        'C1': {'x': 0.25, 'y': 0.25}, // Back left
      },
      Phase.sac: {
        'Co': {'x': 0.15, 'y': 0.85}, // Serves from back right corner
        'R1': {'x': 0.25, 'y': 0.5}, // Back center
        'C2': {'x': 0.75, 'y': 0.75}, // Front right
        'O': {'x': 0.75, 'y': 0.5}, // Front center
        'R2': {'x': 0.75, 'y': 0.25}, // Front left
        'C1': {'x': 0.25, 'y': 0.25}, // Back left
      },
      Phase.recepcio: {
        'Co': {'x': 0.75, 'y': 0.75}, // Moves to net (front right)
        'R1': {'x': 0.15, 'y': 0.85}, // Back right corner to receive
        'C2': {'x': 0.25, 'y': 0.25}, // Drops back (back left)
        'O': {'x': 0.75, 'y': 0.5}, // Front center
        'R2': {'x': 0.75, 'y': 0.25}, // Front left
        'C1': {'x': 0.24, 'y': 0.75}, // Slightly forward to receive
      },
      Phase.defensa: {
        'Co': {'x': 0.75, 'y': 0.75}, // At net (front right)
        'R1': {'x': 0.25, 'y': 0.5}, // Back center
        'C2': {'x': 0.25, 'y': 0.25}, // Back left
        'O': {'x': 0.75, 'y': 0.5}, // Front center
        'R2': {'x': 0.75, 'y': 0.25}, // Front left
        'C1': {'x': 0.25, 'y': 0.75}, // Back right
      },
    },
  };

  // Get positions for a specific rotation and phase
  // Returns a map: PlayerRole -> PositionCoord
  static Map<String, PositionCoord> getPositionCoords(int rotation, Phase phase) {
    final rotationMap = positions[rotation];
    if (rotationMap == null) {
      // Default fallback - use standard positions
      return {
        'Co': PositionCoord.fromStandardPosition(CourtPosition.position1),
        'R1': PositionCoord.fromStandardPosition(CourtPosition.position2),
        'C2': PositionCoord.fromStandardPosition(CourtPosition.position3),
        'O': PositionCoord.fromStandardPosition(CourtPosition.position4),
        'R2': PositionCoord.fromStandardPosition(CourtPosition.position5),
        'C1': PositionCoord.fromStandardPosition(CourtPosition.position6),
      };
    }
    
    final phasePositions = rotationMap[phase];
    if (phasePositions == null) {
      // Default fallback - use standard positions
      return {
        'Co': PositionCoord.fromStandardPosition(CourtPosition.position1),
        'R1': PositionCoord.fromStandardPosition(CourtPosition.position2),
        'C2': PositionCoord.fromStandardPosition(CourtPosition.position3),
        'O': PositionCoord.fromStandardPosition(CourtPosition.position4),
        'R2': PositionCoord.fromStandardPosition(CourtPosition.position5),
        'C1': PositionCoord.fromStandardPosition(CourtPosition.position6),
      };
    }

    final result = <String, PositionCoord>{};
    
    // Map each player role to their position coordinate
    // Convert to Map<String, dynamic> to handle type issues
    final phaseMap = Map<String, dynamic>.from(phasePositions);
    phaseMap.forEach((playerRole, position) {
      if (position is int) {
        // Standard position (1-6)
        result[playerRole] = PositionCoord.fromStandardPosition(position);
      } else if (position is Map) {
        // Custom coordinates - handle both Map<String, dynamic> and Map<Object?, Object?>
        final posMap = Map<String, dynamic>.from(position);
        final x = (posMap['x'] as num?)?.toDouble() ?? 0.5;
        final y = (posMap['y'] as num?)?.toDouble() ?? 0.5;
        result[playerRole] = PositionCoord(x: x, y: y);
      }
    });

    return result;
  }
  
  // Legacy method: Get positions as list (for backward compatibility)
  // Returns a list where index 0-5 corresponds to court positions 1-6
  static List<String> getPositions(int rotation, Phase phase) {
    final coords = getPositionCoords(rotation, phase);
    // Convert to list format (approximate to standard positions)
    final result = List<String>.filled(CourtPosition.allPositions.length, '');
    
    coords.forEach((playerRole, coord) {
      // Find closest standard position
      int closestPos = CourtPosition.position1;
      double minDist = double.infinity;
      for (final pos in CourtPosition.allPositions) {
        final stdCoord = PositionCoord.fromStandardPosition(pos);
        final dist = (coord.x - stdCoord.x).abs() + (coord.y - stdCoord.y).abs();
        if (dist < minDist) {
          minDist = dist;
          closestPos = pos;
        }
      }
      result[closestPos - 1] = playerRole;
    });
    
    return result;
  }
  
  // Get players in front row positions for a specific rotation and phase
  static Map<String, PositionCoord> getFrontRowPositions(int rotation, Phase phase) {
    final allPositions = getPositionCoords(rotation, phase);
    final frontRow = <String, PositionCoord>{};
    
    allPositions.forEach((playerRole, coord) {
      // Find closest standard position
      int closestPos = CourtPosition.position1;
      double minDist = double.infinity;
      for (final pos in CourtPosition.allPositions) {
        final stdCoord = PositionCoord.fromStandardPosition(pos);
        final dist = (coord.x - stdCoord.x).abs() + (coord.y - stdCoord.y).abs();
        if (dist < minDist) {
          minDist = dist;
          closestPos = pos;
        }
      }
      
      // If closest position is in front row, include this player
      if (CourtPosition.isFrontRow(closestPos)) {
        frontRow[playerRole] = coord;
      }
    });
    
    return frontRow;
  }
  
  // Get players in back row positions for a specific rotation and phase
  static Map<String, PositionCoord> getBackRowPositions(int rotation, Phase phase) {
    final allPositions = getPositionCoords(rotation, phase);
    final backRow = <String, PositionCoord>{};
    
    allPositions.forEach((playerRole, coord) {
      // Find closest standard position
      int closestPos = CourtPosition.position1;
      double minDist = double.infinity;
      for (final pos in CourtPosition.allPositions) {
        final stdCoord = PositionCoord.fromStandardPosition(pos);
        final dist = (coord.x - stdCoord.x).abs() + (coord.y - stdCoord.y).abs();
        if (dist < minDist) {
          minDist = dist;
          closestPos = pos;
        }
      }
      
      // If closest position is in back row, include this player
      if (CourtPosition.isBackRow(closestPos)) {
        backRow[playerRole] = coord;
      }
    });
    
    return backRow;
  }
}

