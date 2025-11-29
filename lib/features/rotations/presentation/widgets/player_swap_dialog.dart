import 'package:flutter/material.dart';
import '../../../teams/domain/models/player.dart';

class PlayerSwapDialog extends StatelessWidget {
  final Player currentPlayer;
  final List<Player> benchPlayers;

  const PlayerSwapDialog({
    super.key,
    required this.currentPlayer,
    required this.benchPlayers,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Swap ${currentPlayer.name}'),
      content: SizedBox(
        width: double.maxFinite,
        child: benchPlayers.isEmpty
            ? const Center(child: Text('No players on the bench'))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: benchPlayers.length,
                itemBuilder: (context, index) {
                  final player = benchPlayers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(player.number?.toString() ?? player.getInitials()),
                    ),
                    title: Text(player.name),
                    subtitle: player.mainPosition != null ? Text(player.mainPosition!.name) : null,
                    onTap: () {
                      Navigator.of(context).pop(player);
                    },
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
