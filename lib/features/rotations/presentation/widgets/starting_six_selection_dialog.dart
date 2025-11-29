import 'package:flutter/material.dart';
import '../../../teams/domain/models/team.dart';
import '../../../teams/domain/models/player.dart';

class StartingSixSelectionDialog extends StatefulWidget {
  final Team team;

  const StartingSixSelectionDialog({
    super.key,
    required this.team,
  });

  @override
  State<StartingSixSelectionDialog> createState() => _StartingSixSelectionDialogState();
}

class _StartingSixSelectionDialogState extends State<StartingSixSelectionDialog> {
  final Set<String> _selectedPlayerIds = {};

  @override
  void initState() {
    super.initState();
    // Pre-select first 6 players
    for (var i = 0; i < widget.team.players.length && i < 6; i++) {
      _selectedPlayerIds.add(widget.team.players[i].id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Starting 6'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Selected: ${_selectedPlayerIds.length}/6',
              style: TextStyle(
                color: _selectedPlayerIds.length == 6 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.team.players.length,
                itemBuilder: (context, index) {
                  final player = widget.team.players[index];
                  final isSelected = _selectedPlayerIds.contains(player.id);
                  return CheckboxListTile(
                    title: Text('${player.name} #${player.number ?? ""}'),
                    subtitle: player.mainPosition != null ? Text(player.mainPosition!.name) : null,
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          if (_selectedPlayerIds.length < 6) {
                            _selectedPlayerIds.add(player.id);
                          }
                        } else {
                          _selectedPlayerIds.remove(player.id);
                        }
                      });
                    },
                    enabled: isSelected || _selectedPlayerIds.length < 6,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _selectedPlayerIds.length == 6
              ? () {
                  final selectedPlayers = widget.team.players
                      .where((p) => _selectedPlayerIds.contains(p.id))
                      .toList();
                  Navigator.of(context).pop(selectedPlayers);
                }
              : null,
          child: const Text('Start'),
        ),
      ],
    );
  }
}
