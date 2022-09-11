import '../data/network/BaseApiService.dart';
import '../data/network/NetworkApiService.dart';
import '../res/app_urls.dart';

class AuthRepository {
  BaseApiService _apiService = NetworkApiService();

  Future<dynamic> loginApi(dynamic data) async {
    try {
      dynamic response = _apiService.getPostApiResponse(AppUrl.loginUrl, data);
      return response;
    } catch (ex) {
      throw ex;
    }
  }

  Future<dynamic> registerApi(dynamic data) async {
    try {
      dynamic response =
          _apiService.getPostApiResponse(AppUrl.registerUrl, data);
      return response;
    } catch (ex) {
      throw ex;
    }
  }
}
