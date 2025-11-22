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
}
