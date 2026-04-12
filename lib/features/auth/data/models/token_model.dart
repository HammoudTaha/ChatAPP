class TokenModel {
  final String token;
  final DateTime expiresAT;
  const TokenModel({required this.token, required this.expiresAT});

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      token: json['token'],
      expiresAT: DateTime.now().add(Duration(minutes: json['life_time'])),
    );
  }
}
