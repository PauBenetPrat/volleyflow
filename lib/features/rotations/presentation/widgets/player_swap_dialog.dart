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
    final isPlaceholder = currentPlayer.name == '?';
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(isPlaceholder ? 'Select Player' : 'Swap ${currentPlayer.name}'),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    dense: true, // Make list items more compact
                    leading: CircleAvatar(
                      radius: 16, // Smaller avatar
                      child: Text(
                        player.number?.toString() ?? player.getInitials(),
                        style: const TextStyle(fontSize: 12),
                      ),
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
      // Actions removed to save vertical space
    );
  }
}
