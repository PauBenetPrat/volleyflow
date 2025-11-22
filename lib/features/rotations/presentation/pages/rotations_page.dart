import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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
    // Use orientation for more reliable detection, especially for square screens
    final isPortrait = mediaQuery.orientation == Orientation.portrait;

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

    // Left side panel (phases centered vertically)
    // In small horizontal screens, include rotation indicator at top
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          phaseButtons,
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
        child: _RotateButton(
          currentRotation: currentRotation,
          isSmallScreen: isSmallScreen,
          isVerySmallScreen: isVerySmallScreen,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: PopupMenuButton<String>(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '4-2 (no libero)',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
            ],
          ),
          color: theme.colorScheme.surface,
          onSelected: (String value) {
            if (value == '4-2' || value == '5-1' || value == 'Players') {
              final displayName = value == '4-2' ? '4-2' : value;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$displayName feature coming soon!'),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
            // '4-2-no-libero' és el mode actual, no fa res
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: '4-2',
              child: Text('4-2'),
            ),
            const PopupMenuItem<String>(
              value: '4-2-no-libero',
              child: Text('4-2 (no libero)'),
            ),
            const PopupMenuItem<String>(
              value: '5-1',
              child: Text('5-1'),
            ),
            const PopupMenuItem<String>(
              value: 'Players',
              child: Text('Players'),
            ),
          ],
        ),
        actions: [
          // Drawing mode toggle
          IconButton(
            icon: Icon(
              rotationState.isDrawingMode
                  ? Icons.edit
                  : Icons.edit_outlined,
            ),
            tooltip: rotationState.isDrawingMode
                ? 'Desactivar mode dibuix'
                : 'Activar mode dibuix',
            onPressed: () {
              ref.read(rotationProvider.notifier).toggleDrawingMode();
            },
            color: rotationState.isDrawingMode
                ? theme.colorScheme.primary
                : null,
          ),
          // Undo last drawing button (only visible when there are drawings)
          if (rotationState.drawings.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.undo),
              tooltip: 'Desfer últim traç',
              onPressed: () {
                ref.read(rotationProvider.notifier).undoLastDrawing();
              },
            ),
          // Clear all drawings button (only visible when there are drawings)
          if (rotationState.drawings.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Esborrar tots els dibuixos',
              onPressed: () {
                ref.read(rotationProvider.notifier).clearDrawings();
              },
            ),
          // Copy coordinates button (only in debug mode)
          if (kDebugMode)
            IconButton(
              icon: Icon(Icons.copy),
              onPressed: () {
                final json = ref.read(rotationProvider.notifier).getAllCoordinatesJson();
                Clipboard.setData(ClipboardData(text: json));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Coordenades copiades al portapapers!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              tooltip: 'Copiar coordenades al portapapers',
            ),
          // Reset button
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              ref.read(rotationProvider.notifier).reset();
            },
            tooltip: 'Reset',
          ),
        ],
      ),
      body: SafeArea(
        child: isSmallScreen
            ? Stack(
                children: [
                  isPortrait
                      ? Column(
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
                            // Phase buttons between court and control buttons (portrait)
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: isSmallScreen ? 8.0 : 12.0,
                                horizontal: isSmallScreen ? 8.0 : 16.0,
                              ),
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
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              ref.read(rotationProvider.notifier).setPhase(Phase.base);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                vertical: isVerySmallScreen ? 8.0 : 12.0,
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
                                                fontSize: isVerySmallScreen ? 11 : 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: isVerySmallScreen ? 4 : 8),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              ref.read(rotationProvider.notifier).setPhase(Phase.sac);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                vertical: isVerySmallScreen ? 8.0 : 12.0,
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
                                                fontSize: isVerySmallScreen ? 11 : 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: isVerySmallScreen ? 4 : 8),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              ref.read(rotationProvider.notifier).setPhase(Phase.recepcio);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                vertical: isVerySmallScreen ? 8.0 : 12.0,
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
                                                fontSize: isVerySmallScreen ? 11 : 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: isVerySmallScreen ? 4 : 8),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              ref.read(rotationProvider.notifier).setPhase(Phase.defensa);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                vertical: isVerySmallScreen ? 8.0 : 12.0,
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
                                                fontSize: isVerySmallScreen ? 11 : 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Control Buttons
                            controlButtons,
                          ],
                        )
                      : Row(
                          children: [
                            // Left side - Phase buttons
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
                                ],
                              ),
                            ),
                            // Right side - Control buttons (vertical stack)
                            Container(
                              width: isVerySmallScreen ? 80 : 100,
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
                                    offset: const Offset(-2, 0),
                                  ),
                                ],
                              ),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: _RotateButton(
                                    currentRotation: currentRotation,
                                    isSmallScreen: isSmallScreen,
                                    isVerySmallScreen: isVerySmallScreen,
                                    isCircular: true,
                                  ),
                                ),
                              ),
                            ),
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
                                  Expanded(
                                    child: Text(
                                      'Falta de rotació',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: isSmallScreen ? 12 : 14,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close, color: Colors.white, size: isSmallScreen ? 18 : 20),
                                    onPressed: () {
                                      ref.read(rotationProvider.notifier).clearValidation();
                                    },
                                    tooltip: 'Tancar',
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
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
                  isPortrait
                      ? Row(
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
                        )
                      : Row(
                          children: [
                            // Left side - Phase buttons
                            leftPanel,
                            // Right side - Court
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
                                ],
                              ),
                            ),
                            // Right side - Control buttons (vertical stack)
                            Container(
                              width: 120,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 8.0,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: const Offset(-2, 0),
                                  ),
                                ],
                              ),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: _RotateButton(
                                    currentRotation: currentRotation,
                                    isSmallScreen: isSmallScreen,
                                    isVerySmallScreen: isVerySmallScreen,
                                    isCircular: true,
                                  ),
                                ),
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
                              Row(
                                children: [
                                  const Icon(Icons.error_outline, color: Colors.white, size: 20),
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    child: Text(
                                      'Falta de rotació',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.white, size: 20),
                                    onPressed: () {
                                      ref.read(rotationProvider.notifier).clearValidation();
                                    },
                                    tooltip: 'Tancar',
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
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

// Widget reutilitzable per al botó de rotació
class _RotateButton extends ConsumerWidget {
  final int currentRotation;
  final bool isSmallScreen;
  final bool isVerySmallScreen;
  final bool isCircular;

  const _RotateButton({
    required this.currentRotation,
    required this.isSmallScreen,
    required this.isVerySmallScreen,
    this.isCircular = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onDoubleTap: () {
        ref.read(rotationProvider.notifier).rotateCounterClockwise();
      },
      child: Tooltip(
        message: 'Clic: rotar endavant | Doble clic: rotar endarrere',
        child: isCircular
            ? _buildCircularButton(theme)
            : _buildRectangularButton(theme),
      ),
    );
  }

  Widget _buildCircularButton(ThemeData theme) {
    final size = isSmallScreen ? (isVerySmallScreen ? 56.0 : 64.0) : 72.0;
    
    return Consumer(
      builder: (context, ref, child) {
        return Material(
          elevation: 4,
          shape: const CircleBorder(),
          color: theme.colorScheme.primary,
          child: InkWell(
            onTap: () {
              ref.read(rotationProvider.notifier).rotateClockwise();
            },
            customBorder: const CircleBorder(),
            child: Container(
              width: size,
              height: size,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.rotate_right,
                    color: theme.colorScheme.onPrimary,
                    size: isSmallScreen ? (isVerySmallScreen ? 24 : 28) : 32,
                  ),
                  SizedBox(height: isSmallScreen ? 2 : 4),
                  Text(
                    'R$currentRotation',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: isSmallScreen ? (isVerySmallScreen ? 10 : 12) : 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRectangularButton(ThemeData theme) {
    return Consumer(
      builder: (context, ref, child) {
        return OutlinedButton.icon(
          onPressed: () {
            ref.read(rotationProvider.notifier).rotateClockwise();
          },
      icon: Icon(
        Icons.rotate_right,
        size: isSmallScreen ? (isVerySmallScreen ? 18 : 20) : 24,
      ),
      label: Text(
        'R$currentRotation',
        style: TextStyle(
          fontSize: isSmallScreen ? (isVerySmallScreen ? 12 : 14) : 16,
        ),
      ),
          style: OutlinedButton.styleFrom(
            minimumSize: Size(
              double.infinity,
              isSmallScreen ? (isVerySmallScreen ? 40 : 50) : 50,
            ),
          ),
        );
      },
    );
  }
}

