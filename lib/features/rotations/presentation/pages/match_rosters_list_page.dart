import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volleyball_coaching_app/l10n/app_localizations.dart';
import '../../../teams/domain/models/team.dart';
import '../../../teams/domain/models/match_roster.dart';
import '../../../teams/domain/providers/teams_provider.dart';
import '../../../teams/domain/providers/match_rosters_provider.dart';
import '../../../teams/presentation/pages/match_roster_page.dart';
import 'full_court_rotations_page.dart';

class MatchRostersListPage extends ConsumerWidget {
  const MatchRostersListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final rostersState = ref.watch(matchRostersProvider);
    final teamsState = ref.watch(teamsProvider);

    // Sort rosters by date (most recent first)
    final rosters = [...rostersState.rosters]
      ..sort((a, b) {
        if (a.matchDate == null && b.matchDate == null) return 0;
        if (a.matchDate == null) return 1;
        if (b.matchDate == null) return -1;
        return b.matchDate!.compareTo(a.matchDate!);
      });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.matchRosters),
      ),
      body: rostersState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : rosters.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sports_volleyball,
                        size: 64,
                        color: theme.colorScheme.primary.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noMatchRostersYet,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.createFirstMatchRoster,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: rosters.length,
                  itemBuilder: (context, index) {
                    final roster = rosters[index];
                    final team = teamsState.teams.firstWhere(
                      (t) => t.id == roster.teamId,
                      orElse: () => Team(id: roster.teamId, name: 'Unknown Team'),
                    );

                    return _MatchRosterCard(
                      roster: roster,
                      team: team,
                      onTap: () => _startMatch(context, roster, team),
                      onEdit: () => _editRoster(context, roster, team),
                      onDelete: () => _deleteRoster(context, ref, roster, l10n),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createNewRoster(context, teamsState.teams),
        icon: const Icon(Icons.add),
        label: Text(l10n.newMatchRoster),
      ),
    );
  }

  void _createNewRoster(BuildContext context, List<Team> teams) {
    if (teams.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.noTeamsFound)),
      );
      return;
    }

    if (teams.length == 1) {
      // Go directly to match roster page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MatchRosterPage(team: teams.first, saveRoster: true),
        ),
      );
    } else {
      // Show team selection dialog
      showDialog(
        context: context,
        builder: (context) => _TeamSelectionDialog(
          teams: teams,
          onTeamSelected: (team) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MatchRosterPage(team: team, saveRoster: true),
              ),
            );
          },
        ),
      );
    }
  }

  void _editRoster(BuildContext context, MatchRoster roster, Team team) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MatchRosterPage(
          team: team,
          existingRoster: roster,
          saveRoster: true,
        ),
      ),
    );
  }

  void _startMatch(BuildContext context, MatchRoster roster, Team team) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullCourtRotationsPage(
          team: team,
          matchRoster: roster,
        ),
      ),
    );
  }

  void _deleteRoster(BuildContext context, WidgetRef ref, MatchRoster roster, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteMatchRoster),
        content: Text(l10n.deleteMatchRosterConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              ref.read(matchRostersProvider.notifier).deleteRoster(roster.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}

class _MatchRosterCard extends StatelessWidget {
  final MatchRoster roster;
  final Team team;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MatchRosterCard({
    required this.roster,
    required this.team,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${team.name} vs ${roster.rivalName}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (roster.matchDate != null)
                          Text(
                            '${roster.matchDate!.day}/${roster.matchDate!.month}/${roster.matchDate!.year}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: onEdit,
                        child: Row(
                          children: [
                            const Icon(Icons.edit, size: 20),
                            const SizedBox(width: 8),
                            Text(l10n.edit),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: onDelete,
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: theme.colorScheme.error),
                            const SizedBox(width: 8),
                            Text(l10n.delete, style: TextStyle(color: theme.colorScheme.error)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.people, size: 16, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                  const SizedBox(width: 4),
                  Text(
                    roster.playerIds != null && roster.playerIds!.isNotEmpty
                        ? '${roster.playerIds!.length} ${l10n.players.toLowerCase()}'
                        : 'No players selected',
                    style: theme.textTheme.bodySmall,
                  ),
                  if (roster.location != null) ...[
                    const SizedBox(width: 16),
                    Icon(Icons.location_on, size: 16, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        roster.location!,
                        style: theme.textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeamSelectionDialog extends StatelessWidget {
  final List<Team> teams;
  final Function(Team) onTeamSelected;

  const _TeamSelectionDialog({
    required this.teams,
    required this.onTeamSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.selectTeam),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: teams.length,
          itemBuilder: (context, index) {
            final team = teams[index];
            return ListTile(
              leading: const Icon(Icons.group),
              title: Text(team.name),
              subtitle: Text('${team.players.length} ${l10n.players.toLowerCase()}'),
              onTap: () => onTeamSelected(team),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }
}
