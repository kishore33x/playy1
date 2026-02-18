/// Match model representing a game/match between two teams in a tournament.
class Match {
  final String id;
  final String tournamentId;
  final String teamAId;
  final String teamBId;
  final String sport;
  
  // Score data (flexible to accommodate different sports)
  final Map<String, dynamic> scoreTeamA;
  final Map<String, dynamic> scoreTeamB;
  
  final String status; // 'scheduled', 'ongoing', 'completed'
  final DateTime scheduledTime;
  final DateTime? startTime;
  final DateTime? endTime;
  
  final String venue;
  final String? refereeId;
  
  // Match events timeline
  final List<MatchEvent> events;
  
  final DateTime createdAt;

  Match({
    required this.id,
    required this.tournamentId,
    required this.teamAId,
    required this.teamBId,
    required this.sport,
    Map<String, dynamic>? scoreTeamA,
    Map<String, dynamic>? scoreTeamB,
    required this.status,
    required this.scheduledTime,
    this.startTime,
    this.endTime,
    required this.venue,
    this.refereeId,
    List<MatchEvent>? events,
    required this.createdAt,
  })  : scoreTeamA = scoreTeamA ?? _getDefaultScore(sport),
        scoreTeamB = scoreTeamB ?? _getDefaultScore(sport),
        events = events ?? [];

  /// Get default score structure based on sport
  static Map<String, dynamic> _getDefaultScore(String sport) {
    switch (sport.toLowerCase()) {
      case 'football':
        return {'goals': 0};
      case 'cricket':
        return {'runs': 0, 'wickets': 0, 'overs': 0.0};
      case 'basketball':
        return {'points': 0, 'q1': 0, 'q2': 0, 'q3': 0, 'q4': 0};
      case 'volleyball':
        return {'points': 0, 's1': 0, 's2': 0, 's3': 0};
      default:
        return {'score': 0};
    }
  }

  /// Convert Match to JSON for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tournamentId': tournamentId,
      'teamAId': teamAId,
      'teamBId': teamBId,
      'sport': sport,
      'scoreTeamA': scoreTeamA,
      'scoreTeamB': scoreTeamB,
      'status': status,
      'scheduledTime': scheduledTime,
      'startTime': startTime,
      'endTime': endTime,
      'venue': venue,
      'refereeId': refereeId,
      'events': events.map((e) => e.toMap()).toList(),
      'createdAt': createdAt,
    };
  }

  /// Create Match from Firestore document data
  factory Match.fromMap(String id, Map<String, dynamic> map) {
    return Match(
      id: id,
      tournamentId: map['tournamentId'] ?? '',
      teamAId: map['teamAId'] ?? '',
      teamBId: map['teamBId'] ?? '',
      sport: map['sport'] ?? '',
      scoreTeamA: map['scoreTeamA'] ?? _getDefaultScore(map['sport'] ?? ''),
      scoreTeamB: map['scoreTeamB'] ?? _getDefaultScore(map['sport'] ?? ''),
      status: map['status'] ?? 'scheduled',
      scheduledTime: map['scheduledTime'] != null
          ? (map['scheduledTime'] as dynamic).toDate()
          : DateTime.now(),
      startTime: map['startTime'] != null ? (map['startTime'] as dynamic).toDate() : null,
      endTime: map['endTime'] != null ? (map['endTime'] as dynamic).toDate() : null,
      venue: map['venue'] ?? '',
      refereeId: map['refereeId'],
      events: (map['events'] as List?)
              ?.map((e) => MatchEvent.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
    );
  }

  /// Determine winner (returns 'A', 'B', or 'Draw')
  String? getWinner() {
    if (status != 'completed') return null;
    
    // Compare primary score based on sport
    int scoreA = _getPrimaryScore(scoreTeamA);
    int scoreB = _getPrimaryScore(scoreTeamB);
    
    if (scoreA > scoreB) return 'A';
    if (scoreB > scoreA) return 'B';
    return 'Draw';
  }

  /// Get primary score value based on sport
  int _getPrimaryScore(Map<String, dynamic> score) {
    if (score.containsKey('goals')) return score['goals'] as int;
    if (score.containsKey('runs')) return score['runs'] as int;
    if (score.containsKey('points')) return score['points'] as int;
    return 0;
  }

  /// Create a copy with modifications
  Match copyWith({
    String? id,
    String? tournamentId,
    String? teamAId,
    String? teamBId,
    String? sport,
    Map<String, dynamic>? scoreTeamA,
    Map<String, dynamic>? scoreTeamB,
    String? status,
    DateTime? scheduledTime,
    DateTime? startTime,
    DateTime? endTime,
    String? venue,
    String? refereeId,
    List<MatchEvent>? events,
    DateTime? createdAt,
  }) {
    return Match(
      id: id ?? this.id,
      tournamentId: tournamentId ?? this.tournamentId,
      teamAId: teamAId ?? this.teamAId,
      teamBId: teamBId ?? this.teamBId,
      sport: sport ?? this.sport,
      scoreTeamA: scoreTeamA ?? this.scoreTeamA,
      scoreTeamB: scoreTeamB ?? this.scoreTeamB,
      status: status ?? this.status,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      venue: venue ?? this.venue,
      refereeId: refereeId ?? this.refereeId,
      events: events ?? this.events,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Match event model for tracking goals, wickets, etc.
class MatchEvent {
  final String id;
  final String type; // 'goal', 'wicket', 'yellow_card', 'red_card', 'assist', etc.
  final String playerId;
  final String team; // 'A' or 'B'
  final String description;
  final int minute;
  final DateTime timestamp;

  MatchEvent({
    required this.id,
    required this.type,
    required this.playerId,
    required this.team,
    required this.description,
    required this.minute,
    required this.timestamp,
  });

  /// Convert to JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'playerId': playerId,
      'team': team,
      'description': description,
      'minute': minute,
      'timestamp': timestamp,
    };
  }

  /// Create from JSON
  factory MatchEvent.fromMap(Map<String, dynamic> map) {
    return MatchEvent(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      playerId: map['playerId'] ?? '',
      team: map['team'] ?? 'A',
      description: map['description'] ?? '',
      minute: map['minute'] ?? 0,
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] as dynamic).toDate()
          : DateTime.now(),
    );
  }
}
