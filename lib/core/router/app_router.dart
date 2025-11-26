import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/rotations/presentation/pages/rotations_page.dart';
import '../../features/rotations/presentation/pages/rotation_system_selection_page.dart';
import '../../features/about/presentation/pages/about_page.dart';
import '../../features/match/presentation/pages/match_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/teams/presentation/pages/teams_list_page.dart';
import '../../features/teams/presentation/pages/team_detail_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/profile_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Keep the router alive to prevent recreation on rebuilds
  ref.keepAlive();
  
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
        builder: (context, state) => const RotationSystemSelectionPage(),
        routes: [
          GoRoute(
            path: 'court/:system',
            name: 'rotations-court',
            builder: (context, state) {
              final system = state.pathParameters['system'] ?? '4-2-no-libero';
              return RotationsPage(rotationSystem: system);
            },
          ),
        ],
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
      GoRoute(
        path: '/teams',
        name: 'teams',
        builder: (context, state) => const TeamsListPage(),
      ),
      GoRoute(
        path: '/teams/:teamId',
        name: 'team-detail',
        builder: (context, state) {
          final teamId = state.pathParameters['teamId']!;
          return TeamDetailPage(teamId: teamId);
        },
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
});

