import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:volleyball_coaching_app/l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.volleyballCoachingApp),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
              // App Icon/Logo placeholder
              Icon(
                Icons.sports_volleyball,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 32),
              
              // Title
              Text(
                l10n.welcome,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.welcomeSubtitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              
              // Menu Buttons
              _MenuButton(
                icon: Icons.rotate_right,
                label: l10n.rotations,
                onPressed: () => context.push('/rotations'),
              ),
              const SizedBox(height: 16),
              _MenuButton(
                icon: Icons.gavel,
                label: l10n.refereeMatch,
                onPressed: () => context.push('/match'),
              ),
              const SizedBox(height: 16),
              _MenuButton(
                icon: Icons.settings,
                label: l10n.settings,
                onPressed: () => context.push('/settings'),
              ),
              const SizedBox(height: 16),
              _MenuButton(
                icon: Icons.info_outline,
                label: l10n.about,
                onPressed: () => context.push('/about'),
              ),
            ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 60),
      ),
    );
  }
}

