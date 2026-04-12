import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/use_case.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase extends UseCase<NoParams, NoParams> {
  final AuthRepository _repository;

  const LogoutUseCase(this._repository);

  @override
  Future<Either<Failure, NoParams>> call(NoParams params) {
    return _repository.logout();
  }
}
