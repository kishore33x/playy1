/// Registration model for teams registering in tournaments.
class Registration {
  final String id;
  final String tournamentId;
  final String teamId;
  final String status; // 'pending', 'approved', 'rejected'
  final DateTime registeredAt;
  final String? notes;

  Registration({
    required this.id,
    required this.tournamentId,
    required this.teamId,
    required this.status,
    required this.registeredAt,
    this.notes,
  });

  /// Convert Registration to JSON for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tournamentId': tournamentId,
      'teamId': teamId,
      'status': status,
      'registeredAt': registeredAt,
      'notes': notes,
    };
  }

  /// Create Registration from Firestore document data
  factory Registration.fromMap(String id, Map<String, dynamic> map) {
    return Registration(
      id: id,
      tournamentId: map['tournamentId'] ?? '',
      teamId: map['teamId'] ?? '',
      status: map['status'] ?? 'pending',
      registeredAt: map['registeredAt'] != null
          ? (map['registeredAt'] as dynamic).toDate()
          : DateTime.now(),
      notes: map['notes'],
    );
  }

  /// Create a copy with modifications
  Registration copyWith({
    String? id,
    String? tournamentId,
    String? teamId,
    String? status,
    DateTime? registeredAt,
    String? notes,
  }) {
    return Registration(
      id: id ?? this.id,
      tournamentId: tournamentId ?? this.tournamentId,
      teamId: teamId ?? this.teamId,
      status: status ?? this.status,
      registeredAt: registeredAt ?? this.registeredAt,
      notes: notes ?? this.notes,
    );
  }
}
