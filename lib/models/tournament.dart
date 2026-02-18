/// Tournament model representing a sports tournament in PlayTrack.
/// Contains tournament details, dates, and sport information.
class Tournament {
  final String id;
  final String name;
  final String sport; // e.g., 'Football', 'Cricket', 'Basketball', 'Volleyball'
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String? bannerImageUrl;
  final String status; // 'upcoming', 'ongoing', 'completed'
  final int maxTeams;
  final List<String> registeredTeams; // List of team IDs
  final String createdBy; // User ID of creator
  final DateTime createdAt;
  final String prizePool; // e.g., "$5000"
  final String? rulesUrl;

  Tournament({
    required this.id,
    required this.name,
    required this.sport,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    this.bannerImageUrl,
    required this.status,
    required this.maxTeams,
    required this.registeredTeams,
    required this.createdBy,
    required this.createdAt,
    required this.prizePool,
    this.rulesUrl,
  });

  /// Convert Tournament to JSON for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sport': sport,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'location': location,
      'bannerImageUrl': bannerImageUrl,
      'status': status,
      'maxTeams': maxTeams,
      'registeredTeams': registeredTeams,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'prizePool': prizePool,
      'rulesUrl': rulesUrl,
    };
  }

  /// Create Tournament from Firestore document data
  factory Tournament.fromMap(String id, Map<String, dynamic> map) {
    return Tournament(
      id: id,
      name: map['name'] ?? '',
      sport: map['sport'] ?? '',
      description: map['description'] ?? '',
      startDate: map['startDate'] != null
          ? (map['startDate'] as dynamic).toDate()
          : DateTime.now(),
      endDate: map['endDate'] != null
          ? (map['endDate'] as dynamic).toDate()
          : DateTime.now(),
      location: map['location'] ?? '',
      bannerImageUrl: map['bannerImageUrl'],
      status: map['status'] ?? 'upcoming',
      maxTeams: map['maxTeams'] ?? 16,
      registeredTeams: List<String>.from(map['registeredTeams'] ?? []),
      createdBy: map['createdBy'] ?? '',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
      prizePool: map['prizePool'] ?? '\$0',
      rulesUrl: map['rulesUrl'],
    );
  }

  /// Check if tournament is upcoming
  bool get isUpcoming => DateTime.now().isBefore(startDate);

  /// Check if tournament is ongoing
  bool get isOngoing => DateTime.now().isAfter(startDate) && DateTime.now().isBefore(endDate);

  /// Check if tournament is completed
  bool get isCompleted => DateTime.now().isAfter(endDate);

  /// Check if registration is open
  bool get isRegistrationOpen => isUpcoming && registeredTeams.length < maxTeams;

  /// Create a copy with modifications
  Tournament copyWith({
    String? id,
    String? name,
    String? sport,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? location,
    String? bannerImageUrl,
    String? status,
    int? maxTeams,
    List<String>? registeredTeams,
    String? createdBy,
    DateTime? createdAt,
    String? prizePool,
    String? rulesUrl,
  }) {
    return Tournament(
      id: id ?? this.id,
      name: name ?? this.name,
      sport: sport ?? this.sport,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      location: location ?? this.location,
      bannerImageUrl: bannerImageUrl ?? this.bannerImageUrl,
      status: status ?? this.status,
      maxTeams: maxTeams ?? this.maxTeams,
      registeredTeams: registeredTeams ?? this.registeredTeams,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      prizePool: prizePool ?? this.prizePool,
      rulesUrl: rulesUrl ?? this.rulesUrl,
    );
  }
}
