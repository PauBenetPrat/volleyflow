// Rotation positions data structure for 4-2 system (with libero)
// Each rotation (R1-R6) has 4 phases: BASE, SAC, RECEPCIÓ, DEFENSA
// Each phase defines where each player role (Co, C1, C2, R1, R2, O, L) is positioned
// Positions can be either:
//   - int (1-6): Standard court position
//   - Map with 'x' and 'y': Specific coordinates as percentages (0.0-1.0)
//     where x=0.0 is back (left), x=1.0 is front (right/near net)
//     and y=0.0 is top, y=1.0 is bottom

import 'rotation_positions_4_2_no_libero.dart';

class RotationPositions42 {
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
        'L': {'x': 0.25, 'y': 0.5}, // Position 6: back center
      },
      Phase.sac: {
        'Co': {'x': 0.0374331550802139, 'y': 0.8141711229946524}, // Serves from back right corner
        'R1': {'x': 0.8766, 'y': 0.6108},
        'C2': {'x': 0.8642, 'y': 0.4907},
        'O': {'x': 0.8723, 'y': 0.3614},
        'R2': {'x': 0.3159, 'y': 0.2824},
        'L': {'x': 0.2111, 'y': 0.3659},
      },
      Phase.recepcio: {
        'Co': {'x': 0.37967914438502676, 'y': 0.8489304812834224},
        'R1': {'x': 0.4572192513368984, 'y': 0.7312834224598931},
        'C2': {'x': 0.7458, 'y': 0.4211},
        'O': {'x': 0.8736, 'y': 0.0785},
        'R2': {'x': 0.3582887700534759, 'y': 0.1858288770053476},
        'L': {'x': 0.3877005347593583, 'y': 0.4692513368983957},
      },
      Phase.defensa: {
        'Co': {'x': 0.5357018412558685, 'y': 0.8138983641431925},
        'R1': {'x': 0.9427175029342723, 'y': 0.8634417180164319},
        'C2': {'x': 0.9401821082746479, 'y': 0.7397071229460094},
        'O': {'x': 0.75, 'y': 0.25}, // Front left
        'L': {'x': 0.3431035431338028, 'y': 0.22703931924882628},
        'R2': {'x': 0.22496698943661972, 'y': 0.5190681851525821},
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
        'R2': {'x': 0.23770356514084506, 'y': 0.4799369131455399},
        'C1': {'x': 0.01871657754010695, 'y': 0.7794117647058824},
        'C2': {'x': 0.8983957219251337, 'y': 0.39438502673796794},
        'R1': {'x': 0.8796791443850267, 'y': 0.5093582887700535},
        'O': {'x': 0.339572192513369, 'y': 0.3810160427807487},
      },
      Phase.recepcio: {
        'Co': {'x': 0.8449197860962567, 'y': 0.7312834224598931},
        'R1': {'x': 0.40641711229946526, 'y': 0.5093582887700535},
        'C2': {'x': 0.7754010695187166, 'y': 0.42379679144385024},
        'O': {'x': 0.14705882352941177, 'y': 0.1270053475935829},
        'R2': {'x': 0.39037433155080214, 'y': 0.21524064171122995},
        'C1': {'x': 0.5213903743315508, 'y': 0.7740641711229946},
      },
      Phase.defensa: {
        'Co': {'x': 0.9427495965375586, 'y': 0.859365830399061},
        'R1': {'x': 0.7780681484741784, 'y': 0.27467998092723006},
        'C2': {'x': 0.9466008289319249, 'y': 0.7288594850352113},
        'O': {'x': 0.4144522080399061, 'y': 0.7867655149647887},
        'R2': {'x': 0.2042941241197183, 'y': 0.5231899207746479},
        'C1': {'x': 0.3434244791666667, 'y': 0.19339146860328638},
      },
    },
    // Rotación 3
    3: {
      Phase.base: {
        'Co': {'x': 0.75, 'y': 0.5}, // Front center
        'R1': {'x': 0.75, 'y': 0.25}, // Front left
        'L': {'x': 0.25, 'y': 0.25}, // Back left
        'O': {'x': 0.25, 'y': 0.5},  // Back center
        'R2': {'x': 0.25, 'y': 0.75}, // Back right
        'C1': {'x': 0.75, 'y': 0.75}, // Front right
      },
      Phase.sac: {
        'Co': {'x': 0.8796791443850267, 'y': 0.47459893048128343},
        'C1': {'x': 0.8957219251336899, 'y': 0.5922459893048129},
        'L': {'x': 0.25, 'y': 0.25}, // Back left
        'R1': {'x': 0.8796791443850267, 'y': 0.3729946524064171},
        'R2': {'x': 0.06417112299465241, 'y': 0.81951871657754},
        'O': {'x': 0.3181818181818182, 'y': 0.696524064171123},
      },
      Phase.recepcio: {
        'Co': {'x': 0.8850267379679144, 'y': 0.6109625668449198},
        'R1': {'x': 0.3770053475935829, 'y': 0.16176470588235295},
        'L': {'x': 0.35561497326203206, 'y': 0.4532085561497326},
        'O': {'x': 0.10695187165775401, 'y': 0.6858288770053476},
        'R2': {'x': 0.5240641711229946, 'y': 0.7179144385026738},
        'C1': {'x': 0.7513368983957219, 'y': 0.8997326203208557},
      },
      Phase.defensa: {
        'Co': {'x': 0.9332040419600939, 'y': 0.864693368544601},
        'R1': {'x': 0.8004236355633803, 'y': 0.23844171801643194},
        'L': {'x': 0.37163934125586856, 'y': 0.2153755868544601},
        'O': {'x': 0.4646053403755869, 'y': 0.7448741930751174},
        'R2': {'x': 0.17038035504694835, 'y': 0.5415016138497653},
        'C1': {'x': 0.9342310372652582, 'y': 0.729217099471831},
      },
    },
    // Rotación 4
    4: {
      Phase.base: {
        'Co': {'x': 0.75, 'y': 0.25}, // Front left
        'R1': {'x': 0.25, 'y': 0.25}, // Back left
        'L': {'x': 0.25, 'y': 0.5}, // Back center
        'O': {'x': 0.25, 'y': 0.75},  // Back right
        'R2': {'x': 0.75, 'y': 0.75}, // Front right
        'C1': {'x': 0.75, 'y': 0.5}, // Front center
      },
      Phase.sac: {
        'Co': {'x': 0.8796791443850267, 'y': 0.3649732620320856},
        'C1': {'x': 0.8903743315508021, 'y': 0.4879679144385027},
        'L': {'x': 0.20855614973262032, 'y': 0.410427807486631},
        'R1': {'x': 0.3422459893048128, 'y': 0.3516042780748663},
        'R2': {'x': 0.8556149732620321, 'y': 0.6029411764705882},
        'O': {'x': 0.0374331550802139, 'y': 0.8409090909090909},
      },
      Phase.recepcio: {
        'Co': {'x': 0.9358288770053476, 'y': 0.10828877005347594},
        'R1': {'x': 0.232620320855615, 'y': 0.2072192513368984},
        'L': {'x': 0.39041868397887325, 'y': 0.47658083920187794},
        'O': {'x': 0.11764705882352941, 'y': 0.7098930481283422},
        'R2': {'x': 0.480610878814554, 'y': 0.7624064700704225},
        'C1': {'x': 0.7593582887700535, 'y': 0.16443850267379678},
      },
      Phase.defensa: {
        'Co': {'x': 0.9494113116197183, 'y': 0.8306420554577465},
        'R1': {'x': 0.20388607687793428, 'y': 0.590251797241784},
        'L': {'x': 0.33521768632629106, 'y': 0.18622542546948356},
        'O': {'x': 0.4770118104460094, 'y': 0.7732816167840375},
        'R2': {'x': 0.75, 'y': 0.25}, // Front left
        'C1': {'x': 0.949342539612676, 'y': 0.7268650968309859},
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
        'Co': {'x': 0.7200245745305164, 'y': 0.44797626907276994},
        'R1': {'x': 0.3654085974178404, 'y': 0.49474123386150237},
        'C2': {'x': 0.4900463981807512, 'y': 0.7469098444835681},
        'O': {'x': 0.8449197860962567, 'y': 0.8649732620320856},
        'R2': {'x': 0.3235294117647059, 'y': 0.20989304812834225},
        'C1': {'x': 0.8689839572192514, 'y': 0.04144385026737968},
      },
      Phase.defensa: {
        'Co': {'x': 0.4597133582746479, 'y': 0.8284871992370892},
        'R1': {'x': 0.18380006602112675, 'y': 0.5870057585093896},
        'C2': {'x': 0.3539603506455399, 'y': 0.20560079225352113},
        'O': {'x': 0.946004804870892, 'y': 0.8644824677230047},
        'R2': {'x': 0.7887140551643192, 'y': 0.27118636296948356},
        'C1': {'x': 0.9436298782276995, 'y': 0.7514075337441315},
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
        'L': {'x': 0.25, 'y': 0.25}, // Back left
      },
      Phase.sac: {
        'L': {'x': 0.39040951437793425, 'y': 0.24312279929577466},
        'Co': {'x': 0.3235294117647059, 'y': 0.5414438502673797},
        'C2': {'x': 0.9010695187165776, 'y': 0.570855614973262},
        'R1': {'x': 0.034759358288770054, 'y': 0.8248663101604278},
        'R2': {'x': 0.8823529411764706, 'y': 0.35962566844919786},
        'O': {'x': 0.8823529411764706, 'y': 0.47459893048128343},
      },
      Phase.recepcio: {
        'Co': {'x': 0.8210862619808307, 'y': 0.6900958466453674},
        'R1': {'x': 0.47593896713615025, 'y': 0.7323393485915493},
        'C2': {'x': 0.7635782747603834, 'y': 0.9105431309904153},
        'O': {'x': 0.8753993610223643, 'y': 0.8210862619808307},
        'R2': {'x': 0.3835093896713615, 'y': 0.1932218309859155},
        'L': {'x': 0.3769072769953052, 'y': 0.4985603726525822},
      },
      Phase.defensa: {
        'Co': {'x': 0.5145934198943662, 'y': 0.8100425469483568},
        'R1': {'x': 0.18921013057511737, 'y': 0.5278251540492958},
        'C2': {'x': 0.9398244938380281, 'y': 0.7435950337441315},
        'O': {'x': 0.9439049662558685, 'y': 0.8696082746478874},
        'R2': {'x': 0.75, 'y': 0.25}, // Front left
        'L': {'x': 0.3439471464201878, 'y': 0.19996148767605634},
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

