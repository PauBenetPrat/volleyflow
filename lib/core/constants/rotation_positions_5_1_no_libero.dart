// Rotation positions data structure for 5-1 system (no libero)
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

class RotationPositions51NoLibero {
  // Map: Rotation (1-6) -> Phase -> Player Role -> Position (int 1-6 or Map with x,y)
  // Format: [Rotation][Phase][PlayerRole] = Position (int or Map with 'x' and 'y' keys)
  static final Map<int, Map<Phase, Map<String, dynamic>>> positions = {
    // Rotación 1
    1: {
      Phase.base: {
        'Co': {'x': 0.2500, 'y': 0.7500}, // Position 1: back right
        'R1': {'x': 0.7500, 'y': 0.7500}, // Position 2: front right
        'C2': {'x': 0.7500, 'y': 0.5000}, // Position 3: front center
        'O': {'x': 0.7500, 'y': 0.2500},  // Position 4: front left
        'R2': {'x': 0.2500, 'y': 0.2500}, // Position 5: back left
        'C1': {'x': 0.2500, 'y': 0.5000}, // Position 6: back center
      },
      Phase.sac: {
        'Co': {'x': 0.0374, 'y': 0.8142}, // Serves from back right corner
        'R1': {'x': 0.8766, 'y': 0.6108},
        'C2': {'x': 0.8642, 'y': 0.4907},
        'O': {'x': 0.8723, 'y': 0.3614},
        'R2': {'x': 0.1766, 'y': 0.2471},
        'C1': {'x': 0.2111, 'y': 0.3659},
      },
      Phase.recepcio: {
        'Co': {'x': 0.3797, 'y': 0.8489},
        'R1': {'x': 0.4572, 'y': 0.7312},
        'C2': {'x': 0.7458, 'y': 0.4211},
        'O': {'x': 0.7391, 'y': 0.1083},
        'R2': {'x': 0.3583, 'y': 0.1858},
        'C1': {'x': 0.3877, 'y': 0.4693},
      },
      Phase.defensa: {
        'Co': {'x': 0.3648, 'y': 0.9262},
        'R1': {'x': 0.9462, 'y': 0.8438},
        'C2': {'x': 0.9509, 'y': 0.7460},
        'O': {'x': 0.7438, 'y': 0.3550},
        'R2': {'x': 0.1555, 'y': 0.4350},
        'C1': {'x': 0.3431, 'y': 0.2270},
      },
    },
    // Rotación 2
    2: {
      Phase.base: {
        'Co': {'x': 0.7500, 'y': 0.7500}, // Front right
        'R1': {'x': 0.7500, 'y': 0.5000}, // Front center
        'C2': {'x': 0.7500, 'y': 0.2500}, // Front left
        'O': {'x': 0.2500, 'y': 0.2500},  // Back left
        'R2': {'x': 0.2500, 'y': 0.5000}, // Back center
        'C1': {'x': 0.2500, 'y': 0.7500}, // Back right
      },
      Phase.sac: {
        'Co': {'x': 0.9037, 'y': 0.6029},
        'R2': {'x': 0.2377, 'y': 0.4799},
        'C1': {'x': 0.0187, 'y': 0.7794},
        'C2': {'x': 0.8984, 'y': 0.3943},
        'R1': {'x': 0.8797, 'y': 0.5094},
        'O': {'x': 0.4964, 'y': 0.3423},
      },
      Phase.recepcio: {
        'Co': {'x': 0.9320, 'y': 0.7438},
        'R1': {'x': 0.4135, 'y': 0.2049},
        'C2': {'x': 0.7355, 'y': 0.0850},
        'O': {'x': 0.0828, 'y': 0.2943},
        'R2': {'x': 0.3877, 'y': 0.4982},
        'C1': {'x': 0.4499, 'y': 0.8147},
      },
      Phase.defensa: {
        'Co': {'x': 0.9427, 'y': 0.8594},
        'R1': {'x': 0.7322, 'y': 0.4749},
        'C2': {'x': 0.9466, 'y': 0.7289},
        'O': {'x': 0.2445, 'y': 0.9331},
        'R2': {'x': 0.1632, 'y': 0.4172},
        'C1': {'x': 0.4586, 'y': 0.1900},
      },
    },
    // Rotación 3
    3: {
      Phase.base: {
        'Co': {'x': 0.7500, 'y': 0.5000}, // Front center
        'R1': {'x': 0.7500, 'y': 0.2500}, // Front left
        'C2': {'x': 0.2500, 'y': 0.2500}, // Back left
        'O': {'x': 0.2500, 'y': 0.5000},  // Back center
        'R2': {'x': 0.2500, 'y': 0.7500}, // Back right
        'C1': {'x': 0.7500, 'y': 0.7500}, // Front right
      },
      Phase.sac: {
        'Co': {'x': 0.8797, 'y': 0.4746},
        'C1': {'x': 0.8957, 'y': 0.5921},
        'C2': {'x': 0.2500, 'y': 0.2500}, // Back left
        'R1': {'x': 0.8797, 'y': 0.3730},
        'R2': {'x': 0.0641, 'y': 0.8195},
        'O': {'x': 0.5457, 'y': 0.7009},
      },
      Phase.recepcio: {
        'Co': {'x': 0.8850, 'y': 0.6110},
        'R1': {'x': 0.3775, 'y': 0.1926},
        'C2': {'x': 0.3556, 'y': 0.4532},
        'O': {'x': 0.0509, 'y': 0.5683},
        'R2': {'x': 0.4044, 'y': 0.7700},
        'C1': {'x': 0.7513, 'y': 0.8997},
      },
      Phase.defensa: {
        'Co': {'x': 0.9332, 'y': 0.8647},
        'R1': {'x': 0.7180, 'y': 0.4847},
        'C2': {'x': 0.3716, 'y': 0.2154},
        'O': {'x': 0.2511, 'y': 0.9255},
        'R2': {'x': 0.1141, 'y': 0.4364},
        'C1': {'x': 0.9342, 'y': 0.7292},
      },
    },
    // Rotación 4
    4: {
      Phase.base: {
        'Co': {'x': 0.7500, 'y': 0.2500}, // Front left
        'R1': {'x': 0.2500, 'y': 0.2500}, // Back left
        'C2': {'x': 0.2500, 'y': 0.5000}, // Back center
        'O': {'x': 0.2500, 'y': 0.7500},  // Back right
        'R2': {'x': 0.7500, 'y': 0.7500}, // Front right
        'C1': {'x': 0.7500, 'y': 0.5000}, // Front center
      },
      Phase.sac: {
        'Co': {'x': 0.8797, 'y': 0.3650},
        'C1': {'x': 0.8904, 'y': 0.4880},
        'C2': {'x': 0.2086, 'y': 0.4104},
        'R1': {'x': 0.1748, 'y': 0.3252},
        'R2': {'x': 0.8556, 'y': 0.6029},
        'O': {'x': 0.0374, 'y': 0.8409},
      },
      Phase.recepcio: {
        'Co': {'x': 0.9299, 'y': 0.0970},
        'R1': {'x': 0.3585, 'y': 0.4887},
        'C2': {'x': 0.3900, 'y': 0.8000}, // Position 1: back center
        'O': {'x': 0.0472, 'y': 0.8400},
        'R2': {'x': 0.3521, 'y': 0.2031},
        'C1': {'x': 0.7355, 'y': 0.1679},
      },
      Phase.defensa: {
        'Co': {'x': 0.9494, 'y': 0.8306},
        'R1': {'x': 0.1181, 'y': 0.3946},
        'C2': {'x': 0.3352, 'y': 0.1862},
        'O': {'x': 0.2842, 'y': 0.9469},
        'R2': {'x': 0.7300, 'y': 0.4589},
        'C1': {'x': 0.9493, 'y': 0.7269},
      },
    },
    // Rotación 5
    5: {
      Phase.base: {
        'Co': {'x': 0.2500, 'y': 0.2500}, // Back left
        'R1': {'x': 0.2500, 'y': 0.5000}, // Back center
        'C2': {'x': 0.2500, 'y': 0.7500}, // Back right
        'O': {'x': 0.7500, 'y': 0.7500},  // Front right
        'R2': {'x': 0.7500, 'y': 0.5000}, // Front center
        'C1': {'x': 0.7500, 'y': 0.2500}, // Front left
      },
      Phase.sac: {
        'Co': {'x': 0.5058, 'y': 0.2842},
        'C1': {'x': 0.8824, 'y': 0.3810},
        'C2': {'x': 0.0615, 'y': 0.7901},
        'R1': {'x': 0.2674, 'y': 0.5013},
        'R2': {'x': 0.8690, 'y': 0.4987},
        'O': {'x': 0.9037, 'y': 0.6082},
      },
      Phase.recepcio: {
        'Co': {'x': 0.8408, 'y': 0.3972},
        'R1': {'x': 0.3654, 'y': 0.4947},
        'C2': {'x': 0.4900, 'y': 0.7469},
        'O': {'x': 0.7322, 'y': 0.9106},
        'R2': {'x': 0.4760, 'y': 0.2099},
        'C1': {'x': 0.9350, 'y': 0.0538},
      },
      Phase.defensa: {
        'Co': {'x': 0.3074, 'y': 0.9310},
        'R1': {'x': 0.1741, 'y': 0.3757},
        'C2': {'x': 0.4902, 'y': 0.1719},
        'O': {'x': 0.9448, 'y': 0.8023},
        'R2': {'x': 0.7471, 'y': 0.4593},
        'C1': {'x': 0.9440, 'y': 0.6919},
      },
    },
    // Rotación 6
    6: {
      Phase.base: {
        'Co': {'x': 0.2500, 'y': 0.5000}, // Back center
        'R1': {'x': 0.2500, 'y': 0.7500}, // Back right
        'C2': {'x': 0.7500, 'y': 0.7500}, // Front right
        'O': {'x': 0.7500, 'y': 0.5000},  // Front center
        'R2': {'x': 0.7500, 'y': 0.2500}, // Front left
        'C1': {'x': 0.2500, 'y': 0.2500}, // Back left
      },
      Phase.sac: {
        'C1': {'x': 0.3904, 'y': 0.2431},
        'Co': {'x': 0.4960, 'y': 0.7097},
        'C2': {'x': 0.9011, 'y': 0.5709},
        'R1': {'x': 0.0348, 'y': 0.8249},
        'R2': {'x': 0.8824, 'y': 0.3595},
        'O': {'x': 0.8824, 'y': 0.4746},
      },
      Phase.recepcio: {
        'Co': {'x': 0.8852, 'y': 0.6185},
        'R1': {'x': 0.4759, 'y': 0.7322},
        'C2': {'x': 0.7635, 'y': 0.9105},
        'O': {'x': 0.9589, 'y': 0.7544},
        'R2': {'x': 0.3835, 'y': 0.1932},
        'C1': {'x': 0.3769, 'y': 0.4986},
      },
      Phase.defensa: {
        'Co': {'x': 0.3343, 'y': 0.9473},
        'R1': {'x': 0.1512, 'y': 0.4164},
        'C2': {'x': 0.9557, 'y': 0.6751},
        'O': {'x': 0.9568, 'y': 0.7860},
        'R2': {'x': 0.7155, 'y': 0.4393},
        'C1': {'x': 0.3439, 'y': 0.2000},
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

