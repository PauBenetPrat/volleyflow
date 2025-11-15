import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/volleyball_court_widget.dart';
import '../../domain/providers/rotation_provider.dart';
import '../../../../core/constants/rotation_positions.dart';

class RotationsPage extends ConsumerWidget {
  const RotationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rotationState = ref.watch(rotationProvider);
    final theme = Theme.of(context);

    final currentRotation = rotationState.rotation;
    final currentPhase = rotationState.phase;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rotations'),
      ),
      body: SafeArea(
        child: Row(
          children: [
            // Left side buttons
            Container(
              width: 120,
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(2, 0),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Rotation Indicator
                  Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.only(bottom: 24.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primary,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'R$currentRotation',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Action buttons
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              ref.read(rotationProvider.notifier).setPhase(Phase.base);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              backgroundColor: currentPhase == Phase.base
                                  ? theme.colorScheme.primary
                                  : null,
                            ),
                            child: Text(
                              'BASE',
                              style: TextStyle(
                                color: currentPhase == Phase.base
                                    ? Colors.white
                                    : null,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              ref.read(rotationProvider.notifier).setPhase(Phase.sac);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              backgroundColor: currentPhase == Phase.sac
                                  ? theme.colorScheme.primary
                                  : null,
                            ),
                            child: Text(
                              'SAC',
                              style: TextStyle(
                                color: currentPhase == Phase.sac
                                    ? Colors.white
                                    : null,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              ref.read(rotationProvider.notifier).setPhase(Phase.recepcio);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              backgroundColor: currentPhase == Phase.recepcio
                                  ? theme.colorScheme.primary
                                  : null,
                            ),
                            child: Text(
                              'RECEPCIO',
                              style: TextStyle(
                                color: currentPhase == Phase.recepcio
                                    ? Colors.white
                                    : null,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              ref.read(rotationProvider.notifier).setPhase(Phase.defensa);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              backgroundColor: currentPhase == Phase.defensa
                                  ? theme.colorScheme.primary
                                  : null,
                            ),
                            child: Text(
                              'DEFENSA',
                              style: TextStyle(
                                color: currentPhase == Phase.defensa
                                    ? Colors.white
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Right side - Court and controls
            Expanded(
              child: Column(
                children: [
                  // Court Display
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: VolleyballCourtWidget(
                        playerPositions: rotationState.positions,
                      ),
                    ),
                  ),
                  
                  // Control Buttons
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                ref.read(rotationProvider.notifier).rotateClockwise();
                              },
                              icon: const Icon(Icons.rotate_right),
                              label: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: Text('Rotate'),
                              ),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                ref.read(rotationProvider.notifier).reset();
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: Text('Reset'),
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

