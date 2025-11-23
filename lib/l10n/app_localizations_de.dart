// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'VolleyFlow';

  @override
  String get volleyballCoachingApp => 'Volleyball-Trainings-App';

  @override
  String get welcome => 'Willkommen';

  @override
  String get welcomeSubtitle =>
      'Verwalten Sie die Rotationen und Positionen Ihres Teams';

  @override
  String get rotations => 'Rotationen';

  @override
  String get refereeMatch => 'Schiedsrichter / Spiel';

  @override
  String get about => 'Über';

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
  String get rotationSystemPlayers => 'Spieler';

  @override
  String featureComingSoon(String displayName) {
    return 'Die Funktion $displayName kommt bald!';
  }

  @override
  String get activateDrawingMode => 'Zeichenmodus aktivieren';

  @override
  String get deactivateDrawingMode => 'Zeichenmodus deaktivieren';

  @override
  String get undoLastStroke => 'Letzten Strich rückgängig machen';

  @override
  String get clearAllDrawings => 'Alle Zeichnungen löschen';

  @override
  String get coordinatesCopied => 'Koordinaten in die Zwischenablage kopiert!';

  @override
  String get copyCoordinates => 'Koordinaten in die Zwischenablage kopieren';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get rotationValidationError => 'Rotationsfehler';

  @override
  String get close => 'Schließen';

  @override
  String get rotateTooltip =>
      'Klick: vorwärts drehen | Doppelklick: rückwärts drehen';

  @override
  String get version => 'Version 1.0.0';

  @override
  String get purpose => 'Zweck';

  @override
  String get purposeText =>
      'Diese App wurde entwickelt, um Volleyballtrainern und -spielern zu helfen, Teamrotationen und -positionen auf dem Spielfeld zu visualisieren und zu verwalten.';

  @override
  String get features => 'Funktionen';

  @override
  String get featureRotations =>
      'Teamrotationen auf einem Standard-Volleyballfeld visualisieren';

  @override
  String get featurePositions => 'Spielerpositionen in Echtzeit verfolgen';

  @override
  String get featureReset => 'Positionen einfach drehen und zurücksetzen';

  @override
  String get developer => 'Entwickler';

  @override
  String get developedBy => 'Entwickelt von Pau Benet Prat';

  @override
  String get githubRepository => 'GitHub-Repository';

  @override
  String get linkedinProfile => 'LinkedIn-Profil';

  @override
  String get aboutNote =>
      'Dies ist eine MVP-Version. Weitere Funktionen werden in zukünftigen Updates hinzugefügt. Einen Fehler gefunden oder eine Idee? Schauen Sie sich das GitHub-Repository an!';

  @override
  String get matchControl => 'Spielkontrolle';

  @override
  String get matchInProgress => 'Spiel läuft';

  @override
  String get matchNotStarted => 'Spiel nicht gestartet';

  @override
  String set(int setNumber) {
    return 'Satz $setNumber';
  }

  @override
  String get teamA => 'Team A';

  @override
  String get teamB => 'Team B';

  @override
  String sets(int count) {
    return 'Sätze: $count';
  }

  @override
  String get startMatch => 'Spiel starten';

  @override
  String get resetMatch => 'Spiel zurücksetzen';

  @override
  String get matchWon => 'Spiel gewonnen!';

  @override
  String matchWonMessage(String winner) {
    return '$winner gewinnt das Spiel!';
  }

  @override
  String get ok => 'OK';

  @override
  String get settings => 'Einstellungen';

  @override
  String get language => 'Sprache';

  @override
  String get systemDefault => 'Systemstandard';

  @override
  String get roleSetterName => 'Zuspieler';

  @override
  String get roleSetterDescription =>
      'Zuspieler. Macht den zweiten Pass und organisiert den Angriff.';

  @override
  String get roleMiddleBlockerName => 'Mittelblocker';

  @override
  String get roleMiddleBlockerDescription =>
      'Mittelblocker. Spezialisiert auf Blocken und schnelle Angriffe.';

  @override
  String get roleOppositeName => 'Diagonalspieler';

  @override
  String get roleOppositeDescription =>
      'Diagonalspieler. Hauptangreifer, spielt gegenüber dem Zuspieler (Position 2 oder 1).';

  @override
  String get roleOutsideHitterName => 'Außenangreifer';

  @override
  String get roleOutsideHitterDescription =>
      'Außenangreifer (auch \"Flügelspieler\" oder \"Doppel\" genannt). Spielt auf den Positionen 4 und 6.';

  @override
  String get roleLiberoName => 'Libero';

  @override
  String get roleLiberoDescription =>
      'Libero. Defensivspezialist. Kann nicht angreifen oder blocken, trägt ein anderes Trikot.';

  @override
  String get teams => 'Teams';

  @override
  String get home => 'Startseite';

  @override
  String get teamDetails => 'Team-Details';

  @override
  String get teamName => 'Teamname';

  @override
  String get teamNameRequired => 'Der Teamname ist erforderlich';

  @override
  String get coaches => 'Trainer';

  @override
  String get players => 'Spieler';

  @override
  String get noTeamsYet => 'Noch keine Teams';

  @override
  String get createYourFirstTeam =>
      'Erstellen Sie Ihr erstes Team, um zu beginnen';

  @override
  String get createTeam => 'Team erstellen';

  @override
  String get newTeam => 'Neues Team';

  @override
  String teamInfo(int playerCount, int coachCount) {
    return '$playerCount Spieler, $coachCount Trainer';
  }

  @override
  String get noCoachesYet => 'Noch keine Trainer';

  @override
  String get noPlayersYet => 'Noch keine Spieler';

  @override
  String get addPlayer => 'Spieler hinzufügen';

  @override
  String get editPlayer => 'Spieler bearbeiten';

  @override
  String get playerName => 'Spielername';

  @override
  String get playerNameRequired => 'Der Spielername ist erforderlich';

  @override
  String get alias => 'Spitzname';

  @override
  String get number => 'Nummer';

  @override
  String get age => 'Alter';

  @override
  String get height => 'Größe';

  @override
  String get mainPosition => 'Hauptposition';

  @override
  String get position => 'Position';

  @override
  String get captain => 'Kapitän';

  @override
  String get addCoach => 'Trainer hinzufügen';

  @override
  String get editCoach => 'Trainer bearbeiten';

  @override
  String get coachName => 'Trainername';

  @override
  String get coachNameRequired => 'Der Trainername ist erforderlich';

  @override
  String get primary => 'Haupttrainer';

  @override
  String get primaryCoach => 'Haupttrainer';

  @override
  String get secondaryCoach => 'Zweitrainer';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get teamSaved => 'Team gespeichert';

  @override
  String get premiumFeature => 'Premium-Funktion';

  @override
  String get premiumFeatureMessage =>
      'Das Erstellen mehrerer Teams ist eine Premium-Funktion. Um diese Funktion freizuschalten, kontaktieren Sie uns bitte.';

  @override
  String get premiumFeatureRequest => 'Premium-Funktion anfordern';

  @override
  String get contactUs => 'Kontaktieren Sie uns';

  @override
  String get gender => 'Geschlecht';

  @override
  String get male => 'Männlich';

  @override
  String get female => 'Weiblich';
}
