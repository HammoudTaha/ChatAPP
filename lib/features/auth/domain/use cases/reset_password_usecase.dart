import 'package:chatapp/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/utils/use_case.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUseCase extends UseCase<NoParams, ResetPasswordParams> {
  final AuthRepository _repository;
  const ResetPasswordUseCase(this._repository);
  @override
  Future<Either<Failure, NoParams>> call(ResetPasswordParams params) {
    return _repository.resetPassword(params);
  }
}

class ResetPasswordParams {
  final String phone;
  final String code;
  final String newPassword;
  final String confirmPassword;
  const ResetPasswordParams({
    required this.code,
    required this.phone,
    required this.newPassword,
    required this.confirmPassword,
  });
}
