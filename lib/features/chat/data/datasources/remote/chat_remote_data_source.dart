import 'package:chatapp/core/constants/strings.dart';
import 'package:chatapp/core/services/api_service.dart';
import 'package:chatapp/core/utils/enums.dart';
import 'package:chatapp/features/auth/data/datasources/local/auth_local_data_source.dart';

import '../../../domain/entities/message.dart';

class ChatRemoteDataSource {
  final AuthLocalDataSource _authLocalDataSource;
  final ApiService _apiService;
  const ChatRemoteDataSource(this._apiService, this._authLocalDataSource);

  Future<void> sendMessage(Message message) async {
    await _apiService.request(
      method: HttpMethods.post,
      endpoint: AppStrings.sendMessage,
      data: {
        'id': message.id,
        'chat_id': message.chatId,
        'message': message.content,
      },
      token: (await _authLocalDataSource.getAccessToken()).token,
    );
  }

  Future<void> updateMessageStatus(
    String messageId,
    MessageStatus status,
  ) async {
    await _apiService.request(
      method: HttpMethods.post,
      endpoint: AppStrings.updateMessageStatus,
      data: {'message_id': messageId, 'status': status.name},
      token: (await _authLocalDataSource.getAccessToken()).token,
    );
  }
}
