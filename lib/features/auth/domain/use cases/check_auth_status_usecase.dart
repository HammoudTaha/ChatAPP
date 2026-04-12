import 'package:chatapp/core/errors/failures.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/utils/use_case.dart';
import '../../data/models/auth_status_model.dart';
import '../repositories/auth_repository.dart';

class CheckAuthStatusUseCase extends UseCase<AuthStatusModel, NoParams> {
  final AuthRepository _authRepository;
  const CheckAuthStatusUseCase(this._authRepository);
  @override
  Future<Either<Failure, AuthStatusModel>> call(NoParams params) {
    return _authRepository.checkAuthStatus();
  }
}
