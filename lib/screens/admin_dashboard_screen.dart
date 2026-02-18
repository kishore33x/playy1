import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../utils/constants.dart';

/// Admin dashboard for tournament management
class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final allTournaments = ref.watch(allTournamentsProvider);
    final allTeams = ref.watch(allTeamsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Logout'),
                onTap: () {
                  final authNotifier =
                      ref.read(authNotifierProvider.notifier);
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats overview
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Tournaments',
                    asyncValue: allTournaments.whenData((t) => t.length),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Teams',
                    asyncValue: allTeams.whenData((t) => t.length),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Action buttons
            const Text(
              'Management',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _ActionButton(
              icon: Icons.add_circle_outline,
              label: 'Create Tournament',
              onTap: () {
                _showCreateTournamentDialog(context);
              },
            ),

            const SizedBox(height: 12),

            _ActionButton(
              icon: Icons.group_add_outlined,
              label: 'Add Team',
              onTap: () {
                _showAddTeamDialog(context);
              },
            ),

            const SizedBox(height: 12),

            _ActionButton(
              icon: Icons.person_add_outlined,
              label: 'Add Player',
              onTap: () {
                _showAddPlayerDialog(context);
              },
            ),

            const SizedBox(height: 12),

            _ActionButton(
              icon: Icons.sports_soccer_outlined,
              label: 'Create Match',
              onTap: () {
                _showCreateMatchDialog(context);
              },
            ),

            const SizedBox(height: 24),

            // Tournament management section
            const Text(
              'Tournaments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            allTournaments.when(
              data: (tournaments) {
                if (tournaments.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'No tournaments created yet',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tournaments.length,
                  itemBuilder: (context, index) {
                    final tournament = tournaments[index];
                    return _TournamentManagementCard(
                      tournament: tournament,
                      onEdit: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Edit tournament'),
                          ),
                        );
                      },
                      onDelete: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tournament deleted'),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (err, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Error: $err'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show dialog to create tournament
  void _showCreateTournamentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController nameController = TextEditingController();
        TextEditingController locationController = TextEditingController();
        String selectedSport = AppConstants.sports[0];

        return AlertDialog(
          title: const Text('Create Tournament'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Tournament Name',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedSport,
                items: AppConstants.sports
                    .map((sport) =>
                        DropdownMenuItem(value: sport, child: Text(sport)))
                    .toList(),
                onChanged: (value) {
                  selectedSport = value ?? AppConstants.sports[0];
                },
                decoration: const InputDecoration(
                  labelText: 'Sport',
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
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tournament created')),
                );
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  /// Show dialog to add team
  void _showAddTeamDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController nameController = TextEditingController();
        TextEditingController coachController = TextEditingController();

        return AlertDialog(
          title: const Text('Add Team'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Team Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: coachController,
                decoration: const InputDecoration(labelText: 'Coach Name'),
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
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Team added')),
                );
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  /// Show dialog to add player
  void _showAddPlayerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController nameController = TextEditingController();
        String selectedPosition = 'Forward';

        return AlertDialog(
          title: const Text('Add Player'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Player Name'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedPosition,
                items: ['Forward', 'Midfielder', 'Defender', 'Goalkeeper']
                    .map((pos) =>
                        DropdownMenuItem(value: pos, child: Text(pos)))
                    .toList(),
                onChanged: (value) {
                  selectedPosition = value ?? 'Forward';
                },
                decoration: const InputDecoration(labelText: 'Position'),
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
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Player added')),
                );
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  /// Show dialog to create match
  void _showCreateMatchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Match'),
          content: const Text('Match creation form will be displayed here'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Match created')),
                );
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}

/// Stat card widget
class _StatCard extends StatelessWidget {
  final String label;
  final AsyncValue<int> asyncValue;

  const _StatCard({
    required this.label,
    required this.asyncValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          asyncValue.when(
            data: (count) => Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
              ),
            ),
            loading: () => const CircularProgressIndicator(),
            error: (err, stack) => const Text('Error'),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

/// Action button widget
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1976D2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tournament management card
class _TournamentManagementCard extends StatelessWidget {
  final dynamic tournament;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TournamentManagementCard({
    required this.tournament,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tournament.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tournament.sport,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
