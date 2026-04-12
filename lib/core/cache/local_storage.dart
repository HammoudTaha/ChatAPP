import 'package:shared_preferences/shared_preferences.dart';

import '../errors/exceptions.dart';

class LocalStorage {
  final SharedPreferences _sharedPreferences;
  const LocalStorage(this._sharedPreferences);
  Future<void> storeString(String key, String value) async {
    bool isSet = await _sharedPreferences.setString(key, value);
    if (!isSet) {
      throw CacheException(message: 'Failed to cache data.please try again.');
    }
  }

  Future<void> storeBool(String key, bool value) async {
    bool isSet = await _sharedPreferences.setBool(key, value);
    if (!isSet) {
      throw CacheException(message: 'Failed to cache data.please try again.');
    }
  }

  String getString(String key) {
    String? value = _sharedPreferences.getString(key);
    if (value != null) {
      return value;
    }
    throw CacheException(
      message: 'Failed to get cached data.please try again.',
    );
  }

  bool getBool(String key) {
    bool? value = _sharedPreferences.getBool(key);
    if (value != null) {
      return value;
    }
    throw CacheException(
      message: 'Failed to get cached data.please try again.',
    );
  }

  Future<void> remove(String key) async {
    final isRemoved = await _sharedPreferences.remove(key);
    if (!isRemoved) {
      throw CacheException(
        message: 'Failed to remove cached data.please try again.',
      );
    }
  }

  Future<void> clear() async {
    final isRemoved = await _sharedPreferences.clear();
    if (!isRemoved) {
      throw CacheException(
        message: 'Failed to clear cached data.please try again.',
      );
    }
  }
}
