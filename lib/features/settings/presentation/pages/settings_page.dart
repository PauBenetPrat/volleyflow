import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volleyball_coaching_app/core/providers/locale_provider.dart';
import 'package:volleyball_coaching_app/l10n/app_localizations.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);
    
    // Llista d'idiomes disponibles amb els seus noms
    final languages = [
      {'locale': const Locale('en', ''), 'name': 'English'},
      {'locale': const Locale('ca', ''), 'name': 'Català'},
      {'locale': const Locale('es', ''), 'name': 'Español'},
      {'locale': const Locale('eu', ''), 'name': 'Euskera'},
      {'locale': const Locale('fr', ''), 'name': 'Français'},
      {'locale': const Locale('de', ''), 'name': 'Deutsch'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Language Selection Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.language,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...languages.map((lang) {
                      final locale = lang['locale'] as Locale;
                      final isSelected = currentLocale?.languageCode == locale.languageCode;
                      return RadioListTile<Locale>(
                        title: Text(lang['name'] as String),
                        value: locale,
                        groupValue: currentLocale,
                        onChanged: (Locale? value) {
                          if (value != null) {
                            ref.read(localeProvider.notifier).setLocale(value);
                          }
                        },
                        secondary: isSelected
                            ? Icon(
                                Icons.check_circle,
                                color: theme.colorScheme.primary,
                              )
                            : null,
                      );
                    }).toList(),
                    // System default option
                    RadioListTile<Locale?>(
                      title: Text(l10n.systemDefault),
                      value: null,
                      groupValue: currentLocale,
                      onChanged: (Locale? value) {
                        ref.read(localeProvider.notifier).clearLocale();
                      },
                      secondary: currentLocale == null
                          ? Icon(
                              Icons.check_circle,
                              color: theme.colorScheme.primary,
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

