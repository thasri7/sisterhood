import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? profileImageUrl;

  @HiveField(4)
  final String bio;

  @HiveField(5)
  final List<String> interests;

  @HiveField(6)
  final double latitude;

  @HiveField(7)
  final double longitude;

  @HiveField(8)
  final String city;

  @HiveField(9)
  final int age;

  @HiveField(10)
  final String occupation;

  @HiveField(11)
  final bool isVerified;

  @HiveField(12)
  final List<String> blockedUsers;

  @HiveField(13)
  final DateTime createdAt;

  @HiveField(14)
  final DateTime lastActive;

  @HiveField(15)
  final bool isOnline;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.bio = '',
    this.interests = const [],
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.age,
    this.occupation = '',
    this.isVerified = false,
    this.blockedUsers = const [],
    required this.createdAt,
    required this.lastActive,
    this.isOnline = false,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      bio: map['bio'] ?? '',
      interests: List<String>.from(map['interests'] ?? []),
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      city: map['city'] ?? '',
      age: map['age'] ?? 0,
      occupation: map['occupation'] ?? '',
      isVerified: map['isVerified'] ?? false,
      blockedUsers: List<String>.from(map['blockedUsers'] ?? []),
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      lastActive: DateTime.parse(map['lastActive'] ?? DateTime.now().toIso8601String()),
      isOnline: map['isOnline'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'interests': interests,
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'age': age,
      'occupation': occupation,
      'isVerified': isVerified,
      'blockedUsers': blockedUsers,
      'createdAt': createdAt.toIso8601String(),
      'lastActive': lastActive.toIso8601String(),
      'isOnline': isOnline,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
    String? bio,
    List<String>? interests,
    double? latitude,
    double? longitude,
    String? city,
    int? age,
    String? occupation,
    bool? isVerified,
    List<String>? blockedUsers,
    DateTime? createdAt,
    DateTime? lastActive,
    bool? isOnline,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      city: city ?? this.city,
      age: age ?? this.age,
      occupation: occupation ?? this.occupation,
      isVerified: isVerified ?? this.isVerified,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}