// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'VolleyFlow';

  @override
  String get volleyballCoachingApp => 'Aplicación de Entrenamiento de Voleibol';

  @override
  String get welcome => 'Bienvenido';

  @override
  String get welcomeSubtitle =>
      'Gestiona las rotaciones y posiciones de tu equipo';

  @override
  String get rotations => 'Rotaciones';

  @override
  String get refereeMatch => 'Árbitro / Partido';

  @override
  String get about => 'Acerca de';

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
  String get rotationSystemPlayers => 'Jugadores';

  @override
  String featureComingSoon(String displayName) {
    return '¡La funcionalidad $displayName llegará pronto!';
  }

  @override
  String get activateDrawingMode => 'Activar modo dibujo';

  @override
  String get deactivateDrawingMode => 'Desactivar modo dibujo';

  @override
  String get undoLastStroke => 'Deshacer último trazo';

  @override
  String get clearAllDrawings => 'Borrar todos los dibujos';

  @override
  String get coordinatesCopied => '¡Coordenadas copiadas al portapapeles!';

  @override
  String get copyCoordinates => 'Copiar coordenadas al portapapeles';

  @override
  String get reset => 'Reiniciar';

  @override
  String get rotationValidationError => 'Falta de rotación';

  @override
  String get close => 'Cerrar';

  @override
  String get rotateTooltip => 'Clic: rotar adelante | Doble clic: rotar atrás';

  @override
  String get version => 'Versión 1.0.0';

  @override
  String get purpose => 'Propósito';

  @override
  String get purposeText =>
      'Esta aplicación está diseñada para ayudar a entrenadores y jugadores de voleibol a visualizar y gestionar las rotaciones y posiciones del equipo en la cancha.';

  @override
  String get features => 'Características';

  @override
  String get featureRotations =>
      'Visualiza las rotaciones del equipo en una cancha de voleibol estándar';

  @override
  String get featurePositions =>
      'Rastrea las posiciones de los jugadores en tiempo real';

  @override
  String get featureReset => 'Rota y reinicia las posiciones fácilmente';

  @override
  String get developer => 'Desarrollador';

  @override
  String get developedBy => 'Desarrollado por Pau Benet Prat';

  @override
  String get githubRepository => 'Repositorio de GitHub';

  @override
  String get linkedinProfile => 'Perfil de LinkedIn';

  @override
  String get aboutNote =>
      'Esta es una versión MVP. Se añadirán más funcionalidades en futuras actualizaciones. ¿Has encontrado un error o tienes una idea? ¡Consulta el repositorio de GitHub!';

  @override
  String get matchControl => 'Control de Partido';

  @override
  String get matchInProgress => 'Partido en Curso';

  @override
  String get matchNotStarted => 'Partido No Iniciado';

  @override
  String set(int setNumber) {
    return 'Set $setNumber';
  }

  @override
  String get teamA => 'Equipo A';

  @override
  String get teamB => 'Equipo B';

  @override
  String sets(int count) {
    return 'Sets: $count';
  }

  @override
  String get startMatch => 'Iniciar Partido';

  @override
  String get resetMatch => 'Reiniciar Partido';

  @override
  String get matchWon => '¡Partido Ganado!';

  @override
  String matchWonMessage(String winner) {
    return '¡$winner gana el partido!';
  }

  @override
  String get ok => 'Aceptar';

  @override
  String get settings => 'Configuración';

  @override
  String get language => 'Idioma';

  @override
  String get systemDefault => 'Predeterminado del sistema';

  @override
  String get roleSetterName => 'Colocador';

  @override
  String get roleSetterDescription =>
      'Colocador. Hace la segunda pasada y organiza el ataque.';

  @override
  String get roleMiddleBlockerName => 'Central';

  @override
  String get roleMiddleBlockerDescription =>
      'Central. Especializado en bloqueo y ataques rápidos.';

  @override
  String get roleOppositeName => 'Opuesto';

  @override
  String get roleOppositeDescription =>
      'Opuesto. Atacante principal, juega opuesto al colocador (posición 2 o 1).';

  @override
  String get roleOutsideHitterName => 'Receptor-Atacante';

  @override
  String get roleOutsideHitterDescription =>
      'Receptor-Atacante (también llamado \"punta\" o \"doble\"). Juega en posiciones 4 y 6.';

  @override
  String get roleLiberoName => 'Líbero';

  @override
  String get roleLiberoDescription =>
      'Líbero. Jugador defensivo especializado. No puede atacar ni bloquear, lleva camiseta diferente.';

  @override
  String get teams => 'Equipos';

  @override
  String get home => 'Inicio';

  @override
  String get teamDetails => 'Detalles del Equipo';

  @override
  String get teamName => 'Nombre del Equipo';

  @override
  String get teamNameRequired => 'El nombre del equipo es obligatorio';

  @override
  String get coaches => 'Entrenadores';

  @override
  String get players => 'Jugadores';

  @override
  String get noTeamsYet => 'Aún no hay equipos';

  @override
  String get createYourFirstTeam => 'Crea tu primer equipo para comenzar';

  @override
  String get createTeam => 'Crear Equipo';

  @override
  String get newTeam => 'Nuevo Equipo';

  @override
  String teamInfo(int playerCount, int coachCount) {
    return '$playerCount jugadores, $coachCount entrenadores';
  }

  @override
  String get noCoachesYet => 'Aún no hay entrenadores';

  @override
  String get noPlayersYet => 'Aún no hay jugadores';

  @override
  String get addPlayer => 'Añadir Jugador';

  @override
  String get editPlayer => 'Editar Jugador';

  @override
  String get playerName => 'Nombre del Jugador';

  @override
  String get playerNameRequired => 'El nombre del jugador es obligatorio';

  @override
  String get alias => 'Alias';

  @override
  String get number => 'Número';

  @override
  String get age => 'Edad';

  @override
  String get height => 'Altura';

  @override
  String get mainPosition => 'Posición Principal';

  @override
  String get position => 'Posición';

  @override
  String get captain => 'Capitán';

  @override
  String get addCoach => 'Añadir Entrenador';

  @override
  String get editCoach => 'Editar Entrenador';

  @override
  String get coachName => 'Nombre del Entrenador';

  @override
  String get coachNameRequired => 'El nombre del entrenador es obligatorio';

  @override
  String get primary => 'Principal';

  @override
  String get primaryCoach => 'Entrenador Principal';

  @override
  String get secondaryCoach => 'Entrenador Secundario';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get teamSaved => 'Equipo guardado';

  @override
  String get premiumFeature => 'Funcionalidad Premium';

  @override
  String get premiumFeatureMessage =>
      'Crear múltiples equipos es una funcionalidad premium. Para desbloquear esta funcionalidad, por favor contáctanos.';

  @override
  String get premiumFeatureRequest => 'Solicitud de Funcionalidad Premium';

  @override
  String get contactUs => 'Contáctanos';

  @override
  String get gender => 'Sexo';

  @override
  String get male => 'Hombre';

  @override
  String get female => 'Mujer';
}
