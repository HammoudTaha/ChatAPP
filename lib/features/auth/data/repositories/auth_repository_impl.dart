import 'package:chatapp/features/auth/data/models/token_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/use_case.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/use cases/login_usecase.dart';
import '../../domain/use cases/register_usecase.dart';
import '../../domain/use cases/reset_password_usecase.dart';
import '../../domain/use cases/verify_phone_usecase.dart';
import '../datasources/local/auth_local_data_source.dart';
import '../datasources/remote/auth_remote_data_source.dart';
import '../models/auth_model.dart';
import '../models/auth_status_model.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource _authLocalDataSource;
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRepositoryImpl(this._authLocalDataSource, this._authRemoteDataSource);

  @override
  Future<Either<Failure, UserModel>> login(LoginParams params) async {
    try {
      final remoteResponse = await _authRemoteDataSource.login(params);
      _cacheData(remoteResponse);
      return Right(remoteResponse.user);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserModel>> register(RegisterParams params) async {
    try {
      final remoteResponse = await _authRemoteDataSource.register(params);
      _cacheData(remoteResponse);
      return Right(remoteResponse.user);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  void _cacheData(AuthModel model) async {
    _authLocalDataSource.setUser(model.user);
    await _authLocalDataSource.setAccessToken(model.accessToken);
    await _authLocalDataSource.setRefreshToken(model.refreshToken);
    await _authLocalDataSource.setIsLoggedInUser(true);
  }

  @override
  Future<Either<Failure, NoParams>> logout() async {
    try {
      await _authRemoteDataSource.logout(
        (await _authLocalDataSource.getAccessToken()).token,
      );
      await _authLocalDataSource.clearCash();
      return Right(NoParams());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, NoParams>> resetPassword(
    ResetPasswordParams params,
  ) async {
    try {
      await _authRemoteDataSource.resetPassword(params);
      return Right(NoParams());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, NoParams>> sendVerificationCode(String phone) async {
    try {
      await _authRemoteDataSource.sendVerificationCode(phone);
      return Right(NoParams());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, NoParams>> verifyPhone(
    VerifyPhoneParams params,
  ) async {
    try {
      await _authRemoteDataSource.verifyPhone(params);
      return Right(NoParams());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, AuthStatusModel>> checkAuthStatus() async {
    try {
      if (_authLocalDataSource.getIsLoggedInUser()) {
        TokenModel accessToken = await _authLocalDataSource.getAccessToken();
        if (accessToken.expiresAT.isBefore(DateTime.now())) {
          return Right(AuthStatusModel(isAuthenticated: false));
        }
        return Right(
          AuthStatusModel(
            isAuthenticated: true,
            user: _authLocalDataSource.getUser(),
          ),
        );
      } else {
        return Right(AuthStatusModel(isAuthenticated: false));
      }
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, NoParams>> checkPhoneAvailability(String phone) async {
    try {
      await _authRemoteDataSource.checkPhoneAvailability(phone);
      return Right(NoParams());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, NoParams>> checkPhoneExistence(String phone) async {
    try {
      await _authRemoteDataSource.checkPhoneExistence(phone);
      return Right(NoParams());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  // Future<Either<Failure, String>> sendVerificationCode(String phone) async {
  //   if (await _connectionInfo.checkConnection()) {
  //     final remoteResponse = await _userRemoteDataSource.sendVerificationCode(
  //       phone,
  //     );
  //     return remoteResponse.fold((l) => Left(l), (r) => Right(r));
  //   } else {
  //     return Left(Failure(message: 'No internet Connection, Please try again'));
  //   }
  // }
  // Future<Either<Failure, String>> forgetPassword(String phone) async {
  //   if (await _connectionInfo.checkConnection()) {
  //     final remoteResponse = await _userRemoteDataSource.forgetpassword(phone);
  //     return remoteResponse.fold((l) => Left(l), (r) => Right(r));
  //   } else {
  //     return Left(Failure(message: 'No internet Connection, Please try again'));
  //   }
  // }
  // Future<Either<Failure, String>> verifyPhone(VerifyPhoneParams params) async {
  //   if (await _connectionInfo.checkConnection()) {
  //     final remoteResponse = await _userRemoteDataSource.verifyPhone(params);
  //     return remoteResponse.fold((l) => Left(l), (r) => Right(r));
  //   } else {
  //     return Left(Failure(message: 'No internet Connection, Please try again'));
  //   }
  // }
  // Future<Either<Failure, String>> verifyResetCode(
  //   VerifyPhoneParams params,
  // ) async {
  //   if (await _connectionInfo.checkConnection()) {
  //     final remoteResponse = await _userRemoteDataSource.verifyResetCode(
  //       params,
  //     );
  //     return remoteResponse.fold((l) => Left(l), (r) => Right(r));
  //   } else {
  //     return Left(Failure(message: 'No internet Connection, Please try again'));
  //   }
  // }
  // Future<Either<Failure, String>> resetPassword(
  //   ResetPasswordParams params,
  // ) async {
  //   if (await _connectionInfo.checkConnection()) {
  //     final remoteResponse = await _userRemoteDataSource.resetPassword(params);
  //     return remoteResponse.fold((l) => Left(l), (r) => Right(r));
  //   } else {
  //     return Left(Failure(message: 'No internet Connection, Please try again'));
  //   }
  // }
  // Future<Either<Failure, NoParams>> logout() async {
  //   if (await _connectionInfo.checkConnection()) {
  //     try {
  //       final remoteResponse = await _userRemoteDataSource.logout();
  //       return remoteResponse.fold((l) => Left(l), (r) {
  //         _userLocalDataSource.clearCash();
  //         _userLocalDataSource.setIsLogedInUser(false);
  //         return Right(r);
  //       });
  //     } on CachException catch (e) {
  //       return Left(Failure(message: e.message));
  //     }
  //   } else {
  //     return Left(Failure(message: 'No internet Connection, Please try again'));
  //   }
  // }
}
