import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:volleyball_coaching_app/l10n/app_localizations.dart';
import '../../domain/providers/teams_provider.dart';
import '../../domain/models/team.dart';
import '../../domain/models/player.dart';
import '../../domain/models/coach.dart';
import '../../domain/models/player_position.dart';
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamDetailPage extends ConsumerStatefulWidget {
  final String teamId;

  const TeamDetailPage({
    super.key,
    required this.teamId,
  });

  @override
  ConsumerState<TeamDetailPage> createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends ConsumerState<TeamDetailPage> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final teamsState = ref.read(teamsProvider);
      final team = teamsState.teams.firstWhere(
        (t) => t.id == widget.teamId,
        orElse: () => Team(
          id: widget.teamId,
          name: '',
        ),
      );
      _nameController.text = team.name;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveTeam() {
    // Restrict editing for now
    _showPremiumDialog(context, AppLocalizations.of(context)!);
  }

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final teamsState = ref.watch(teamsProvider);
    final team = teamsState.teams.firstWhere(
      (t) => t.id == widget.teamId,
      orElse: () => Team(id: widget.teamId, name: _nameController.text),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.teamDetails),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveTeam,
            tooltip: l10n.save,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            color: theme.colorScheme.error,
            onPressed: () => _showPremiumDialog(context, l10n),
            tooltip: l10n.deleteTeam,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Team name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.teamName,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.group),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.teamNameRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            
            // Coaches section
            _SectionHeader(
              title: l10n.coaches,
              subtitle: '${team.coaches.length}/2',
              onAdd: () => _showPremiumDialog(context, l10n),
            ),
            const SizedBox(height: 8),
            if (team.coaches.isEmpty)
              _EmptyState(
                icon: Icons.person_outline,
                message: l10n.noCoachesYet,
              )
            else
              ...team.coaches.map((coach) => _CoachCard(
                    coach: coach,
                    team: team,
                    onEdit: () => _showPremiumDialog(context, l10n),
                    onDelete: () => _showPremiumDialog(context, l10n),
                  )),
            const SizedBox(height: 24),
            
            // Players section
            _SectionHeader(
              title: l10n.players,
              subtitle: '${team.players.length}/18',
              onAdd: () => _showPremiumDialog(context, l10n),
            ),
            const SizedBox(height: 8),
            if (team.players.isEmpty)
              _EmptyState(
                icon: Icons.people_outline,
                message: l10n.noPlayersYet,
              )
            else
              ...team.players.map((player) => _PlayerCard(
                    player: player,
                    team: team,
                    onEdit: () => _showPremiumDialog(context, l10n),
                    onDelete: () => _showPremiumDialog(context, l10n),
                  )),
          ],
        ),
      ),
    );
  }

  void _showAddPlayerDialog(BuildContext context, Team team) {
    showDialog(
      context: context,
      builder: (context) => _PlayerEditDialog(
        team: team,
        player: null,
      ),
    );
  }

  void _showAddCoachDialog(BuildContext context, Team team) {
    showDialog(
      context: context,
      builder: (context) => _CoachEditDialog(
        team: team,
        coach: null,
      ),
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
                  context.pop(); // Tornar a la llista d'equips
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
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onAdd;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        if (onAdd != null)
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: onAdd,
            tooltip: 'Add',
          ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyState({
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerCard extends ConsumerWidget {
  final Player player;
  final Team team;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PlayerCard({
    required this.player,
    required this.team,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary,
          child: Text(
            player.getInitials(),
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                player.alias ?? player.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (player.isCaptain)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'C',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (player.alias != null) Text(player.name),
            if (player.gender != null)
              Text('${l10n.gender}: ${player.gender == PlayerGender.male ? l10n.male : l10n.female}'),
            if (player.number != null) Text('${l10n.number}: ${player.number}'),
            if (player.age != null) Text('${l10n.age}: ${player.age}'),
            if (player.height != null)
              Text('${l10n.height}: ${player.height!.toStringAsFixed(0)} cm'),
            if (player.mainPosition != null)
              Text(
                '${l10n.position}: ${player.mainPosition!.getDisplayName(locale)}',
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: theme.colorScheme.error,
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _CoachCard extends ConsumerWidget {
  final Coach coach;
  final Team team;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CoachCard({
    required this.coach,
    required this.team,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.secondary,
          child: Text(
            coach.getInitials(),
            style: TextStyle(
              color: theme.colorScheme.onSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(child: Text(coach.name)),
            if (coach.isPrimary)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  l10n.primary,
                  style: TextStyle(
                    color: theme.colorScheme.onSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Text(
          coach.isPrimary ? l10n.primaryCoach : l10n.secondaryCoach,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: theme.colorScheme.error,
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerEditDialog extends ConsumerStatefulWidget {
  final Team team;
  final Player? player;

  const _PlayerEditDialog({
    required this.team,
    this.player,
  });

  @override
  ConsumerState<_PlayerEditDialog> createState() => _PlayerEditDialogState();
}

class _PlayerEditDialogState extends ConsumerState<_PlayerEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _aliasController;
  late final TextEditingController _numberController;
  late final TextEditingController _ageController;
  late final TextEditingController _heightController;
  PlayerPosition? _selectedPosition;
  bool _isCaptain = false;
  PlayerGender? _selectedGender;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.player?.name ?? '');
    _aliasController = TextEditingController(text: widget.player?.alias ?? '');
    _numberController = TextEditingController(
      text: widget.player?.number?.toString() ?? '',
    );
    _ageController = TextEditingController(
      text: widget.player?.age?.toString() ?? '',
    );
    _heightController = TextEditingController(
      text: widget.player?.height?.toStringAsFixed(0) ?? '',
    );
    _selectedPosition = widget.player?.mainPosition;
    _isCaptain = widget.player?.isCaptain ?? false;
    _selectedGender = widget.player?.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aliasController.dispose();
    _numberController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final player = Player(
        id: widget.player?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        alias: _aliasController.text.trim().isEmpty
            ? null
            : _aliasController.text.trim(),
        number: _numberController.text.trim().isEmpty
            ? null
            : int.tryParse(_numberController.text.trim()),
        age: _ageController.text.trim().isEmpty
            ? null
            : int.tryParse(_ageController.text.trim()),
        height: _heightController.text.trim().isEmpty
            ? null
            : double.tryParse(_heightController.text.trim()),
        mainPosition: _selectedPosition,
        isCaptain: _isCaptain,
        gender: _selectedGender,
      );

      if (widget.player == null) {
        ref.read(teamsProvider.notifier).addPlayerToTeam(widget.team.id, player);
      } else {
        ref.read(teamsProvider.notifier).updatePlayerInTeam(widget.team.id, player);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    return AlertDialog(
      title: Text(widget.player == null ? l10n.addPlayer : l10n.editPlayer),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.playerName,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.playerNameRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _aliasController,
                decoration: InputDecoration(
                  labelText: l10n.alias,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _numberController,
                      decoration: InputDecoration(
                        labelText: l10n.number,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      decoration: InputDecoration(
                        labelText: l10n.age,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(
                  labelText: l10n.height,
                  border: const OutlineInputBorder(),
                  suffixText: 'cm',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<PlayerGender>(
                value: _selectedGender,
                decoration: InputDecoration(
                  labelText: l10n.gender,
                  border: const OutlineInputBorder(),
                ),
                items: PlayerGender.values.map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender == PlayerGender.male ? l10n.male : l10n.female),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<PlayerPosition>(
                value: _selectedPosition,
                decoration: InputDecoration(
                  labelText: l10n.mainPosition,
                  border: const OutlineInputBorder(),
                ),
                items: PlayerPosition.values.map((position) {
                  return DropdownMenuItem(
                    value: position,
                    child: Text(position.getDisplayName(locale)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPosition = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: Text(l10n.captain),
                value: _isCaptain,
                onChanged: (value) {
                  setState(() {
                    _isCaptain = value ?? false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: _save,
          child: Text(l10n.save),
        ),
      ],
    );
  }
}

class _CoachEditDialog extends ConsumerStatefulWidget {
  final Team team;
  final Coach? coach;

  const _CoachEditDialog({
    required this.team,
    this.coach,
  });

  @override
  ConsumerState<_CoachEditDialog> createState() => _CoachEditDialogState();
}

class _CoachEditDialogState extends ConsumerState<_CoachEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  bool _isPrimary = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.coach?.name ?? '');
    _isPrimary = widget.coach?.isPrimary ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final coach = Coach(
        id: widget.coach?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        isPrimary: _isPrimary,
      );

      if (widget.coach == null) {
        ref.read(teamsProvider.notifier).addCoachToTeam(widget.team.id, coach);
      } else {
        ref.read(teamsProvider.notifier).updateCoachInTeam(widget.team.id, coach);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(widget.coach == null ? l10n.addCoach : l10n.editCoach),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.coachName,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.coachNameRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: Text(l10n.primary),
              value: _isPrimary,
              onChanged: (value) {
                setState(() {
                  _isPrimary = value ?? false;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: _save,
          child: Text(l10n.save),
        ),
      ],
    );
  }
}

