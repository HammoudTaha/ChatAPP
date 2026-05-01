import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:isar/isar.dart';
import '../../../../core/utils/enums.dart';
import '../../domain/entities/chat_entity.dart';
part 'chat_model.g.dart';

@collection
class ChatModel {
  final Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  final String chatId;
  final String title;
  @enumerated
  final ChatType type;
  final List<String> participantIds;
  final String? lastMessage;
  @Index()
  final DateTime? lastMessageAt;
  final int unreadCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChatModel({
    required this.chatId,
    required this.title,
    required this.type,
    this.lastMessageAt,
    required this.createdAt,
    required this.updatedAt,
    this.unreadCount = 0,
    required this.participantIds,
    this.lastMessage,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      chatId: json['chatId'],
      title: json['title'],
      type: ChatType.byName(json['type']),
      participantIds: List<String>.from(json['participantIds']),
      lastMessage: json['lastMessage'],
      lastMessageAt: (json['lastMessageAt'] as firestore.Timestamp?)?.toDate(),
      unreadCount: json['unreadCount'] ?? 0,
      createdAt:
          (json['createdAt'] as firestore.Timestamp?)?.toDate() ??
          DateTime.now(),
      updatedAt:
          (json['updatedAt'] as firestore.Timestamp?)?.toDate() ??
          DateTime.now(),
    );
  }

  static ChatModel fromEntity(ChatEntity entity) {
    return ChatModel(
      chatId: entity.chatId,
      title: entity.title,
      type: entity.type,
      participantIds: entity.participantIds,
      lastMessage: entity.lastMessage,
      lastMessageAt: entity.lastMessageAt,
      unreadCount: entity.unreadCount,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  ChatEntity toEntity() {
    return ChatEntity(
      chatId: chatId,
      title: title,
      type: type,
      participantIds: participantIds,
      lastMessage: lastMessage,
      lastMessageAt: lastMessageAt,
      unreadCount: unreadCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  ChatModel copyWith({
    String? title,
    String? lastMessage,
    DateTime? lastMessageAt,
    int? unreadCount,
    DateTime? updatedAt,
  }) {
    return ChatModel(
      chatId: chatId,
      title: title ?? this.title,
      type: type,
      participantIds: participantIds,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
