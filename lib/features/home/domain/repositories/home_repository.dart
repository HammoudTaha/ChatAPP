import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/use_case.dart';
import '../entities/home_contact.dart';

abstract class HomeRepository {
  Future<Either<Failure,String>> checkPhoneFoundOnChat(String phone);
  Future<Either<Failure, NoParams>> saveContact(HomeContact contact);
}
