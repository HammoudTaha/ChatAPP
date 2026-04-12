import 'package:chatapp/core/utils/enums.dart';
import 'package:isar/isar.dart';

import '../../../domain/entities/message.dart';
part 'message_model.g.dart';

@collection
class MessageModel {
  final Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  final String messageId;
  @Index()
  final String chatId;
  final String senderId;
  final String content;
  @Index()
  final DateTime createdAt;
  @Index()
  @enumerated
  final MessageStatus status;
  const MessageModel({
    required this.senderId,
    required this.content,
    required this.createdAt,
    required this.chatId,
    required this.messageId,
    this.status = MessageStatus.sending,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageId: json['id'].toString(),
      senderId: json['sender_id'].toString(),
      content: json['message'],
      createdAt: DateTime.parse(json['created_at']),
      chatId: json['chat_id'],
      status: json['status'] == 'sent'
          ? MessageStatus.sent
          : json['status'] == 'delivered'
          ? MessageStatus.delivered
          : MessageStatus.seen,
    );
  }

  Message toEntity() {
    return Message(
      id: messageId,
      chatId: chatId,
      senderId: senderId,
      content: content,
      createdAt: createdAt,
      status: status,
    );
  }

  MessageModel copyWith({
    String? content,
    DateTime? createdAt,
    MessageStatus? status,
  }) {
    return MessageModel(
      messageId: messageId,
      chatId: chatId,
      senderId: senderId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  static MessageModel fromEntity(Message message) {
    return MessageModel(
      messageId: message.id,
      chatId: message.chatId,
      content: message.content,
      senderId: message.senderId,
      createdAt: message.createdAt,
    );
  }
}
