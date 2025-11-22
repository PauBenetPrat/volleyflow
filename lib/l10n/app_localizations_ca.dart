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
}
