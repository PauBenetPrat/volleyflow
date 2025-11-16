import 'package:flutter/material.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  int _teamAScore = 0;
  int _teamBScore = 0;
  int _setNumber = 1;
  int _teamASets = 0;
  int _teamBSets = 0;
  bool _isMatchActive = false;

  void _startMatch() {
    setState(() {
      _isMatchActive = true;
      _teamAScore = 0;
      _teamBScore = 0;
      _setNumber = 1;
      _teamASets = 0;
      _teamBSets = 0;
    });
  }

  void _resetMatch() {
    setState(() {
      _isMatchActive = false;
      _teamAScore = 0;
      _teamBScore = 0;
      _setNumber = 1;
      _teamASets = 0;
      _teamBSets = 0;
    });
  }

  void _incrementScore(bool isTeamA) {
    if (!_isMatchActive) return;

    setState(() {
      if (isTeamA) {
        _teamAScore++;
      } else {
        _teamBScore++;
      }

      // Check if set is won (first to 25, win by 2, or 15 in 5th set)
      final winningScore = _setNumber == 5 ? 15 : 25;
      final scoreDiff = (isTeamA ? _teamAScore : _teamBScore) - 
                        (isTeamA ? _teamBScore : _teamAScore);

      if ((isTeamA ? _teamAScore : _teamBScore) >= winningScore && scoreDiff >= 2) {
        // Set won
        if (isTeamA) {
          _teamASets++;
        } else {
          _teamBSets++;
        }

        // Check if match is won (best of 5 sets)
        if (_teamASets >= 3 || _teamBSets >= 3) {
          _showMatchWinnerDialog(isTeamA ? 'Team A' : 'Team B');
        } else {
          // Start next set
          _setNumber++;
          _teamAScore = 0;
          _teamBScore = 0;
        }
      }
    });
  }

  void _decrementScore(bool isTeamA) {
    if (!_isMatchActive) return;

    setState(() {
      if (isTeamA && _teamAScore > 0) {
        _teamAScore--;
      } else if (!isTeamA && _teamBScore > 0) {
        _teamBScore--;
      }
    });
  }

  void _showMatchWinnerDialog(String winner) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Match Won!'),
        content: Text('$winner wins the match!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetMatch();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Control'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Match status
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        _isMatchActive ? 'Match in Progress' : 'Match Not Started',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _isMatchActive 
                              ? theme.colorScheme.primary 
                              : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Set $_setNumber',
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Score display
              Row(
                children: [
                  // Team A
                  Expanded(
                    child: Card(
                      color: theme.colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Text(
                              'Team A',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '$_teamAScore',
                              style: theme.textTheme.displayLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sets: $_teamASets',
                              style: theme.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Team B
                  Expanded(
                    child: Card(
                      color: theme.colorScheme.secondaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Text(
                              'Team B',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '$_teamBScore',
                              style: theme.textTheme.displayLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSecondaryContainer,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sets: $_teamBSets',
                              style: theme.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Score controls
              if (_isMatchActive) ...[
                Row(
                  children: [
                    // Team A controls (left side)
                    Expanded(
                      child: Column(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => _incrementScore(true),
                            icon: const Icon(Icons.add),
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Text('Team A'),
                            ),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => _decrementScore(true),
                            icon: const Icon(Icons.remove),
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Text('Team A'),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Team B controls (right side)
                    Expanded(
                      child: Column(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => _incrementScore(false),
                            icon: const Icon(Icons.add),
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Text('Team B'),
                            ),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => _decrementScore(false),
                            icon: const Icon(Icons.remove),
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Text('Team B'),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],

              const Spacer(),

              // Match controls
              if (!_isMatchActive)
                ElevatedButton.icon(
                  onPressed: _startMatch,
                  icon: const Icon(Icons.play_arrow),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('Start Match'),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                  ),
                )
              else
                OutlinedButton.icon(
                  onPressed: _resetMatch,
                  icon: const Icon(Icons.stop),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('Reset Match'),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

