import 'user_model.dart';

class AuthStatusModel {
  final bool isAuthenticated;
  final UserModel? user;

  AuthStatusModel({required this.isAuthenticated, this.user});
}
