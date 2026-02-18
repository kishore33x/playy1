import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../models/tournament.dart';
import '../models/team.dart';
import '../models/match.dart';
import '../models/player.dart';
import '../models/registration.dart';

/// Service for handling Firestore database operations.
class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // ==================== USER OPERATIONS ====================

  /// Save user profile to Firestore
  Future<void> saveUserProfile(User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toMap());
    } catch (e) {
      print('Error saving user profile: $e');
      rethrow;
    }
  }

  /// Get user profile by UID
  Future<User?> getUserProfile(String uid) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return User.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  /// Stream of user profile updates
  Stream<User?> getUserProfileStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return User.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  // ==================== TOURNAMENT OPERATIONS ====================

  /// Create a new tournament
  Future<String> createTournament(Tournament tournament) async {
    try {
      final docRef = await _firestore
          .collection('tournaments')
          .add(tournament.toMap());
      return docRef.id;
    } catch (e) {
      print('Error creating tournament: $e');
      rethrow;
    }
  }

  /// Get tournament by ID
  Future<Tournament?> getTournament(String tournamentId) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('tournaments').doc(tournamentId).get();
      if (doc.exists) {
        return Tournament.fromMap(
            tournamentId, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting tournament: $e');
      return null;
    }
  }

  /// Get all tournaments
  Future<List<Tournament>> getAllTournaments() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firestore.collection('tournaments').get();
      return querySnapshot.docs
          .map((doc) => Tournament.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('Error getting tournaments: $e');
      return [];
    }
  }

  /// Stream of all tournaments
  Stream<List<Tournament>> getTournamentsStream() {
    return _firestore.collection('tournaments').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Tournament.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  /// Get ongoing tournaments
  Stream<List<Tournament>> getOngoingTournamentsStream() {
    final now = DateTime.now();
    return _firestore
        .collection('tournaments')
        .where('startDate', isLessThanOrEqualTo: now)
        .where('endDate', isGreaterThanOrEqualTo: now)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Tournament.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  /// Get upcoming tournaments
  Stream<List<Tournament>> getUpcomingTournamentsStream() {
    final now = DateTime.now();
    return _firestore
        .collection('tournaments')
        .where('startDate', isGreaterThan: now)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Tournament.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  /// Update tournament
  Future<void> updateTournament(String tournamentId, Tournament tournament) async {
    try {
      await _firestore
          .collection('tournaments')
          .doc(tournamentId)
          .update(tournament.toMap());
    } catch (e) {
      print('Error updating tournament: $e');
      rethrow;
    }
  }

  /// Update tournament status
  Future<void> updateTournamentStatus(
      String tournamentId, String status) async {
    try {
      await _firestore
          .collection('tournaments')
          .doc(tournamentId)
          .update({'status': status});
    } catch (e) {
      print('Error updating tournament status: $e');
      rethrow;
    }
  }

  // ==================== TEAM OPERATIONS ====================

  /// Create a new team
  Future<String> createTeam(Team team) async {
    try {
      final docRef =
          await _firestore.collection('teams').add(team.toMap());
      return docRef.id;
    } catch (e) {
      print('Error creating team: $e');
      rethrow;
    }
  }

  /// Get team by ID
  Future<Team?> getTeam(String teamId) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('teams').doc(teamId).get();
      if (doc.exists) {
        return Team.fromMap(teamId, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting team: $e');
      return null;
    }
  }

  /// Get all teams
  Future<List<Team>> getAllTeams() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firestore.collection('teams').get();
      return querySnapshot.docs
          .map((doc) => Team.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('Error getting teams: $e');
      return [];
    }
  }

  /// Stream all teams
  Stream<List<Team>> getTeamsStream() {
    return _firestore.collection('teams').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Team.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  /// Update team
  Future<void> updateTeam(String teamId, Team team) async {
    try {
      await _firestore.collection('teams').doc(teamId).update(team.toMap());
    } catch (e) {
      print('Error updating team: $e');
      rethrow;
    }
  }

  /// Update team statistics
  Future<void> updateTeamStats(
    String teamId,
    int wins,
    int losses,
    int draws,
    int points,
  ) async {
    try {
      await _firestore.collection('teams').doc(teamId).update({
        'wins': wins,
        'losses': losses,
        'draws': draws,
        'points': points,
      });
    } catch (e) {
      print('Error updating team stats: $e');
      rethrow;
    }
  }

  // ==================== PLAYER OPERATIONS ====================

  /// Create a new player
  Future<String> createPlayer(Player player) async {
    try {
      final docRef =
          await _firestore.collection('players').add(player.toMap());
      return docRef.id;
    } catch (e) {
      print('Error creating player: $e');
      rethrow;
    }
  }

  /// Get player by ID
  Future<Player?> getPlayer(String playerId) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('players').doc(playerId).get();
      if (doc.exists) {
        return Player.fromMap(playerId, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting player: $e');
      return null;
    }
  }

  /// Get players by team
  Future<List<Player>> getPlayersByTeam(String teamId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('players')
          .where('teamId', isEqualTo: teamId)
          .get();
      return querySnapshot.docs
          .map((doc) => Player.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('Error getting players by team: $e');
      return [];
    }
  }

  /// Stream players by team
  Stream<List<Player>> getPlayersByTeamStream(String teamId) {
    return _firestore
        .collection('players')
        .where('teamId', isEqualTo: teamId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Player.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  /// Update player stats
  Future<void> updatePlayerStats(String playerId, Map<String, dynamic> stats) async {
    try {
      await _firestore
          .collection('players')
          .doc(playerId)
          .update({'stats': stats});
    } catch (e) {
      print('Error updating player stats: $e');
      rethrow;
    }
  }

  // ==================== MATCH OPERATIONS ====================

  /// Create a new match
  Future<String> createMatch(Match match) async {
    try {
      final docRef =
          await _firestore.collection('matches').add(match.toMap());
      return docRef.id;
    } catch (e) {
      print('Error creating match: $e');
      rethrow;
    }
  }

  /// Get match by ID
  Future<Match?> getMatch(String matchId) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('matches').doc(matchId).get();
      if (doc.exists) {
        return Match.fromMap(matchId, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting match: $e');
      return null;
    }
  }

  /// Stream match by ID (for live updates)
  Stream<Match?> getMatchStream(String matchId) {
    return _firestore.collection('matches').doc(matchId).snapshots().map((doc) {
      if (doc.exists) {
        return Match.fromMap(matchId, doc.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  /// Get matches by tournament
  Future<List<Match>> getMatchesByTournament(String tournamentId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('matches')
          .where('tournamentId', isEqualTo: tournamentId)
          .get();
      return querySnapshot.docs
          .map((doc) => Match.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('Error getting matches: $e');
      return [];
    }
  }

  /// Stream matches by tournament
  Stream<List<Match>> getMatchesByTournamentStream(String tournamentId) {
    return _firestore
        .collection('matches')
        .where('tournamentId', isEqualTo: tournamentId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Match.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  /// Get ongoing matches
  Stream<List<Match>> getOngoingMatchesStream() {
    return _firestore
        .collection('matches')
        .where('status', isEqualTo: 'ongoing')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Match.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  /// Update match
  Future<void> updateMatch(String matchId, Match match) async {
    try {
      await _firestore.collection('matches').doc(matchId).update(match.toMap());
    } catch (e) {
      print('Error updating match: $e');
      rethrow;
    }
  }

  /// Update match score
  Future<void> updateMatchScore(
    String matchId,
    Map<String, dynamic> scoreTeamA,
    Map<String, dynamic> scoreTeamB,
  ) async {
    try {
      await _firestore.collection('matches').doc(matchId).update({
        'scoreTeamA': scoreTeamA,
        'scoreTeamB': scoreTeamB,
      });
    } catch (e) {
      print('Error updating match score: $e');
      rethrow;
    }
  }

  /// Update match status
  Future<void> updateMatchStatus(String matchId, String status) async {
    try {
      await _firestore
          .collection('matches')
          .doc(matchId)
          .update({'status': status});
    } catch (e) {
      print('Error updating match status: $e');
      rethrow;
    }
  }

  // ==================== REGISTRATION OPERATIONS ====================

  /// Create a tournament registration
  Future<String> createRegistration(Registration registration) async {
    try {
      final docRef = await _firestore
          .collection('registrations')
          .add(registration.toMap());
      return docRef.id;
    } catch (e) {
      print('Error creating registration: $e');
      rethrow;
    }
  }

  /// Get registrations by tournament
  Future<List<Registration>> getRegistrationsByTournament(
      String tournamentId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('registrations')
          .where('tournamentId', isEqualTo: tournamentId)
          .get();
      return querySnapshot.docs
          .map((doc) => Registration.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('Error getting registrations: $e');
      return [];
    }
  }

  /// Update registration status
  Future<void> updateRegistrationStatus(
      String registrationId, String status) async {
    try {
      await _firestore
          .collection('registrations')
          .doc(registrationId)
          .update({'status': status});
    } catch (e) {
      print('Error updating registration: $e');
      rethrow;
    }
  }
}
