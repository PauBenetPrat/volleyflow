enum PlayerPosition {
  setter,
  libero,
  middleBlock,
  opposite,
  attack,
}

extension PlayerPositionExtension on PlayerPosition {
  String getDisplayName(String locale) {
    switch (this) {
      case PlayerPosition.setter:
        return locale == 'ca' ? 'Col·locador' : 
               locale == 'es' ? 'Colocador' :
               locale == 'fr' ? 'Passeur' :
               locale == 'de' ? 'Zuspieler' :
               locale == 'eu' ? 'Eratzailea' :
               'Setter';
      case PlayerPosition.libero:
        return locale == 'ca' ? 'Llibero' :
               locale == 'es' ? 'Líbero' :
               locale == 'fr' ? 'Libéro' :
               locale == 'de' ? 'Libero' :
               locale == 'eu' ? 'Liberoa' :
               'Libero';
      case PlayerPosition.middleBlock:
        return locale == 'ca' ? 'Central' :
               locale == 'es' ? 'Central' :
               locale == 'fr' ? 'Central' :
               locale == 'de' ? 'Mittelblocker' :
               locale == 'eu' ? 'Erdiko' :
               'Middle Block';
      case PlayerPosition.opposite:
        return locale == 'ca' ? 'Oposat' :
               locale == 'es' ? 'Opuesto' :
               locale == 'fr' ? 'Pointu' :
               locale == 'de' ? 'Diagonal' :
               locale == 'eu' ? 'Aurkakoa' :
               'Opposite';
      case PlayerPosition.attack:
        return locale == 'ca' ? 'Atacant' :
               locale == 'es' ? 'Atacante' :
               locale == 'fr' ? 'Attaquant' :
               locale == 'de' ? 'Außenangreifer' :
               locale == 'eu' ? 'Erasotzailea' :
               'Attack';
    }
  }
}

