import 'package:chatapp/core/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
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
      senderId: json['senderId'].toString(),
      content: json['content'],
      createdAt:
          (json['createdAt'] as firestore.Timestamp?)?.toDate() ??
          DateTime.now(),
      chatId: json['chatId'],
      status: json['status'] == 'sent'
          ? MessageStatus.sent
          : json['status'] == 'delivered'
          ? MessageStatus.delivered
          : MessageStatus.seen,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': messageId,
    'senderId': senderId,
    'content': content,
    'chatId': chatId,
    'createdAt': createdAt,
  };

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
