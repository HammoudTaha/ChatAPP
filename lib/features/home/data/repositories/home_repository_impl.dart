import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/connection_info.dart';
import '../../../../core/utils/use_case.dart';
import '../../domain/entities/home_contact.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_data_source.dart';
import '../datasources/home_remote_data_source.dart';
import '../models/home_contact_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final ConnectionInfo _connectionInfo;
  final HomeLocalDataSource _homeLocalDataSource;
  final HomeRemoteDataSource _homeRemoteDataSource;

  HomeRepositoryImpl(
    this._connectionInfo,
    this._homeLocalDataSource,
    this._homeRemoteDataSource,
  );

  @override
  Future<Either<Failure, String>> checkPhoneFoundOnChat(String phone) async {
    try {
      if (await _homeLocalDataSource.checkPhoneFoundOnChat(phone)) {
        return const Right('Contact already exists');
      } else {
        if (await _connectionInfo.isConnected) {
          await _homeRemoteDataSource.checkPhoneFoundOnChat(phone);
          return const Right('Contact found on app');
        } else {
          return Left(const Failure('No internet connection'));
        }
      }
    } on ServerException catch (e) {
      if (e is NotFoundException) {
        return const Right('Contact not found on app');
      }
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, NoParams>> saveContact(HomeContact contact) async {
    try {
      await _homeLocalDataSource.saveContact(
        HomeContactModel.fromEntity(contact),
      );
      return const Right(NoParams());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
