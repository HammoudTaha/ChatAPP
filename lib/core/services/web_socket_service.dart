import 'dart:async';
import 'dart:convert';
import 'package:chatapp/core/constants/strings.dart';
import 'package:chatapp/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import '../../features/chat/data/datasources/local/chat_local_data_source.dart';
import '../../features/chat/data/datasources/remote/chat_remote_data_source.dart';
import '../../features/chat/data/models/messgaModel/message_model.dart';
import '../utils/di.dart';
import '../utils/enums.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final ChatLocalDataSource _chatLocalDataSource;
  final ChatRemoteDataSource _chatRemoteDataSource;
  int _deley = 1;
  bool _isClosed = false;
  bool _isConnecting = false;
  final Future<String> Function() getToken;
  final String chatId;
  WebSocketService(
    this.getToken,
    this.chatId,
    this._chatLocalDataSource,
    this._chatRemoteDataSource,
  );
  StreamSubscription? _subscription;

  void connect() async {
    if (_isConnecting || _isClosed) return;
    _isConnecting = true;
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('ws://10.0.2.2:8080/app/wkyhpuhhotlpymljcr2t'),
      );
      _subscription = _channel?.stream.listen(
        _onData,
        onError: (error) {
          _reconnect();
        },
        onDone: () {
          _reconnect();
        },
        cancelOnError: true,
      );
      _deley = 1;
    } catch (e) {
      _reconnect();
    } finally {
      _isConnecting = false;
    }
  }

  void _onData(dynamic data) async {
    print('Received data: $data');
    try {
      final message = jsonDecode(data);
      final event = message['event'];
      switch (event) {
        case 'pusher:ping':
          _pingPong({'event': 'pusher:pong'});
          break;
        case 'pusher:connection_established':
          _channel?.sink.add(
            jsonEncode({
              "event": "pusher:subscribe",
              "data": {"channel": "chat"},
            }),
          );
          // String soketId = jsonDecode(message["data"])["socket_id"];
          // String? authToken = await _onAuthenticate(soketId);
          // if (authToken != null) {
          //   _onSubscribe(authToken);
          // }
          _deley = 1;
          break;
        case 'message.sent':
          print('BBBBBBBBBBBBBBBBBBBBBBB');
          final json = jsonDecode(message['data'])['message'];
          print('Received message: $json');
          // final messageModel = MessageModel.fromJson(json);
          //  _chatLocalDataSource.addOrUpdateMessage(messageModel);
          // if (getIt<AuthBloc>().state.user!.id != messageModel.senderId &&
          //   messageModel.status == MessageStatus.sent) {
          // await _chatRemoteDataSource.updateMessageStatus(
          //   messageModel.messageId,
          //   MessageStatus.delivered,
          // );
          ///}
          break;
      }
    } catch (_) {}
  }

  void _pingPong(Map<String, dynamic> data) {
    try {
      _channel?.sink.add(jsonEncode(data));
    } catch (_) {}
  }

  Future<String?> _onAuthenticate(String socketId) async {
    try {
      final response = await http.post(
        Uri.parse(AppStrings.auth),
        headers: {
          'Authorization': 'Bearer ${(await getToken())}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "socket_id": socketId,
          "channel_name": 'private-chat.$chatId',
        }),
      );
      if (response.statusCode == 200) {
        final authData = jsonDecode(response.body);
        final authToken = authData['auth'];
        return authToken;
      }
    } catch (_) {}
    return null;
  }

  Future<void> _onSubscribe(String authToken) async {
    final subscriptionMessage = {
      'event': 'pusher:subscribe',
      'data': {'auth': authToken, 'channel': 'private-chat.$chatId'},
    };
    _channel?.sink.add(jsonEncode(subscriptionMessage));
  }

  void sendMessage(MessageModel messageModel) {
    print('MMMMMMMMMMMMMMM');
    final message = {
      'event': 'client-send-message',
      'data': {'content': messageModel.content},
      'channel': 'chat',
    };
    try {
      _channel?.sink.add(jsonEncode(message));
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  void _reconnect() {
    if (!_isClosed) {
      Future.delayed(Duration(seconds: _deley), () {
        connect();
      });
      _deley = (_deley * 2).clamp(1, 60);
    }
  }

  void disconnect() async {
    _isClosed = true;
    await _subscription?.cancel();
    await _channel?.sink.close();
  }
}
