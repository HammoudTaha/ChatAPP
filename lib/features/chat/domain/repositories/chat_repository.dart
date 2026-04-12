import '../entities/message.dart';

abstract class ChatRepository {
  Stream<List<Message>> watchMessages(String chatId);
  void sendLocalMessage(Message message);
  void sendRemoteMessage(Message message);
  Future<void> deleteAllChatMessages(String chatId);
}
