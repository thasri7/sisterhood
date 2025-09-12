import 'package:hive/hive.dart';

part 'group_model.g.dart';

@HiveType(typeId: 1)
class GroupModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String creatorId;

  @HiveField(4)
  final List<String> memberIds;

  @HiveField(5)
  final String? imageUrl;

  @HiveField(6)
  final List<String> tags;

  @HiveField(7)
  final String category;

  @HiveField(8)
  final bool isPrivate;

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final DateTime updatedAt;

  @HiveField(11)
  final int memberCount;

  GroupModel({
    required this.id,
    required this.name,
    required this.description,
    required this.creatorId,
    this.memberIds = const [],
    this.imageUrl,
    this.tags = const [],
    required this.category,
    this.isPrivate = false,
    required this.createdAt,
    required this.updatedAt,
    this.memberCount = 0,
  });

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      creatorId: map['creatorId'] ?? '',
      memberIds: List<String>.from(map['memberIds'] ?? []),
      imageUrl: map['imageUrl'],
      tags: List<String>.from(map['tags'] ?? []),
      category: map['category'] ?? '',
      isPrivate: map['isPrivate'] ?? false,
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
      memberCount: map['memberCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'creatorId': creatorId,
      'memberIds': memberIds,
      'imageUrl': imageUrl,
      'tags': tags,
      'category': category,
      'isPrivate': isPrivate,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'memberCount': memberCount,
    };
  }

  GroupModel copyWith({
    String? id,
    String? name,
    String? description,
    String? creatorId,
    List<String>? memberIds,
    String? imageUrl,
    List<String>? tags,
    String? category,
    bool? isPrivate,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? memberCount,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      creatorId: creatorId ?? this.creatorId,
      memberIds: memberIds ?? this.memberIds,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      isPrivate: isPrivate ?? this.isPrivate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      memberCount: memberCount ?? this.memberCount,
    );
  }
}