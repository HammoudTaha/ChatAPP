import 'package:chatapp/core/constants/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/utils/di.dart';
import '../../../../../core/utils/enums.dart';
import '../../../../../core/utils/me.dart';
import '../../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../models/messgaModel/message_model.dart';

class ChatRemoteDataSource {
  final FirebaseFirestore firestore;
  const ChatRemoteDataSource(this.firestore);

  Future<void> sendMessage(MessageModel message) async {
    final batch = firestore.batch();
    batch.set(
      firestore
          .collection(AppStrings.chats)
          .doc(message.chatId)
          .collection(AppStrings.messages)
          .doc(message.messageId),
      {
        'id': message.messageId,
        'content': message.content,
        'senderId': message.senderId,
        'chatId': message.chatId,
        'createdAt': FieldValue.serverTimestamp(),
        'status': MessageStatus.sent.name,
      },
      SetOptions(merge: true),
    );
    final now = FieldValue.serverTimestamp();
    final participants =
        (await firestore.collection(AppStrings.chats).doc(message.chatId).get())
            .get('participantIds') ??
        [];
    for (var userId in participants) {
      final userChatRef = firestore
          .collection(AppStrings.userChats)
          .doc(userId)
          .collection(AppStrings.chats)
          .doc(message.chatId);
      batch.set(userChatRef, {
        'lastMessage': message.content,
        'lastMessageAt': now,
        if (me.phone != userId) 'unreadCount': FieldValue.increment(1),
      }, SetOptions(merge: true));
    }
    await batch.commit();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
    String chatId,
  ) async* {
    yield* firestore
        .collection(AppStrings.chats)
        .doc(chatId)
        .collection(AppStrings.messages)
        .orderBy('createdAt')
        .snapshots(includeMetadataChanges: true);
  }

  Future<void> updateStatusToDelivered(
    List<DocumentChange<Map<String, dynamic>>> docs,
  ) async {
    final batch = firestore.batch();
    for (final doc in docs) {
      final data = doc.doc.data() as Map<String, dynamic>;
      if (doc.doc.metadata.hasPendingWrites) continue;
      if (data['senderId'] == getIt<AuthBloc>().state.user?.phone) continue;
      if ((data['status'] == 'delivered') || (data['status'] == 'seen')) {
        continue;
      }
      batch.update(doc.doc.reference, {'status': 'delivered'});
    }
    await batch.commit();
  }

  Future<void> updateStatusToSeen(List<MessageModel> messages) async {
    firestore.runTransaction((transaction) async {
      final List<Map<String, dynamic>> updates = [];
      for (final message in messages) {
        final docRef = firestore
            .collection(AppStrings.chats)
            .doc(message.chatId)
            .collection(AppStrings.messages)
            .doc(message.messageId);

        final userChatRef = firestore
            .collection(AppStrings.userChats)
            .doc(me.phone)
            .collection(AppStrings.chats)
            .doc(message.chatId);

        final messageSnapshot = await transaction.get(docRef);
        final userChatSnapshot = await transaction.get(userChatRef);

        final status = messageSnapshot.get('status');
        final unread = userChatSnapshot.get('unreadCount') ?? 0;

        if (status != 'seen') {
          updates.add({
            'docRef': docRef,
            'userChatRef': userChatRef,
            'unread': unread,
          });
        }
      }
      for (final item in updates) {
        transaction.update(item['docRef'], {'status': 'seen'});
        if (item['unread'] > 0) {
          transaction.update(item['userChatRef'], {
            'unreadCount': item['unread'] - 1,
          });
        }
      }
    });
  }
}
