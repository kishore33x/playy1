import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../utils/constants.dart';
import '../models/tournament.dart';

/// Home screen displaying tournaments and quick navigation
class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // Sample tournaments data
  List<Tournament> _getSampleTournaments() {
    return [
      Tournament(
        id: 'tournament1',
        name: 'Summer Football League',
        sport: 'Football',
        description: 'Premier football tournament',
        startDate: DateTime.now().add(const Duration(days: 15)),
        endDate: DateTime.now().add(const Duration(days: 30)),
        location: 'City Sports Complex',
        status: 'ongoing',
        maxTeams: 8,
        registeredTeams: ['team1', 'team2', 'team3'],
        createdBy: 'admin1',
        createdAt: DateTime.now(),
        prizePool: '₹5,00,000',
      ),
      Tournament(
        id: 'tournament2',
        name: 'Cricket Championship 2026',
        sport: 'Cricket',
        description: 'T20 format tournament',
        startDate: DateTime.now().add(const Duration(days: 5)),
        endDate: DateTime.now().add(const Duration(days: 20)),
        location: 'Central Ground',
        status: 'ongoing',
        maxTeams: 6,
        registeredTeams: ['team4', 'team5'],
        createdBy: 'admin1',
        createdAt: DateTime.now(),
        prizePool: '₹3,00,000',
      ),
      Tournament(
        id: 'tournament3',
        name: 'Basketball League',
        sport: 'Basketball',
        description: 'Fast-paced basketball',
        startDate: DateTime.now().add(const Duration(days: 30)),
        endDate: DateTime.now().add(const Duration(days: 45)),
        location: 'Downtown Arena',
        status: 'upcoming',
        maxTeams: 10,
        registeredTeams: ['team6'],
        createdBy: 'admin1',
        createdAt: DateTime.now(),
        prizePool: '₹4,00,000',
      ),
      Tournament(
        id: 'tournament4',
        name: 'Volleyball Cup',
        sport: 'Volleyball',
        description: 'Community volleyball tournament',
        startDate: DateTime.now().add(const Duration(days: 60)),
        endDate: DateTime.now().add(const Duration(days: 75)),
        location: 'Sports Hall',
        status: 'upcoming',
        maxTeams: 12,
        registeredTeams: [],
        createdBy: 'admin1',
        createdAt: DateTime.now(),
        prizePool: '₹2,50,000',
      ),
      Tournament(
        id: 'tournament5',
        name: 'Tennis Open',
        sport: 'Tennis',
        description: 'Professional tennis tournament',
        startDate: DateTime.now().add(const Duration(days: 45)),
        endDate: DateTime.now().add(const Duration(days: 60)),
        location: 'Tennis Courts',
        status: 'upcoming',
        maxTeams: 20,
        registeredTeams: ['team7', 'team8'],
        createdBy: 'admin1',
        createdAt: DateTime.now(),
        prizePool: '\$6,000',
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sampleTournaments = _getSampleTournaments();
    final ongoingTournaments = sampleTournaments.where((t) => t.status == 'ongoing').toList();
    final upcomingTournaments = sampleTournaments.where((t) => t.status == 'upcoming').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('PlayOn'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () {
              Navigator.pushNamed(context, AppConstants.adminDashboardRoute);
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Profile'),
                onTap: () {},
              ),
              PopupMenuItem(
                child: const Text('Settings'),
                onTap: () {},
              ),
              PopupMenuItem(
                child: const Text('Logout'),
                onTap: () {
                  final authNotifier = ref.read(authNotifierProvider.notifier);
                  authNotifier.signOut();
                  Navigator.pushReplacementNamed(
                    context,
                    AppConstants.loginRoute,
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Featured banner
            Container(
              margin: const EdgeInsets.all(16),
              height: 200,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1976D2), Color(0xFF1565C0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1976D2).withOpacity(0.3),
                    offset: const Offset(0, 8),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Background pattern
                  Positioned(
                    right: -50,
                    top: -50,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.sports_soccer, size: 48, color: Colors.white),
                        SizedBox(height: 16),
                        Text(
                          'Summer Sports Challenge 2026',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Join Now: 5 Tournaments | Register Teams',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Quick navigation buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _QuickNavCard(
                      icon: Icons.sports_volleyball,
                      label: 'Live Scores',
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppConstants.liveScoresRoute,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickNavCard(
                      icon: Icons.leaderboard,
                      label: 'Leaderboard',
                      onTap: () {
                        // Would pass tournament ID in real app
                        Navigator.pushNamed(
                          context,
                          AppConstants.leaderboardRoute,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickNavCard(
                      icon: Icons.people,
                      label: 'Player Stats',
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppConstants.playerStatsRoute,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Ongoing tournaments
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ongoing Tournaments',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),

            ongoingTournaments.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: ongoingTournaments.length,
                    itemBuilder: (context, index) {
                      final tournament = ongoingTournaments[index];
                      return _TournamentCard(
                        tournament: tournament,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppConstants.tournamentDetailRoute,
                            arguments: tournament.id,
                          );
                        },
                      );
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'No ongoing tournaments',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),

            const SizedBox(height: 24),

            // Upcoming tournaments
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Upcoming Tournaments',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),

            upcomingTournaments.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: upcomingTournaments.length,
                    itemBuilder: (context, index) {
                      final tournament = upcomingTournaments[index];
                      return _TournamentCard(
                        tournament: tournament,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppConstants.tournamentDetailRoute,
                            arguments: tournament.id,
                          );
                        },
                      );
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'No upcoming tournaments',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

/// Quick navigation card widget
class _QuickNavCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickNavCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_QuickNavCard> createState() => _QuickNavCardState();
}

class _QuickNavCardState extends State<_QuickNavCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: _isHovered ? const Color(0xFF1976D2) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _isHovered 
                    ? const Color(0xFF1976D2).withOpacity(0.3)
                    : Colors.black.withOpacity(0.05),
                offset: const Offset(0, 4),
                blurRadius: _isHovered ? 12 : 4,
              ),
            ],
          ),
          child: Column(
            children: [
              AnimatedScale(
                scale: _isHovered ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  widget.icon,
                  color: _isHovered ? Colors.white : const Color(0xFF1976D2),
                  size: 32,
                ),
              ),
              const SizedBox(height: 8),
              AnimatedDefaultTextStyle(
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _isHovered ? Colors.white : Colors.black87,
                ),
                duration: const Duration(milliseconds: 200),
                child: Text(
                  widget.label,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tournament card widget
class _TournamentCard extends StatefulWidget {
  final dynamic tournament;
  final VoidCallback onTap;

  const _TournamentCard({
    required this.tournament,
    required this.onTap,
  });

  @override
  State<_TournamentCard> createState() => _TournamentCardState();
}

class _TournamentCardState extends State<_TournamentCard> {
  bool _isHovered = false;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.tournament.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
                        widget.tournament.sport,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1976D2),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      widget.tournament.location,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Teams Registered',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.tournament.registeredTeams.length}/${widget.tournament.maxTeams}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1976D2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Prize Pool',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.tournament.prizePool,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4CAF50),
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
      ),
    );
  }
}
