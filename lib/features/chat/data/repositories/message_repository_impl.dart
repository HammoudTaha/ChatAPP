import 'dart:async';
import '../../../../core/utils/connection_info.dart';
import '../../../../core/utils/enums.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/local/chat_local_data_source.dart';
import '../datasources/remote/chat_remote_data_source.dart';
import '../models/messgaModel/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatLocalDataSource _chatLocalDataSource;
  final ChatRemoteDataSource _chatRemoteDataSource;
  final ConnectionInfo _connectionInfo;
  const ChatRepositoryImpl(
    this._chatLocalDataSource,
    this._chatRemoteDataSource,
    this._connectionInfo,
  );

  @override
  Future<void> sendLocalMessage(Message message) async {
    try {
      await _chatLocalDataSource.addOrUpdateMessage(
        MessageModel.fromEntity(message),
      );
      await sendRemoteMessage(message);
    } catch (_) {}
  }

  Future<void> updateStatusToSeen(List<Message> messages) async {
    await _chatRemoteDataSource.updateStatusToSeen(
      messages.map((e) => MessageModel.fromEntity(e)).toList(),
    );
  }

  @override
  Future<void> sendRemoteMessage(Message message) async {
    try {
      if (await _connectionInfo.isConnected) {
        await _chatRemoteDataSource.sendMessage(
          MessageModel.fromEntity(message),
        );
        _chatLocalDataSource.updateMessageStatus(
          message.id,
          MessageStatus.sent,
        );
      } else {
        _chatLocalDataSource.updateMessageStatus(
          message.id,
          MessageStatus.failed,
        );
      }
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
