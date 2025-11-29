import '../../../../features/teams/domain/models/player.dart';

class Alineation {
  final List<Player> players;

  Alineation({required this.players});

  factory Alineation.fromTeam(List<Player> teamPlayers) {
    return Alineation(players: List.from(teamPlayers));
  }
}
