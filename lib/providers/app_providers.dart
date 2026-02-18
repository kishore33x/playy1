import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

// ==================== SERVICE PROVIDERS ====================

/// Firebase Auth Service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Firestore Service provider
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// ==================== AUTHENTICATION PROVIDERS ====================

/// Current Firebase user stream provider
final firebaseUserProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

/// Current authenticated user ID
final currentUserIdProvider = Provider<String?>((ref) {
  final user = ref.watch(firebaseUserProvider);
  return user.when(
    data: (user) => user?.uid,
    loading: () => null,
    error: (err, stack) => null,
  );
});

/// Current authenticated user email
final currentUserEmailProvider = Provider<String?>((ref) {
  final user = ref.watch(firebaseUserProvider);
  return user.when(
    data: (user) => user?.email,
    loading: () => null,
    error: (err, stack) => null,
  );
});

/// Check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(firebaseUserProvider);
  return user.when(
    data: (user) => user != null,
    loading: () => false,
    error: (err, stack) => false,
  );
});

// ==================== USER PROFILE PROVIDER ====================

/// Current user profile provider
final currentUserProfileProvider = StreamProvider((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  final userId = ref.watch(currentUserIdProvider);
  
  if (userId == null) {
    return Stream.value(null);
  }
  
  return firestoreService.getUserProfileStream(userId);
});

// ==================== TOURNAMENT PROVIDERS ====================

/// All tournaments provider
final allTournamentsProvider = StreamProvider((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getTournamentsStream();
});

/// Ongoing tournaments provider
final ongoingTournamentsProvider = StreamProvider((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getOngoingTournamentsStream();
});

/// Upcoming tournaments provider
final upcomingTournamentsProvider = StreamProvider((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getUpcomingTournamentsStream();
});

/// Single tournament provider
final tournamentProvider = FutureProvider.family((ref, String tournamentId) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getTournament(tournamentId);
});

// ==================== TEAM PROVIDERS ====================

/// All teams provider
final allTeamsProvider = StreamProvider((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getTeamsStream();
});

/// Single team provider
final teamProvider = FutureProvider.family((ref, String teamId) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getTeam(teamId);
});

// ==================== PLAYER PROVIDERS ====================

/// Players by team provider
final playersByTeamProvider =
    StreamProvider.family<List<dynamic>, String>((ref, String teamId) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getPlayersByTeamStream(teamId);
});

/// Single player provider
final playerProvider = FutureProvider.family((ref, String playerId) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getPlayer(playerId);
});

// ==================== MATCH PROVIDERS ====================

/// Matches by tournament provider
final matchesByTournamentProvider =
    StreamProvider.family<List<dynamic>, String>((ref, String tournamentId) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getMatchesByTournamentStream(tournamentId);
});

/// Single match provider
final matchProvider = StreamProvider.family((ref, String matchId) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getMatchStream(matchId);
});

/// Ongoing matches provider
final ongoingMatchesProvider = StreamProvider((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getOngoingMatchesStream();
});

// ==================== HELPER PROVIDERS ====================

/// Auth service notifier for sign in/sign up/sign out
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  final authService = ref.watch(authServiceProvider);
  final firestoreService = ref.watch(firestoreServiceProvider);
  return AuthNotifier(authService, firestoreService);
});

/// Auth Notifier for managing auth operations
class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthService authService;
  final FirestoreService firestoreService;

  AuthNotifier(this.authService, this.firestoreService)
      : super(const AsyncValue.data(null));

  /// Sign up user
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = await authService.signUp(
        email: email,
        password: password,
        name: name,
        role: role,
      );
      
      if (user != null) {
        await firestoreService.saveUserProfile(user);
      }
    });
  }

  /// Sign in user
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await authService.signIn(
        email: email,
        password: password,
      );
    });
  }

  /// Sign out user
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await authService.signOut();
    });
  }
}
