import '../data/network/base_api_service.dart';
import '../data/network/network_api_service.dart';
import '../res/app_urls.dart';

class AuthRepository {
  final BaseApiService _apiService = NetworkApiService();

  Future<dynamic> loginApi(dynamic data) async {
    try {
      dynamic response = _apiService.getPostApiResponse(AppUrl.loginUrl, data);
      return response;
    } catch (ex) {
      rethrow; 
      // ex;
    }
  }

  Future<dynamic> registerApi(dynamic data) async {
    try {
      dynamic response =
          _apiService.getPostApiResponse(AppUrl.registerUrl, data);
      return response;
    } catch (ex) {
      rethrow;
      // throw ex;
    }
  }
}
