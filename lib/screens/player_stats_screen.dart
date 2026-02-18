import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/responsive.dart';

/// Player statistics screen showing player performance
class PlayerStatsScreen extends ConsumerStatefulWidget {
  const PlayerStatsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PlayerStatsScreen> createState() => _PlayerStatsScreenState();
}

class _PlayerStatsScreenState extends ConsumerState<PlayerStatsScreen> {
  late TextEditingController _searchController;
  String _selectedTeam = '';

  List<Map<String, dynamic>> _getSamplePlayers() {
    return [
      {
        'name': 'Rajesh Kumar',
        'team': 'Phoenix United',
        'jersey': '10',
        'position': 'Forward',
        'goals': 8,
        'assists': 3,
        'matches': 6,
      },
      {
        'name': 'Arjun Singh',
        'team': 'Phoenix United',
        'jersey': '7',
        'position': 'Midfielder',
        'goals': 5,
        'assists': 7,
        'matches': 6,
      },
      {
        'name': 'Vikram Patel',
        'team': 'Thunder Strikers',
        'jersey': '9',
        'position': 'Forward',
        'goals': 6,
        'assists': 2,
        'matches': 6,
      },
      {
        'name': 'Sanjay Verma',
        'team': 'Thunder Strikers',
        'jersey': '5',
        'position': 'Defender',
        'goals': 1,
        'assists': 0,
        'matches': 6,
      },
      {
        'name': 'Anil Kumar',
        'team': 'Dragon Force',
        'jersey': '11',
        'position': 'Forward',
        'goals': 4,
        'assists': 1,
        'matches': 6,
      },
      {
        'name': 'Deepak Sharma',
        'team': 'Dragon Force',
        'jersey': '4',
        'position': 'Defender',
        'goals': 0,
        'assists': 1,
        'matches': 6,
      },
      {
        'name': 'Rohit Gupta',
        'team': 'Victory Vipers',
        'jersey': '8',
        'position': 'Midfielder',
        'goals': 3,
        'assists': 4,
        'matches': 6,
      },
      {
        'name': 'Nikhil Rao',
        'team': 'Eagles Elite',
        'jersey': '3',
        'position': 'Defender',
        'goals': 0,
        'assists': 0,
        'matches': 6,
      },
    ];
  }

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

  @override
  Widget build(BuildContext context) {
    final allPlayers = _getSamplePlayers();
    
    // Filter players by search and team
    final filteredPlayers = allPlayers.where((player) {
      final matchesSearch = player['name']
          .toString()
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());
      final matchesTeam =
          _selectedTeam.isEmpty || player['team'] == _selectedTeam;
      return matchesSearch && matchesTeam;
    }).toList();

    // Get unique teams
    final uniqueTeams = <String>{'All Teams'};
    for (var player in allPlayers) {
      uniqueTeams.add(player['team'] as String);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Statistics'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: Responsive.getResponsivePadding(context),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search players...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

          // Team filter
          Padding(
            padding: Responsive.getResponsivePadding(context),
            child: SizedBox(
              height: 45,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: uniqueTeams.map((team) {
                  final isSelected =
                      (_selectedTeam.isEmpty && team == 'All Teams') ||
                          _selectedTeam == team;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(team),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedTeam = team == 'All Teams' ? '' : team;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Players list
          Expanded(
            child: filteredPlayers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No players found',
                          style: TextStyle(
                            fontSize: Responsive.responsiveFont(context, 16),
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
                      itemCount: filteredPlayers.length,
                      itemBuilder: (context, index) {
                        final player = filteredPlayers[index];
                        return _PlayerStatsCard(player: player);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Player stats card widget
class _PlayerStatsCard extends StatefulWidget {
  final Map<String, dynamic> player;

  const _PlayerStatsCard({required this.player});

  @override
  State<_PlayerStatsCard> createState() => _PlayerStatsCardState();
}

class _PlayerStatsCardState extends State<_PlayerStatsCard> {
  bool _isHovered = false;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with name and jersey
              Row(
                children: [
                  // Jersey badge
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1976D2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '#${widget.player['jersey']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Player info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.player['name'],
                          style: TextStyle(
                            fontSize: Responsive.responsiveFont(context, 16),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1976D2).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                widget.player['position'],
                                style: TextStyle(
                                  fontSize:
                                      Responsive.responsiveFont(context, 11),
                                  color: const Color(0xFF1976D2),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.player['team'],
                              style: TextStyle(
                                fontSize: Responsive.responsiveFont(context, 12),
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Stats row
              Row(
                children: [
                  _StatItem(
                    label: 'Goals',
                    value: widget.player['goals'].toString(),
                    color: const Color(0xFF4CAF50),
                  ),
                  const Spacer(),
                  _StatItem(
                    label: 'Assists',
                    value: widget.player['assists'].toString(),
                    color: const Color(0xFF2196F3),
                  ),
                  const Spacer(),
                  _StatItem(
                    label: 'Matches',
                    value: widget.player['matches'].toString(),
                    color: const Color(0xFFFF9800),
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

/// Stat item component
class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: Responsive.responsiveFont(context, 18),
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: Responsive.responsiveFont(context, 11),
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
