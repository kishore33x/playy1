/// Player model representing an athlete in PlayTrack tournaments.
/// Stores player statistics based on sport type.
class Player {
  final String id;
  final String name;
  final int jerseyNumber;
  final String position;
  final String sport; // e.g., 'Football', 'Cricket', 'Basketball'
  final String teamId;
  final String? photoUrl;
  
  // Sport-specific statistics
  final Map<String, dynamic> stats; // Flexible stats map for different sports
  
  final DateTime dateOfBirth;
  final DateTime createdAt;

  Player({
    required this.id,
    required this.name,
    required this.jerseyNumber,
    required this.position,
    required this.sport,
    required this.teamId,
    this.photoUrl,
    Map<String, dynamic>? stats,
    required this.dateOfBirth,
    required this.createdAt,
  }) : stats = stats ?? _getDefaultStats(sport);

  /// Get default stats structure based on sport
  static Map<String, dynamic> _getDefaultStats(String sport) {
    switch (sport.toLowerCase()) {
      case 'football':
        return {
          'goals': 0,
          'assists': 0,
          'matches': 0,
          'yellowCards': 0,
          'redCards': 0,
        };
      case 'cricket':
        return {
          'runs': 0,
          'wickets': 0,
          'matches': 0,
          'highestScore': 0,
          'average': 0.0,
        };
      case 'basketball':
        return {
          'points': 0,
          'rebounds': 0,
          'assists': 0,
          'matches': 0,
          'average': 0.0,
        };
      case 'volleyball':
        return {
          'points': 0,
          'matches': 0,
          'aces': 0,
          'blocks': 0,
        };
      default:
        return {'matches': 0};
    }
  }

  /// Convert Player to JSON for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'jerseyNumber': jerseyNumber,
      'position': position,
      'sport': sport,
      'teamId': teamId,
      'photoUrl': photoUrl,
      'stats': stats,
      'dateOfBirth': dateOfBirth,
      'createdAt': createdAt,
    };
  }

  /// Create Player from Firestore document data
  factory Player.fromMap(String id, Map<String, dynamic> map) {
    return Player(
      id: id,
      name: map['name'] ?? '',
      jerseyNumber: map['jerseyNumber'] ?? 0,
      position: map['position'] ?? '',
      sport: map['sport'] ?? '',
      teamId: map['teamId'] ?? '',
      photoUrl: map['photoUrl'],
      stats: map['stats'] ?? _getDefaultStats(map['sport'] ?? ''),
      dateOfBirth: map['dateOfBirth'] != null
          ? (map['dateOfBirth'] as dynamic).toDate()
          : DateTime.now(),
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
    );
  }

  /// Calculate age from date of birth
  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  /// Get formatted stats display text based on sport
  String getStatDisplay(String statKey) {
    final value = stats[statKey];
    if (value == null) return '0';
    if (value is double) return value.toStringAsFixed(2);
    return value.toString();
  }

  /// Create a copy with modifications
  Player copyWith({
    String? id,
    String? name,
    int? jerseyNumber,
    String? position,
    String? sport,
    String? teamId,
    String? photoUrl,
    Map<String, dynamic>? stats,
    DateTime? dateOfBirth,
    DateTime? createdAt,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      jerseyNumber: jerseyNumber ?? this.jerseyNumber,
      position: position ?? this.position,
      sport: sport ?? this.sport,
      teamId: teamId ?? this.teamId,
      photoUrl: photoUrl ?? this.photoUrl,
      stats: stats ?? this.stats,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
