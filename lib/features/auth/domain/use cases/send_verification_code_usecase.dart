import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/use_case.dart';
import '../repositories/auth_repository.dart';

class SendVerificationCodeUseCase extends UseCase<NoParams, String> {
  final AuthRepository _repository;

  const SendVerificationCodeUseCase(this._repository);

  @override
  Future<Either<Failure, NoParams>> call(String phone) {
    return _repository.sendVerificationCode(phone);
  }
}
