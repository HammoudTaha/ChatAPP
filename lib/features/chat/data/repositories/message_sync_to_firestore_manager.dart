import 'dart:async';
import 'dart:collection';
import '../../../../core/utils/enums.dart';
import '../datasources/local/chat_local_data_source.dart';
import '../datasources/remote/chat_remote_data_source.dart';
import '../models/messgaModel/message_model.dart';

class MessageSyncToFirestoreManager {
  final ChatLocalDataSource _local;
  final ChatRemoteDataSource _remote;
  final Queue<MessageModel> _queue = Queue();
  final Set<String> _inProgress = <String>{};
  StreamSubscription? _syncSub;
  bool _isActive = false;
  bool _isSyncing = false;
  MessageSyncToFirestoreManager(this._local, this._remote);
  void start() {
    _syncSub?.cancel();
    _isActive = true;
    _syncSub = _local.watchFailedMessages().listen((event) {
      if (event.isNotEmpty) {
        _enqueue(event);
      }
    });
  }

  void _enqueue(List<MessageModel> messages) async {
    for (final msg in messages) {
      if (!_inProgress.contains(msg.messageId) &&
          !_queue.any((m) => m.messageId == msg.messageId)) {
        _queue.add(msg);
      }
    }
    if (_isSyncing || !_isActive) return;
    _isSyncing = true;
    try {
      while (_queue.isNotEmpty && _isActive) {
        final msg = _queue.removeFirst();
        try {
          _inProgress.add(msg.messageId);
          await _sendRemoteMessage(msg);
        } finally {
          _inProgress.remove(msg.messageId);
        }
      }
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _sendRemoteMessage(MessageModel message) async {
    try {
      await _remote.sendMessage(message);
      _local.updateMessageStatus(message.messageId, MessageStatus.sent);
    } catch (_) {
      _local.updateMessageStatus(message.messageId, MessageStatus.failed);
    }
  }

  Future<void> stop() async {
    await _syncSub?.cancel();
    _syncSub = null;
    _isActive = false;
  }
}
