import 'package:dartz/dartz.dart';

import '../errors/failures.dart';

abstract class UseCase<T, Params> {
  const UseCase();
  Future<Either<Failure, T>> call(Params params);
}

class NoParams {
  const NoParams();
}
