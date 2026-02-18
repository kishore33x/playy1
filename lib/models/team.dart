/// Team model representing a sports team in PlayTrack tournaments.
class Team {
  final String id;
  final String name;
  final String shortCode; // e.g., "MU" for Manchester United
  final String? logoUrl;
  final String coach;
  final List<String> playerIds;
  final int wins;
  final int losses;
  final int draws;
  final int points; // Total tournament points
  final DateTime createdAt;

  Team({
    required this.id,
    required this.name,
    required this.shortCode,
    this.logoUrl,
    required this.coach,
    required this.playerIds,
    this.wins = 0,
    this.losses = 0,
    this.draws = 0,
    this.points = 0,
    required this.createdAt,
  });

  /// Convert Team to JSON for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'shortCode': shortCode,
      'logoUrl': logoUrl,
      'coach': coach,
      'playerIds': playerIds,
      'wins': wins,
      'losses': losses,
      'draws': draws,
      'points': points,
      'createdAt': createdAt,
    };
  }

  /// Create Team from Firestore document data
  factory Team.fromMap(String id, Map<String, dynamic> map) {
    return Team(
      id: id,
      name: map['name'] ?? '',
      shortCode: map['shortCode'] ?? '',
      logoUrl: map['logoUrl'],
      coach: map['coach'] ?? '',
      playerIds: List<String>.from(map['playerIds'] ?? []),
      wins: map['wins'] ?? 0,
      losses: map['losses'] ?? 0,
      draws: map['draws'] ?? 0,
      points: map['points'] ?? 0,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
    );
  }

  /// Calculate win-loss-draw record
  String get record => '$wins-$losses-$draws';

  /// Create a copy with modifications
  Team copyWith({
    String? id,
    String? name,
    String? shortCode,
    String? logoUrl,
    String? coach,
    List<String>? playerIds,
    int? wins,
    int? losses,
    int? draws,
    int? points,
    DateTime? createdAt,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      shortCode: shortCode ?? this.shortCode,
      logoUrl: logoUrl ?? this.logoUrl,
      coach: coach ?? this.coach,
      playerIds: playerIds ?? this.playerIds,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      draws: draws ?? this.draws,
      points: points ?? this.points,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
