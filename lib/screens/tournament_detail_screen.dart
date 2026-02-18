import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';

/// Tournament detail screen showing tournament info and matches
class TournamentDetailScreen extends ConsumerWidget {
  final String tournamentId;

  const TournamentDetailScreen({
    Key? key,
    required this.tournamentId,
  }) : super(key: key);

  Map<String, dynamic>? _getTournamentData(String id) {
    final tournaments = {
      'tournament1': {
        'name': 'Summer Football League',
        'sport': 'Football',
        'location': 'City Sports Complex',
        'description': 'Premier football tournament featuring top local clubs competing for glory and ₹5,00,000 prize pool.',
        'status': 'ongoing',
        'prizePool': '₹5,00,000',
        'maxTeams': 8,
        'registered': 3,
      },
      'tournament2': {
        'name': 'Cricket Championship 2026',
        'sport': 'Cricket',
        'location': 'Central Ground',
        'description': 'T20 format cricket tournament with the best cricket teams competing for ₹3,00,000 prize pool.',
        'status': 'ongoing',
        'prizePool': '₹3,00,000',
        'maxTeams': 6,
        'registered': 2,
      },
      'tournament3': {
        'name': 'Basketball League',
        'sport': 'Basketball',
        'location': 'Downtown Arena',
        'description': 'Fast-paced basketball tournament for all skill levels with ₹4,00,000 prize pool.',
        'status': 'upcoming',
        'prizePool': '₹4,00,000',
        'maxTeams': 10,
        'registered': 1,
      },
    };
    return tournaments[id];
  }

  List<Map<String, dynamic>> _getSampleMatches(String tournamentId) {
    final matchesByTournament = {
      'tournament1': [
        {'team1': 'Phoenix United', 'team2': 'Thunder Strikers', 'score1': 2, 'score2': 1, 'status': 'completed', 'date': '2026-02-15'},
        {'team1': 'Dragon Force', 'team2': 'Victory Vipers', 'score1': 1, 'score2': 1, 'status': 'completed', 'date': '2026-02-16'},
        {'team1': 'Eagles Elite', 'team2': 'Phoenix United', 'score1': 0, 'score2': 3, 'status': 'completed', 'date': '2026-02-17'},
      ],
      'tournament2': [
        {'team1': 'Dragon Force', 'team2': 'Victory Vipers', 'score1': 145, 'score2': 120, 'status': 'ongoing', 'date': '2026-02-18'},
        {'team1': 'Phoenix United', 'team2': 'Stars United', 'score1': 0, 'score2': 0, 'status': 'scheduled', 'date': '2026-02-19'},
      ],
      'tournament3': [
        {'team1': 'Eagles Elite', 'team2': 'Stars United', 'score1': 62, 'score2': 58, 'status': 'ongoing', 'date': '2026-02-20'},
      ],
    };
    return matchesByTournament[tournamentId] ?? [];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournament = _getTournamentData(tournamentId);
    final matches = _getSampleMatches(tournamentId);

    if (tournament == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tournament Details')),
        body: const Center(child: Text('Tournament not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournament Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Container(
              width: double.infinity,
              height: 200,
              color: const Color(0xFF1976D2),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getIconForSport(tournament['sport']),
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      tournament['name'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Responsive.responsiveFont(context, 24),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Tournament info
            Padding(
              padding: Responsive.getResponsivePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow('Sport', tournament['sport']),
                  const SizedBox(height: 12),
                  _InfoRow('Location', tournament['location']),
                  const SizedBox(height: 12),
                  _InfoRow('Status', tournament['status'].toString().toUpperCase()),
                  const SizedBox(height: 12),
                  _InfoRow('Prize Pool', tournament['prizePool']),
                  const SizedBox(height: 12),
                  _InfoRow(
                    'Teams',
                    '${tournament['registered']}/${tournament['maxTeams']}',
                  ),

                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'About',
                    style: TextStyle(
                      fontSize: Responsive.responsiveFont(context, 18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tournament['description'],
                    style: TextStyle(
                      fontSize: Responsive.responsiveFont(context, 14),
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Matches section
                  Text(
                    'Matches (${matches.length})',
                    style: TextStyle(
                      fontSize: Responsive.responsiveFont(context, 18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            // Matches list
            if (matches.isEmpty)
              Padding(
                padding: Responsive.getResponsivePadding(context),
                child: Text(
                  'No matches scheduled yet',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: Responsive.responsiveFont(context, 14),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: Responsive.getResponsivePadding(context),
                itemCount: matches.length,
                itemBuilder: (context, index) {
                  final match = matches[index];
                  return _MatchCard(match: match);
                },
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  IconData _getIconForSport(String sport) {
    switch (sport.toLowerCase()) {
      case 'football':
        return Icons.sports_soccer;
      case 'cricket':
        return Icons.sports_cricket;
      case 'basketball':
        return Icons.sports_basketball;
      case 'volleyball':
        return Icons.sports_volleyball;
      case 'tennis':
        return Icons.sports_tennis;
      default:
        return Icons.sports;
    }
  }
}

/// Information row widget
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Responsive.responsiveFont(context, 14),
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: Responsive.responsiveFont(context, 14),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// Match card widget
class _MatchCard extends StatefulWidget {
  final Map<String, dynamic> match;

  const _MatchCard({required this.match});

  @override
  State<_MatchCard> createState() => _MatchCardState();
}

class _MatchCardState extends State<_MatchCard> {
  bool _isHovered = false;

  Color _getStatusColor() {
    switch (widget.match['status']) {
      case 'completed':
        return Colors.grey;
      case 'ongoing':
        return const Color(0xFF4CAF50);
      case 'scheduled':
        return const Color(0xFF2196F3);
      default:
        return Colors.grey;
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
          child: Column(
            children: [
              // Header with status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.match['date'],
                    style: TextStyle(
                      fontSize: Responsive.responsiveFont(context, 12),
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.match['status'].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Teams and score
              Row(
                children: [
                  // Team 1
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.match['team1'],
                          style: TextStyle(
                            fontSize: Responsive.responsiveFont(context, 13),
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.match['score1'].toString(),
                          style: TextStyle(
                            fontSize: Responsive.responsiveFont(context, 24),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1976D2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'VS',
                      style: TextStyle(
                        fontSize: Responsive.responsiveFont(context, 12),
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  // Team 2
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.match['team2'],
                          style: TextStyle(
                            fontSize: Responsive.responsiveFont(context, 13),
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.match['score2'].toString(),
                          style: TextStyle(
                            fontSize: Responsive.responsiveFont(context, 24),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1976D2),
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
      ),
    );
  }
}
