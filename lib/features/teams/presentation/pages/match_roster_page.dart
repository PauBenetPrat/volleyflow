import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../teams/domain/models/team.dart';
import '../../../teams/domain/models/player.dart';
import '../../../teams/domain/models/match_roster.dart';
import '../../../teams/domain/models/player_position.dart';
import '../../../teams/domain/providers/match_rosters_provider.dart';
import '../../../rotations/presentation/pages/full_court_rotations_page.dart';
import 'package:volleyball_coaching_app/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

class MatchRosterPage extends ConsumerStatefulWidget {
  final Team team;
  final bool saveRoster;
  final MatchRoster? existingRoster;

  const MatchRosterPage({
    super.key,
    required this.team,
    this.saveRoster = false,
    this.existingRoster,
  });

  @override
  ConsumerState<MatchRosterPage> createState() => _MatchRosterPageState();
}

class _MatchRosterPageState extends ConsumerState<MatchRosterPage> {
  final Set<String> _selectedPlayerIds = {};
  DateTime? _matchDate;
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _rivalNameController = TextEditingController();
  
  static const int _maxPlayers = 14;
  static const int _minPlayers = 6;

  @override
  void initState() {
    super.initState();
    if (widget.existingRoster != null) {
      if (widget.existingRoster!.playerIds != null) {
        _selectedPlayerIds.addAll(widget.existingRoster!.playerIds!);
      }
      _matchDate = widget.existingRoster!.matchDate;
      _locationController.text = widget.existingRoster!.location ?? '';
      _rivalNameController.text = widget.existingRoster!.rivalName;
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _rivalNameController.dispose();
    super.dispose();
  }

  void _togglePlayer(String playerId) {
    setState(() {
      if (_selectedPlayerIds.contains(playerId)) {
        _selectedPlayerIds.remove(playerId);
      } else {
        if (_selectedPlayerIds.length < _maxPlayers) {
          _selectedPlayerIds.add(playerId);
        }
      }
    });
  }

  void _toggleAllPlayers(bool? value) {
    setState(() {
      if (value == true) {
        // Select all (up to max)
        for (final player in widget.team.players) {
          if (_selectedPlayerIds.length < _maxPlayers) {
            _selectedPlayerIds.add(player.id);
          }
        }
      } else {
        // Deselect all
        _selectedPlayerIds.clear();
      }
    });
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _matchDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        _matchDate = picked;
      });
    }
  }

  void _startMatch() async {
    final l10n = AppLocalizations.of(context)!;
    
    // Validate required fields
    if (_rivalNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.rivalTeam} is required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_matchDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.matchDate} is required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final roster = MatchRoster(
      id: widget.existingRoster?.id ?? const Uuid().v4(),
      teamId: widget.team.id,
      rivalName: _rivalNameController.text.trim(),
      matchDate: _matchDate!,
      playerIds: _selectedPlayerIds.isEmpty ? null : _selectedPlayerIds.toList(),
      location: _locationController.text.isEmpty ? null : _locationController.text.trim(),
      createdAt: widget.existingRoster?.createdAt ?? DateTime.now(),
    );

    // Save or update roster if requested
    if (widget.saveRoster) {
      try {
        if (widget.existingRoster != null) {
          await ref.read(matchRostersProvider.notifier).updateRoster(roster);
        } else {
          await ref.read(matchRostersProvider.notifier).addRoster(roster);
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.existingRoster != null 
                  ? 'Match roster updated'
                  : 'Match roster created'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Go back to list
          return;
        }
      } catch (e) {
        print('Error saving roster: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving roster: ${e.toString()}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
        return;
      }
    }

    // Start match immediately (from team detail page flow)
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullCourtRotationsPage(
            team: widget.team,
            matchRoster: roster,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final hasRivalName = _rivalNameController.text.trim().isNotEmpty;
    final hasMatchDate = _matchDate != null;
    final canSave = hasRivalName && hasMatchDate; // Need rival name and match date
    final canStartMatch = hasRivalName && hasMatchDate && _selectedPlayerIds.length >= _minPlayers; // Need players to start match
    final allSelected = _selectedPlayerIds.length == widget.team.players.length || 
                        _selectedPlayerIds.length == _maxPlayers;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingRoster != null ? l10n.editMatchRoster : l10n.createMatchRoster),
        actions: [
          TextButton.icon(
            onPressed: widget.saveRoster ? (canSave ? _startMatch : null) : (canStartMatch ? _startMatch : null),
            icon: Icon(widget.saveRoster ? Icons.save : Icons.sports_volleyball),
            label: Text(widget.saveRoster ? l10n.save : l10n.startMatch),
            style: TextButton.styleFrom(
              foregroundColor: (widget.saveRoster ? canSave : canStartMatch) ? Colors.white : Colors.white54,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Match Details (moved to top as most important)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Match Details',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    
                    // Rival Name (Required)
                    TextField(
                      controller: _rivalNameController,
                      decoration: InputDecoration(
                        labelText: '${l10n.rivalTeam} *',
                        hintText: 'e.g., CV Barcelona',
                        prefixIcon: const Icon(Icons.shield),
                        border: const OutlineInputBorder(),
                        errorText: _rivalNameController.text.isEmpty && hasRivalName == false 
                            ? 'Required'
                            : null,
                      ),
                      maxLength: 50,
                      onChanged: (_) => setState(() {}), // Trigger rebuild for validation
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Date Picker (Required)
                    InkWell(
                      onTap: _selectDate,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _matchDate == null && !hasMatchDate
                                ? Colors.red
                                : Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${l10n.matchDate} *',
                                    style: TextStyle(
                                      color: _matchDate == null && !hasMatchDate
                                          ? Colors.red
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _matchDate != null
                                        ? '${_matchDate!.day}/${_matchDate!.month}/${_matchDate!.year}'
                                        : 'Select date',
                                    style: TextStyle(
                                      color: _matchDate == null
                                          ? Colors.grey
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_matchDate != null)
                              IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () => setState(() => _matchDate = null),
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (_matchDate == null && !hasMatchDate)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 16),
                        child: Text(
                          'Required',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    
                    const Divider(),
                    
                    // Location Field (Optional)
                    TextField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: '${l10n.location} (Optional)',
                        hintText: 'e.g., Sports Center Arena',
                        prefixIcon: const Icon(Icons.location_on),
                        border: const OutlineInputBorder(),
                      ),
                      maxLength: 100,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Player Selection Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            l10n.selectPlayers,
                            style: theme.textTheme.titleLarge,
                          ),
                        ),
                        Chip(
                          label: Text(
                            '${_selectedPlayerIds.length} / $_maxPlayers',
                            style: TextStyle(
                              color: _selectedPlayerIds.length >= _minPlayers
                                  ? Colors.green
                                  : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: _selectedPlayerIds.length >= _minPlayers
                              ? Colors.green.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                        ),
                      ],
                    ),
                    const Divider(),
                    CheckboxListTile(
                      title: Text(l10n.selectAll),
                      value: allSelected,
                      onChanged: _toggleAllPlayers,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            if (!widget.saveRoster && _selectedPlayerIds.length < _minPlayers)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Select at least $_minPlayers players to start match',
                  style: TextStyle(
                    color: Colors.orange.shade700,
                    fontSize: 12,
                  ),
                ),
              ),
            
            if (widget.saveRoster && _selectedPlayerIds.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Players can be added later (optional)',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

            // Player List
            ...widget.team.players.map((player) {
              final isSelected = _selectedPlayerIds.contains(player.id);
              final canSelect = _selectedPlayerIds.length < _maxPlayers || isSelected;
              final positionName = player.mainPosition?.getDisplayName(locale) ?? '-';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: CheckboxListTile(
                  value: isSelected,
                  onChanged: canSelect
                      ? (value) => _togglePlayer(player.id)
                      : null,
                  title: Text('${player.number}. ${player.name}'),
                  subtitle: Text(positionName),
                  secondary: CircleAvatar(
                    backgroundColor: isSelected ? theme.colorScheme.primary : Colors.grey.shade300,
                    foregroundColor: isSelected ? theme.colorScheme.onPrimary : Colors.grey.shade700,
                    child: Text(player.getInitials()),
                  ),
                  enabled: canSelect,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
