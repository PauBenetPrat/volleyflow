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
    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.width < 600;
    final isVerySmallScreen = mediaQuery.size.width < 400;

    final currentRotation = rotationState.rotation;
    final currentPhase = rotationState.phase;

    // Phase buttons widget
    Widget phaseButtons = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              ref.read(rotationProvider.notifier).setPhase(Phase.base);
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: isSmallScreen ? 12.0 : 16.0,
              ),
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
                fontSize: isSmallScreen ? 12 : 14,
              ),
            ),
          ),
        ),
        SizedBox(height: isSmallScreen ? 8 : 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              ref.read(rotationProvider.notifier).setPhase(Phase.sac);
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: isSmallScreen ? 12.0 : 16.0,
              ),
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
                fontSize: isSmallScreen ? 12 : 14,
              ),
            ),
          ),
        ),
        SizedBox(height: isSmallScreen ? 8 : 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              ref.read(rotationProvider.notifier).setPhase(Phase.recepcio);
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: isSmallScreen ? 12.0 : 16.0,
              ),
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
                fontSize: isSmallScreen ? 12 : 14,
              ),
            ),
          ),
        ),
        SizedBox(height: isSmallScreen ? 8 : 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              ref.read(rotationProvider.notifier).setPhase(Phase.defensa);
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: isSmallScreen ? 12.0 : 16.0,
              ),
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
                fontSize: isSmallScreen ? 12 : 14,
              ),
            ),
          ),
        ),
      ],
    );

    // Rotation indicator
    Widget rotationIndicator = Container(
      width: isSmallScreen ? 50 : 60,
      height: isSmallScreen ? 50 : 60,
      margin: EdgeInsets.only(bottom: isSmallScreen ? 16.0 : 24.0),
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
            fontSize: isSmallScreen ? 16 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    // Left side panel
    Widget leftPanel = Container(
      width: isSmallScreen ? (isVerySmallScreen ? 80 : 100) : 120,
      padding: EdgeInsets.symmetric(
        vertical: isSmallScreen ? 12.0 : 16.0,
        horizontal: isSmallScreen ? 4.0 : 8.0,
      ),
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
          rotationIndicator,
          Expanded(child: phaseButtons),
        ],
      ),
    );

    // Control buttons
    Widget controlButtons = Container(
      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
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
        child: isSmallScreen
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ref.read(rotationProvider.notifier).rotateCounterClockwise();
                          },
                          icon: Icon(Icons.rotate_left, size: isVerySmallScreen ? 18 : 20),
                          label: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: isVerySmallScreen ? 8.0 : 12.0,
                            ),
                            child: Text(
                              'Back',
                              style: TextStyle(fontSize: isVerySmallScreen ? 12 : 14),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.infinity, isVerySmallScreen ? 40 : 50),
                          ),
                        ),
                      ),
                      SizedBox(width: isVerySmallScreen ? 8 : 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ref.read(rotationProvider.notifier).rotateClockwise();
                          },
                          icon: Icon(Icons.rotate_right, size: isVerySmallScreen ? 18 : 20),
                          label: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: isVerySmallScreen ? 8.0 : 12.0,
                            ),
                            child: Text(
                              'Rotate',
                              style: TextStyle(fontSize: isVerySmallScreen ? 12 : 14),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.infinity, isVerySmallScreen ? 40 : 50),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isVerySmallScreen ? 8 : 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ref.read(rotationProvider.notifier).reset();
                      },
                      icon: Icon(Icons.refresh, size: isVerySmallScreen ? 18 : 20),
                      label: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: isVerySmallScreen ? 8.0 : 12.0,
                        ),
                        child: Text(
                          'Reset',
                          style: TextStyle(fontSize: isVerySmallScreen ? 12 : 14),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, isVerySmallScreen ? 40 : 50),
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ref.read(rotationProvider.notifier).rotateCounterClockwise();
                      },
                      icon: const Icon(Icons.rotate_left),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text('Back'),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
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
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rotations'),
      ),
      body: SafeArea(
        child: isSmallScreen
            ? Stack(
                children: [
                  Column(
                    children: [
                      // Court Display
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(isSmallScreen ? 8.0 : 16.0),
                          child: VolleyballCourtWidget(
                            playerPositions: rotationState.positions,
                            rotation: rotationState.rotation,
                            phase: rotationState.phase,
                            validationResult: rotationState.validationResult,
                          ),
                        ),
                      ),
                      // Control Buttons
                      controlButtons,
                    ],
                  ),
                  // Validation errors overlay (no afecta les dimensions)
                  if (rotationState.validationResult != null && 
                      !rotationState.validationResult!.isValid)
                    Positioned(
                      bottom: isSmallScreen ? 80 : 100,
                      left: isSmallScreen ? 8.0 : 16.0,
                      right: isSmallScreen ? 8.0 : 16.0,
                      child: Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: EdgeInsets.all(isSmallScreen ? 8.0 : 12.0),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red, width: 2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.error_outline, color: Colors.white, size: isSmallScreen ? 18 : 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Falta de rotació',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: isSmallScreen ? 12 : 14,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              ...rotationState.validationResult!.errors.map((error) => Padding(
                                padding: EdgeInsets.only(bottom: 4),
                                child: Text(
                                  '• $error',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isSmallScreen ? 11 : 12,
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              )
            : Stack(
                children: [
                  Row(
                    children: [
                      // Left side buttons
                      leftPanel,
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
                                  rotation: rotationState.rotation,
                                  phase: rotationState.phase,
                                  validationResult: rotationState.validationResult,
                                ),
                              ),
                            ),
                            // Control Buttons
                            controlButtons,
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Validation errors overlay (no afecta les dimensions)
                  if (rotationState.validationResult != null && 
                      !rotationState.validationResult!.isValid)
                    Positioned(
                      bottom: 100,
                      left: (isSmallScreen ? (isVerySmallScreen ? 80 : 100) : 120) + 16,
                      right: 16,
                      child: Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red, width: 2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.error_outline, color: Colors.white, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Falta de rotació',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ...rotationState.validationResult!.errors.map((error) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  '• $error',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

