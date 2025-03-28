import 'package:flutter/material.dart';
import 'package:storyapp/screen/login_screen.dart';
import 'package:storyapp/screen/register_screen.dart';
import '../repository/auth_repository.dart';
import '../screen/splash_screen.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthRepository authRepository;

  MyRouterDelegate(this.authRepository)
    : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    isLoggedIn = await authRepository.isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    if(isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }
    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      onDidRemovePage: (page) {
        if (isRegister) {
          isRegister = false;
          notifyListeners();
        }
      },
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(configuration) {
    // TODO: implement setNewRoutePath
    throw UnimplementedError();
  }

  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;

  List<Page> get _splashStack {
    return [MaterialPage(child: SplashScreen())];
  }

  List<Page> get _loggedInStack {
    return [MaterialPage(child: SplashScreen())];
  }

  List<Page> get _loggedOutStack {
    return [
      MaterialPage(
        child: LoginScreen(
          onLogin: () async {
            isLoggedIn = await authRepository.isLoggedIn();
            notifyListeners();
          },
          onRegister: () {
            isRegister = true;
            notifyListeners();
          },
        ),
      ),
      if (isRegister)
        MaterialPage(
          child: RegisterScreen(
            onLogin: () async {
              isLoggedIn = await authRepository.isLoggedIn();
              notifyListeners();
            },
            onRegister: () {
              isRegister = true;
              notifyListeners();
            },
          ),
        ),
    ];
  }
}
