import '../../../../core/constants/strings.dart';
import '../../../../core/services/api_service.dart';

class HomeRemoteDataSource {
  final ApiService _apiService;
  const HomeRemoteDataSource(this._apiService);

  Future<void> checkPhoneFoundOnChat(String phone) async {
    await _apiService.request(
      endpoint: '${AppStrings.user}${AppStrings.checkPhoneExistence}',
      data: {'phone': phone},
    );
  }
}
