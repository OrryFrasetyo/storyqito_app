import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyqito_app/core/data/model/user.dart';
import 'package:storyqito_app/core/data/network/response/login_response.dart';
import 'package:storyqito_app/core/data/network/response/simple_response.dart';
import 'package:storyqito_app/core/data/network/service/api_services.dart';
import 'package:storyqito_app/core/data/network/util/api_response.dart';

class AuthRepository {
  final SharedPreferences _sharedPrefs;
  final ApiServices _apiServices;

  AuthRepository(this._sharedPrefs, this._apiServices);

  final String stateKey = "state";
  final String userKey = "user";

  Future<bool> isLoggedIn() async {
    return _sharedPrefs.getBool(stateKey) ?? false;
  }

  Future<bool> login() async {
    return _sharedPrefs.setBool(stateKey, true);
  }

  Future<bool> logout() async {
    return _sharedPrefs.setBool(stateKey, false);
  }

  Future<bool> saveUser(User user) async {
    return _sharedPrefs.setString(userKey, user.toJson());
  }

  Future<bool> deleteUser() async {
    return _sharedPrefs.setString(userKey, "");
  }

  Future<User?> getUser() async {
    await Future.delayed(Duration(seconds: 2));

    final json = _sharedPrefs.getString(userKey) ?? "";
    User? user;
    try {
      user = User.fromJson(json);
    } catch (e) {
      user = null;
    }
    return user;
  }

  Future<ApiResponse<SimpleResponse>> register(User user) async {
    final response = await _apiServices.register(user);
    if (response.data != null && !response.data!.error) {
      return ApiResponse.success(response.data!);
    }
    return ApiResponse.error(response.message ?? "Unknown error occurred");
  }

  Future<ApiResponse<LoginResponse>> loginUser(
    String email,
    String password,
  ) async {
    final response = await _apiServices.login(email, password);
    if (response.data != null && !response.data!.error) {
      final user = User(
        email: email,
        name: response.data!.loginResult.name,
        password: password,
        token: response.data!.loginResult.token,
        language: "en",
      );

      await saveUser(user);
      await login();
      return ApiResponse.success(response.data!);
    }
    return ApiResponse.error(response.message ?? "Unknown error occurred");
  }
}
