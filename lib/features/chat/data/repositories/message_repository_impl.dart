import 'dart:async';
import '../../../../core/utils/enums.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/local/chat_local_data_source.dart';
import '../datasources/remote/chat_remote_data_source.dart';
import '../models/messgaModel/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatLocalDataSource _chatLocalDataSource;
  final ChatRemoteDataSource _chatRemoteDataSource;
  ChatRepositoryImpl(this._chatLocalDataSource, this._chatRemoteDataSource);

  @override
  Future<void> sendLocalMessage(Message message) async {
    try {
      await _chatLocalDataSource.addOrUpdateMessage(
        MessageModel.fromEntity(message),
      );
      await sendRemoteMessage(message);
    } catch (_) {}
  }

  @override
  Future<void> sendRemoteMessage(Message message) async {
    try {
      await _chatRemoteDataSource.sendMessage(message);
      _chatLocalDataSource.updateMessageStatus(message.id, MessageStatus.sent);
    } catch (_) {
      _chatLocalDataSource.updateMessageStatus(
        message.id,
        MessageStatus.failed,
      );
    }
  }

  @override
  Future<void> deleteAllChatMessages(String chatId) async {
    _chatLocalDataSource.deleteAllChatMessages(chatId);
  }

  @override
  Stream<List<Message>> watchMessages(String chatId) async* {
    yield* _chatLocalDataSource.watchMessages(chatId);
  }
}
