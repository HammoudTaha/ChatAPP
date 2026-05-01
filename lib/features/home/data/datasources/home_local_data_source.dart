import 'package:isar/isar.dart';
import '../models/chat_model.dart';

class HomeLocalDataSource {
  final Isar _isar;
  const HomeLocalDataSource(this._isar);
  Future<bool> checkPhoneFoundOnChat(String phone) async {
    final contact = await _isar.chatModels
        .filter()
        .participantIdsElementContains(phone)
        .findFirst();
    if (contact == null) {
      return false;
    }
    return true;
  }

  Future<void> addOrUpdateChat(ChatModel chat) async {
    await _isar.writeTxn(() async {
      final existingChat = await _isar.chatModels
          .where()
          .chatIdEqualTo(chat.chatId)
          .findFirst();
      if (existingChat != null) {
        final updatedChat = existingChat.copyWith(
          title: chat.title,
          lastMessage: chat.lastMessage,
          lastMessageAt: chat.lastMessageAt,
          unreadCount: chat.unreadCount,
        );
        await _isar.chatModels.put(updatedChat);
      } else {
        await _isar.chatModels.put(chat);
      }
    });
  }

  // Future<void> saveContact(HomeContactModel contact) async {
  //   try {
  //    //final contacts = getContacts();
  //     // final updatedContacts = List<HomeContactModel>.from(contacts);
  //     // final existingIndex = updatedContacts.indexWhere(
  //     //   (element) => element.phone == contact.phone,
  //     // );
  //     // if (existingIndex != -1) {
  //     //   updatedContacts[existingIndex] = contact;
  //     // } else {
  //     //   updatedContacts.add(contact);
  //     // }
  //     // await _isar.writeTxn(() async {
  //     //   await _isar.saveAll(updatedContacts);
  //     // });
  //   } catch (e) {
  //     throw CacheException(message: 'Failed to save contact');
  //   }
  // }

  Stream<List<ChatModel>> watchChats() {
    return _isar.chatModels.where().sortByLastMessageAt().watch(
      fireImmediately: true,
    );
  }

  Stream<List<String>> watchUnListenedChatIds(List<String> chatIds) {
    return (chatIds.isNotEmpty
            ? _isar.chatModels.filter().not().anyOf(
                chatIds,
                (q, element) => q.chatIdEqualTo(element),
              )
            : _isar.chatModels.where())
        .watch(fireImmediately: true)
        .map((event) => [for (final e in event) e.chatId]);
  }

  void clearChats() async {
    await _isar.writeTxn(() async {
      await _isar.chatModels.clear();
    });
  }

  // List<HomeContactModel> getContacts() {
  //   try {
  //     final contactsJson = _localStorage.getString(AppStrings.cachedHomeContacts);
  //     if (contactsJson == null || contactsJson.isEmpty) {
  //       return [];
  //     }
  //     final List<dynamic> decodedContacts = jsonDecode(contactsJson);
  //     return decodedContacts
  //         .map(
  //           (contact) =>
  //               HomeContactModel.fromJson(Map<String, dynamic>.from(contact)),
  //         )
  //         .toList();
  //   } catch (e) {
  //     throw CacheException(message: 'Failed to load contacts');
  //   }
  // }
}
