import '../utils/reqular_expressions.dart';

extension StringValidatorExtension on String {
  bool get isPhoneValid => RegularExpressions.phone.hasMatch(this);
  bool get isPasswordValid => RegularExpressions.password.hasMatch(this);
  bool get isCodeValid => RegularExpressions.code.hasMatch(this);
}
