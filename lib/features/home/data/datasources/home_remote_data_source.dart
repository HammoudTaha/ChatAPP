import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/utils/di.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../models/chat_model.dart';

class HomeRemoteDataSource {
  final ApiService _apiService;
  final FirebaseFirestore _firestore;
  const HomeRemoteDataSource(this._apiService, this._firestore);

  Future<void> checkPhoneFoundOnChat(String phone) async {
    await _apiService.request(
      endpoint: '${AppStrings.user}${AppStrings.checkPhoneExistence}',
      data: {'phone': phone},
    );
  }

  Future<void> saveChat(ChatModel chat) async {
    await _firestore.collection(AppStrings.chats).doc(chat.chatId).set({
      'chatId': chat.chatId,
      'title': chat.title,
      'type': chat.type.name,
      'participantIds': chat.participantIds,
      'lastMessage': null,
      'lastMessageAt': null,
      'unreadCount': chat.unreadCount,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    final batch = _firestore.batch();
    for (final particiantId in chat.participantIds) {
      final userChatRef = _firestore
          .collection(AppStrings.userChats)
          .doc(particiantId)
          .collection(AppStrings.chats)
          .doc(chat.chatId);
      batch.set(userChatRef, {
        'chatId': chat.chatId,
        'type': chat.type.name,
        'title': getIt<AuthBloc>().state.user?.phone == particiantId
            ? chat.title
            : getIt<AuthBloc>().state.user?.phone,
        'lastMessage': null,
        'lastMessageAt': null,
        'participantIds': chat.participantIds,
        'unreadCount': chat.unreadCount,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  Stream<List<ChatModel>> getChats(String userId) async* {
    yield* _firestore
        .collection(AppStrings.userChats)
        .doc(userId)
        .collection(AppStrings.chats)
        .where('lastMessageAt', isNull: false)
        .orderBy('lastMessageAt', descending: true)
        .snapshots(includeMetadataChanges: true)
        .map((event) {
          List<ChatModel> chats = [];
          for (var doc in event.docs) {
            chats.add(ChatModel.fromJson(doc.data()));
          }
          return chats;
        });
  }
}
