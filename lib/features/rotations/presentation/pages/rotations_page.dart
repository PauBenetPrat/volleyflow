import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:volleyball_coaching_app/l10n/app_localizations.dart';
import '../../../../shared/widgets/volleyball_court_widget.dart';
import '../../domain/providers/rotation_provider.dart';
import '../../../../core/constants/rotation_positions_4_2_no_libero.dart';
import '../../../../core/constants/player_roles.dart';

class RotationsPage extends ConsumerWidget {
  final String? rotationSystem;
  
  const RotationsPage({super.key, this.rotationSystem});
  
  // Helper method to convert error messages to use new abbreviations
  static String _convertErrorToDisplayAbbreviations(String error) {
    const playerRoles = ['Co', 'C1', 'C2', 'R1', 'R2', 'O'];
    String displayError = error;
    for (final role in playerRoles) {
      final displayAbbr = PlayerRole.getDisplayAbbreviation(role);
      // Reemplaçar les claus internes amb les noves abreviatures
      displayError = displayError.replaceAll(RegExp('\\b$role\\b'), displayAbbr);
    }
    return displayError;
  }

  // Show dialog to select rotation system
  void _showRotationSystemDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n, ThemeData theme) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must select a system
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Rotation System'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(l10n.rotationSystem42NoLibero),
                  onTap: () {
                    ref.read(rotationProvider.notifier).setRotationSystem('4-2-no-libero');
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text(l10n.rotationSystem42),
                  onTap: () {
                    ref.read(rotationProvider.notifier).setRotationSystem('4-2');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.featureComingSoon(l10n.rotationSystem42)),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text(l10n.rotationSystem51),
                  onTap: () {
                    ref.read(rotationProvider.notifier).setRotationSystem('5-1');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.featureComingSoon(l10n.rotationSystem51)),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text(l10n.rotationSystemPlayers),
                  onTap: () {
                    ref.read(rotationProvider.notifier).setRotationSystem('Players');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.featureComingSoon(l10n.rotationSystemPlayers)),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rotationState = ref.watch(rotationProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.width < 600;
    final isVerySmallScreen = mediaQuery.size.width < 400;
    // Use orientation for more reliable detection, especially for square screens
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    // For iPad mini and similar tablets in portrait, treat as small screen for layout
    final isTabletPortrait = isPortrait && mediaQuery.size.width >= 600 && mediaQuery.size.width < 900;

    final currentRotation = rotationState.rotation;
    final currentPhase = rotationState.phase;

    // Set rotation system from parameter or state (using Future to avoid modifying during build)
    final systemToUse = rotationSystem ?? rotationState.rotationSystem;
    if (systemToUse != null && rotationState.rotationSystem != systemToUse) {
      Future.microtask(() {
        if (context.mounted) {
          ref.read(rotationProvider.notifier).setRotationSystem(systemToUse);
        }
      });
    }
    
    // Ensure rotation system is selected (should be set from selection page or parameter)
    if (rotationState.rotationSystem == null && systemToUse == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // If somehow we got here without a system, go back to selection
        if (context.mounted) {
          context.go('/rotations');
        }
      });
      // Return empty container while redirecting
      return const Scaffold(body: SizedBox.shrink());
    }
    
    // If system is being set, show loading or wait for it
    if (systemToUse != null && rotationState.rotationSystem != systemToUse) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }


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
              l10n.base,
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
              l10n.sac,
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
              l10n.recepcio,
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
              l10n.defensa,
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

    // Left side panel (phases buttons for landscape mode)
    Widget leftPanel = Container(
      width: isSmallScreen ? (isVerySmallScreen ? 80 : 100) : 120,
      padding: EdgeInsets.symmetric(
        vertical: isSmallScreen ? 12.0 : 16.0,
        horizontal: isSmallScreen ? 4.0 : 8.0,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          phaseButtons,
        ],
      ),
    );

    // Right side panel (phases and rotation button aligned vertically) - for portrait mode
    Widget rightPanel = Container(
      width: isSmallScreen ? (isVerySmallScreen ? 80 : 100) : 120,
      padding: EdgeInsets.symmetric(
        vertical: isSmallScreen ? 12.0 : 16.0,
        horizontal: isSmallScreen ? 4.0 : 8.0,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          phaseButtons,
          const SizedBox(height: 16),
          _RotateButton(
            currentRotation: currentRotation,
            isSmallScreen: isSmallScreen,
            isVerySmallScreen: isVerySmallScreen,
            isCircular: true,
          ),
        ],
      ),
    );

    // Control buttons
    Widget controlButtons = Container(
      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
      ),
      child: SafeArea(
        child: _RotateButton(
          currentRotation: currentRotation,
          isSmallScreen: isSmallScreen,
          isVerySmallScreen: isVerySmallScreen,
        ),
      ),
    );

    // Get display name for current rotation system
    String getRotationSystemDisplayName() {
      switch (rotationState.rotationSystem) {
        case '4-2':
          return l10n.rotationSystem42;
        case '4-2-no-libero':
          return l10n.rotationSystem42NoLibero;
        case '5-1':
          return l10n.rotationSystem51;
        case 'Players':
          return l10n.rotationSystemPlayers;
        default:
          return l10n.rotationTitle;
      }
    }

    // Show exit confirmation dialog
    void _showExitConfirmation() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sortir'),
            content: const Text('Estàs segur que vols sortir?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel·lar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/');
                },
                child: const Text('Sortir'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Main content with SafeArea
          SafeArea(
            child: (isSmallScreen || isTabletPortrait)
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
                                  rotationSystem: rotationState.rotationSystem,
                                  validationResult: rotationState.validationResult,
                                  showGrid: rotationState.showGrid,
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
                                              l10n.base,
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
                                              l10n.sac,
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
                                              l10n.recepcio,
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
                                              l10n.defensa,
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
                            // Center - Court
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
                                      l10n.rotationValidationError,
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
                                    tooltip: l10n.close,
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              ...rotationState.validationResult!.errors.map((error) {
                                // Convertir les claus internes a les noves abreviatures
                                final displayError = _convertErrorToDisplayAbbreviations(error);
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    '• $displayError',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isSmallScreen ? 11 : 12,
                                    ),
                                  ),
                                );
                              }),
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
                      ? Column(
                          children: [
                            // Court Display
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: VolleyballCourtWidget(
                                  playerPositions: rotationState.positions,
                                  rotation: rotationState.rotation,
                                  phase: rotationState.phase,
                                  rotationSystem: rotationState.rotationSystem,
                                  validationResult: rotationState.validationResult,
                                  showGrid: rotationState.showGrid,
                                ),
                              ),
                            ),
                            // Phase buttons between court and control buttons (portrait)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 16.0,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                              ),
                              child: SafeArea(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          ref.read(rotationProvider.notifier).setPhase(Phase.base);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                                          backgroundColor: currentPhase == Phase.base
                                              ? theme.colorScheme.primary
                                              : null,
                                        ),
                                        child: Text(
                                          l10n.base,
                                          style: TextStyle(
                                            color: currentPhase == Phase.base
                                                ? Colors.white
                                                : null,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          ref.read(rotationProvider.notifier).setPhase(Phase.sac);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                                          backgroundColor: currentPhase == Phase.sac
                                              ? theme.colorScheme.primary
                                              : null,
                                        ),
                                        child: Text(
                                          l10n.sac,
                                          style: TextStyle(
                                            color: currentPhase == Phase.sac
                                                ? Colors.white
                                                : null,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          ref.read(rotationProvider.notifier).setPhase(Phase.recepcio);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                                          backgroundColor: currentPhase == Phase.recepcio
                                              ? theme.colorScheme.primary
                                              : null,
                                        ),
                                        child: Text(
                                          l10n.recepcio,
                                          style: TextStyle(
                                            color: currentPhase == Phase.recepcio
                                                ? Colors.white
                                                : null,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          ref.read(rotationProvider.notifier).setPhase(Phase.defensa);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                                          backgroundColor: currentPhase == Phase.defensa
                                              ? theme.colorScheme.primary
                                              : null,
                                        ),
                                        child: Text(
                                          l10n.defensa,
                                          style: TextStyle(
                                            color: currentPhase == Phase.defensa
                                                ? Colors.white
                                                : null,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
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
                            // Center - Court
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
                                        rotationSystem: rotationState.rotationSystem,
                                        validationResult: rotationState.validationResult,
                                        showGrid: rotationState.showGrid,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                  // Rotation button at bottom right (landscape mode only)
                  if (!isPortrait)
                    Positioned(
                      bottom: MediaQuery.of(context).padding.bottom + 16,
                      right: 16,
                      child: _RotateButton(
                        currentRotation: currentRotation,
                        isSmallScreen: isSmallScreen,
                        isVerySmallScreen: isVerySmallScreen,
                        isCircular: true,
                      ),
                    ),
                  // Validation errors overlay (no afecta les dimensions)
                  if (rotationState.validationResult != null && 
                      !rotationState.validationResult!.isValid)
                    Positioned(
                      bottom: 100,
                      left: isPortrait 
                          ? (isSmallScreen ? (isVerySmallScreen ? 80 : 100) : 120) + 16
                          : (isSmallScreen ? (isVerySmallScreen ? 80 : 100) : 120) + 16,
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
                                  Expanded(
                                    child: Text(
                                      l10n.rotationValidationError,
                                      style: const TextStyle(
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
                                    tooltip: l10n.close,
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
          // Close button and action buttons grouped together
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 8,
            child: isPortrait
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Action buttons in a row
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Grid toggle
                          FloatingActionButton.small(
                            heroTag: 'grid',
                            elevation: 0,
                            onPressed: () {
                              ref.read(rotationProvider.notifier).toggleGrid();
                            },
                            backgroundColor: rotationState.showGrid
                                ? theme.colorScheme.primary
                                : theme.colorScheme.surface,
                            child: Icon(
                              rotationState.showGrid
                                  ? Icons.grid_on
                                  : Icons.grid_off,
                              color: rotationState.showGrid
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Drawing mode toggle
                          FloatingActionButton.small(
                            heroTag: 'drawing',
                            elevation: 0,
                            onPressed: () {
                              ref.read(rotationProvider.notifier).toggleDrawingMode();
                            },
                            backgroundColor: rotationState.isDrawingMode
                                ? theme.colorScheme.primary
                                : theme.colorScheme.surface,
                            child: Icon(
                              rotationState.isDrawingMode
                                  ? Icons.edit
                                  : Icons.edit_outlined,
                              color: rotationState.isDrawingMode
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                          // Undo last drawing button (only visible when there are drawings)
                          if (rotationState.drawings.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            FloatingActionButton.small(
                              heroTag: 'undo',
                              elevation: 0,
                              onPressed: () {
                                ref.read(rotationProvider.notifier).undoLastDrawing();
                              },
                              backgroundColor: theme.colorScheme.surface,
                              child: Icon(
                                Icons.undo,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                          // Clear all drawings button (only visible when there are drawings)
                          if (rotationState.drawings.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            FloatingActionButton.small(
                              heroTag: 'clear',
                              elevation: 0,
                              onPressed: () {
                                ref.read(rotationProvider.notifier).clearDrawings();
                              },
                              backgroundColor: theme.colorScheme.surface,
                              child: Icon(
                                Icons.delete_outline,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                          // Copy coordinates button (only in debug mode)
                          if (kDebugMode) ...[
                            const SizedBox(width: 8),
                            FloatingActionButton.small(
                              heroTag: 'copy',
                              elevation: 0,
                              onPressed: () {
                                final json = ref.read(rotationProvider.notifier).getAllCoordinatesJson();
                                Clipboard.setData(ClipboardData(text: json));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.coordinatesCopied),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              backgroundColor: theme.colorScheme.surface,
                              child: Icon(
                                Icons.copy,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                          // Reset button
                          const SizedBox(width: 8),
                          FloatingActionButton.small(
                            heroTag: 'reset',
                            elevation: 0,
                            onPressed: () {
                              ref.read(rotationProvider.notifier).reset();
                            },
                            backgroundColor: theme.colorScheme.surface,
                            child: Icon(
                              Icons.refresh,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      // Close button (X)
                      Material(
                        elevation: 0,
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _showExitConfirmation,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: theme.colorScheme.onSurface,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Close button (X)
                      Material(
                        elevation: 0,
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _showExitConfirmation,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: theme.colorScheme.onSurface,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Grid toggle
                      FloatingActionButton.small(
                        heroTag: 'grid',
                        elevation: 0,
                        onPressed: () {
                          ref.read(rotationProvider.notifier).toggleGrid();
                        },
                        backgroundColor: rotationState.showGrid
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surface,
                        child: Icon(
                          rotationState.showGrid
                              ? Icons.grid_on
                              : Icons.grid_off,
                          color: rotationState.showGrid
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Drawing mode toggle
                      FloatingActionButton.small(
                        heroTag: 'drawing',
                        elevation: 0,
                        onPressed: () {
                          ref.read(rotationProvider.notifier).toggleDrawingMode();
                        },
                        backgroundColor: rotationState.isDrawingMode
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surface,
                        child: Icon(
                          rotationState.isDrawingMode
                              ? Icons.edit
                              : Icons.edit_outlined,
                          color: rotationState.isDrawingMode
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      // Undo last drawing button (only visible when there are drawings)
                      if (rotationState.drawings.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        FloatingActionButton.small(
                          heroTag: 'undo',
                          elevation: 0,
                          onPressed: () {
                            ref.read(rotationProvider.notifier).undoLastDrawing();
                          },
                          backgroundColor: theme.colorScheme.surface,
                          child: Icon(
                            Icons.undo,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                      // Clear all drawings button (only visible when there are drawings)
                      if (rotationState.drawings.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        FloatingActionButton.small(
                          heroTag: 'clear',
                          elevation: 0,
                          onPressed: () {
                            ref.read(rotationProvider.notifier).clearDrawings();
                          },
                          backgroundColor: theme.colorScheme.surface,
                          child: Icon(
                            Icons.delete_outline,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                      // Copy coordinates button (only in debug mode)
                      if (kDebugMode) ...[
                        const SizedBox(height: 8),
                        FloatingActionButton.small(
                          heroTag: 'copy',
                          elevation: 0,
                          onPressed: () {
                            final json = ref.read(rotationProvider.notifier).getAllCoordinatesJson();
                            Clipboard.setData(ClipboardData(text: json));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.coordinatesCopied),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          backgroundColor: theme.colorScheme.surface,
                          child: Icon(
                            Icons.copy,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                      // Reset button
                      const SizedBox(height: 8),
                      FloatingActionButton.small(
                        heroTag: 'reset',
                        elevation: 0,
                        onPressed: () {
                          ref.read(rotationProvider.notifier).reset();
                        },
                        backgroundColor: theme.colorScheme.surface,
                        child: Icon(
                          Icons.refresh,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
          ),
          ],
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
    final l10n = AppLocalizations.of(context)!;
    
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onDoubleTap: () {
        ref.read(rotationProvider.notifier).rotateCounterClockwise();
      },
      child: Tooltip(
        message: l10n.rotateTooltip,
        child: isCircular
            ? _buildCircularButton(theme)
            : _buildRectangularButton(theme),
      ),
    );
  }

  Widget _buildCircularButton(ThemeData theme) {
    final iconSize = isSmallScreen ? (isVerySmallScreen ? 64.0 : 72.0) : 80.0;
    
    return Consumer(
      builder: (context, ref, child) {
        return GestureDetector(
          onTap: () {
            ref.read(rotationProvider.notifier).rotateClockwise();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.rotate_right,
                size: iconSize,
                color: theme.colorScheme.primary,
              ),
              Text(
                'R$currentRotation',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: isSmallScreen ? (isVerySmallScreen ? 14 : 16) : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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

