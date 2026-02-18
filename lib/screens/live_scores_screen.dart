import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';
import '../models/match.dart';

/// Live scores screen with real-time match updates
class LiveScoresScreen extends ConsumerWidget {
  const LiveScoresScreen({Key? key}) : super(key: key);

  /// Sample team data for display
  final teamNames = const {
    'team1': 'Phoenix United',
    'team2': 'Thunder Strikers',
    'team3': 'Dragon Force',
    'team4': 'Victory Vipers',
    'team5': 'Eagles Elite',
    'team6': 'Stars United',
  };

  List<Match> _getSampleMatches() {
    final now = DateTime.now();
    return [
      Match(
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
      ),
      Match(
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
      ),
      Match(
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
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sampleMatches = _getSampleMatches();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Scores'),
        elevation: 0,
      ),
      body: sampleMatches.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sports_score,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No ongoing matches',
                    style: TextStyle(
                      fontSize: Responsive.responsiveFont(context, 18),
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {},
              child: ListView.builder(
                padding: Responsive.getResponsivePadding(context),
                itemCount: sampleMatches.length,
                itemBuilder: (context, index) {
                  final match = sampleMatches[index];
                  return _LiveMatchCard(
                    match: match,
                    teamAName: teamNames[match.teamAId] ?? 'Team A',
                    teamBName: teamNames[match.teamBId] ?? 'Team B',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppConstants.matchDetailRoute,
                        arguments: match.id,
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}

/// Live match card widget with hover effects
class _LiveMatchCard extends StatefulWidget {
  final Match match;
  final String teamAName;
  final String teamBName;
  final VoidCallback onTap;

  const _LiveMatchCard({
    required this.match,
    required this.teamAName,
    required this.teamBName,
    required this.onTap,
  });

  @override
  State<_LiveMatchCard> createState() => _LiveMatchCardState();
}

class _LiveMatchCardState extends State<_LiveMatchCard> {
  bool _isHovered = false;

  String _formatScore(String sport, Map<String, dynamic> score) {
    switch (sport.toLowerCase()) {
      case 'football':
        return (score['goals'] ?? 0).toString();
      case 'cricket':
        final runs = score['runs'] ?? 0;
        final wickets = score['wickets'] ?? 0;
        return '$runs/$wickets';
      case 'basketball':
        return (score['points'] ?? 0).toString();
      case 'volleyball':
        return (score['points'] ?? 0).toString();
      default:
        return (score['score'] ?? 0).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final scoreA = _formatScore(widget.match.sport, widget.match.scoreTeamA);
    final scoreB = _formatScore(widget.match.sport, widget.match.scoreTeamB);

    return MouseRegion(
      onEnter: isMobile ? null : (_) => setState(() => _isHovered = true),
      onExit: isMobile ? null : (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: _isHovered
                ? Border.all(color: const Color(0xFF1976D2), width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? const Color(0xFF1976D2).withOpacity(0.2)
                    : Colors.black.withOpacity(0.05),
                offset: Offset(0, _isHovered ? 8 : 2),
                blurRadius: _isHovered ? 16.0 : 4.0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header with sport and LIVE badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1976D2).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.match.sport,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 8,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'LIVE',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Score display - Team vs Team
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.teamAName,
                            style: TextStyle(
                              fontSize: Responsive.responsiveFont(context, 13),
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            scoreA,
                            style: TextStyle(
                              fontSize: Responsive.responsiveFont(context, 36),
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1976D2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'VS',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.teamBName,
                            style: TextStyle(
                              fontSize: Responsive.responsiveFont(context, 13),
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            scoreB,
                            style: TextStyle(
                              fontSize: Responsive.responsiveFont(context, 36),
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1976D2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Venue info
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.match.venue,
                        style: TextStyle(
                          fontSize: Responsive.responsiveFont(context, 13),
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Tap for details link
                AnimatedDefaultTextStyle(
                  style: TextStyle(
                    fontSize: Responsive.responsiveFont(context, 12),
                    fontWeight: FontWeight.bold,
                    color: _isHovered
                        ? const Color(0xFF1565C0)
                        : const Color(0xFF1976D2),
                  ),
                  duration: const Duration(milliseconds: 200),
                  child: const Text('Tap for full details →'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
