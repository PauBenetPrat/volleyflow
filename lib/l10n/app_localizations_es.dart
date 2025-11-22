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
}
