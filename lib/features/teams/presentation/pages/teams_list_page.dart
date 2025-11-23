import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:volleyball_coaching_app/l10n/app_localizations.dart';
import '../../domain/providers/teams_provider.dart';
import '../../domain/models/team.dart';
import 'team_detail_page.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamsListPage extends ConsumerWidget {
  const TeamsListPage({super.key});

  void _showPremiumDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.premiumFeature),
          content: Text(l10n.premiumFeatureMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () async {
                final email = 'pau.benet.prat@gmail.com';
                final uri = Uri.parse('mailto:$email?subject=${Uri.encodeComponent(l10n.premiumFeatureRequest)}');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(l10n.contactUs),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteTeamConfirmation(BuildContext context, WidgetRef ref, Team team, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.deleteTeam),
          content: Text(
            l10n.deleteTeamConfirmation(team.name),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                ref.read(teamsProvider.notifier).deleteTeam(team.id);
                Navigator.of(context).pop();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.teamDeleted),
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final teamsState = ref.watch(teamsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.teams),
      ),
      body: teamsState.teams.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.group,
                    size: 80,
                    color: theme.colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.noTeamsYet,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.createYourFirstTeam,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: teamsState.teams.length,
              itemBuilder: (context, index) {
                final team = teamsState.teams[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primary,
                      child: Text(
                        team.getInitials(),
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(team.name),
                    subtitle: Text(
                      l10n.teamInfo(
                        team.players.length,
                        team.coaches.length,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: theme.colorScheme.error,
                          onPressed: () => _showDeleteTeamConfirmation(context, ref, team, l10n),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () {
                      context.push('/teams/${team.id}');
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (teamsState.canCreateTeam()) {
            final newTeam = Team(
              id: const Uuid().v4(),
              name: l10n.newTeam,
            );
            ref.read(teamsProvider.notifier).addTeam(newTeam);
            context.push('/teams/${newTeam.id}');
          } else {
            _showPremiumDialog(context, l10n);
          }
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.createTeam),
      ),
    );
  }
}

