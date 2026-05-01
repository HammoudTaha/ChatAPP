import 'package:chatapp/features/chat/data/models/messgaModel/message_model.dart';
import 'package:chatapp/features/chat/domain/entities/message.dart';
import 'package:isar/isar.dart';

import '../../../../../core/utils/enums.dart';

class ChatLocalDataSource {
  final Isar _isar;
  const ChatLocalDataSource(this._isar);

  Future<void> addOrUpdateMessage(MessageModel message) async {
    await _isar.writeTxn(() async {
      final existingMessage = await _isar.messageModels
          .where()
          .messageIdEqualTo(message.messageId)
          .findFirst();
      if (existingMessage != null) {
        final updatedMessage = existingMessage.copyWith(
          content: message.content,
          createdAt: message.createdAt,
          status: message.status,
        );
        await _isar.messageModels.put(updatedMessage);
      } else {
        await _isar.messageModels.put(message);
      }
    });
  }

  Future<void> updateMessageStatus(
    String messageId, [
    MessageStatus status = MessageStatus.sent,
  ]) async {
    await _isar.writeTxn(() async {
      final message = await _isar.messageModels
          .where()
          .messageIdEqualTo(messageId)
          .findFirst();
      if (message != null) {
        await _isar.messageModels.put(message.copyWith(status: status));
      }
    });
  }

  Future<void> deleteAllChatMessages(String chatId) async {
    await _isar.writeTxn(() async {
      _isar.messageModels.where().filter().chatIdEqualTo(chatId).deleteAll();
    });
  }

  Future<List<MessageModel>> getlastMessageAdded() async {
    return await _isar.messageModels.where().findAll();
  }

  Stream<List<Message>> watchMessages(String chatId) async* {
    yield* _isar.messageModels
        .where()
        .chatIdEqualTo(chatId)
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true)
        .map(
          (messageModel) =>
              messageModel.map((model) => model.toEntity()).toList(),
        );
  }

  Stream<List<MessageModel>> watchFailedMessages() async* {
    yield* _isar.messageModels
        .where()
        .statusEqualTo(MessageStatus.failed)
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true);
  }

    Stream<List<MessageModel>> watchSentMessages() async* {
    yield* _isar.messageModels
        .where()
        .statusEqualTo(MessageStatus.failed)
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true);
  }

  void deleteAllMessages() {
    _isar.writeTxn(() async {
      _isar.messageModels.where().deleteAll();
    });
  }
}
