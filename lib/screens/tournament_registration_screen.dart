import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';

/// Tournament registration screen for teams
class TournamentRegistrationScreen extends ConsumerStatefulWidget {
  final String tournamentId;

  const TournamentRegistrationScreen({
    Key? key,
    required this.tournamentId,
  }) : super(key: key);

  @override
  ConsumerState<TournamentRegistrationScreen> createState() =>
      _TournamentRegistrationScreenState();
}

class _TournamentRegistrationScreenState
    extends ConsumerState<TournamentRegistrationScreen> {
  late TextEditingController _teamNameController;
  late TextEditingController _coachNameController;
  String? _selectedTeam;

  @override
  void initState() {
    super.initState();
    _teamNameController = TextEditingController();
    _coachNameController = TextEditingController();
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    _coachNameController.dispose();
    super.dispose();
  }

  /// Handle team registration
  void _handleRegistration() async {
    final teamName = _teamNameController.text.trim();
    final coachName = _coachNameController.text.trim();

    if (teamName.isEmpty || coachName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // Register team in Firestore
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Team registered successfully'),
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tournament = ref.watch(tournamentProvider(widget.tournamentId));
    final allTeams = ref.watch(allTeamsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournament Registration'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            tournament.when(
              data: (tournamentData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tournament info
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tournamentData?.name ?? 'Tournament',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  tournamentData?.sport ?? '',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  'Spots left: ${(tournamentData?.maxTeams ?? 0) - (tournamentData?.registeredTeams.length ?? 0)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Registration type
                    const Text(
                      'How would you like to register?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Register new team
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ExpansionTile(
                        title: const Text('Register New Team'),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                TextField(
                                  controller: _teamNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Team Name',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _coachNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Coach Name',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _handleRegistration,
                                    child: const Text('Register Team'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Register existing team
                    allTeams.when(
                      data: (teams) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ExpansionTile(
                            title: const Text('Register Existing Team'),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    DropdownButtonFormField<String>(
                                      value: _selectedTeam,
                                      hint: const Text('Select a team'),
                                      items: teams.map((team) {
                                        return DropdownMenuItem(
                                          value: team.id,
                                          child: Text(team.name),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedTeam = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: _selectedTeam != null
                                            ? () {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Team registered successfully',
                                                    ),
                                                  ),
                                                );
                                                Navigator.pop(context);
                                              }
                                            : null,
                                        child: const Text('Register Team'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (err, stack) => Center(
                        child: Text('Error: $err'),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Terms & conditions
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: true,
                          onChanged: (value) {},
                        ),
                        Expanded(
                          child: Text(
                            'I agree to the tournament rules and regulations',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (err, stack) => Center(
                child: Text('Error: $err'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
