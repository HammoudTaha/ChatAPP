import '../../../../../../core/constants/strings.dart';
import '../../../../../core/services/api_service.dart';
import '../../../domain/use cases/login_usecase.dart';
import '../../../domain/use cases/register_usecase.dart';
import '../../../domain/use cases/reset_password_usecase.dart';
import '../../../domain/use cases/verify_phone_usecase.dart';
import '../../models/auth_model.dart';

class AuthRemoteDataSource {
  final ApiService _apiService;
  const AuthRemoteDataSource(this._apiService);

  Future<AuthModel> login(LoginParams params) async {
    final data = await _apiService.request(
      endpoint: '${AppStrings.user}${AppStrings.login}',
      data: {'phone': params.phone, 'password': params.password},
    );

    return AuthModel.fromJson(data['data']);
  }

  Future<AuthModel> register(RegisterParams params) async {
    final data = await _apiService.request(
      endpoint: '${AppStrings.user}${AppStrings.register}',
      data: {
        'name': params.name,
        'phone': params.phone,
        'password': params.password,
      },
    );
    return AuthModel.fromJson(data['data']);
  }

  Future<void> verifyPhone(VerifyPhoneParams params) async {
    await _apiService.request(
      endpoint: '${AppStrings.user}${AppStrings.verifyPhone}',
      data: {'phone': params.phone, 'code': params.code},
    );
  }

  Future<void> sendVerificationCode(String phone) async {
    await _apiService.request(
      endpoint: '${AppStrings.user}${AppStrings.sendVerificationCode}',
      data: {'phone': phone},
    );
  }

  Future<void> resetPassword(ResetPasswordParams params) async {
    await _apiService.request(
      endpoint: '${AppStrings.user}${AppStrings.resetPassword}',
      data: {
        'phone': params.phone,
        'code': params.code,
        'new_password': params.newPassword,
        'confirm_password': params.confirmPassword,
      },
    );
  }

  Future<void> logout(String token) async {
    await _apiService.request(
      endpoint: '${AppStrings.user}${AppStrings.logout}',
      token: token,
    );
  }

  Future<void> checkPhoneAvailability(String phone) async {
    await _apiService.request(
      endpoint: '${AppStrings.user}${AppStrings.checkPhoneAvailability}',
      data: {'phone': phone},
    );
  }

  Future<void> checkPhoneExistence(String phone) async {
    await _apiService.request(
      endpoint: '${AppStrings.user}${AppStrings.checkPhoneExistence}',
      data: {'phone': phone},
    );
  }
}
