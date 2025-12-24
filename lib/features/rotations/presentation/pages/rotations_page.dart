import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volleyball_coaching_app/l10n/app_localizations.dart';
import '../../../../shared/widgets/volleyball_court_widget.dart';
import '../../domain/providers/rotation_provider.dart';
import '../../../../core/constants/rotation_positions_5_1_no_libero.dart';
import '../../../../core/constants/player_roles.dart';

class RotationsPage extends ConsumerStatefulWidget {
  final String? rotationSystem;
  
  const RotationsPage({super.key, this.rotationSystem});

  @override
  ConsumerState<RotationsPage> createState() => _RotationsPageState();
}

class _RotationsPageState extends ConsumerState<RotationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirstTime();
    });
  }

  Future<void> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hasShownHelp = prefs.getBool('has_shown_rotations_help') ?? false;
    
    if (!hasShownHelp && mounted) {
      _showHelpDialog(context, AppLocalizations.of(context)!);
    }
  }

  void _showHelpDialog(BuildContext context, AppLocalizations l10n) {
    bool dontShowAgain = false;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.helpTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.helpMovePlayers),
                  const SizedBox(height: 8),
                  Text(l10n.helpPlayerInfo),
                  const SizedBox(height: 8),
                  Text(l10n.helpRotate),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: dontShowAgain,
                        onChanged: (value) {
                          setState(() {
                            dontShowAgain = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(l10n.dontShowAgain),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (dontShowAgain) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('has_shown_rotations_help', true);
                    }
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(l10n.ok),
                ),
              ],
            );
          },
        );
      },
    );
  }
  
  // Helper method to convert error messages to use new abbreviations
  static String _convertErrorToDisplayAbbreviations(String error, AppLocalizations l10n) {
    const playerRoles = ['Co', 'C1', 'C2', 'R1', 'R2', 'O'];
    String displayError = error;
    for (final role in playerRoles) {
      final displayAbbr = PlayerRole.getDisplayAbbreviation(role, l10n);
      // Reemplaçar les claus internes amb les noves abreviatures
      displayError = displayError.replaceAll(RegExp('\\b$role\\b'), displayAbbr);
    }
    return displayError;
  }



  @override
  Widget build(BuildContext context) {
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
    final systemToUse = widget.rotationSystem ?? rotationState.rotationSystem;
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


    // Phase buttons widget (toggles, no base button)
    Widget phaseButtons = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
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

    // Show PIN dialog for copying coordinates
    void _showPinDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n, ThemeData theme) {
      final pinController = TextEditingController();
      final formKey = GlobalKey<FormState>();
      const correctPin = '7536'; // PIN per copiar les coordenades
      
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text(l10n.enterPin),
            content: Form(
              key: formKey,
              child: TextFormField(
                controller: pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.pin,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pinRequired;
                  }
                  if (value != correctPin) {
                    return l10n.incorrectPin;
                  }
                  return null;
                },
                autofocus: true,
                onFieldSubmitted: (value) {
                  if (formKey.currentState!.validate()) {
                    final json = ref.read(rotationProvider.notifier).getAllCoordinatesJson();
                    Clipboard.setData(ClipboardData(text: json));
                    Navigator.of(dialogContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.coordinatesCopied),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final json = ref.read(rotationProvider.notifier).getAllCoordinatesJson();
                    Clipboard.setData(ClipboardData(text: json));
                    Navigator.of(dialogContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.coordinatesCopied),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Text(l10n.ok),
              ),
            ],
          );
        },
      );
    }

    // Show exit confirmation dialog
    void _showExitConfirmation() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(l10n.exit),
            content: Text(l10n.exitConfirmation),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/rotations');
                },
                child: Text(l10n.exit),
              ),
            ],
          );
        },
      );
    }

    // Show reset confirmation dialog
    void _showResetConfirmation() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(l10n.reset),
            content: Text(l10n.resetConfirmation),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(rotationProvider.notifier).reset();
                },
                child: Text(l10n.reset),
              ),
            ],
          );
        },
      );
    }



    // Right side panel for landscape mode (action buttons and rotation button)
    Widget rightPanelLandscape = Container(
      width: (isSmallScreen ? (isVerySmallScreen ? 80 : 100) : 120) + mediaQuery.padding.right,
      padding: EdgeInsets.only(
        top: isSmallScreen ? 12.0 : 16.0,
        bottom: isSmallScreen ? 12.0 : 16.0,
        left: isSmallScreen ? 4.0 : 8.0,
        right: (isSmallScreen ? 4.0 : 8.0) + mediaQuery.padding.right,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Action buttons at top
          Column(
            mainAxisSize: MainAxisSize.min,
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
              const SizedBox(height: 4),
              // Reset button (with confirmation)
              FloatingActionButton.small(
                heroTag: 'reset-landscape',
                elevation: 0,
                onPressed: _showResetConfirmation,
                backgroundColor: theme.colorScheme.surface,
                child: Icon(
                  Icons.refresh,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              // Help button
              FloatingActionButton.small(
                heroTag: 'help-landscape',
                elevation: 0,
                onPressed: () {
                  _showHelpDialog(context, l10n);
                },
                backgroundColor: theme.colorScheme.surface,
                child: Icon(
                  Icons.help_outline,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              // Grid toggle
              FloatingActionButton.small(
                heroTag: 'grid-landscape',
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
              const SizedBox(height: 4),
              // Drawing mode toggle
              FloatingActionButton.small(
                heroTag: 'drawing-landscape',
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
              if (rotationState.drawings.isNotEmpty) ...[
                const SizedBox(height: 4),
                FloatingActionButton.small(
                  heroTag: 'undo-landscape',
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
                const SizedBox(height: 4),
                FloatingActionButton.small(
                  heroTag: 'clear-landscape',
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
              const SizedBox(height: 4),
              // Copy coordinates button (only in debug mode)
              if (kDebugMode)
               FloatingActionButton.small(
                heroTag: 'copy-landscape',
                elevation: 0,
                onPressed: () {
                  _showPinDialog(context, ref, l10n, theme);
                },
                backgroundColor: theme.colorScheme.surface,
                child: Icon(
                  Icons.copy,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          // Rotation button at bottom
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
                                  customPositions: rotationState.customPositions,
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
                                        rotationSystem: rotationState.rotationSystem,
                                        showGrid: rotationState.showGrid,
                                        customPositions: rotationState.customPositions,
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
                                final displayError = _convertErrorToDisplayAbbreviations(error, l10n);
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
                                  customPositions: rotationState.customPositions,
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
                                        customPositions: rotationState.customPositions,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Right side - Action buttons and rotation button
                            rightPanelLandscape,
                          ],
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
          // Close button and action buttons grouped together (only in portrait mode)
          if (isPortrait)
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 8,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Action buttons in a row
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Copy coordinates button (only in debug mode)
                      if (kDebugMode)
                        FloatingActionButton.small(
                          heroTag: 'copy',
                          elevation: 0,
                          onPressed: () {
                            _showPinDialog(context, ref, l10n, theme);
                          },
                          backgroundColor: theme.colorScheme.surface,
                          child: Icon(
                            Icons.copy,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      // Clear all drawings button (only visible when there are drawings)
                      if (rotationState.drawings.isNotEmpty) ...[
                        const SizedBox(width: 4),
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
                      // Undo last drawing button (only visible when there are drawings)
                      if (rotationState.drawings.isNotEmpty) ...[
                        const SizedBox(width: 4),
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
                      const SizedBox(width: 4),
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
                      const SizedBox(width: 4),
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
                      const SizedBox(width: 4),
                      // Help button
                      FloatingActionButton.small(
                        heroTag: 'help',
                        elevation: 0,
                        onPressed: () {
                          _showHelpDialog(context, l10n);
                        },
                        backgroundColor: theme.colorScheme.surface,
                        child: Icon(
                          Icons.help_outline,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Reset button (with confirmation)
                      FloatingActionButton.small(
                        heroTag: 'reset',
                        elevation: 0,
                        onPressed: _showResetConfirmation,
                        backgroundColor: theme.colorScheme.surface,
                        child: Icon(
                          Icons.refresh,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 4),
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

  Future<void> _handleDoubleTap(BuildContext context, WidgetRef ref, AppLocalizations l10n) async {
    ref.read(rotationProvider.notifier).rotateCounterClockwise();
    
    final prefs = await SharedPreferences.getInstance();
    final hasDiscovered = prefs.getBool('has_discovered_double_tap_rotation') ?? false;
    
    if (!hasDiscovered && context.mounted) {
      await prefs.setBool('has_discovered_double_tap_rotation', true);
      
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(l10n.doubleTapDiscoveryTitle),
            content: Text(l10n.doubleTapDiscoveryMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.gotIt),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onDoubleTap: () {
        _handleDoubleTap(context, ref, l10n);
      },
      child: Tooltip(
        message: l10n.rotateTooltip,
        child: isCircular
            ? _buildCircularButton(theme, ref)
            : _buildRectangularButton(theme, ref),
      ),
    );
  }

  Widget _buildCircularButton(ThemeData theme, WidgetRef ref) {
    final iconSize = isSmallScreen ? (isVerySmallScreen ? 64.0 : 72.0) : 80.0;
    
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
  }

  Widget _buildRectangularButton(ThemeData theme, WidgetRef ref) {
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
  }
}

