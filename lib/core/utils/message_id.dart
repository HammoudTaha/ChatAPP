import 'dart:math';

String generateId() {
  const encoding = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';
  final time = DateTime.now().millisecondsSinceEpoch;
  final random = Random.secure();

  String encodeTime(int time, int length) {
    var out = '';
    for (int i = length - 1; i >= 0; i--) {
      out = encoding[time % 32] + out;
      time ~/= 32;
    }
    return out;
  }

  String encodeRandom(int length) {
    var out = '';
    for (int i = 0; i < length; i++) {
      out += encoding[random.nextInt(32)];
    }
    return out;
  }

  return encodeTime(time, 10) + encodeRandom(16);
}
