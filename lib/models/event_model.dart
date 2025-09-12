import 'package:hive/hive.dart';

part 'event_model.g.dart';

@HiveType(typeId: 2)
class EventModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String organizerId;

  @HiveField(4)
  final String groupId;

  @HiveField(5)
  final DateTime startTime;

  @HiveField(6)
  final DateTime endTime;

  @HiveField(7)
  final String location;

  @HiveField(8)
  final double latitude;

  @HiveField(9)
  final double longitude;

  @HiveField(10)
  final List<String> attendeeIds;

  @HiveField(11)
  final int maxAttendees;

  @HiveField(12)
  final String? imageUrl;

  @HiveField(13)
  final String category;

  @HiveField(14)
  final bool isOnline;

  @HiveField(15)
  final DateTime createdAt;

  @HiveField(16)
  final DateTime updatedAt;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.organizerId,
    required this.groupId,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.attendeeIds = const [],
    this.maxAttendees = 50,
    this.imageUrl,
    required this.category,
    this.isOnline = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      organizerId: map['organizerId'] ?? '',
      groupId: map['groupId'] ?? '',
      startTime: DateTime.parse(map['startTime'] ?? DateTime.now().toIso8601String()),
      endTime: DateTime.parse(map['endTime'] ?? DateTime.now().toIso8601String()),
      location: map['location'] ?? '',
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      attendeeIds: List<String>.from(map['attendeeIds'] ?? []),
      maxAttendees: map['maxAttendees'] ?? 50,
      imageUrl: map['imageUrl'],
      category: map['category'] ?? '',
      isOnline: map['isOnline'] ?? false,
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'organizerId': organizerId,
      'groupId': groupId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'attendeeIds': attendeeIds,
      'maxAttendees': maxAttendees,
      'imageUrl': imageUrl,
      'category': category,
      'isOnline': isOnline,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? organizerId,
    String? groupId,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    double? latitude,
    double? longitude,
    List<String>? attendeeIds,
    int? maxAttendees,
    String? imageUrl,
    String? category,
    bool? isOnline,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      organizerId: organizerId ?? this.organizerId,
      groupId: groupId ?? this.groupId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      attendeeIds: attendeeIds ?? this.attendeeIds,
      maxAttendees: maxAttendees ?? this.maxAttendees,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      isOnline: isOnline ?? this.isOnline,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}