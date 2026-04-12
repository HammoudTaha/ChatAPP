import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/use_case.dart';
import '../entities/home_contact.dart';
import '../repositories/home_repository.dart';

class SaveContactUseCase extends UseCase<NoParams, HomeContact> {
  final HomeRepository _homeRepository;
  const SaveContactUseCase(this._homeRepository);

  @override
  Future<Either<Failure, NoParams>> call(HomeContact contact) {
    return _homeRepository.saveContact(contact);
  }
}