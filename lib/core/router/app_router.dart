import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/rotations/presentation/pages/rotations_page.dart';
import '../../features/about/presentation/pages/about_page.dart';
import '../../features/match/presentation/pages/match_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/rotations',
        name: 'rotations',
        builder: (context, state) => const RotationsPage(),
      ),
      GoRoute(
        path: '/match',
        name: 'match',
        builder: (context, state) => const MatchPage(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/about',
        name: 'about',
        builder: (context, state) => const AboutPage(),
      ),
    ],
  );
});

