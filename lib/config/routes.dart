import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/admin_login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/home_screen.dart';
import '../screens/tournament_detail_screen.dart';
import '../screens/live_scores_screen.dart';
import '../screens/match_detail_screen.dart';
import '../screens/player_stats_screen.dart';
import '../screens/leaderboard_screen.dart';
import '../screens/tournament_registration_screen.dart';
import '../screens/admin_dashboard_screen.dart';
import '../utils/constants.dart';

/// App routes configuration
class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstants.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      
      case AppConstants.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      case AppConstants.adminLoginRoute:
        return MaterialPageRoute(builder: (_) => const AdminLoginScreen());
      
      case AppConstants.signupRoute:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      
      case AppConstants.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      
      case AppConstants.tournamentDetailRoute:
        final args = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => TournamentDetailScreen(tournamentId: args ?? ''),
        );
      
      case AppConstants.liveScoresRoute:
        return MaterialPageRoute(builder: (_) => const LiveScoresScreen());
      
      case AppConstants.matchDetailRoute:
        final args = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => MatchDetailScreen(matchId: args ?? ''),
        );
      
      case AppConstants.playerStatsRoute:
        return MaterialPageRoute(builder: (_) => const PlayerStatsScreen());
      
      case AppConstants.leaderboardRoute:
        final args = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => LeaderboardScreen(tournamentId: args ?? ''),
        );
      
      case AppConstants.registrationRoute:
        final args = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => TournamentRegistrationScreen(tournamentId: args ?? ''),
        );
      
      case AppConstants.adminDashboardRoute:
        return MaterialPageRoute(builder: (_) => const AdminDashboardScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
