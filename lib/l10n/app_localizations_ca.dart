// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get appTitle => 'VolleyFlow';

  @override
  String get volleyballCoachingApp => 'Aplicació d\'Entrenament de Voleibol';

  @override
  String get welcome => 'Benvingut';

  @override
  String get welcomeSubtitle =>
      'Gestiona les rotacions i posicions del teu equip';

  @override
  String get rotations => 'Rotacions';

  @override
  String get refereeMatch => 'Àrbitre / Partit';

  @override
  String get about => 'Sobre';

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
  String get rotationSystemPlayers => 'Jugadors';

  @override
  String get selectRotationSystem => 'Selecciona un sistema de rotació';

  @override
  String get rotationSystem42NoLiberoDescription => 'Sistema 4-2 sense libero';

  @override
  String get rotationSystem42Description => 'Sistema 4-2 amb libero';

  @override
  String get rotationSystem51Description => 'Sistema 5-1 amb un col·locador';

  @override
  String get rotationSystemPlayersDescription =>
      'Rotació personalitzada amb jugadors específics';

  @override
  String featureComingSoon(String displayName) {
    return 'La funcionalitat $displayName arribarà aviat!';
  }

  @override
  String get activateDrawingMode => 'Activar mode dibuix';

  @override
  String get deactivateDrawingMode => 'Desactivar mode dibuix';

  @override
  String get undoLastStroke => 'Desfer últim traç';

  @override
  String get clearAllDrawings => 'Esborrar tots els dibuixos';

  @override
  String get coordinatesCopied => 'Coordenades copiades al portapapers!';

  @override
  String get copyCoordinates => 'Copiar coordenades al portapapers';

  @override
  String get reset => 'Reset';

  @override
  String get rotationValidationError => 'Falta de rotació';

  @override
  String get close => 'Tancar';

  @override
  String get rotateTooltip =>
      'Clic: rotar endavant | Doble clic: rotar endarrere';

  @override
  String get version => 'Versió 1.0.0';

  @override
  String get purpose => 'Propòsit';

  @override
  String get purposeText =>
      'Aquesta aplicació està dissenyada per ajudar entrenadors i jugadors de voleibol a visualitzar i gestionar les rotacions i posicions de l\'equip a la pista.';

  @override
  String get features => 'Funcionalitats';

  @override
  String get featureRotations =>
      'Visualitza les rotacions de l\'equip en una pista de voleibol estàndard';

  @override
  String get featurePositions =>
      'Segueix les posicions dels jugadors en temps real';

  @override
  String get featureReset => 'Rota i reinicia les posicions fàcilment';

  @override
  String get developer => 'Desenvolupador';

  @override
  String get developedBy => 'Desenvolupat per Pau Benet Prat';

  @override
  String get githubRepository => 'Repositori de GitHub';

  @override
  String get linkedinProfile => 'Perfil de LinkedIn';

  @override
  String get aboutNote =>
      'Aquesta és una versió MVP. S\'afegiran més funcionalitats en futures actualitzacions. Has trobat un error o tens una idea? Consulta el repositori de GitHub!';

  @override
  String get matchControl => 'Control de Partit';

  @override
  String get matchInProgress => 'Partit en Curs';

  @override
  String get matchNotStarted => 'Partit No Iniciat';

  @override
  String set(int setNumber) {
    return 'Set $setNumber';
  }

  @override
  String get teamA => 'Equip A';

  @override
  String get teamB => 'Equip B';

  @override
  String sets(int count) {
    return 'Sets: $count';
  }

  @override
  String get startMatch => 'Iniciar Partit';

  @override
  String get resetMatch => 'Reiniciar Partit';

  @override
  String get matchWon => 'Partit Guanyat!';

  @override
  String matchWonMessage(String winner) {
    return '$winner guanya el partit!';
  }

  @override
  String get ok => 'D\'acord';

  @override
  String get settings => 'Configuració';

  @override
  String get language => 'Idioma';

  @override
  String get systemDefault => 'Per defecte del sistema';

  @override
  String get roleSetterName => 'Col·locador';

  @override
  String get roleSetterDescription =>
      'Col·locador. Fa la segona passada i organitza l\'atac.';

  @override
  String get roleMiddleBlockerName => 'Central';

  @override
  String get roleMiddleBlockerDescription =>
      'Central. Especialitzat en bloqueig i atacs ràpids.';

  @override
  String get roleOppositeName => 'Oposat';

  @override
  String get roleOppositeDescription =>
      'Oposat. Atacant principal, juga oposat al col·locador (posició 2 o 1).';

  @override
  String get roleOutsideHitterName => 'Receptor-Atacant';

  @override
  String get roleOutsideHitterDescription =>
      'Receptor-Atacant (també anomenat \"punta\" o \"doble\"). Juga a posicions 4 i 6.';

  @override
  String get roleLiberoName => 'Llibero';

  @override
  String get roleLiberoDescription =>
      'Llibero. Jugador defensiu especialitzat. No pot atacar ni bloquejar, porta samarreta diferent.';

  @override
  String get roleSetterAbbr => 'Co';

  @override
  String get roleMiddleBlockerAbbr => 'C';

  @override
  String get roleOppositeAbbr => 'O';

  @override
  String get roleOutsideHitterAbbr => 'R';

  @override
  String get roleLiberoAbbr => 'L';

  @override
  String get teams => 'Equips';

  @override
  String get home => 'Inici';

  @override
  String get teamDetails => 'Detalls de l\'Equip';

  @override
  String get teamName => 'Nom de l\'Equip';

  @override
  String get teamNameRequired => 'El nom de l\'equip és obligatori';

  @override
  String get coaches => 'Entrenadors';

  @override
  String get players => 'Jugadors';

  @override
  String get noTeamsYet => 'Encara no hi ha equips';

  @override
  String get createYourFirstTeam => 'Crea el teu primer equip per començar';

  @override
  String get createTeam => 'Crear Equip';

  @override
  String get newTeam => 'Nou Equip';

  @override
  String teamInfo(int playerCount, int coachCount) {
    return '$playerCount jugadors, $coachCount entrenadors';
  }

  @override
  String get noCoachesYet => 'Encara no hi ha entrenadors';

  @override
  String get noPlayersYet => 'Encara no hi ha jugadors';

  @override
  String get addPlayer => 'Afegir Jugador';

  @override
  String get editPlayer => 'Editar Jugador';

  @override
  String get playerName => 'Nom del Jugador';

  @override
  String get playerNameRequired => 'El nom del jugador és obligatori';

  @override
  String get alias => 'Àlies';

  @override
  String get number => 'Número';

  @override
  String get age => 'Edat';

  @override
  String get height => 'Alçada';

  @override
  String get mainPosition => 'Posició Principal';

  @override
  String get position => 'Posició';

  @override
  String get captain => 'Capità';

  @override
  String get addCoach => 'Afegir Entrenador';

  @override
  String get editCoach => 'Editar Entrenador';

  @override
  String get coachName => 'Nom de l\'Entrenador';

  @override
  String get coachNameRequired => 'El nom de l\'entrenador és obligatori';

  @override
  String get primary => 'Principal';

  @override
  String get primaryCoach => 'Entrenador Principal';

  @override
  String get secondaryCoach => 'Entrenador Secundari';

  @override
  String get save => 'Desar';

  @override
  String get cancel => 'Cancel·lar';

  @override
  String get teamSaved => 'Equip desat';

  @override
  String get premiumFeature => 'Funcionalitat Premium';

  @override
  String get premiumFeatureMessage =>
      'Crear múltiples equips és una funcionalitat premium. Per desbloquejar aquesta funcionalitat, si us plau, contacta amb nosaltres.';

  @override
  String get premiumFeatureRequest => 'Sol·licitud de Funcionalitat Premium';

  @override
  String get contactUs => 'Contacta amb Nosaltres';

  @override
  String get gender => 'Sexe';

  @override
  String get male => 'Home';

  @override
  String get female => 'Dona';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteTeam => 'Eliminar Equip';

  @override
  String deleteTeamConfirmation(String name) {
    return 'Estàs segur que vols eliminar l\'equip \"$name\"? Aquesta acció no es pot desfer.';
  }

  @override
  String get teamDeleted => 'Equip eliminat';

  @override
  String get deletePlayer => 'Eliminar Jugador';

  @override
  String deletePlayerConfirmation(String name) {
    return 'Estàs segur que vols eliminar $name?';
  }

  @override
  String get playerDeleted => 'Jugador eliminat';

  @override
  String get deleteCoach => 'Eliminar Entrenador';

  @override
  String deleteCoachConfirmation(String name) {
    return 'Estàs segur que vols eliminar $name?';
  }

  @override
  String get coachDeleted => 'Entrenador eliminat';

  @override
  String get enterPin => 'Introdueix el PIN';

  @override
  String get pin => 'PIN';

  @override
  String get pinRequired => 'El PIN és obligatori';

  @override
  String get incorrectPin => 'PIN incorrecte';

  @override
  String get help => 'Ajuda';

  @override
  String get helpTitle => 'Com funciona';

  @override
  String get helpMovePlayers => '• Arrossega els jugadors per moure\'ls.';

  @override
  String get helpPlayerInfo =>
      '• Fes doble toc sobre un jugador per veure la seva informació.';

  @override
  String get helpRotate => '• Clica el botó de rotació per rotar endavant.';

  @override
  String get dontShowAgain => 'No tornar a mostrar';

  @override
  String get doubleTapDiscoveryTitle => 'Ho sabies?';

  @override
  String get doubleTapDiscoveryMessage =>
      'Acabes de descobrir una funció oculta! El doble toc rota endarrere.';

  @override
  String get gotIt => 'Entesos!';
}
