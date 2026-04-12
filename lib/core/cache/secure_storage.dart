import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../errors/exceptions.dart';

class SecureStorage {
  final FlutterSecureStorage _secureStorage;
  const SecureStorage(this._secureStorage);
  Future<String> get(String key) async {
    String? value = await _secureStorage.read(key: key);
    if (value != null) {
      return value;
    }
    throw const CacheException(
      message: 'Failed to get cached data.please try again.',
    );
  }

  Future<void> set({required String key, required String value}) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> clear() async {
    await _secureStorage.deleteAll();
  }
}
