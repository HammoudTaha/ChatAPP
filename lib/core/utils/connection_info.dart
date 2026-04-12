import 'dart:async';
import 'package:chatapp/core/utils/di.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../features/chat/data/repositories/message_sync_manager.dart';
import '../services/web_socket_service.dart';

class ConnectionInfo {
  final Connectivity _connectivity;
  ConnectionInfo(this._connectivity);
  Future<bool> get isConnected async {
    final List<ConnectivityResult> connectivityResult = await _connectivity
        .checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.mobile)) {
      return true;
    }
    return false;
  }

  void listenToConnectionChanges() {
    _connectivity.onConnectivityChanged.listen((event) {
      if (event.contains(ConnectivityResult.mobile)) {
        getIt<WebSocketService>().connect();
        getIt<MessageSyncManager>().start();
      } else {
        getIt<WebSocketService>().disconnect();
        getIt<MessageSyncManager>().stop();
      }
    });
  }
}
