import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyqito_app/core/constant/my_pref_key.dart';
import 'package:storyqito_app/core/data/model/user.dart';
import 'package:storyqito_app/core/data/network/responses/login_response.dart';
import 'package:storyqito_app/core/data/network/responses/simple_response.dart';
import 'package:storyqito_app/core/data/network/service/api_services.dart';
import 'package:storyqito_app/core/data/network/util/api_response.dart';

class AuthRepository {
  final SharedPreferences _sharedPrefs;
  final ApiServices _apiServices;

  AuthRepository(this._sharedPrefs, this._apiServices);

  Future<bool> isLoggedIn() async {
    return _sharedPrefs.getBool(AuthPrefsKey.stateKey) ?? false;
  }

  Future<bool> login() async {
    return _sharedPrefs.setBool(AuthPrefsKey.stateKey, true);
  }

  Future<bool> logout() async {
    return _sharedPrefs.setBool(AuthPrefsKey.stateKey, false);
  }

  Future<bool> saveUser(User user) async {
    return _sharedPrefs.setString(AuthPrefsKey.userKey, user.toJsonString());
  }

  Future<bool> deleteUser() async {
    return _sharedPrefs.setString(AuthPrefsKey.userKey, "");
  }

  Future<User?> getUser() async {
    await Future.delayed(const Duration(seconds: 2));

    final json = _sharedPrefs.getString(AuthPrefsKey.userKey) ?? "";
    User? user;
    try {
      user = UserExtension.fromJsonString(json);
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
        password: "password",
        token: response.data!.loginResult.token,
      );

      await saveUser(user);
      await login();
      return ApiResponse.success(response.data!);
    }
    return ApiResponse.error(response.message ?? "Unknown error occurred");
  }
}
