import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/player.dart';

/// Player statistics screen showing player performance
class PlayerStatsScreen extends ConsumerStatefulWidget {
  const PlayerStatsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PlayerStatsScreen> createState() => _PlayerStatsScreenState();
}

class _PlayerStatsScreenState extends ConsumerState<PlayerStatsScreen> {
  late TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getSampleData() {
    return [
      {
        'team': 'Phoenix United',
        'players': [
          Player(
            id: 'player1',
            name: 'John Doe',
            jerseyNumber: 7,
            position: 'Forward',
            sport: 'Football',
            teamId: 'team1',
            dateOfBirth: DateTime(1998, 5, 15),
            stats: {'goals': 12, 'assists': 5, 'matches': 15},
          ),
          Player(
            id: 'player2',
            name: 'Alex Johnson',
            jerseyNumber: 10,
            position: 'Midfielder',
            sport: 'Football',
            teamId: 'team1',
            dateOfBirth: DateTime(2000, 3, 22),
            stats: {'goals': 8, 'assists': 9, 'matches': 14},
          ),
          Player(
            id: 'player3',
            name: 'Mike Wilson',
            jerseyNumber: 1,
            position: 'Goalkeeper',
            sport: 'Football',
            teamId: 'team1',
            dateOfBirth: DateTime(1996, 7, 10),
            stats: {'saves': 45, 'clean_sheets': 8, 'matches': 15},
          ),
        ],
      },
      {
        'team': 'Thunder Strikers',
        'players': [
          Player(
            id: 'player4',
            name: 'Sarah Smith',
            jerseyNumber: 9,
            position: 'Forward',
            sport: 'Football',
            teamId: 'team2',
            dateOfBirth: DateTime(1999, 8, 5),
            stats: {'goals': 14, 'assists': 6, 'matches': 15},
          ),
          Player(
            id: 'player5',
            name: 'Emma Davis',
            jerseyNumber: 23,
            position: 'Defender',
            sport: 'Football',
            teamId: 'team2',
            dateOfBirth: DateTime(2001, 1, 18),
            stats: {'tackles': 28, 'clean_sheets': 7, 'matches': 15},
          ),
        ],
      },
      {
        'team': 'Dragon Force',
        'players': [
          Player(
            id: 'player7',
            name: 'Raj Kumar',
            jerseyNumber: 5,
            position: 'Batsman',
            sport: 'Cricket',
            teamId: 'team3',
            dateOfBirth: DateTime(1997, 6, 20),
            stats: {'runs': 450, 'wickets': 0, 'matches': 12},
          ),
          Player(
            id: 'player8',
            name: 'Priya Sharma',
            jerseyNumber: 11,
            position: 'Bowler',
            sport: 'Cricket',
            teamId: 'team3',
            dateOfBirth: DateTime(1998, 4, 12),
            stats: {'runs': 150, 'wickets': 18, 'matches': 12},
          ),
        ],
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final sampleData = _getSampleData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Statistics'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search players...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          Expanded(
            child: sampleData.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No players found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: sampleData.length,
                    itemBuilder: (context, index) {
                      final teamData = sampleData[index];
                      final teamName = teamData['team'] as String;
                      final players = teamData['players'] as List<Player>;

                      // Filter players based on search
                      final filteredPlayers = _searchQuery.isEmpty
                          ? players
                          : players
                              .where((p) =>
                                  p.name.toLowerCase().contains(_searchQuery))
                              .toList();

                      if (filteredPlayers.isEmpty) {
                        return SizedBox.shrink();
                      }

                      return _TeamPlayersSection(
                        teamName: teamName,
                        players: filteredPlayers,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Team players section widget
class _TeamPlayersSection extends StatelessWidget {
  final String teamName;
  final List<Player> players;

  const _TeamPlayersSection({
    required this.teamName,
    required this.players,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Text(
            teamName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: players.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _PlayerCard(player: players[index]),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Player card widget with hover effects
class _PlayerCard extends StatefulWidget {
  final Player player;

  const _PlayerCard({required this.player});

  @override
  State<_PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends State<_PlayerCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
              offset: Offset(0, _isHovered ? 6 : 2),
              blurRadius: _isHovered ? 12.0 : 4.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Player info header
              Row(
                children: [
                  // Jersey number badge
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1976D2),
                      boxShadow: _isHovered
                          ? [
                              BoxShadow(
                                color: const Color(0xFF1976D2).withOpacity(0.3),
                                offset: const Offset(0, 2),
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        '#${widget.player.jerseyNumber}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Player name and position
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.player.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.player.position,
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

              const SizedBox(height: 12),

              // Stats grid
              _buildStatsGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    final stats = widget.player.stats;
    final statEntries = stats.entries.toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: statEntries.length,
      itemBuilder: (context, index) {
        final entry = statEntries[index];
        final key = entry.key;
        final value = entry.value;

        // Format label
        final label = key
            .replaceAll('_', ' ')
            .split(' ')
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(' ');

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1976D2).withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF1976D2).withOpacity(0.2),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976D2),
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
