import 'package:chatapp/core/errors/failures.dart';
import 'package:chatapp/features/auth/domain/repositories/auth_repository.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/utils/use_case.dart';
import '../entities/user.dart';

class RegisterUseCase extends UseCase<UserEntity, RegisterParams> {
  final AuthRepository _repository;
  const RegisterUseCase(this._repository);
  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) {
    return _repository.register(params);
  }
}

class RegisterParams {
  final String name;
  final String phone;
  final String password;

  const RegisterParams({
    required this.name,
    required this.phone,
    required this.password,
  });
}
