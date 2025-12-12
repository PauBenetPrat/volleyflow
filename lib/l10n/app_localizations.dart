import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ca.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_eu.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ca'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('eu'),
    Locale('fr'),
    Locale('ja'),
    Locale('zh')
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'VolleyFlow'**
  String get appTitle;

  /// Home page title
  ///
  /// In en, this message translates to:
  /// **'Volleyball Coaching App'**
  String get volleyballCoachingApp;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Welcome subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage your team\'s rotations and positions'**
  String get welcomeSubtitle;

  /// Rotations menu item
  ///
  /// In en, this message translates to:
  /// **'Rotations'**
  String get rotations;

  /// Referee/Match menu item
  ///
  /// In en, this message translates to:
  /// **'Referee / Match'**
  String get refereeMatch;

  /// About menu item
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Base phase
  ///
  /// In en, this message translates to:
  /// **'BASE'**
  String get base;

  /// Serve phase
  ///
  /// In en, this message translates to:
  /// **'SERVE'**
  String get sac;

  /// Reception phase
  ///
  /// In en, this message translates to:
  /// **'RECEPTION'**
  String get recepcio;

  /// Defense phase
  ///
  /// In en, this message translates to:
  /// **'DEFENSE'**
  String get defensa;

  /// Rotation system title
  ///
  /// In en, this message translates to:
  /// **'4-2 (no libero)'**
  String get rotationTitle;

  /// 4-2 rotation system
  ///
  /// In en, this message translates to:
  /// **'4-2'**
  String get rotationSystem42;

  /// 4-2 no libero rotation system
  ///
  /// In en, this message translates to:
  /// **'4-2 (no libero)'**
  String get rotationSystem42NoLibero;

  /// 5-1 rotation system
  ///
  /// In en, this message translates to:
  /// **'5-1'**
  String get rotationSystem51;

  /// Players rotation system
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get rotationSystemPlayers;

  /// Prompt to select a rotation system
  ///
  /// In en, this message translates to:
  /// **'Select a rotation system'**
  String get selectRotationSystem;

  /// Description for 4-2 no libero system
  ///
  /// In en, this message translates to:
  /// **'4-2 system without libero'**
  String get rotationSystem42NoLiberoDescription;

  /// Description for 4-2 system
  ///
  /// In en, this message translates to:
  /// **'4-2 system with libero'**
  String get rotationSystem42Description;

  /// Description for 5-1 system
  ///
  /// In en, this message translates to:
  /// **'5-1 system with one setter'**
  String get rotationSystem51Description;

  /// Description for Players system
  ///
  /// In en, this message translates to:
  /// **'Custom rotation with specific players'**
  String get rotationSystemPlayersDescription;

  /// Feature coming soon message
  ///
  /// In en, this message translates to:
  /// **'{displayName} feature coming soon!'**
  String featureComingSoon(String displayName);

  /// Tooltip for activate drawing mode
  ///
  /// In en, this message translates to:
  /// **'Activate drawing mode'**
  String get activateDrawingMode;

  /// Tooltip for deactivate drawing mode
  ///
  /// In en, this message translates to:
  /// **'Deactivate drawing mode'**
  String get deactivateDrawingMode;

  /// Tooltip for undo last drawing stroke
  ///
  /// In en, this message translates to:
  /// **'Undo last stroke'**
  String get undoLastStroke;

  /// Tooltip for clear all drawings
  ///
  /// In en, this message translates to:
  /// **'Clear all drawings'**
  String get clearAllDrawings;

  /// Message when coordinates are copied
  ///
  /// In en, this message translates to:
  /// **'Coordinates copied to clipboard!'**
  String get coordinatesCopied;

  /// Tooltip for copy coordinates
  ///
  /// In en, this message translates to:
  /// **'Copy coordinates to clipboard'**
  String get copyCoordinates;

  /// Reset button label
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Rotation validation error title
  ///
  /// In en, this message translates to:
  /// **'Rotation error'**
  String get rotationValidationError;

  /// Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Tooltip for rotate button
  ///
  /// In en, this message translates to:
  /// **'Click: rotate forward | Double click: rotate backward'**
  String get rotateTooltip;

  /// App version
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get version;

  /// Purpose section title
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get purpose;

  /// Purpose description
  ///
  /// In en, this message translates to:
  /// **'This app is designed to help volleyball coaches and players visualize and manage team rotations and positions on the court.'**
  String get purposeText;

  /// Features section title
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get features;

  /// Feature: rotations
  ///
  /// In en, this message translates to:
  /// **'Visualize team rotations on a standard volleyball court'**
  String get featureRotations;

  /// Feature: positions
  ///
  /// In en, this message translates to:
  /// **'Track player positions in real-time'**
  String get featurePositions;

  /// Feature: reset
  ///
  /// In en, this message translates to:
  /// **'Easily rotate and reset positions'**
  String get featureReset;

  /// Developer section title
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// Developer name
  ///
  /// In en, this message translates to:
  /// **'Developed by Pau Benet Prat'**
  String get developedBy;

  /// GitHub repository link
  ///
  /// In en, this message translates to:
  /// **'GitHub Repository'**
  String get githubRepository;

  /// LinkedIn profile link
  ///
  /// In en, this message translates to:
  /// **'LinkedIn Profile'**
  String get linkedinProfile;

  /// About page note
  ///
  /// In en, this message translates to:
  /// **'This is an MVP version. More features will be added in future updates. Found a bug or have an idea? Check out the GitHub repository!'**
  String get aboutNote;

  /// Match control page title
  ///
  /// In en, this message translates to:
  /// **'Match Control'**
  String get matchControl;

  /// Match in progress status
  ///
  /// In en, this message translates to:
  /// **'Match in Progress'**
  String get matchInProgress;

  /// Match not started status
  ///
  /// In en, this message translates to:
  /// **'Match Not Started'**
  String get matchNotStarted;

  /// Set number
  ///
  /// In en, this message translates to:
  /// **'Set {setNumber}'**
  String set(int setNumber);

  /// Team A label
  ///
  /// In en, this message translates to:
  /// **'Team A'**
  String get teamA;

  /// Team B label
  ///
  /// In en, this message translates to:
  /// **'Team B'**
  String get teamB;

  /// Sets count
  ///
  /// In en, this message translates to:
  /// **'Sets: {count}'**
  String sets(int count);

  /// Start match button label
  ///
  /// In en, this message translates to:
  /// **'Start Match'**
  String get startMatch;

  /// Dialog title for reset confirmation
  ///
  /// In en, this message translates to:
  /// **'Reset Match?'**
  String get resetMatch;

  /// Match won dialog title
  ///
  /// In en, this message translates to:
  /// **'Match Won!'**
  String get matchWon;

  /// Match won message
  ///
  /// In en, this message translates to:
  /// **'{winner} wins the match!'**
  String matchWonMessage(String winner);

  /// OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Language selection label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// System default language option
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// Setter role name
  ///
  /// In en, this message translates to:
  /// **'Setter'**
  String get roleSetterName;

  /// Setter role description
  ///
  /// In en, this message translates to:
  /// **'Setter. Makes the second pass and organizes the attack.'**
  String get roleSetterDescription;

  /// Middle Blocker role name
  ///
  /// In en, this message translates to:
  /// **'Middle Blocker'**
  String get roleMiddleBlockerName;

  /// Middle Blocker role description
  ///
  /// In en, this message translates to:
  /// **'Middle Blocker. Specialized in blocking and quick attacks.'**
  String get roleMiddleBlockerDescription;

  /// Opposite role name
  ///
  /// In en, this message translates to:
  /// **'Opposite'**
  String get roleOppositeName;

  /// Opposite role description
  ///
  /// In en, this message translates to:
  /// **'Opposite. Main attacker, plays opposite to the setter (position 2 or 1).'**
  String get roleOppositeDescription;

  /// Outside Hitter role name
  ///
  /// In en, this message translates to:
  /// **'Outside Hitter'**
  String get roleOutsideHitterName;

  /// Outside Hitter role description
  ///
  /// In en, this message translates to:
  /// **'Outside Hitter (also called \"wing\" or \"double\"). Plays at positions 4 and 6.'**
  String get roleOutsideHitterDescription;

  /// Libero role name
  ///
  /// In en, this message translates to:
  /// **'Libero'**
  String get roleLiberoName;

  /// Libero role description
  ///
  /// In en, this message translates to:
  /// **'Libero. Defensive specialist player. Cannot attack or block, wears a different jersey.'**
  String get roleLiberoDescription;

  /// No description provided for @roleSetterAbbr.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get roleSetterAbbr;

  /// No description provided for @roleMiddleBlockerAbbr.
  ///
  /// In en, this message translates to:
  /// **'MB'**
  String get roleMiddleBlockerAbbr;

  /// No description provided for @roleOppositeAbbr.
  ///
  /// In en, this message translates to:
  /// **'OP'**
  String get roleOppositeAbbr;

  /// No description provided for @roleOutsideHitterAbbr.
  ///
  /// In en, this message translates to:
  /// **'OH'**
  String get roleOutsideHitterAbbr;

  /// No description provided for @roleLiberoAbbr.
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get roleLiberoAbbr;

  /// Middle Blocker 1 abbreviation
  ///
  /// In en, this message translates to:
  /// **'MB1'**
  String get roleMiddleBlocker1Abbr;

  /// Middle Blocker 2 abbreviation
  ///
  /// In en, this message translates to:
  /// **'MB2'**
  String get roleMiddleBlocker2Abbr;

  /// Outside Hitter 1 abbreviation
  ///
  /// In en, this message translates to:
  /// **'OH1'**
  String get roleOutsideHitter1Abbr;

  /// Outside Hitter 2 abbreviation
  ///
  /// In en, this message translates to:
  /// **'OH2'**
  String get roleOutsideHitter2Abbr;

  /// Teams menu item
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get teams;

  /// Home menu item
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Team details page title
  ///
  /// In en, this message translates to:
  /// **'Team Details'**
  String get teamDetails;

  /// Team name field label
  ///
  /// In en, this message translates to:
  /// **'Team Name'**
  String get teamName;

  /// Team name validation error
  ///
  /// In en, this message translates to:
  /// **'Team name is required'**
  String get teamNameRequired;

  /// Coaches section title
  ///
  /// In en, this message translates to:
  /// **'Coaches'**
  String get coaches;

  /// Players section title
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get players;

  /// Empty teams list message
  ///
  /// In en, this message translates to:
  /// **'No teams yet'**
  String get noTeamsYet;

  /// Empty teams list subtitle
  ///
  /// In en, this message translates to:
  /// **'Create your first team to get started'**
  String get createYourFirstTeam;

  /// Create team button
  ///
  /// In en, this message translates to:
  /// **'Create Team'**
  String get createTeam;

  /// Default team name
  ///
  /// In en, this message translates to:
  /// **'New Team'**
  String get newTeam;

  /// Team info subtitle
  ///
  /// In en, this message translates to:
  /// **'{playerCount} players, {coachCount} coaches'**
  String teamInfo(int playerCount, int coachCount);

  /// Empty coaches list message
  ///
  /// In en, this message translates to:
  /// **'No coaches yet'**
  String get noCoachesYet;

  /// Empty players list message
  ///
  /// In en, this message translates to:
  /// **'No players yet'**
  String get noPlayersYet;

  /// Add player dialog title
  ///
  /// In en, this message translates to:
  /// **'Add Player'**
  String get addPlayer;

  /// Edit player dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Player'**
  String get editPlayer;

  /// Player name field label
  ///
  /// In en, this message translates to:
  /// **'Player Name'**
  String get playerName;

  /// Player name validation error
  ///
  /// In en, this message translates to:
  /// **'Player name is required'**
  String get playerNameRequired;

  /// Player alias field label
  ///
  /// In en, this message translates to:
  /// **'Alias'**
  String get alias;

  /// Player number field label
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get number;

  /// Player age field label
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// Player height field label
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// Player main position field label
  ///
  /// In en, this message translates to:
  /// **'Main Position'**
  String get mainPosition;

  /// Position label
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get position;

  /// Captain checkbox label
  ///
  /// In en, this message translates to:
  /// **'Captain'**
  String get captain;

  /// Add coach dialog title
  ///
  /// In en, this message translates to:
  /// **'Add Coach'**
  String get addCoach;

  /// Edit coach dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Coach'**
  String get editCoach;

  /// Coach name field label
  ///
  /// In en, this message translates to:
  /// **'Coach Name'**
  String get coachName;

  /// Coach name validation error
  ///
  /// In en, this message translates to:
  /// **'Coach name is required'**
  String get coachNameRequired;

  /// Primary coach label
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get primary;

  /// Primary coach label
  ///
  /// In en, this message translates to:
  /// **'Primary Coach'**
  String get primaryCoach;

  /// Secondary coach label
  ///
  /// In en, this message translates to:
  /// **'Secondary Coach'**
  String get secondaryCoach;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Team saved success message
  ///
  /// In en, this message translates to:
  /// **'Team saved'**
  String get teamSaved;

  /// Premium feature dialog title
  ///
  /// In en, this message translates to:
  /// **'Premium Feature'**
  String get premiumFeature;

  /// Premium feature dialog message
  ///
  /// In en, this message translates to:
  /// **'Creating multiple teams is a premium feature. To unlock this feature, please contact us.'**
  String get premiumFeatureMessage;

  /// Email subject for premium feature request
  ///
  /// In en, this message translates to:
  /// **'Premium Feature Request'**
  String get premiumFeatureRequest;

  /// Contact us button
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// Gender field label
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// Male gender option
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// Female gender option
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Delete team button/title
  ///
  /// In en, this message translates to:
  /// **'Delete Team'**
  String get deleteTeam;

  /// Delete team confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the team \"{name}\"? This action cannot be undone.'**
  String deleteTeamConfirmation(String name);

  /// Team deleted success message
  ///
  /// In en, this message translates to:
  /// **'Team deleted'**
  String get teamDeleted;

  /// Delete player button/title
  ///
  /// In en, this message translates to:
  /// **'Delete Player'**
  String get deletePlayer;

  /// Delete player confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}?'**
  String deletePlayerConfirmation(String name);

  /// Player deleted success message
  ///
  /// In en, this message translates to:
  /// **'Player deleted'**
  String get playerDeleted;

  /// Delete coach button/title
  ///
  /// In en, this message translates to:
  /// **'Delete Coach'**
  String get deleteCoach;

  /// Delete coach confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}?'**
  String deleteCoachConfirmation(String name);

  /// Coach deleted success message
  ///
  /// In en, this message translates to:
  /// **'Coach deleted'**
  String get coachDeleted;

  /// No description provided for @enterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get enterPin;

  /// No description provided for @pin.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get pin;

  /// No description provided for @pinRequired.
  ///
  /// In en, this message translates to:
  /// **'PIN is required'**
  String get pinRequired;

  /// No description provided for @incorrectPin.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN'**
  String get incorrectPin;

  /// Help button tooltip
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// Help dialog title
  ///
  /// In en, this message translates to:
  /// **'How to use'**
  String get helpTitle;

  /// Help text for moving players
  ///
  /// In en, this message translates to:
  /// **'• Drag and drop players to move them.'**
  String get helpMovePlayers;

  /// Help text for player info
  ///
  /// In en, this message translates to:
  /// **'• Double tap on a player to see their info.'**
  String get helpPlayerInfo;

  /// Help text for rotating
  ///
  /// In en, this message translates to:
  /// **'• Click the rotation button to rotate forward.'**
  String get helpRotate;

  /// Checkbox to not show help again
  ///
  /// In en, this message translates to:
  /// **'Don\'t show again'**
  String get dontShowAgain;

  /// Title for double tap discovery dialog
  ///
  /// In en, this message translates to:
  /// **'Did you know?'**
  String get doubleTapDiscoveryTitle;

  /// Message for double tap discovery dialog
  ///
  /// In en, this message translates to:
  /// **'You just discovered a hidden feature! Double tapping rotates backwards.'**
  String get doubleTapDiscoveryMessage;

  /// Button to dismiss discovery dialog
  ///
  /// In en, this message translates to:
  /// **'Got it!'**
  String get gotIt;

  /// Buy me a coffee button text
  ///
  /// In en, this message translates to:
  /// **'Buy Me a Coffee'**
  String get buyMeACoffee;

  /// Support developer text
  ///
  /// In en, this message translates to:
  /// **'Support the Developer'**
  String get supportDeveloper;

  /// Exit button
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// Exit confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit?'**
  String get exitConfirmation;

  /// Reset confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset all changes?'**
  String get resetConfirmation;

  /// Select team dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Team'**
  String get selectTeam;

  /// No teams found message
  ///
  /// In en, this message translates to:
  /// **'No teams found. Please create a team first.'**
  String get noTeamsFound;

  /// Dialog title for selecting starting lineup
  ///
  /// In en, this message translates to:
  /// **'Select Starting 6'**
  String get selectStarting6;

  /// Start button label
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// Create match roster button label
  ///
  /// In en, this message translates to:
  /// **'Create Match Roster'**
  String get createMatchRoster;

  /// Match roster title
  ///
  /// In en, this message translates to:
  /// **'Match Roster'**
  String get matchRoster;

  /// Select players section title
  ///
  /// In en, this message translates to:
  /// **'Select Players'**
  String get selectPlayers;

  /// Match date field label
  ///
  /// In en, this message translates to:
  /// **'Match Date'**
  String get matchDate;

  /// Location field label
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Rival team name field label
  ///
  /// In en, this message translates to:
  /// **'Rival Team'**
  String get rivalTeam;

  /// Select all players checkbox label
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// Match rosters menu item
  ///
  /// In en, this message translates to:
  /// **'Match Rosters'**
  String get matchRosters;

  /// Match rosters description
  ///
  /// In en, this message translates to:
  /// **'Save and manage match call-ups'**
  String get matchRostersDescription;

  /// Empty state message
  ///
  /// In en, this message translates to:
  /// **'No match rosters yet'**
  String get noMatchRostersYet;

  /// Empty state subtitle
  ///
  /// In en, this message translates to:
  /// **'Create your first match roster'**
  String get createFirstMatchRoster;

  /// New match roster button
  ///
  /// In en, this message translates to:
  /// **'New Roster'**
  String get newMatchRoster;

  /// Edit match roster title
  ///
  /// In en, this message translates to:
  /// **'Edit Match Roster'**
  String get editMatchRoster;

  /// Delete match roster dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Match Roster'**
  String get deleteMatchRoster;

  /// Delete confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this match roster?'**
  String get deleteMatchRosterConfirmation;

  /// Edit button label
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Dialog title for editing opponent player number
  ///
  /// In en, this message translates to:
  /// **'Edit Opponent Player Number'**
  String get editOpponentPlayerNumber;

  /// Label for player number input
  ///
  /// In en, this message translates to:
  /// **'Player Number'**
  String get playerNumber;

  /// Hint text for player number input
  ///
  /// In en, this message translates to:
  /// **'Enter number (1-99)'**
  String get enterNumber;

  /// Dialog title asking which team serves first
  ///
  /// In en, this message translates to:
  /// **'Who Serves First?'**
  String get whoServesFirst;

  /// Dialog content for first serve selection
  ///
  /// In en, this message translates to:
  /// **'Select the team that serves first.'**
  String get selectTeamServesFirst;

  /// Button to start a new match
  ///
  /// In en, this message translates to:
  /// **'New Match'**
  String get newMatch;

  /// Button to start next set
  ///
  /// In en, this message translates to:
  /// **'Next Set'**
  String get nextSet;

  /// Dialog content for reset confirmation
  ///
  /// In en, this message translates to:
  /// **'This will reset scores, sets, and player positions. Are you sure?'**
  String get resetMatchConfirmation;

  /// Section title for match details
  ///
  /// In en, this message translates to:
  /// **'Match Details'**
  String get matchDetails;

  /// Required field indicator
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// Example text for rival team name
  ///
  /// In en, this message translates to:
  /// **'e.g., CV Barcelona'**
  String get exampleRivalName;

  /// Placeholder text for date selection
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// Optional field indicator
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// Example text for location
  ///
  /// In en, this message translates to:
  /// **'e.g., Sports Center Arena'**
  String get exampleLocation;

  /// Warning message for minimum players
  ///
  /// In en, this message translates to:
  /// **'Select at least {count} players to start match'**
  String selectAtLeastPlayers(int count);

  /// Info message that players are optional for roster save
  ///
  /// In en, this message translates to:
  /// **'Players can be added later (optional)'**
  String get playersCanBeAddedLater;

  /// Required field error message
  ///
  /// In en, this message translates to:
  /// **'{field} is required'**
  String rivalTeamRequired(String field);

  /// Success message for roster creation
  ///
  /// In en, this message translates to:
  /// **'Match roster created'**
  String get matchRosterCreated;

  /// Success message for roster update
  ///
  /// In en, this message translates to:
  /// **'Match roster updated'**
  String get matchRosterUpdated;

  /// Error message for roster save failure
  ///
  /// In en, this message translates to:
  /// **'Error saving roster: {error}'**
  String errorSavingRoster(String error);

  /// Message when no players are in roster
  ///
  /// In en, this message translates to:
  /// **'No players selected'**
  String get noPlayersSelected;

  /// Tooltip for showing player initials
  ///
  /// In en, this message translates to:
  /// **'Show Initials'**
  String get showInitials;

  /// Tooltip to toggle showing player numbers
  ///
  /// In en, this message translates to:
  /// **'Show Numbers'**
  String get showNumbers;

  /// Default opponent team name
  ///
  /// In en, this message translates to:
  /// **'Opponent'**
  String get opponent;

  /// Validation message when trying to start match without 6 players
  ///
  /// In en, this message translates to:
  /// **'Please place 6 players on the court to start.'**
  String get placeSixPlayersToStart;

  /// Tooltip for reset match button
  ///
  /// In en, this message translates to:
  /// **'Reset Match'**
  String get resetMatchTooltip;

  /// Tooltip for switch sides button
  ///
  /// In en, this message translates to:
  /// **'Switch Sides'**
  String get switchSidesTooltip;

  /// Tooltip for drawing mode button
  ///
  /// In en, this message translates to:
  /// **'Drawing Mode'**
  String get drawingModeTooltip;

  /// Tooltip for undo last point button
  ///
  /// In en, this message translates to:
  /// **'Undo Last Point'**
  String get undoLastPointTooltip;

  /// Tooltip for export match log button
  ///
  /// In en, this message translates to:
  /// **'Export Match Log (CSV)'**
  String get exportMatchLogTooltip;

  /// Tooltip for zoom button
  ///
  /// In en, this message translates to:
  /// **'Zoom'**
  String get zoomTooltip;

  /// Tooltip for undo drawing button
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undoTooltip;

  /// Tooltip for clear all drawings button
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAllTooltip;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ca',
        'de',
        'en',
        'es',
        'eu',
        'fr',
        'ja',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ca':
      return AppLocalizationsCa();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'eu':
      return AppLocalizationsEu();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
