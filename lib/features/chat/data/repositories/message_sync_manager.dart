import 'dart:async';
import 'dart:collection';
import '../../../../core/utils/enums.dart';
import '../../domain/entities/message.dart';
import '../datasources/local/chat_local_data_source.dart';
import '../datasources/remote/chat_remote_data_source.dart';

class MessageSyncManager {
  final ChatLocalDataSource _local;
  final ChatRemoteDataSource _remote;
  final Queue<Message> _queue = Queue();
  final Set<String> _inProgress = <String>{};
  StreamSubscription? _syncSub;
  bool _isClosed = false;
  bool _isSyncing = false;

  MessageSyncManager(this._local, this._remote);
  void start() {
    _syncSub?.cancel();
    _isClosed = true;
    _syncSub = _local.watchFailedMessages().listen((event) {
      if (event.isNotEmpty) {
        _enqueue(event);
      }
    });
  }

  void _enqueue(List<Message> messages) async {
    for (final msg in messages) {
      if (!_inProgress.contains(msg.id) && !_queue.any((m) => m.id == msg.id)) {
        _queue.add(msg);
      }
    }
    if (_isSyncing || !_isClosed) return;
    _isSyncing = true;
    try {
      while (_queue.isNotEmpty) {
        final msg = _queue.removeFirst();
        _inProgress.add(msg.id);
        await _sendRemoteMessage(msg);
        _inProgress.remove(msg.id);
      }
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _sendRemoteMessage(Message message) async {
    try {
      await _remote.sendMessage(message);
      _local.updateMessageStatus(message.id, MessageStatus.sent);
    } catch (_) {
      _local.updateMessageStatus(message.id, MessageStatus.failed);
    }
  }

  Future<void> stop() async {
    await _syncSub?.cancel();
    _syncSub = null;
    _isClosed = false;
  }
}
