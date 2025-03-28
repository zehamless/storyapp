import 'package:flutter/material.dart';
import 'package:storyapp/model/user.dart';
import 'package:storyapp/repository/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider(this.authRepository);

  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;
  bool isLoggedIn = false;

  Future<bool> login(User user) async {
    isLoadingLogin = true;
    notifyListeners();

    isLoggedIn = await authRepository.isLoggedIn();
    if (!isLoggedIn) {
      await authRepository.login();
      isLoggedIn = await authRepository.isLoggedIn();
    }
    isLoadingLogin = false;
    notifyListeners();

    return isLoggedIn;
  }

  Future<bool> register(String email, String password) async {
    isLoadingRegister = true;
    notifyListeners();

    isLoggedIn = await authRepository.isLoggedIn();
    if (!isLoggedIn) {
      await authRepository.register(email, password);
      isLoggedIn = await authRepository.isLoggedIn();
    }
    isLoadingRegister = false;
    notifyListeners();

    return isLoggedIn;
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();

    isLoggedIn = await authRepository.isLoggedIn();
    if (isLoggedIn) {
      await authRepository.logout();
      isLoggedIn = await authRepository.isLoggedIn();
    }

    isLoadingLogout = false;
    notifyListeners();

    return !isLoggedIn;
  }
}
