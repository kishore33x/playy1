import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../utils/constants.dart';
import '../models/match.dart';

/// Match detail screen with live updates and admin controls
class MatchDetailScreen extends ConsumerWidget {
  final String matchId;

  const MatchDetailScreen({
    Key? key,
    required this.matchId,
  }) : super(key: key);

  /// Get sample match data for testing
 Match _getSampleMatch(String id) {
    final now = DateTime.now();
    final teamNames = {
      'team1': 'Phoenix United',
      'team2': 'Thunder Strikers',
      'team3': 'Dragon Force',
      'team4': 'Victory Vipers',
      'team5': 'Eagles Elite',
      'team6': 'Stars United',
    };
    
    switch (id) {
      case 'match1':
        return Match(
          id: 'match1',
          tournamentId: 'tournament1',
          teamAId: 'team1',
          teamBId: 'team2',
          sport: 'Football',
          scoreTeamA: {'goals': 2},
          scoreTeamB: {'goals': 1},
          status: 'ongoing',
          scheduledTime: now,
          startTime: now.subtract(const Duration(minutes: 35)),
          venue: 'City Sports Complex',
          createdAt: now,
          events: [
            MatchEvent(
              id: 'event1',
              type: 'goal',
              minute: 12,
              playerId: 'player1',
              team: 'A',
              description: 'Goal scored by Phoenix United',
              timestamp: now.subtract(const Duration(minutes: 23)),
            ),
            MatchEvent(
              id: 'event2',
              type: 'goal',
              minute: 28,
              playerId: 'player4',
              team: 'B',
              description: 'Goal scored by Thunder Strikers',
              timestamp: now.subtract(const Duration(minutes: 7)),
            ),
            MatchEvent(
              id: 'event3',
              type: 'goal',
              minute: 33,
              playerId: 'player2',
              team: 'A',
              description: 'Goal scored by Phoenix United',
              timestamp: now.subtract(const Duration(minutes: 2)),
            ),
          ],
        );
      case 'match2':
        return Match(
          id: 'match2',
          tournamentId: 'tournament2',
          teamAId: 'team3',
          teamBId: 'team4',
          sport: 'Cricket',
          scoreTeamA: {'runs': 145, 'wickets': 4, 'overs': 18.2},
          scoreTeamB: {'runs': 120, 'wickets': 8, 'overs': 19.5},
          status: 'ongoing',
          scheduledTime: now,
          startTime: now.subtract(const Duration(hours: 2)),
          venue: 'Central Ground',
          createdAt: now,
          events: [
            MatchEvent(
              id: 'event4',
              type: 'wicket',
              minute: 15,
              playerId: 'player6',
              team: 'A',
              description: 'Wicket - Dragon Force struck',
              timestamp: now.subtract(const Duration(hours: 1, minutes: 45)),
            ),
            MatchEvent(
              id: 'event5',
              type: 'six',
              minute: 22,
              playerId: 'player7',
              team: 'A',
              description: 'Six runs - Dragon Force',
              timestamp: now.subtract(const Duration(hours: 1, minutes: 38)),
            ),
          ],
        );
      case 'match3':
        return Match(
          id: 'match3',
          tournamentId: 'tournament3',
          teamAId: 'team5',
          teamBId: 'team6',
          sport: 'Basketball',
          scoreTeamA: {'points': 62},
          scoreTeamB: {'points': 58},
          status: 'ongoing',
          scheduledTime: now,
          startTime: now.subtract(const Duration(minutes: 15)),
          venue: 'Downtown Arena',
          createdAt: now,
          events: [
            MatchEvent(
              id: 'event6',
              type: 'basket',
              minute: 8,
              playerId: 'player10',
              team: 'A',
              description: '2-point basket by Eagles Elite',
              timestamp: now.subtract(const Duration(minutes: 7)),
            ),
            MatchEvent(
              id: 'event7',
              type: 'basket',
              minute: 12,
              playerId: 'player12',
              team: 'B',
              description: '3-point basket by Stars United',
              timestamp: now.subtract(const Duration(minutes: 3)),
            ),
          ],
        );
      default:
        return Match(
          id: id,
          tournamentId: 'tournament1',
          teamAId: 'team1',
          teamBId: 'team2',
          sport: 'Football',
          scoreTeamA: {'goals': 0},
          scoreTeamB: {'goals': 0},
          status: 'scheduled',
          scheduledTime: now.add(const Duration(days: 1)),
          venue: 'Default Stadium',
          createdAt: now,
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchStream = ref.watch(matchProvider(matchId));
    final userProfile = ref.watch(currentUserProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Details'),
      ),
      body: matchStream.when(
        data: (matchData) {
          // Use sample data if match not found in Firestore
          final match = matchData ?? _getSampleMatch(matchId);

          return SingleChildScrollView(
            child: Column(
              children: [
                // Match header
                Container(
                  color: const Color(0xFF1976D2),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Sport and status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            match.sport,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: match.status ==
                                      AppConstants.matchStatusOngoing
                                  ? Colors.green
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              match.status.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Teams and scores
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Team A',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _getScoreDisplay(match.scoreTeamA),
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            'vs',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Team B',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _getScoreDisplay(match.scoreTeamB),
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Match info
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoCard(
                        label: 'Venue',
                        value: match.venue,
                      ),
                      const SizedBox(height: 12),
                      _InfoCard(
                        label: 'Scheduled Time',
                        value: match.scheduledTime.toString().split('.')[0],
                      ),
                      if (match.startTime != null)
                        Column(
                          children: [
                            const SizedBox(height: 12),
                            _InfoCard(
                              label: 'Started At',
                              value:
                                  match.startTime.toString().split('.')[0],
                            ),
                          ],
                        ),
                      const SizedBox(height: 24),

                      // Admin controls (if user is admin)
                      userProfile.when(
                        data: (user) {
                          if (user != null && user.isAdmin) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Admin Controls',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Show update score dialog
                                      _showUpdateScoreDialog(context);
                                    },
                                    child: const Text('Update Score'),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Change match status
                                      _showStatusDialog(context);
                                    },
                                    child: const Text('Update Status'),
                                  ),
                                ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (err, stack) => const SizedBox.shrink(),
                      ),

                      const SizedBox(height: 24),

                      // Match events/timeline
                      if (match.events.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Timeline',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...match.events.map((event) {
                              return _EventTile(event: event);
                            }).toList(),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  /// Format score for display
  String _getScoreDisplay(Map<String, dynamic> score) {
    if (score.containsKey('goals')) {
      return score['goals'].toString();
    }
    if (score.containsKey('runs')) {
      return '${score['runs']}/${score['wickets']}';
    }
    if (score.containsKey('points')) {
      return score['points'].toString();
    }
    return '0';
  }

  /// Show dialog to update score
  void _showUpdateScoreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController scoreAController = TextEditingController();
        TextEditingController scoreBController = TextEditingController();

        return AlertDialog(
          title: const Text('Update Score'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: scoreAController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Team A Score',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: scoreBController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Team B Score',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Update score logic here
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Score updated')),
                );
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  /// Show dialog to update match status
  void _showStatusDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Scheduled'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                title: const Text('Ongoing'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                title: const Text('Completed'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Info card widget
class _InfoCard extends StatelessWidget {
  final String label;
  final String value;

  const _InfoCard({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// Event tile widget for match timeline
class _EventTile extends StatelessWidget {
  final dynamic event;

  const _EventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1976D2).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  '${event.minute}\'',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.type.replaceAll('_', ' ').toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
