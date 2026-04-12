import 'package:isar/isar.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/chat_model.dart';
import '../models/home_contact_model.dart';

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

  Future<void> saveContact(HomeContactModel contact) async {
    try {
      //final contacts = getContacts();
      // final updatedContacts = List<HomeContactModel>.from(contacts);
      // final existingIndex = updatedContacts.indexWhere(
      //   (element) => element.phone == contact.phone,
      // );

      // if (existingIndex != -1) {
      //   updatedContacts[existingIndex] = contact;
      // } else {
      //   updatedContacts.add(contact);
      // }

      // await _isar.writeTxn(() async {
      //   await _isar.saveAll(updatedContacts);
      // });
    } catch (e) {
      throw CacheException(message: 'Failed to save contact');
    }
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
