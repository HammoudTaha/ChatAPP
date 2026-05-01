import 'package:chatapp/core/utils/enums.dart';

import '../../../domain/entities/message.dart';

class MessageModel {
  String id;
  final String chatId;
  final String senderId;
  final String content;
  final DateTime createdAt;
  final MessageStatus status;
  MessageModel({
    required this.id,
    required this.senderId,
    required this.content,
    required this.createdAt,
    required this.chatId,
    required this.status,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'].toString(),
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
      id: id,
      chatId: chatId,
      senderId: senderId,
      content: content,
      createdAt: createdAt,
      status: status,
    );
  }

  static MessageModel fromEntity(Message message) {
    return MessageModel(
      id: message.id,
      chatId: message.chatId,
      content: message.content,
      senderId: message.senderId,
      createdAt: message.createdAt,
      status: message.status,
    );
  }
}
