import 'package:isar/isar.dart';

import '../../../../core/utils/enums.dart';
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
  @Index()
  final DateTime lastMessageAt;
  final int unreadCount;

  const ChatModel({
    required this.chatId,
    required this.title,
    required this.type,
    required this.lastMessageAt,
    this.unreadCount = 0,
    required this.participantIds,
  });
}
