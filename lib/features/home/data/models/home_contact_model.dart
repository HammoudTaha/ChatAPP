import '../../domain/entities/home_contact.dart';

class HomeContactModel extends HomeContact {
  const HomeContactModel({required super.name, required super.phone});

  factory HomeContactModel.fromJson(Map<String, dynamic> json) {
    return HomeContactModel(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'phone': phone};
  }

  factory HomeContactModel.fromEntity(HomeContact contact) {
    return HomeContactModel(name: contact.name, phone: contact.phone);
  }
}