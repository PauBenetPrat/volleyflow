import 'rotation_positions_5_1_no_libero.dart';

class AppConstants {
  // Court dimensions (relative units)
  // Full court: 18m x 9m (each half is 9m x 9m)
  static const double courtWidth = 18.0; // meters (full court length)
  static const double courtLength = 9.0; // meters (court width)
  static const double halfCourtLength = 9.0; // meters (each team's side)
  static const double attackLineDistance = 3.0; // meters from net
  
  // Player positions (standard volleyball positions)
  // Use CourtPosition.allPositions.length for total players
  static int get totalPlayers => CourtPosition.allPositions.length;
  
  // Court positions (fixed, not displayed):
  // See CourtPosition class for position constants:
  // CourtPosition.position1: back right (looking at net)
  // CourtPosition.position2: front right (counter-clockwise from 1)
  // CourtPosition.position3: front center (counter-clockwise from 2)
  // CourtPosition.position4: front left (counter-clockwise from 3)
  // CourtPosition.position5: back left (counter-clockwise from 4)
  // CourtPosition.position6: back center (counter-clockwise from 5)
  //
  // Front row positions: CourtPosition.frontRowPositions (2, 3, 4)
  // Back row positions: CourtPosition.backRowPositions (1, 5, 6)
  
  // Player roles:
  // Co = Setter (Colocador)
  // C1 = Middle Blocker (main) (Central 1)
  // C2 = Middle Blocker (secondary) (Central 2)
  // O = Opposite (Opuesto)
  // R1 = Outside Hitter (main) (Receptor 1)
  // R2 = Outside Hitter (secondary) (Receptor 2)
  
  // Default player positions (initial/reset position)
  // Each player role is assigned to a court position
  // Index 0 = CourtPosition.position1, Index 1 = CourtPosition.position2, etc.
  // CourtPosition.position1 -> Co, CourtPosition.position2 -> R1, 
  // CourtPosition.position3 -> C2, CourtPosition.position4 -> O, 
  // CourtPosition.position5 -> R2, CourtPosition.position6 -> C1
  static const List<String> defaultPositions = ['Co', 'R1', 'C2', 'O', 'R2', 'C1'];
}

