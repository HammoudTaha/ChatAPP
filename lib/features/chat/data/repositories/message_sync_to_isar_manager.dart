import 'dart:async';
import 'package:chatapp/features/home/data/datasources/home_local_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../datasources/local/chat_local_data_source.dart';
import '../datasources/remote/chat_remote_data_source.dart';
import '../models/messgaModel/message_model.dart';

class MessageSyncToIsarManager {
  final ChatLocalDataSource _local;
  final ChatRemoteDataSource _remote;
  final HomeLocalDataSource _homeLocalDataSource;
  MessageSyncToIsarManager(
    this._local,
    this._remote,
    this._homeLocalDataSource,
  );
  final Map<String, StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>
  _chatSubs = {};
  void start() {
    _homeLocalDataSource.watchUnListenedChatIds(_chatSubs.keys.toList()).listen(
      (chatIds) {
        for (final chatId in chatIds) {
          if (!_chatSubs.containsKey(chatId)) {
            _startChatListener(chatId);
          }
        }
      },
    );
  }

  void _startChatListener(String chatId) {
    if (_chatSubs.containsKey(chatId)) return;
    _chatSubs[chatId] = _remote.getMessages(chatId).listen((event) async {
      final writes = <Future>[];
      for (final change in event.docChanges) {
        final data = change.doc.data() as Map<String, dynamic>;
        final message = MessageModel.fromJson(data);
        switch (change.type) {
          case DocumentChangeType.added:
          case DocumentChangeType.modified:
            writes.add(_local.addOrUpdateMessage(message));
            break;
          case DocumentChangeType.removed:
            break;
        }
      }
      await Future.wait(writes);
      await _remote.updateStatusToDelivered(
        event.docChanges.where(
          (change) => change.type == DocumentChangeType.added,
        ).toList(),
      );
    });
  }

  Future<void> stop() async {
    await Future.wait(_chatSubs.values.map((sub) => sub.cancel()));
    _chatSubs.clear();
  }
}
