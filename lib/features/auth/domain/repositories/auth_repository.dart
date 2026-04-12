import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/use_case.dart';
import '../../data/models/auth_status_model.dart';
import '../../data/models/user_model.dart';
import '../use cases/login_usecase.dart';
import '../use cases/register_usecase.dart';
import '../use cases/reset_password_usecase.dart';
import '../use cases/verify_phone_usecase.dart';

abstract class AuthRepository {
  Future<Either<Failure, NoParams>> logout();
  Future<Either<Failure, AuthStatusModel>> checkAuthStatus();
  Future<Either<Failure, UserModel>> login(LoginParams params);
  Future<Either<Failure, UserModel>> register(RegisterParams params);
  Future<Either<Failure, NoParams>> checkPhoneExistence(String phone);
  Future<Either<Failure, NoParams>> sendVerificationCode(String phone);
  Future<Either<Failure, NoParams>> checkPhoneAvailability(String phone);
  Future<Either<Failure, NoParams>> verifyPhone(VerifyPhoneParams params);
  Future<Either<Failure, NoParams>> resetPassword(ResetPasswordParams params);
}
