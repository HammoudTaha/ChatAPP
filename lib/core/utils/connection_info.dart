import 'dart:async';
import 'package:chatapp/core/utils/di.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../features/chat/data/repositories/message_sync_to_firestore_manager.dart';
import '../../features/chat/data/repositories/message_sync_to_isar_manager.dart';
import '../../features/home/data/repositories/chat_sync_to_isar_manager.dart';

class ConnectionInfo {
  final Connectivity _connectivity;
  ConnectionInfo(this._connectivity);
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Future<bool> get isConnected async {
    final List<ConnectivityResult> connectivityResult = await _connectivity
        .checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      return true;
    }
    return false;
  }

  void listenToConnectionChanges() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      event,
    ) {
      if (event.contains(ConnectivityResult.mobile)) {
        getIt<MessageSyncToFirestoreManager>().start();
        getIt<MessageSyncToIsarManager>().start();
        getIt<ChatSyncToIsarManager>().startSync();
      } else {
        getIt<MessageSyncToFirestoreManager>().stop();
        getIt<MessageSyncToIsarManager>().stop();
        getIt<ChatSyncToIsarManager>().stopSync();
      }
    });
  }
}
