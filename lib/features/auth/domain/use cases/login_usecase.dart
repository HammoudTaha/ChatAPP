import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/use_case.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase extends UseCase<UserEntity, LoginParams> {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    return await _repository.login(params);
  }
}

class LoginParams {
  final String phone;
  final String password;
  const LoginParams({required this.phone, required this.password});
}
