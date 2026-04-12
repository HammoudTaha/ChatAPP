import 'dart:convert';

import '../../domain/entities/user.dart';

class UserModel extends UserEntity {
  UserModel({required super.id, required super.name, required super.phone});
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'],
      phone: json['phone'],
    );
  }
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'phone': phone};
  }
}

UserModel userModelFromJson(String source) =>
    UserModel.fromJson(json.decode(source));

String userModelToJson(UserModel data) => json.encode(data.toJson());
