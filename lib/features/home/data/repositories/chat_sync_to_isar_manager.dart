import 'dart:async';

import '../../../../core/utils/di.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../datasources/home_local_data_source.dart';
import '../datasources/home_remote_data_source.dart';

class ChatSyncToIsarManager {
  final HomeLocalDataSource _homeLocalDataSource;
  final HomeRemoteDataSource _homeRemoteDataSource;
  ChatSyncToIsarManager(this._homeLocalDataSource, this._homeRemoteDataSource);
  StreamSubscription? _chatSub;
  Future<void> startSync() async {
    _chatSub = _homeRemoteDataSource
        .getChats(getIt<AuthBloc>().state.user?.phone ?? '')
        .listen((chats) async {
          for (final chat in chats) {
            await _homeLocalDataSource.addOrUpdateChat(chat);
          }
        });
  }

  Future<void> stopSync() async {
    await _chatSub?.cancel();
  }
}
