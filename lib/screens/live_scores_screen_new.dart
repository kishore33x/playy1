import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/constants.dart';
import '../models/match.dart';

/// Live scores screen with real-time match updates
class LiveScoresScreen extends ConsumerWidget {
  const LiveScoresScreen({Key? key}) : super(key: key);

  List<Match> _getSampleMatches() {
    return [
      Match(
        id: 'match1',
        tournament: 'tournament1',
        team1: 'Phoenix United',
        team2: 'Thunder Strikers',
        sport: 'Football',
        status: 'ongoing',
        scheduledTime: DateTime.now(),
        startTime: DateTime.now().subtract(const Duration(minutes: 35)),
        endTime: null,
        venue: 'City Sports Complex',
        scores: {'Football': {'Phoenix United': '2', 'Thunder Strikers': '1'}},
        events: [],
      ),
      Match(
        id: 'match2',
        tournament: 'tournament2',
        team1: 'Dragon Force',
        team2: 'Victory Vipers',
        sport: 'Cricket',
        status: 'ongoing',
        scheduledTime: DateTime.now(),
        startTime: DateTime.now().subtract(const Duration(hours: 2)),
        endTime: null,
        venue: 'Central Ground',
        scores: {'Cricket': {'Dragon Force': '145/6', 'Victory Vipers': '120/8'}},
        events: [],
      ),
      Match(
        id: 'match3',
        tournament: 'tournament3',
        team1: 'Eagles Elite',
        team2: 'Stars United',
        sport: 'Basketball',
        status: 'ongoing',
        scheduledTime: DateTime.now(),
        startTime: DateTime.now().subtract(const Duration(minutes: 15)),
        endTime: null,
        venue: 'Downtown Arena',
        scores: {'Basketball': {'Eagles Elite': '62', 'Stars United': '58'}},
        events: [],
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
                      fontSize: 18,
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
                padding: const EdgeInsets.all(12),
                itemCount: sampleMatches.length,
                itemBuilder: (context, index) {
                  final match = sampleMatches[index];
                  return _LiveMatchCard(
                    match: match,
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
  final VoidCallback onTap;

  const _LiveMatchCard({
    required this.match,
    required this.onTap,
  });

  @override
  State<_LiveMatchCard> createState() => _LiveMatchCardState();
}

class _LiveMatchCardState extends State<_LiveMatchCard> {
  bool _isHovered = false;

  String _getScore(String team) {
    final sportScores = widget.match.scores[widget.match.sport];
    return sportScores?[team] ?? '0';
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
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
                            widget.match.team1,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getScore(widget.match.team1),
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1976D2),
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
                            widget.match.team2,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getScore(widget.match.team2),
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1976D2),
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
                          fontSize: 13,
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
                    fontSize: 12,
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
