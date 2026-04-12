import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/use_case.dart';
import '../repositories/auth_repository.dart';

class CheckPhoneAvailabilityUseCase extends UseCase<NoParams, String> {
  final AuthRepository _authRepository;
  const CheckPhoneAvailabilityUseCase(this._authRepository);
  @override
  Future<Either<Failure, NoParams>> call(String phone) {
    return _authRepository.checkPhoneAvailability(phone);
  }
}
