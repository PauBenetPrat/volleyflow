// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Basque (`eu`).
class AppLocalizationsEu extends AppLocalizations {
  AppLocalizationsEu([String locale = 'eu']) : super(locale);

  @override
  String get appTitle => 'VolleyFlow';

  @override
  String get volleyballCoachingApp => 'Boleibol Entrenamendu Aplikazioa';

  @override
  String get welcome => 'Ongi etorri';

  @override
  String get welcomeSubtitle =>
      'Zure taldearen errotazioak eta posizioak kudeatu';

  @override
  String get rotations => 'Errotazioak';

  @override
  String get refereeMatch => 'Epaile / Partida';

  @override
  String get about => 'Honi buruz';

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
  String get rotationSystemPlayers => 'Jokalariak';

  @override
  String featureComingSoon(String displayName) {
    return '$displayName funtzionalitatea laster etorriko da!';
  }

  @override
  String get activateDrawingMode => 'Marrazketako modua aktibatu';

  @override
  String get deactivateDrawingMode => 'Marrazketako modua desaktibatu';

  @override
  String get undoLastStroke => 'Azken trazu desegin';

  @override
  String get clearAllDrawings => 'Marrazki guztiak ezabatu';

  @override
  String get coordinatesCopied => 'Koordenatuak arbelera kopiatu dira!';

  @override
  String get copyCoordinates => 'Koordenatuak arbelera kopiatu';

  @override
  String get reset => 'Berrezarri';

  @override
  String get rotationValidationError => 'Errotazio falta';

  @override
  String get close => 'Itxi';

  @override
  String get rotateTooltip =>
      'Klik: aurrera biratu | Klik bikoitza: atzera biratu';

  @override
  String get version => '1.0.0 bertsioa';

  @override
  String get purpose => 'Helburua';

  @override
  String get purposeText =>
      'Aplikazio hau boleibol entrenatzaileei eta jokalariei taldearen errotazioak eta posizioak zelaian ikusteko eta kudeatzeko laguntzeko diseinatuta dago.';

  @override
  String get features => 'Ezaugarriak';

  @override
  String get featureRotations =>
      'Taldearen errotazioak ikusi boleibol zelai estandarrean';

  @override
  String get featurePositions =>
      'Jokalarien posizioak denbora errealean jarraitu';

  @override
  String get featureReset => 'Posizioak erraz biratu eta berrezarri';

  @override
  String get developer => 'Garatzailea';

  @override
  String get developedBy => 'Pau Benet Prat-ek garatua';

  @override
  String get githubRepository => 'GitHub biltegia';

  @override
  String get linkedinProfile => 'LinkedIn profila';

  @override
  String get aboutNote =>
      'Hau MVP bertsioa da. Etorkizuneko eguneratzeetan ezaugarri gehiago gehituko dira. Akats bat aurkitu duzu edo ideia bat? Begiratu GitHub biltegia!';

  @override
  String get matchControl => 'Partidaren Kontrola';

  @override
  String get matchInProgress => 'Partida Martxan';

  @override
  String get matchNotStarted => 'Partida Ez Hasi';

  @override
  String set(int setNumber) {
    return '$setNumber set-a';
  }

  @override
  String get teamA => 'A Taldea';

  @override
  String get teamB => 'B Taldea';

  @override
  String sets(int count) {
    return 'Set-ak: $count';
  }

  @override
  String get startMatch => 'Partida Hasi';

  @override
  String get resetMatch => 'Partida Berrezarri';

  @override
  String get matchWon => 'Partida Irabazita!';

  @override
  String matchWonMessage(String winner) {
    return '$winner partida irabazi du!';
  }

  @override
  String get ok => 'Ados';

  @override
  String get settings => 'Ezarpenak';

  @override
  String get language => 'Hizkuntza';

  @override
  String get systemDefault => 'Sistemaren lehenetsia';
}
