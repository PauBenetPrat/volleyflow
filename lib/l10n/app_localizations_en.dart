// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'VolleyFlow';

  @override
  String get volleyballCoachingApp => 'Volleyball Coaching App';

  @override
  String get welcome => 'Welcome';

  @override
  String get welcomeSubtitle => 'Manage your team\'s rotations and positions';

  @override
  String get rotations => 'Rotations';

  @override
  String get refereeMatch => 'Referee / Match';

  @override
  String get about => 'About';

  @override
  String get base => 'BASE';

  @override
  String get sac => 'SAC';

  @override
  String get recepcio => 'RECEPCIO';

  @override
  String get defensa => 'DEFENSA';

  @override
  String get rotationTitle => '4-2 (no libero)';

  @override
  String get rotationSystem42 => '4-2';

  @override
  String get rotationSystem42NoLibero => '4-2 (no libero)';

  @override
  String get rotationSystem51 => '5-1';

  @override
  String get rotationSystemPlayers => 'Players';

  @override
  String get selectRotationSystem => 'Select a rotation system';

  @override
  String get rotationSystem42NoLiberoDescription => '4-2 system without libero';

  @override
  String get rotationSystem42Description => '4-2 system with libero';

  @override
  String get rotationSystem51Description => '5-1 system with one setter';

  @override
  String get rotationSystemPlayersDescription =>
      'Custom rotation with specific players';

  @override
  String featureComingSoon(String displayName) {
    return '$displayName feature coming soon!';
  }

  @override
  String get activateDrawingMode => 'Activate drawing mode';

  @override
  String get deactivateDrawingMode => 'Deactivate drawing mode';

  @override
  String get undoLastStroke => 'Undo last stroke';

  @override
  String get clearAllDrawings => 'Clear all drawings';

  @override
  String get coordinatesCopied => 'Coordinates copied to clipboard!';

  @override
  String get copyCoordinates => 'Copy coordinates to clipboard';

  @override
  String get reset => 'Reset';

  @override
  String get rotationValidationError => 'Rotation error';

  @override
  String get close => 'Close';

  @override
  String get rotateTooltip =>
      'Click: rotate forward | Double click: rotate backward';

  @override
  String get version => 'Version 1.0.0';

  @override
  String get purpose => 'Purpose';

  @override
  String get purposeText =>
      'This app is designed to help volleyball coaches and players visualize and manage team rotations and positions on the court.';

  @override
  String get features => 'Features';

  @override
  String get featureRotations =>
      'Visualize team rotations on a standard volleyball court';

  @override
  String get featurePositions => 'Track player positions in real-time';

  @override
  String get featureReset => 'Easily rotate and reset positions';

  @override
  String get developer => 'Developer';

  @override
  String get developedBy => 'Developed by Pau Benet Prat';

  @override
  String get githubRepository => 'GitHub Repository';

  @override
  String get linkedinProfile => 'LinkedIn Profile';

  @override
  String get aboutNote =>
      'This is an MVP version. More features will be added in future updates. Found a bug or have an idea? Check out the GitHub repository!';

  @override
  String get matchControl => 'Match Control';

  @override
  String get matchInProgress => 'Match in Progress';

  @override
  String get matchNotStarted => 'Match Not Started';

  @override
  String set(int setNumber) {
    return 'Set $setNumber';
  }

  @override
  String get teamA => 'Team A';

  @override
  String get teamB => 'Team B';

  @override
  String sets(int count) {
    return 'Sets: $count';
  }

  @override
  String get startMatch => 'Start Match';

  @override
  String get resetMatch => 'Reset Match';

  @override
  String get matchWon => 'Match Won!';

  @override
  String matchWonMessage(String winner) {
    return '$winner wins the match!';
  }

  @override
  String get ok => 'OK';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get systemDefault => 'System Default';

  @override
  String get roleSetterName => 'Setter';

  @override
  String get roleSetterDescription =>
      'Setter. Makes the second pass and organizes the attack.';

  @override
  String get roleMiddleBlockerName => 'Middle Blocker';

  @override
  String get roleMiddleBlockerDescription =>
      'Middle Blocker. Specialized in blocking and quick attacks.';

  @override
  String get roleOppositeName => 'Opposite';

  @override
  String get roleOppositeDescription =>
      'Opposite. Main attacker, plays opposite to the setter (position 2 or 1).';

  @override
  String get roleOutsideHitterName => 'Outside Hitter';

  @override
  String get roleOutsideHitterDescription =>
      'Outside Hitter (also called \"wing\" or \"double\"). Plays at positions 4 and 6.';

  @override
  String get roleLiberoName => 'Libero';

  @override
  String get roleLiberoDescription =>
      'Libero. Defensive specialist player. Cannot attack or block, wears a different jersey.';

  @override
  String get teams => 'Teams';

  @override
  String get home => 'Home';

  @override
  String get teamDetails => 'Team Details';

  @override
  String get teamName => 'Team Name';

  @override
  String get teamNameRequired => 'Team name is required';

  @override
  String get coaches => 'Coaches';

  @override
  String get players => 'Players';

  @override
  String get noTeamsYet => 'No teams yet';

  @override
  String get createYourFirstTeam => 'Create your first team to get started';

  @override
  String get createTeam => 'Create Team';

  @override
  String get newTeam => 'New Team';

  @override
  String teamInfo(int playerCount, int coachCount) {
    return '$playerCount players, $coachCount coaches';
  }

  @override
  String get noCoachesYet => 'No coaches yet';

  @override
  String get noPlayersYet => 'No players yet';

  @override
  String get addPlayer => 'Add Player';

  @override
  String get editPlayer => 'Edit Player';

  @override
  String get playerName => 'Player Name';

  @override
  String get playerNameRequired => 'Player name is required';

  @override
  String get alias => 'Alias';

  @override
  String get number => 'Number';

  @override
  String get age => 'Age';

  @override
  String get height => 'Height';

  @override
  String get mainPosition => 'Main Position';

  @override
  String get position => 'Position';

  @override
  String get captain => 'Captain';

  @override
  String get addCoach => 'Add Coach';

  @override
  String get editCoach => 'Edit Coach';

  @override
  String get coachName => 'Coach Name';

  @override
  String get coachNameRequired => 'Coach name is required';

  @override
  String get primary => 'Primary';

  @override
  String get primaryCoach => 'Primary Coach';

  @override
  String get secondaryCoach => 'Secondary Coach';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get teamSaved => 'Team saved';

  @override
  String get premiumFeature => 'Premium Feature';

  @override
  String get premiumFeatureMessage =>
      'Creating multiple teams is a premium feature. To unlock this feature, please contact us.';

  @override
  String get premiumFeatureRequest => 'Premium Feature Request';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get delete => 'Delete';

  @override
  String get deleteTeam => 'Delete Team';

  @override
  String deleteTeamConfirmation(String name) {
    return 'Are you sure you want to delete the team \"$name\"? This action cannot be undone.';
  }

  @override
  String get teamDeleted => 'Team deleted';

  @override
  String get deletePlayer => 'Delete Player';

  @override
  String deletePlayerConfirmation(String name) {
    return 'Are you sure you want to delete $name?';
  }

  @override
  String get playerDeleted => 'Player deleted';

  @override
  String get deleteCoach => 'Delete Coach';

  @override
  String deleteCoachConfirmation(String name) {
    return 'Are you sure you want to delete $name?';
  }

  @override
  String get coachDeleted => 'Coach deleted';

  @override
  String get enterPin => 'Enter PIN';

  @override
  String get pin => 'PIN';

  @override
  String get pinRequired => 'PIN is required';

  @override
  String get incorrectPin => 'Incorrect PIN';
}
