import 'package:flutter/material.dart';
import 'package:storyqito_app/core/data/model/user.dart';
import 'package:storyqito_app/core/data/network/responses/login_response.dart';
import 'package:storyqito_app/core/data/network/responses/simple_response.dart';
import 'package:storyqito_app/core/data/network/util/api_response.dart';
import 'package:storyqito_app/core/data/repository/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider(this.authRepository);

  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;
  bool isLoggedIn = false;

  User? user;
  String errorMsg = "";

  Future<bool> isLogged() async {
    isLoggedIn = await authRepository.isLoggedIn();
    return isLoggedIn;
  }

  Future<ApiResponse<SimpleResponse>> register(User user) async {
    isLoadingRegister = true;
    notifyListeners();

    final response = await authRepository.register(user);

    isLoadingRegister = false;
    notifyListeners();

    return response;
  }

  Future<ApiResponse<LoginResponse>> login(
    String email,
    String password,
  ) async {
    isLoadingLogin = true;
    notifyListeners();

    final response = await authRepository.loginUser(email, password);
    isLoggedIn = await authRepository.isLoggedIn();

    isLoadingLogin = false;
    notifyListeners();

    return response;
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();

    final logout = await authRepository.logout();
    if (logout) {
      await authRepository.deleteUser();
    }
    isLoggedIn = await authRepository.isLoggedIn();

    isLoadingLogout = false;
    notifyListeners();

    return !isLoggedIn;
  }

  Future<bool> saveUser(User user) async {
    isLoadingRegister = true;
    notifyListeners();

    final userState = await authRepository.saveUser(user);

    isLoadingRegister = false;
    notifyListeners();

    return userState;
  }

  Future<void> getUser() async {
    isLoadingLogin = true;
    notifyListeners();

    try {
      user = await authRepository.getUser();
      if (user == null) {
        errorMsg = "Employee not found";
      }
    } catch (e) {
      errorMsg = "Error occurred while fetching employee data";
    }

    isLoadingLogin = false;
    notifyListeners();
  }
}
