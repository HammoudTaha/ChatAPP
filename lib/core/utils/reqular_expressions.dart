abstract final class RegularExpressions {
  const RegularExpressions._();
  static final email = RegExp(r'^[a-z]([a-zA-Z0-9_+-])@gmail\.com$');
  static final phone = RegExp(r'^09\d{8}$');
  static final password = RegExp(r'^\w{5,}$');
  static final code = RegExp(r'^\d{6}$');
}
