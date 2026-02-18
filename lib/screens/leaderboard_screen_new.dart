import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/team.dart';

/// Leaderboard screen showing team rankings
class LeaderboardScreen extends ConsumerWidget {
  final String tournamentId;

  const LeaderboardScreen({
    Key? key,
    required this.tournamentId,
  }) : super(key: key);

  List<Team> _getSampleTeams() {
    return [
      Team(
        id: 'team1',
        name: 'Phoenix United',
        shortCode: 'PU',
        coach: 'John Smith',
        players: ['player1', 'player2', 'player3'],
        wins: 8,
        losses: 1,
        draws: 1,
        points: 25,
      ),
      Team(
        id: 'team2',
        name: 'Thunder Strikers',
        shortCode: 'TS',
        coach: 'Mike Johnson',
        players: ['player4', 'player5', 'player6'],
        wins: 7,
        losses: 2,
        draws: 1,
        points: 22,
      ),
      Team(
        id: 'team3',
        name: 'Dragon Force',
        shortCode: 'DF',
        coach: 'Sarah Williams',
        players: ['player7', 'player8', 'player9'],
        wins: 6,
        losses: 3,
        draws: 1,
        points: 19,
      ),
      Team(
        id: 'team4',
        name: 'Eagles Elite',
        shortCode: 'EE',
        coach: 'Tom Brown',
        players: ['player10', 'player11', 'player12'],
        wins: 5,
        losses: 4,
        draws: 1,
        points: 16,
      ),
      Team(
        id: 'team5',
        name: 'Stars United',
        shortCode: 'SU',
        coach: 'Lisa Davis',
        players: ['player13', 'player14', 'player15'],
        wins: 4,
        losses: 5,
        draws: 1,
        points: 13,
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sampleTeams = _getSampleTeams();
    final sortedTeams = List<Team>.from(sampleTeams)
      ..sort((a, b) => b.points.compareTo(a.points));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        elevation: 0,
      ),
      body: sortedTeams.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.emoji_events,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No teams registered',
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
                itemCount: sortedTeams.length,
                itemBuilder: (context, index) {
                  final team = sortedTeams[index];
                  final position = index + 1;

                  return _LeaderboardCard(
                    position: position,
                    team: team,
                  );
                },
              ),
            ),
    );
  }
}

/// Leaderboard card widget with hover effects
class _LeaderboardCard extends StatefulWidget {
  final int position;
  final Team team;

  const _LeaderboardCard({
    required this.position,
    required this.team,
  });

  @override
  State<_LeaderboardCard> createState() => _LeaderboardCardState();
}

class _LeaderboardCardState extends State<_LeaderboardCard> {
  bool _isHovered = false;

  Color _getMedalColor() {
    switch (widget.position) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return Colors.grey[400]!;
    }
  }

  String _getMedalEmoji() {
    switch (widget.position) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: _isHovered && widget.position <= 3
              ? Border.all(color: _getMedalColor(), width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? const Color(0xFF1976D2).withOpacity(0.15)
                  : Colors.black.withOpacity(0.05),
              offset: Offset(0, _isHovered ? 8 : 2),
              blurRadius: _isHovered ? 16.0 : 4.0,
            ),
          ],
        ),
        transform: _isHovered ? Matrix4.identity()..translate(0, -2) : Matrix4.identity(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Position badge
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.position <= 3
                      ? _getMedalColor()
                      : Colors.grey[200],
                  boxShadow: widget.position <= 3
                      ? [
                          BoxShadow(
                            color: _getMedalColor().withOpacity(0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    widget.position <= 3
                        ? _getMedalEmoji()
                        : '#${widget.position}',
                    style: TextStyle(
                      fontSize: widget.position <= 3 ? 24 : 18,
                      fontWeight: FontWeight.bold,
                      color: widget.position <= 3 ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Team info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.team.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Coach: ${widget.team.coach}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Record display
                    Text(
                      '${widget.team.wins}W - ${widget.team.losses}L - ${widget.team.draws}D',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Points display
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Points',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.team.points.toString(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
