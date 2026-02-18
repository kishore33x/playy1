import '../models/tournament.dart';
import '../models/team.dart';
import '../models/match.dart';
import '../models/player.dart';
import '../services/firestore_service.dart';

/// Sample data for testing and demo
class SampleData {
  static final FirestoreService _firestoreService = FirestoreService();

  /// Initialize sample tournaments in Firestore
  static Future<void> initializeSampleTournaments() async {
    try {
      final tournaments = [
        Tournament(
          id: 'tournament1',
          name: 'Summer Sports Challenge 2026',
          sport: 'Football',
          description:
              'An exciting 8-team tournament featuring the best local football clubs competing for glory and prizes.',
          startDate: DateTime.now().add(const Duration(days: 30)),
          endDate: DateTime.now().add(const Duration(days: 45)),
          location: 'City Sports Complex',
          status: 'upcoming',
          maxTeams: 8,
          registeredTeams: [],
          createdBy: 'admin1',
          createdAt: DateTime.now(),
          prizePool: '₹5,00,000',
        ),
        Tournament(
          id: 'tournament2',
          name: 'Cricket Championship 2026',
          sport: 'Cricket',
          description: 'Premier cricket tournament with T20 format matches.',
          startDate: DateTime.now().add(const Duration(days: 15)),
          endDate: DateTime.now().add(const Duration(days: 30)),
          location: 'Central Cricket Ground',
          status: 'ongoing',
          maxTeams: 6,
          registeredTeams: ['team1', 'team2', 'team3'],
          createdBy: 'admin1',
          createdAt: DateTime.now(),
          prizePool: '₹3,00,000',
        ),
        Tournament(
          id: 'tournament3',
          name: 'Basketball League',
          sport: 'Basketball',
          description: 'Fast-paced basketball tournament for all skill levels.',
          startDate: DateTime.now().subtract(const Duration(days: 15)),
          endDate: DateTime.now().add(const Duration(days: 10)),
          location: 'Downtown Arena',
          status: 'ongoing',
          maxTeams: 10,
          registeredTeams: ['team4', 'team5'],
          createdBy: 'admin1',
          createdAt: DateTime.now(),
          prizePool: '₹4,00,000',
        ),
      ];

      // Save tournaments to Firestore
      for (final tournament in tournaments) {
        await _firestoreService.createTournament(tournament);
      }

      print('Sample tournaments initialized successfully');
    } catch (e) {
      print('Error initializing sample tournaments: $e');
    }
  }

  /// Initialize sample teams in Firestore
  static Future<void> initializeSampleTeams() async {
    try {
      final teams = [
        Team(
          id: 'team1',
          name: 'Phoenix United',
          shortCode: 'PHX',
          coach: 'John Smith',
          playerIds: ['player1', 'player2', 'player3'],
          wins: 3,
          losses: 1,
          draws: 0,
          points: 9,
          createdAt: DateTime.now(),
        ),
        Team(
          id: 'team2',
          name: 'Thunder Strikers',
          shortCode: 'TS',
          coach: 'Jane Doe',
          playerIds: ['player4', 'player5'],
          wins: 2,
          losses: 2,
          draws: 0,
          points: 6,
          createdAt: DateTime.now(),
        ),
        Team(
          id: 'team3',
          name: 'Dragon Force',
          shortCode: 'DF',
          coach: 'Mike Johnson',
          playerIds: ['player6', 'player7'],
          wins: 1,
          losses: 3,
          draws: 0,
          points: 3,
          createdAt: DateTime.now(),
        ),
        Team(
          id: 'team4',
          name: 'Eagles Wings',
          shortCode: 'EW',
          coach: 'Sarah Wilson',
          playerIds: ['player8', 'player9'],
          wins: 4,
          losses: 0,
          draws: 1,
          points: 13,
          createdAt: DateTime.now(),
        ),
        Team(
          id: 'team5',
          name: 'Titans Academy',
          shortCode: 'TA',
          coach: 'Robert Brown',
          playerIds: ['player10', 'player11'],
          wins: 2,
          losses: 2,
          draws: 1,
          points: 7,
          createdAt: DateTime.now(),
        ),
      ];

      // Save teams to Firestore
      for (final team in teams) {
        await _firestoreService.createTeam(team);
      }

      print('Sample teams initialized successfully');
    } catch (e) {
      print('Error initializing sample teams: $e');
    }
  }

  /// Initialize sample players in Firestore
  static Future<void> initializeSamplePlayers() async {
    try {
      final players = [
        Player(
          id: 'player1',
          name: 'Alex Martinez',
          jerseyNumber: 10,
          position: 'Forward',
          sport: 'Football',
          teamId: 'team1',
          dateOfBirth: DateTime(1998, 5, 15),
          createdAt: DateTime.now(),
          stats: {
            'goals': 12,
            'assists': 5,
            'matches': 10,
            'yellowCards': 2,
            'redCards': 0,
          },
        ),
        Player(
          id: 'player2',
          name: 'Marcus Williams',
          jerseyNumber: 7,
          position: 'Midfielder',
          sport: 'Football',
          teamId: 'team1',
          dateOfBirth: DateTime(2000, 3, 22),
          createdAt: DateTime.now(),
          stats: {
            'goals': 5,
            'assists': 8,
            'matches': 10,
            'yellowCards': 1,
            'redCards': 0,
          },
        ),
        Player(
          id: 'player3',
          name: 'David Chen',
          jerseyNumber: 3,
          position: 'Defender',
          sport: 'Football',
          teamId: 'team1',
          dateOfBirth: DateTime(1997, 7, 10),
          createdAt: DateTime.now(),
          stats: {
            'goals': 1,
            'assists': 0,
            'matches': 10,
            'yellowCards': 3,
            'redCards': 0,
          },
        ),
        Player(
          id: 'player4',
          name: 'Emily Davis',
          jerseyNumber: 9,
          position: 'Forward',
          sport: 'Football',
          teamId: 'team2',
          dateOfBirth: DateTime(1999, 11, 5),
          createdAt: DateTime.now(),
          stats: {
            'goals': 8,
            'assists': 3,
            'matches': 8,
            'yellowCards': 2,
            'redCards': 0,
          },
        ),
        Player(
          id: 'player5',
          name: 'Chris Anderson',
          jerseyNumber: 5,
          position: 'Defender',
          sport: 'Football',
          teamId: 'team2',
          dateOfBirth: DateTime(1996, 8, 20),
          createdAt: DateTime.now(),
          stats: {
            'goals': 0,
            'assists': 1,
            'matches': 8,
            'yellowCards': 4,
            'redCards': 0,
          },
        ),
        Player(
          id: 'player6',
          name: 'Priya Patel',
          jerseyNumber: 11,
          position: 'Forward',
          sport: 'Football',
          teamId: 'team3',
          dateOfBirth: DateTime(2001, 2, 14),
          createdAt: DateTime.now(),
          stats: {
            'goals': 4,
            'assists': 2,
            'matches': 6,
            'yellowCards': 1,
            'redCards': 0,
          },
        ),
        Player(
          id: 'player7',
          name: 'James Wilson',
          jerseyNumber: 6,
          position: 'Midfielder',
          sport: 'Football',
          teamId: 'team3',
          dateOfBirth: DateTime(1998, 9, 8),
          createdAt: DateTime.now(),
          stats: {
            'goals': 2,
            'assists': 3,
            'matches': 6,
            'yellowCards': 2,
            'redCards': 0,
          },
        ),
      ];

      // Save players to Firestore
      for (final player in players) {
        await _firestoreService.createPlayer(player);
      }

      print('Sample players initialized successfully');
    } catch (e) {
      print('Error initializing sample players: $e');
    }
  }

  /// Initialize sample matches in Firestore
  static Future<void> initializeSampleMatches() async {
    try {
      final matches = [
        Match(
          id: 'match1',
          tournamentId: 'tournament2',
          teamAId: 'team1',
          teamBId: 'team2',
          sport: 'Football',
          scoreTeamA: {'goals': 2},
          scoreTeamB: {'goals': 1},
          status: 'completed',
          scheduledTime: DateTime.now().subtract(const Duration(hours: 2)),
          startTime: DateTime.now().subtract(const Duration(hours: 2)),
          endTime: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
          venue: 'Central Stadium',
          createdAt: DateTime.now(),
        ),
        Match(
          id: 'match2',
          tournamentId: 'tournament2',
          teamAId: 'team2',
          teamBId: 'team3',
          sport: 'Football',
          scoreTeamA: {'goals': 1},
          scoreTeamB: {'goals': 1},
          status: 'ongoing',
          scheduledTime: DateTime.now(),
          startTime: DateTime.now().subtract(const Duration(minutes: 30)),
          venue: 'West Park Field',
          createdAt: DateTime.now(),
        ),
        Match(
          id: 'match3',
          tournamentId: 'tournament2',
          teamAId: 'team1',
          teamBId: 'team3',
          sport: 'Football',
          scoreTeamA: {'goals': 0},
          scoreTeamB: {'goals': 0},
          status: 'scheduled',
          scheduledTime: DateTime.now().add(const Duration(days: 2)),
          venue: 'East Field',
          createdAt: DateTime.now(),
        ),
      ];

      // Save matches to Firestore
      for (final match in matches) {
        await _firestoreService.createMatch(match);
      }

      print('Sample matches initialized successfully');
    } catch (e) {
      print('Error initializing sample matches: $e');
    }
  }

  /// Initialize all sample data
  static Future<void> initializeAll() async {
    try {
      print('Initializing sample data...');
      await initializeSampleTournaments();
      await initializeSampleTeams();
      await initializeSamplePlayers();
      await initializeSampleMatches();
      print('All sample data initialized successfully');
    } catch (e) {
      print('Error initializing sample data: $e');
    }
  }
}
