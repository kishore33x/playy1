/// App constants and configuration values
class AppConstants {
  // App Info
  static const String appName = 'PlayOn';
  static const String appVersion = '1.0.0';

  // Route names
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String adminLoginRoute = '/admin-login';
  static const String signupRoute = '/signup';
  static const String homeRoute = '/home';
  static const String tournamentDetailRoute = '/tournament-detail';
  static const String liveScoresRoute = '/live-scores';
  static const String matchDetailRoute = '/match-detail';
  static const String playerStatsRoute = '/player-stats';
  static const String leaderboardRoute = '/leaderboard';
  static const String registrationRoute = '/registration';
  static const String adminDashboardRoute = '/admin-dashboard';

  // Sports types
  static const List<String> sports = [
    'Football',
    'Cricket',
    'Basketball',
    'Volleyball'
  ];

  // User roles
  static const String adminRole = 'admin';
  static const String userRole = 'user';

  // Match statuses
  static const String matchStatusScheduled = 'scheduled';
  static const String matchStatusOngoing = 'ongoing';
  static const String matchStatusCompleted = 'completed';

  // Tournament statuses
  static const String tournamentStatusUpcoming = 'upcoming';
  static const String tournamentStatusOngoing = 'ongoing';
  static const String tournamentStatusCompleted = 'completed';

  // Registration statuses
  static const String registrationStatusPending = 'pending';
  static const String registrationStatusApproved = 'approved';
  static const String registrationStatusRejected = 'rejected';

  // Durations
  static const Duration splashDelay = Duration(seconds: 2);
  static const Duration animationDuration = Duration(milliseconds: 300);
}
