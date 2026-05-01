enum MessageStatus { sending, sent, delivered, seen, failed }

enum HttpMethods { get, post }

enum BlocStatus { initial, loading, success, failure }

enum VerificationFrom { registration, forgetPassword }

enum ChatType {
  single,
  group;

  static ChatType byName(String name) {
    if (name == group.name) {
      return group;
    } else {
      return single;
    }
  }
}
