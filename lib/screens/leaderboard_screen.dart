import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/responsive.dart';

/// Leaderboard screen showing team rankings
class LeaderboardScreen extends ConsumerWidget {
  final String tournamentId;

  const LeaderboardScreen({
    Key? key,
    required this.tournamentId,
  }) : super(key: key);

  List<Map<String, dynamic>> _getSampleLeaderboard() {
    return [
      {
        'rank': 1,
        'team': 'Phoenix United',
        'wins': 5,
        'losses': 1,
        'draws': 0,
        'points': 15,
        'played': 6,
        'gf': 18,
        'ga': 6
      },
      {
        'rank': 2,
        'team': 'Thunder Strikers',
        'wins': 4,
        'losses': 2,
        'draws': 0,
        'points': 12,
        'played': 6,
        'gf': 16,
        'ga': 8
      },
      {
        'rank': 3,
        'team': 'Dragon Force',
        'wins': 3,
        'losses': 2,
        'draws': 1,
        'points': 10,
        'played': 6,
        'gf': 14,
        'ga': 9
      },
      {
        'rank': 4,
        'team': 'Victory Vipers',
        'wins': 2,
        'losses': 3,
        'draws': 1,
        'points': 7,
        'played': 6,
        'gf': 11,
        'ga': 13
      },
      {
        'rank': 5,
        'team': 'Eagles Elite',
        'wins': 1,
        'losses': 4,
        'draws': 1,
        'points': 4,
        'played': 6,
        'gf': 8,
        'ga': 16
      },
      {
        'rank': 6,
        'team': 'Stars United',
        'wins': 0,
        'losses': 5,
        'draws': 1,
        'points': 1,
        'played': 6,
        'gf': 3,
        'ga': 18
      },
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sampleData = _getSampleLeaderboard();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
      ),
      body: Column(
        children: [
          // Header stats
          Container(
            color: const Color(0xFF1976D2),
            padding: Responsive.getResponsivePadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tournament Standings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Responsive.responsiveFont(context, 20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Played: ${sampleData[0]['played']} Matches',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: Responsive.responsiveFont(context, 14),
                  ),
                ),
              ],
            ),
          ),
          // Leaderboard table
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {},
              child: ListView.builder(
                padding: Responsive.getResponsivePadding(context),
                itemCount: sampleData.length,
                itemBuilder: (context, index) {
                  final team = sampleData[index];
                  final isTop3 = team['rank'] <= 3;
                  return _LeaderboardCard(
                    data: team,
                    isTop3: isTop3,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Leaderboard card widget
class _LeaderboardCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool isTop3;

  const _LeaderboardCard({
    required this.data,
    required this.isTop3,
  });

  @override
  State<_LeaderboardCard> createState() => _LeaderboardCardState();
}

class _LeaderboardCardState extends State<_LeaderboardCard> {
  bool _isHovered = false;

  Color getMedalColor() {
    switch (widget.data['rank']) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return Colors.grey;
    }
  }

  IconData getMedalIcon() {
    switch (widget.data['rank']) {
      case 1:
        return Icons.emoji_events;
      case 2:
      case 3:
        return Icons.emoji_events;
      default:
        return Icons.format_list_numbered;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return MouseRegion(
      onEnter: isMobile ? null : (_) => setState(() => _isHovered = true),
      onExit: isMobile ? null : (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: _isHovered
              ? Border.all(color: const Color(0xFF1976D2), width: 2)
              : widget.isTop3
                  ? Border.all(color: getMedalColor(), width: 1)
                  : null,
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? const Color(0xFF1976D2).withOpacity(0.15)
                  : Colors.black.withOpacity(0.05),
              blurRadius: _isHovered ? 8 : 2,
              offset: Offset(0, _isHovered ? 4 : 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Rank badge
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: getMedalColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Center(
                  child: widget.isTop3
                      ? Icon(
                          getMedalIcon(),
                          color: getMedalColor(),
                          size: 20,
                        )
                      : Text(
                          widget.data['rank'].toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1976D2),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 14),
              // Team info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data['team'],
                      style: TextStyle(
                        fontSize: Responsive.responsiveFont(context, 15),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${widget.data['wins']}W',
                          style: TextStyle(
                            fontSize: Responsive.responsiveFont(context, 11),
                            color: const Color(0xFF4CAF50),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.data['losses']}L',
                          style: TextStyle(
                            fontSize: Responsive.responsiveFont(context, 11),
                            color: const Color(0xFFF44336),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.data['draws']}D',
                          style: TextStyle(
                            fontSize: Responsive.responsiveFont(context, 11),
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Stats columns
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${widget.data['gf']}:${widget.data['ga']}',
                    style: TextStyle(
                      fontSize: Responsive.responsiveFont(context, 14),
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'GF:GA',
                    style: TextStyle(
                      fontSize: Responsive.responsiveFont(context, 10),
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Points
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.data['points'].toString(),
                      style: TextStyle(
                        fontSize: Responsive.responsiveFont(context, 18),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1976D2),
                      ),
                    ),
                    Text(
                      'PTS',
                      style: TextStyle(
                        fontSize: Responsive.responsiveFont(context, 9),
                        color: const Color(0xFF1976D2),
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
