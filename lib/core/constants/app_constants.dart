class AppConstants {
  // Court dimensions (relative units)
  // Full court: 18m x 9m (each half is 9m x 9m)
  static const double courtWidth = 18.0; // meters (full court length)
  static const double courtLength = 9.0; // meters (court width)
  static const double halfCourtLength = 9.0; // meters (each team's side)
  static const double attackLineDistance = 3.0; // meters from net
  
  // Player positions (standard volleyball positions)
  static const int totalPlayers = 6;
  
  // Court positions (fixed, not displayed):
  // Position 1: back right (looking at net)
  // Position 2: front right (counter-clockwise from 1)
  // Position 3: front center (counter-clockwise from 2)
  // Position 4: front left (counter-clockwise from 3)
  // Position 5: back left (counter-clockwise from 4)
  // Position 6: back center (counter-clockwise from 5)
  
  // Player roles:
  // Co = Setter (Colocador)
  // C1 = Middle Blocker (main) (Central 1)
  // C2 = Middle Blocker (secondary) (Central 2)
  // O = Opposite (Opuesto)
  // R1 = Outside Hitter (main) (Receptor 1)
  // R2 = Outside Hitter (secondary) (Receptor 2)
  
  // Default player positions (initial/reset position)
  // Each player role is assigned to a court position (1-6)
  // Index 0 = Position 1, Index 1 = Position 2, etc.
  // Position 1 -> Co, Position 2 -> R1, Position 3 -> C2, 
  // Position 4 -> O, Position 5 -> R2, Position 6 -> C1
  static const List<String> defaultPositions = ['Co', 'R1', 'C2', 'O', 'R2', 'C1'];
}

