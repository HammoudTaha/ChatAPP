import 'package:equatable/equatable.dart';

class HomeContact extends Equatable {
  final String name;
  final String phone;

  const HomeContact({required this.name, required this.phone});

  @override
  List<Object> get props => [name, phone];
}