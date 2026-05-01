import '../../../../core/utils/enums.dart';

class ChatEntity {
  final String chatId;
  final String title;
  final ChatType type;
  final List<String> participantIds;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatEntity({
    required this.chatId,
    required this.title,
    required this.type,
    required this.participantIds,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });
}
