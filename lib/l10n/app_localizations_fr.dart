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
  String get selectRotationSystem => 'Sélectionnez un système de rotation';

  @override
  String get rotationSystem42NoLiberoDescription => 'Système 4-2 sans libero';

  @override
  String get rotationSystem42Description => 'Système 4-2 avec libero';

  @override
  String get rotationSystem51Description => 'Système 5-1 avec un passeur';

  @override
  String get rotationSystemPlayersDescription =>
      'Rotation personnalisée avec des joueurs spécifiques';

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

  @override
  String get roleSetterName => 'Passeur';

  @override
  String get roleSetterDescription =>
      'Passeur. Effectue la deuxième passe et organise l\'attaque.';

  @override
  String get roleMiddleBlockerName => 'Central';

  @override
  String get roleMiddleBlockerDescription =>
      'Central. Spécialisé dans le contre et les attaques rapides.';

  @override
  String get roleOppositeName => 'Pointu';

  @override
  String get roleOppositeDescription =>
      'Pointu. Attaquant principal, joue en opposition au passeur (position 2 ou 1).';

  @override
  String get roleOutsideHitterName => 'Réceptionneur-Attaquant';

  @override
  String get roleOutsideHitterDescription =>
      'Réceptionneur-Attaquant (aussi appelé \"ailier\" ou \"double\"). Joue aux positions 4 et 6.';

  @override
  String get roleLiberoName => 'Libéro';

  @override
  String get roleLiberoDescription =>
      'Libéro. Joueur défensif spécialisé. Ne peut pas attaquer ni contrer, porte un maillot différent.';

  @override
  String get teams => 'Équipes';

  @override
  String get home => 'Accueil';

  @override
  String get teamDetails => 'Détails de l\'Équipe';

  @override
  String get teamName => 'Nom de l\'Équipe';

  @override
  String get teamNameRequired => 'Le nom de l\'équipe est obligatoire';

  @override
  String get coaches => 'Entraîneurs';

  @override
  String get players => 'Joueurs';

  @override
  String get noTeamsYet => 'Aucune équipe pour le moment';

  @override
  String get createYourFirstTeam =>
      'Créez votre première équipe pour commencer';

  @override
  String get createTeam => 'Créer une Équipe';

  @override
  String get newTeam => 'Nouvelle Équipe';

  @override
  String teamInfo(int playerCount, int coachCount) {
    return '$playerCount joueurs, $coachCount entraîneurs';
  }

  @override
  String get noCoachesYet => 'Aucun entraîneur pour le moment';

  @override
  String get noPlayersYet => 'Aucun joueur pour le moment';

  @override
  String get addPlayer => 'Ajouter un Joueur';

  @override
  String get editPlayer => 'Modifier le Joueur';

  @override
  String get playerName => 'Nom du Joueur';

  @override
  String get playerNameRequired => 'Le nom du joueur est obligatoire';

  @override
  String get alias => 'Surnom';

  @override
  String get number => 'Numéro';

  @override
  String get age => 'Âge';

  @override
  String get height => 'Taille';

  @override
  String get mainPosition => 'Position Principale';

  @override
  String get position => 'Position';

  @override
  String get captain => 'Capitaine';

  @override
  String get addCoach => 'Ajouter un Entraîneur';

  @override
  String get editCoach => 'Modifier l\'Entraîneur';

  @override
  String get coachName => 'Nom de l\'Entraîneur';

  @override
  String get coachNameRequired => 'Le nom de l\'entraîneur est obligatoire';

  @override
  String get primary => 'Principal';

  @override
  String get primaryCoach => 'Entraîneur Principal';

  @override
  String get secondaryCoach => 'Entraîneur Secondaire';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get teamSaved => 'Équipe enregistrée';

  @override
  String get premiumFeature => 'Fonctionnalité Premium';

  @override
  String get premiumFeatureMessage =>
      'Créer plusieurs équipes est une fonctionnalité premium. Pour débloquer cette fonctionnalité, veuillez nous contacter.';

  @override
  String get premiumFeatureRequest => 'Demande de Fonctionnalité Premium';

  @override
  String get contactUs => 'Contactez-nous';

  @override
  String get gender => 'Sexe';

  @override
  String get male => 'Homme';

  @override
  String get female => 'Femme';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteTeam => 'Supprimer l\'Équipe';

  @override
  String deleteTeamConfirmation(String name) {
    return 'Êtes-vous sûr de vouloir supprimer l\'équipe \"$name\"? Cette action ne peut pas être annulée.';
  }

  @override
  String get teamDeleted => 'Équipe supprimée';

  @override
  String get deletePlayer => 'Supprimer le Joueur';

  @override
  String deletePlayerConfirmation(String name) {
    return 'Êtes-vous sûr de vouloir supprimer $name?';
  }

  @override
  String get playerDeleted => 'Joueur supprimé';

  @override
  String get deleteCoach => 'Supprimer l\'Entraîneur';

  @override
  String deleteCoachConfirmation(String name) {
    return 'Êtes-vous sûr de vouloir supprimer $name?';
  }

  @override
  String get coachDeleted => 'Entraîneur supprimé';

  @override
  String get enterPin => 'Entrez le code PIN';

  @override
  String get pin => 'Code PIN';

  @override
  String get pinRequired => 'Le code PIN est requis';

  @override
  String get incorrectPin => 'Code PIN incorrect';
}
