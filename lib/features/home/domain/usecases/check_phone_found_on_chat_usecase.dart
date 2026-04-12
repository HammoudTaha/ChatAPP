import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/use_case.dart';
import '../repositories/home_repository.dart';

class CheckPhoneFoundOnChatUseCase extends UseCase<String, String> {
  final HomeRepository _homeRepository;
  const CheckPhoneFoundOnChatUseCase(this._homeRepository);

  @override
  Future<Either<Failure, String>> call(String phone) async {
    return await _homeRepository.checkPhoneFoundOnChat(phone);
  }
}
