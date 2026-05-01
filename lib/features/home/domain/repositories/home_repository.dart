import 'package:chatapp/core/utils/use_case.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/chat_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, String>> checkPhoneFoundOnChat(String phone);
  Future<Either<Failure, NoParams>> saveChat(ChatEntity contact);
  Stream<List<ChatEntity>> watchChats();
}
