import 'package:chatapp/core/errors/failures.dart';
import 'package:chatapp/features/auth/domain/repositories/auth_repository.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/utils/use_case.dart';

class VerifyPhoneUseCase extends UseCase<NoParams, VerifyPhoneParams> {
  final AuthRepository _repository;

  const VerifyPhoneUseCase(this._repository);
  @override
  Future<Either<Failure, NoParams>> call(VerifyPhoneParams params) {
    return _repository.verifyPhone(params);
  }
}

class VerifyPhoneParams {
  final String phone;
  final String code;
  const VerifyPhoneParams({required this.phone, required this.code});
}
