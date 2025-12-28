import 'package:flutter/material.dart';
import 'package:volleyball_coaching_app/features/match/domain/models/match_configuration.dart';
import 'package:volleyball_coaching_app/l10n/app_localizations.dart';

class MatchSettingsDialog extends StatefulWidget {
  final MatchConfiguration currentConfig;

  const MatchSettingsDialog({
    super.key,
    required this.currentConfig,
  });

  @override
  State<MatchSettingsDialog> createState() => _MatchSettingsDialogState();
}

class _MatchSettingsDialogState extends State<MatchSettingsDialog> {
  late int _maxPoints;
  late int _lastSetMaxPoints;
  late int _totalSets;
  late bool _winByTwo;

  @override
  void initState() {
    super.initState();
    _maxPoints = widget.currentConfig.maxPoints;
    _lastSetMaxPoints = widget.currentConfig.lastSetMaxPoints;
    _totalSets = widget.currentConfig.totalSets;
    _winByTwo = widget.currentConfig.winByTwo;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.matchSettings),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Max Points
            Text(
              l10n.maxPoints,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  onPressed: _maxPoints > 15
                      ? () => setState(() => _maxPoints--)
                      : null,
                  icon: const Icon(Icons.remove),
                ),
                Expanded(
                  child: Text(
                    '$_maxPoints',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: _maxPoints < 50
                      ? () => setState(() => _maxPoints++)
                      : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Last Set Max Points
            Text(
              l10n.lastSetMaxPoints,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  onPressed: _lastSetMaxPoints > 10
                      ? () => setState(() => _lastSetMaxPoints--)
                      : null,
                  icon: const Icon(Icons.remove),
                ),
                Expanded(
                  child: Text(
                    '$_lastSetMaxPoints',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: _lastSetMaxPoints < 30
                      ? () => setState(() => _lastSetMaxPoints++)
                      : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Total Sets
            Text(
              l10n.totalSets,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [1, 3, 5, 7].map((sets) {
                return ChoiceChip(
                  label: Text('$sets'),
                  selected: _totalSets == sets,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _totalSets = sets);
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Win by Two
            SwitchListTile(
              title: Text(l10n.winByTwo),
              value: _winByTwo,
              onChanged: (value) => setState(() => _winByTwo = value),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            final newConfig = MatchConfiguration(
              maxPoints: _maxPoints,
              lastSetMaxPoints: _lastSetMaxPoints,
              totalSets: _totalSets,
              winByTwo: _winByTwo,
            );
            Navigator.of(context).pop(newConfig);
          },
          child: Text(l10n.saveSettings),
        ),
      ],
    );
  }
}
