/// User model representing a user in the PlayTrack application.
/// Supports both admin and regular users with role-based access control.
class User {
  final String uid;
  final String email;
  final String name;
  final String role; // 'admin' or 'user'
  final String? phoneNumber;
  final String? profileImageUrl;
  final DateTime createdAt;
  final bool isActive;

  User({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.phoneNumber,
    this.profileImageUrl,
    required this.createdAt,
    this.isActive = true,
  });

  /// Convert User to JSON for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt,
      'isActive': isActive,
    };
  }

  /// Create User from Firestore document data
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? 'user',
      phoneNumber: map['phoneNumber'],
      profileImageUrl: map['profileImageUrl'],
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
      isActive: map['isActive'] ?? true,
    );
  }

  /// Check if user is an admin
  bool get isAdmin => role == 'admin';

  /// Create a copy with modifications
  User copyWith({
    String? uid,
    String? email,
    String? name,
    String? role,
    String? phoneNumber,
    String? profileImageUrl,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
