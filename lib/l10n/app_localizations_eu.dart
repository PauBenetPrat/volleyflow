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

  @override
  String get roleSetterName => 'Eratzailea';

  @override
  String get roleSetterDescription =>
      'Eratzailea. Bigarren pasea egiten du eta erasoa antolatzen du.';

  @override
  String get roleMiddleBlockerName => 'Erdiko Blokeatzailea';

  @override
  String get roleMiddleBlockerDescription =>
      'Erdiko Blokeatzailea. Blokeoan eta eraso azkarretan espezializatua.';

  @override
  String get roleOppositeName => 'Aurkakoa';

  @override
  String get roleOppositeDescription =>
      'Aurkakoa. Erasotzaile nagusia, eratzailaren aurkakoan jokatzen du (2 edo 1 posizioa).';

  @override
  String get roleOutsideHitterName => 'Kanpoko Erasotzailea';

  @override
  String get roleOutsideHitterDescription =>
      'Kanpoko Erasotzailea (\"hegal\" edo \"bikoitza\" ere deitua). 4 eta 6 posizioetan jokatzen du.';

  @override
  String get roleLiberoName => 'Liberoa';

  @override
  String get roleLiberoDescription =>
      'Liberoa. Defentsa espezializatuko jokalaria. Ezin du eraso egin ezta blokeatu, kamiseta desberdina darama.';

  @override
  String get teams => 'Taldeak';

  @override
  String get home => 'Hasiera';

  @override
  String get teamDetails => 'Taldearen Xehetasunak';

  @override
  String get teamName => 'Taldearen Izena';

  @override
  String get teamNameRequired => 'Taldearen izena beharrezkoa da';

  @override
  String get coaches => 'Entrenatzaileak';

  @override
  String get players => 'Jokalariak';

  @override
  String get noTeamsYet => 'Oraindik ez dago talderik';

  @override
  String get createYourFirstTeam => 'Sortu zure lehen taldea hasteko';

  @override
  String get createTeam => 'Taldea Sortu';

  @override
  String get newTeam => 'Talde Berria';

  @override
  String teamInfo(int playerCount, int coachCount) {
    return '$playerCount jokalari, $coachCount entrenatzaile';
  }

  @override
  String get noCoachesYet => 'Oraindik ez dago entrenatzailerik';

  @override
  String get noPlayersYet => 'Oraindik ez dago jokalaririk';

  @override
  String get addPlayer => 'Jokalaria Gehitu';

  @override
  String get editPlayer => 'Jokalaria Editatu';

  @override
  String get playerName => 'Jokalariaren Izena';

  @override
  String get playerNameRequired => 'Jokalariaren izena beharrezkoa da';

  @override
  String get alias => 'Ezizena';

  @override
  String get number => 'Zenbakia';

  @override
  String get age => 'Adina';

  @override
  String get height => 'Altuera';

  @override
  String get mainPosition => 'Posizio Nagusia';

  @override
  String get position => 'Posizioa';

  @override
  String get captain => 'Kapitaina';

  @override
  String get addCoach => 'Entrenatzailea Gehitu';

  @override
  String get editCoach => 'Entrenatzailea Editatu';

  @override
  String get coachName => 'Entrenatzailearen Izena';

  @override
  String get coachNameRequired => 'Entrenatzailearen izena beharrezkoa da';

  @override
  String get primary => 'Nagusia';

  @override
  String get primaryCoach => 'Entrenatzaile Nagusia';

  @override
  String get secondaryCoach => 'Bigarren Entrenatzailea';

  @override
  String get save => 'Gorde';

  @override
  String get cancel => 'Utzi';

  @override
  String get teamSaved => 'Taldea gordeta';

  @override
  String get premiumFeature => 'Premium Funtzionalitatea';

  @override
  String get premiumFeatureMessage =>
      'Talde anitz sortzea premium funtzionalitatea da. Funtzionalitate hau desblokeatzeko, mesedez jarri gurekin harremanetan.';

  @override
  String get premiumFeatureRequest => 'Premium Funtzionalitate Eskaera';

  @override
  String get contactUs => 'Jarri Gurekin Harremanetan';

  @override
  String get gender => 'Generoa';

  @override
  String get male => 'Gizonezkoa';

  @override
  String get female => 'Emakumezkoa';
}
