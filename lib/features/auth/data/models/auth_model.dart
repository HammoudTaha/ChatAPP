import 'token_model.dart';
import 'user_model.dart';

class AuthModel {
  final UserModel user;
  final TokenModel accessToken;
  final TokenModel refreshToken;

  AuthModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      user: UserModel.fromJson(json['user']),
      accessToken: TokenModel.fromJson(json['access_token']),
      refreshToken: TokenModel.fromJson(json['refresh_token']),
    );
  }
}
