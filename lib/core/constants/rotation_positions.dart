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

// Helper class for position coordinates
class PositionCoord {
  final double x; // 0.0 = back, 1.0 = front (near net)
  final double y; // 0.0 = top, 1.0 = bottom
  
  const PositionCoord({required this.x, required this.y});
  
  // Create from standard position (1-6)
  static PositionCoord fromStandardPosition(int position) {
    switch (position) {
      case 1: return const PositionCoord(x: 0.25, y: 0.75); // back right
      case 2: return const PositionCoord(x: 0.75, y: 0.75); // front right
      case 3: return const PositionCoord(x: 0.75, y: 0.5); // front center
      case 4: return const PositionCoord(x: 0.75, y: 0.25); // front left
      case 5: return const PositionCoord(x: 0.25, y: 0.25); // back left
      case 6: return const PositionCoord(x: 0.25, y: 0.5); // back center
      default: return const PositionCoord(x: 0.5, y: 0.5);
    }
  }
}

class RotationPositions {
  // Map: Rotation (1-6) -> Phase -> Player Role -> Position (int 1-6 or PositionCoord)
  // Format: [Rotation][Phase][PlayerRole] = Position (int or PositionCoord)
  static const Map<int, Map<Phase, Map<String, dynamic>>> positions = {
    // Rotación 1
    1: {
      Phase.base: {
        'Co': 1, // Position 1
        'R1': 2, // Position 2
        'C2': 3, // Position 3
        'O': 4,  // Position 4
        'R2': 5, // Position 5
        'C1': 6, // Position 6
      },
      Phase.sac: {
        'Co': 1, // Serves from position 1
        'R1': 2,
        'C2': 3,
        'O': 4,
        'R2': 5,
        'C1': 6,
      },
      Phase.recepcio: {
        'Co': 2, // Moves to net
        'R1': 1, // Drops back to receive
        'C2': 3,
        'O': 4,
        'R2': 5,
        'C1': 6,
      },
      Phase.defensa: {
        'Co': 2, // At net
        'R1': 1,
        'C2': 3,
        'O': 4,
        'R2': 5,
        'C1': 6,
      },
    },
    // Rotación 2
    2: {
      Phase.base: {
        'Co': 2, // Front right
        'R1': 3, // Front center
        'C2': 4, // Front left
        'O': 5,  // Back left
        'R2': 6, // Back center
        'C1': 1, // Back right
      },
      Phase.sac: {
        'Co': 2,
        'R1': 3,
        'C2': 4,
        'O': 1, // Serves from position 1
        'R2': 6,
        'C1': 5,
      },
      Phase.recepcio: {
        'Co': 2, // At net (front right)
        'R1': 3, // Front center
        'C2': 4, // Front left
        'O': 1,  // Back right (just served)
        'R2': 6, // Back center
        'C1': 5, // Back left
      },
      Phase.defensa: {
        'Co': 2, // At net
        'R1': 3,
        'C2': 4,
        'O': 1,
        'R2': 6,
        'C1': 5,
      },
    },
    // Rotación 3
    3: {
      Phase.base: {
        'Co': 3, // Front center
        'R1': 4, // Front left
        'C2': 5, // Back left
        'O': 6,  // Back center
        'R2': 1, // Back right
        'C1': 2, // Front right
      },
      Phase.sac: {
        'Co': 3,
        'R1': 4,
        'C2': 5,
        'O': 1, // Serves from position 1
        'R2': 6,
        'C1': 2,
      },
      Phase.recepcio: {
        'Co': 2, // Moves to net
        'R1': 4,
        'C2': 5,
        'O': 1,
        'R2': 6,
        'C1': 3, // Drops back
      },
      Phase.defensa: {
        'Co': 2,
        'R1': 4,
        'C2': 5,
        'O': 1,
        'R2': 6,
        'C1': 3,
      },
    },
    // Rotación 4
    4: {
      Phase.base: {
        'Co': 4, // Front left
        'R1': 5, // Back left
        'C2': 6, // Back center
        'O': 1,  // Back right
        'R2': 2, // Front right
        'C1': 3, // Front center
      },
      Phase.sac: {
        'Co': 4,
        'R1': 5,
        'C2': 6,
        'O': 1, // Serves from position 1
        'R2': 2,
        'C1': 3,
      },
      Phase.recepcio: {
        'Co': 2, // Moves to net
        'R1': 5,
        'C2': 6,
        'O': 1,
        'R2': 4, // Drops back
        'C1': 3,
      },
      Phase.defensa: {
        'Co': 2,
        'R1': 5,
        'C2': 6,
        'O': 1,
        'R2': 4,
        'C1': 3,
      },
    },
    // Rotación 5
    5: {
      Phase.base: {
        'Co': 5, // Back left
        'R1': 6, // Back center
        'C2': 1, // Back right
        'O': 2,  // Front right
        'R2': 3, // Front center
        'C1': 4, // Front left
      },
      Phase.sac: {
        'Co': 5,
        'R1': 6,
        'C2': 1,
        'O': 1, // Serves from position 1
        'R2': 3,
        'C1': 4,
      },
      Phase.recepcio: {
        'Co': 2, // Moves to net
        'R1': 6,
        'C2': 1,
        'O': 5, // Drops back
        'R2': 3,
        'C1': 4,
      },
      Phase.defensa: {
        'Co': 2,
        'R1': 6,
        'C2': 1,
        'O': 5,
        'R2': 3,
        'C1': 4,
      },
    },
    // Rotación 6
    6: {
      Phase.base: {
        'Co': 6, // Back center
        'R1': 1, // Back right
        'C2': 2, // Front right
        'O': 3,  // Front center
        'R2': 4, // Front left
        'C1': 5, // Back left
      },
      Phase.sac: {
        'Co': 1, // Serves from position 1
        'R1': 6,
        'C2': 2,
        'O': 3,
        'R2': 4,
        'C1': 5,
      },
      Phase.recepcio: {
        'Co': 2, // Moves to net
        'R1': 6,
        'C2': 5, // Drops back
        'O': 3,
        'R2': 4,
        'C1': 1,
      },
      Phase.defensa: {
        'Co': 2,
        'R1': 6,
        'C2': 5,
        'O': 3,
        'R2': 4,
        'C1': 1,
      },
    },
  };

  // Get positions for a specific rotation and phase
  // Returns a map: PlayerRole -> PositionCoord
  static Map<String, PositionCoord> getPositionCoords(int rotation, Phase phase) {
    final phasePositions = positions[rotation]?[phase];
    if (phasePositions == null) {
      // Default fallback - use standard positions
      return {
        'Co': PositionCoord.fromStandardPosition(1),
        'R1': PositionCoord.fromStandardPosition(2),
        'C2': PositionCoord.fromStandardPosition(3),
        'O': PositionCoord.fromStandardPosition(4),
        'R2': PositionCoord.fromStandardPosition(5),
        'C1': PositionCoord.fromStandardPosition(6),
      };
    }

    final result = <String, PositionCoord>{};
    
    // Map each player role to their position coordinate
    phasePositions.forEach((playerRole, position) {
      if (position is int) {
        // Standard position (1-6)
        result[playerRole] = PositionCoord.fromStandardPosition(position);
      } else if (position is Map) {
        // Custom coordinates
        final x = position['x'] as double? ?? 0.5;
        final y = position['y'] as double? ?? 0.5;
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
    final result = List<String>.filled(6, '');
    
    coords.forEach((playerRole, coord) {
      // Find closest standard position
      int closestPos = 1;
      double minDist = double.infinity;
      for (int pos = 1; pos <= 6; pos++) {
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
}

