import 'package:hive/hive.dart';

part 'message_model.g.dart';

@HiveType(typeId: 3)
class MessageModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final String senderId;

  @HiveField(3)
  final String groupId;

  @HiveField(4)
  final DateTime timestamp;

  @HiveField(5)
  final String? imageUrl;

  @HiveField(6)
  final MessageType type;

  @HiveField(7)
  final bool isRead;

  @HiveField(8)
  final List<String> readBy;

  @HiveField(9)
  final String? replyToMessageId;

  @HiveField(10)
  final Map<String, dynamic>? metadata;

  MessageModel({
    required this.id,
    required this.content,
    required this.senderId,
    required this.groupId,
    required this.timestamp,
    this.imageUrl,
    this.type = MessageType.text,
    this.isRead = false,
    this.readBy = const [],
    this.replyToMessageId,
    this.metadata,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
      senderId: map['senderId'] ?? '',
      groupId: map['groupId'] ?? '',
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      imageUrl: map['imageUrl'],
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${map['type']}',
        orElse: () => MessageType.text,
      ),
      isRead: map['isRead'] ?? false,
      readBy: List<String>.from(map['readBy'] ?? []),
      replyToMessageId: map['replyToMessageId'],
      metadata: map['metadata'] != null ? Map<String, dynamic>.from(map['metadata']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'senderId': senderId,
      'groupId': groupId,
      'timestamp': timestamp.toIso8601String(),
      'imageUrl': imageUrl,
      'type': type.toString().split('.').last,
      'isRead': isRead,
      'readBy': readBy,
      'replyToMessageId': replyToMessageId,
      'metadata': metadata,
    };
  }

  MessageModel copyWith({
    String? id,
    String? content,
    String? senderId,
    String? groupId,
    DateTime? timestamp,
    String? imageUrl,
    MessageType? type,
    bool? isRead,
    List<String>? readBy,
    String? replyToMessageId,
    Map<String, dynamic>? metadata,
  }) {
    return MessageModel(
      id: id ?? this.id,
      content: content ?? this.content,
      senderId: senderId ?? this.senderId,
      groupId: groupId ?? this.groupId,
      timestamp: timestamp ?? this.timestamp,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      readBy: readBy ?? this.readBy,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      metadata: metadata ?? this.metadata,
    );
  }
}

@HiveType(typeId: 4)
enum MessageType {
  @HiveField(0)
  text,
  @HiveField(1)
  image,
  @HiveField(2)
  file,
  @HiveField(3)
  system,
}