import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/use_case.dart';
import '../entities/chat_entity.dart';
import '../repositories/home_repository.dart';

class SaveContactUseCase extends UseCase<NoParams, ChatEntity> {
  final HomeRepository _homeRepository;
  const SaveContactUseCase(this._homeRepository);

  @override
  Future<Either<Failure, NoParams>> call(ChatEntity contact) {
    return _homeRepository.saveChat(contact);
  }
}
