import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:volleyball_coaching_app/l10n/app_localizations.dart';
import '../../domain/providers/rotation_provider.dart';
import '../widgets/team_selection_dialog.dart';
import '../../../teams/domain/models/team.dart';
import '../../../teams/domain/providers/teams_provider.dart';

class RotationSystemSelectionPage extends ConsumerWidget {
  const RotationSystemSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    // Prefetch teams by watching the provider - this triggers loading when page is built
    ref.watch(teamsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.rotations),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.selectRotationSystem,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _RotationSystemCard(
                        title: l10n.rotationSystem51,
                        description: l10n.rotationSystem51Description,
                        icon: Icons.group,
                        onTap: () {
                          ref.read(rotationProvider.notifier).setRotationSystem('5-1');
                          context.push('/rotations/court/5-1');
                        },
                      ),
                      const SizedBox(height: 16),
                      _RotationSystemCard(
                        title: l10n.rotationSystem51NoLibero,
                        description: l10n.rotationSystem51NoLiberoDescription,
                        icon: Icons.people,
                        onTap: () {
                          // Navigate with rotation system as parameter
                          context.push('/rotations/court/5-1-no-libero');
                        },
                      ),
                      const SizedBox(height: 16),
                      _RotationSystemCard(
                        title: l10n.rotationSystemMatch,
                        description: l10n.rotationSystemMatchDescription,
                        icon: Icons.sports_volleyball,
                        onTap: () async {
                          final teamsState = ref.read(teamsProvider);
                          
                          if (teamsState.isLoading) {
                             ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Loading teams...')),
                            );
                            return;
                          }

                          final teams = teamsState.teams;

                          if (teams.isEmpty) {
                             await showDialog<Team>(
                              context: context,
                              builder: (context) => const TeamSelectionDialog(),
                            );
                          } else if (teams.length == 1) {
                            final team = teams.first;
                            if (context.mounted) {
                              context.pushNamed('rotations-players-new', extra: team);
                            }
                          } else {
                            final team = await showDialog<Team>(
                              context: context,
                              builder: (context) => const TeamSelectionDialog(),
                            );
                            if (team != null && context.mounted) {
                              context.pushNamed('rotations-players-new', extra: team);
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      _RotationSystemCard(
                        title: l10n.rotationSystemFree,
                        description: l10n.rotationSystemFreeDescription,
                        icon: Icons.edit_location_alt,
                        onTap: () async {
                          final teamsState = ref.read(teamsProvider);
                          
                          if (teamsState.isLoading) {
                             ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Loading teams...')),
                            );
                            return;
                          }

                          final teams = teamsState.teams;

                          if (teams.isEmpty) {
                             await showDialog<Team>(
                              context: context,
                              builder: (context) => const TeamSelectionDialog(),
                            );
                          } else if (teams.length == 1) {
                            final team = teams.first;
                            if (context.mounted) {
                              context.pushNamed('rotations-free', extra: team);
                            }
                          } else {
                            final team = await showDialog<Team>(
                              context: context,
                              builder: (context) => const TeamSelectionDialog(),
                            );
                            if (team != null && context.mounted) {
                              context.pushNamed('rotations-free', extra: team);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RotationSystemCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _RotationSystemCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

