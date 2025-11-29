import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:volleyball_coaching_app/l10n/app_localizations.dart';
import '../../../teams/domain/providers/teams_provider.dart';
import '../../../teams/domain/models/team.dart';

class TeamSelectionDialog extends ConsumerWidget {
  const TeamSelectionDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final teamsState = ref.watch(teamsProvider);

    return AlertDialog(
      title: Text(l10n.selectTeam),
      content: SizedBox(
        width: double.maxFinite,
        child: teamsState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Builder(
                builder: (context) {
                  final teams = teamsState.teams;
                  if (teams.isEmpty) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(l10n.noTeamsFound),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            context.go('/teams'); 
                          },
                          child: Text(l10n.createTeam),
                        ),
                      ],
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: teams.length,
                    itemBuilder: (context, index) {
                      final team = teams[index];
                      return ListTile(
                        title: Text(team.name),
                        subtitle: Text(l10n.teamInfo(team.players.length, team.coaches.length)),
                        onTap: () {
                          Navigator.of(context).pop(team);
                        },
                      );
                    },
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }
}
