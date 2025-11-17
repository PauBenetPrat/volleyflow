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
        'Co': {'x': 0.0374331550802139, 'y': 0.8141711229946524}, // Serves from back right corner
        'R1': {'x': 0.8766, 'y': 0.6108},
        'C2': {'x': 0.8642, 'y': 0.4907},
        'O': {'x': 0.8723, 'y': 0.3614},
        'R2': {'x': 0.3159, 'y': 0.2824},
        'C1': {'x': 0.2111, 'y': 0.3659},
      },
      Phase.recepcio: {
        'Co': {'x': 0.15, 'y': 0.85}, // Back right corner to receive
        'R1': {'x': 0.31016042780748665, 'y': 0.7713903743315508},
        'C2': {'x': 0.7458, 'y': 0.4211},
        'O': {'x': 0.8736, 'y': 0.0785},
        'R2': {'x': 0.32887700534759357, 'y': 0.18315508021390375},
        'C1': {'x': 0.20053475935828877, 'y': 0.42112299465240643},
      },
      Phase.defensa: {
        'Co': {'x': 0.5927, 'y': 0.7716}, // At net (front right)
        'R1': {'x': 0.9236, 'y': 0.7456}, // Back right
        'C2': {'x': 0.9258, 'y': 0.6023}, // Front center
        'O': {'x': 0.75, 'y': 0.25}, // Front left
        'R2': {'x': 0.3519, 'y': 0.2149}, // Back left
        'C1': {'x': 0.2240, 'y': 0.4830}, // Back center
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
        'Co': {'x': 0.9037433155080213, 'y': 0.6029411764705882},
        'C1': {'x': 0.01871657754010695, 'y': 0.7794117647058824},
        'C2': {'x': 0.8983957219251337, 'y': 0.39438502673796794},
        'R1': {'x': 0.8796791443850267, 'y': 0.5093582887700535},
        'O': {'x': 0.339572192513369, 'y': 0.3810160427807487},
      },
      Phase.recepcio: {
        'Co': {'x': 0.8449197860962567, 'y': 0.7312834224598931},
        'R1': {'x': 0.1925133689839572, 'y': 0.49064171122994654},
        'C2': {'x': 0.7754010695187166, 'y': 0.42379679144385024},
        'O': {'x': 0.14705882352941177, 'y': 0.1270053475935829},
        'R2': {'x': 0.32085561497326204, 'y': 0.1804812834224599},
        'C1': {'x': 0.25668449197860965, 'y': 0.7767379679144385},
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
        'Co': {'x': 0.8796791443850267, 'y': 0.47459893048128343},
        'C1': {'x': 0.8957219251336899, 'y': 0.5922459893048129},
        'R1': {'x': 0.8796791443850267, 'y': 0.3729946524064171},
        'R2': {'x': 0.06417112299465241, 'y': 0.81951871657754},
        'O': {'x': 0.3181818181818182, 'y': 0.696524064171123},
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
        'Co': {'x': 0.8796791443850267, 'y': 0.3649732620320856},
        'C1': {'x': 0.8903743315508021, 'y': 0.4879679144385027},
        'C2': {'x': 0.20855614973262032, 'y': 0.410427807486631},
        'R1': {'x': 0.3422459893048128, 'y': 0.3516042780748663},
        'R2': {'x': 0.8556149732620321, 'y': 0.6029411764705882},
        'O': {'x': 0.0374331550802139, 'y': 0.8409090909090909},
      },
      Phase.recepcio: {
        'Co': {'x': 0.9358288770053476, 'y': 0.10828877005347594},
        'R1': {'x': 0.3609625668449198, 'y': 0.21524064171122995},
        'C2': {'x': 0.25, 'y': 0.5}, // Back center
        'O': {'x': 0.11764705882352941, 'y': 0.7098930481283422},
        'R2': {'x': 0.3546325878594249, 'y': 0.8115015974440895},
        'C1': {'x': 0.7593582887700535, 'y': 0.16443850267379678},
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
        'Co': {'x': 0.32620320855614976, 'y': 0.3622994652406417},
        'C1': {'x': 0.8823529411764706, 'y': 0.3810160427807487},
        'C2': {'x': 0.06149732620320856, 'y': 0.7901069518716578},
        'R1': {'x': 0.26737967914438504, 'y': 0.5013368983957219},
        'R2': {'x': 0.8689839572192514, 'y': 0.49866310160427807},
        'O': {'x': 0.9037433155080213, 'y': 0.6082887700534759},
      },
      Phase.recepcio: {
        'Co': {'x': 0.645367412140575, 'y': 0.45686900958466453},
        'R1': {'x': 0.25, 'y': 0.5}, // Back center
        'C2': {'x': 0.3850267379679144, 'y': 0.766042780748663},
        'O': {'x': 0.8449197860962567, 'y': 0.8649732620320856},
        'R2': {'x': 0.3582887700534759, 'y': 0.21256684491978609},
        'C1': {'x': 0.8689839572192514, 'y': 0.04144385026737968},
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
        'Co': {'x': 0.3235294117647059, 'y': 0.5414438502673797},
        'C2': {'x': 0.9010695187165776, 'y': 0.570855614973262},
        'R1': {'x': 0.034759358288770054, 'y': 0.8248663101604278},
        'R2': {'x': 0.8823529411764706, 'y': 0.35962566844919786},
        'O': {'x': 0.8823529411764706, 'y': 0.47459893048128343},
      },
      Phase.recepcio: {
        'Co': {'x': 0.8210862619808307, 'y': 0.6900958466453674},
        'R1': {'x': 0.2971246006389776, 'y': 0.8115015974440895},
        'C2': {'x': 0.7635782747603834, 'y': 0.9105431309904153},
        'O': {'x': 0.8753993610223643, 'y': 0.8210862619808307},
        'R2': {'x': 0.30670926517571884, 'y': 0.22364217252396165},
        'C1': {'x': 0.14376996805111822, 'y': 0.4952076677316294},
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

