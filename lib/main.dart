import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volleyball_coaching_app/l10n/app_localizations.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/locale_provider.dart';

void main() {
  runApp(
    const ProviderScope(
      child: VolleyballCoachingApp(),
    ),
  );
}

class VolleyballCoachingApp extends ConsumerWidget {
  const VolleyballCoachingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);
    
    return MaterialApp.router(
      title: 'VolleyFlow',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      locale: locale, // Usa l'idioma seleccionat o null per usar el del sistema
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('ca', ''), // Català
        Locale('es', ''), // Español
        Locale('eu', ''), // Euskera
        Locale('fr', ''), // Français
        Locale('de', ''), // Deutsch
      ],
    );
  }
}

