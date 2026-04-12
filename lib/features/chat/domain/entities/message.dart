import 'package:chatapp/core/utils/enums.dart';

class Message {
  final String id;
  final String chatId;
  final String content;
  final String senderId;
  final DateTime createdAt;
  final MessageStatus status;

  Message({
    required this.id,
    required this.content,
    required this.senderId,
    required this.createdAt,
    this.status = MessageStatus.sending,
    required this.chatId,
  });
}
