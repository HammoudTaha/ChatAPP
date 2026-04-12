import '../../../../../core/cache/secure_storage.dart';
import '../../../../../core/constants/strings.dart';
import '../../../../../core/cache/local_storage.dart';
import '../../models/token_model.dart';
import '../../models/user_model.dart';

class AuthLocalDataSource {
  final SecureStorage _secureStorage;
  final LocalStorage _localStorage;
  const AuthLocalDataSource(this._secureStorage, this._localStorage);

  Future<void> setUser(UserModel user) async {
    await _localStorage.storeString(
      AppStrings.cachedUser,
      userModelToJson(user),
    );
  }

  UserModel getUser() {
    try {
      String user = _localStorage.getString(AppStrings.cachedUser);
      return userModelFromJson(user);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> setAccessToken(TokenModel accessToken) async {
    await _secureStorage.set(
      key: AppStrings.cachedAccessToken,
      value: accessToken.token,
    );
    _localStorage.storeString(
      AppStrings.cacheAccessTokenLifeTime,
      accessToken.expiresAT.toString(),
    );
  }

  Future<void> setRefreshToken(TokenModel refreshToken) async {
    await _secureStorage.set(
      key: AppStrings.cachedRefreshToken,
      value: refreshToken.token,
    );
    _localStorage.storeString(
      AppStrings.cacheRefreshTokenLifeTime,
      refreshToken.expiresAT.toString(),
    );
  }

  Future<TokenModel> getAccessToken() async {
    TokenModel accessToken = TokenModel(
      token: await _secureStorage.get(AppStrings.cachedAccessToken),
      expiresAT: DateTime.parse(
        _localStorage.getString(AppStrings.cacheAccessTokenLifeTime),
      ),
    );
    return accessToken;
  }

  Future<TokenModel> getRefreshToken() async {
    TokenModel refreshToken = TokenModel(
      token: await _secureStorage.get(AppStrings.cachedRefreshToken),
      expiresAT: DateTime.parse(
        _localStorage.getString(AppStrings.cacheRefreshTokenLifeTime),
      ),
    );
    return refreshToken;
  }

  Future<void> setIsLoggedInUser(bool value) async {
    await _localStorage.storeBool(AppStrings.cachedIsLoggedInUser, value);
  }

  bool getIsLoggedInUser() {
    return _localStorage.getBool(AppStrings.cachedIsLoggedInUser);
  }

  Future<void> clearCash() async {
    await _secureStorage.clear();
    await _localStorage.clear();
  }
}
