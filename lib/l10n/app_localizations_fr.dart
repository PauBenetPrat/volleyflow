// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'VolleyFlow';

  @override
  String get volleyballCoachingApp =>
      'Application d\'Entraînement de Volley-ball';

  @override
  String get welcome => 'Bienvenue';

  @override
  String get welcomeSubtitle =>
      'Gérez les rotations et positions de votre équipe';

  @override
  String get rotations => 'Rotations';

  @override
  String get refereeMatch => 'Arbitre / Match';

  @override
  String get about => 'À propos';

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
  String get rotationSystemPlayers => 'Joueurs';

  @override
  String featureComingSoon(String displayName) {
    return 'La fonctionnalité $displayName arrive bientôt !';
  }

  @override
  String get activateDrawingMode => 'Activer le mode dessin';

  @override
  String get deactivateDrawingMode => 'Désactiver le mode dessin';

  @override
  String get undoLastStroke => 'Annuler le dernier trait';

  @override
  String get clearAllDrawings => 'Effacer tous les dessins';

  @override
  String get coordinatesCopied =>
      'Coordonnées copiées dans le presse-papiers !';

  @override
  String get copyCoordinates => 'Copier les coordonnées dans le presse-papiers';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get rotationValidationError => 'Erreur de rotation';

  @override
  String get close => 'Fermer';

  @override
  String get rotateTooltip =>
      'Clic : tourner vers l\'avant | Double clic : tourner vers l\'arrière';

  @override
  String get version => 'Version 1.0.0';

  @override
  String get purpose => 'Objectif';

  @override
  String get purposeText =>
      'Cette application est conçue pour aider les entraîneurs et joueurs de volley-ball à visualiser et gérer les rotations et positions de l\'équipe sur le terrain.';

  @override
  String get features => 'Fonctionnalités';

  @override
  String get featureRotations =>
      'Visualisez les rotations de l\'équipe sur un terrain de volley-ball standard';

  @override
  String get featurePositions =>
      'Suivez les positions des joueurs en temps réel';

  @override
  String get featureReset =>
      'Tournez et réinitialisez facilement les positions';

  @override
  String get developer => 'Développeur';

  @override
  String get developedBy => 'Développé par Pau Benet Prat';

  @override
  String get githubRepository => 'Dépôt GitHub';

  @override
  String get linkedinProfile => 'Profil LinkedIn';

  @override
  String get aboutNote =>
      'Ceci est une version MVP. D\'autres fonctionnalités seront ajoutées dans les futures mises à jour. Vous avez trouvé un bug ou avez une idée ? Consultez le dépôt GitHub !';

  @override
  String get matchControl => 'Contrôle du Match';

  @override
  String get matchInProgress => 'Match en Cours';

  @override
  String get matchNotStarted => 'Match Non Commencé';

  @override
  String set(int setNumber) {
    return 'Set $setNumber';
  }

  @override
  String get teamA => 'Équipe A';

  @override
  String get teamB => 'Équipe B';

  @override
  String sets(int count) {
    return 'Sets : $count';
  }

  @override
  String get startMatch => 'Démarrer le Match';

  @override
  String get resetMatch => 'Réinitialiser le Match';

  @override
  String get matchWon => 'Match Gagné !';

  @override
  String matchWonMessage(String winner) {
    return '$winner gagne le match !';
  }

  @override
  String get ok => 'OK';

  @override
  String get settings => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get systemDefault => 'Par défaut du système';
}
