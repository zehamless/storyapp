import 'package:flutter/material.dart';
import 'package:storyapp/model/story_model.dart';
import 'package:storyapp/screen/detail_screen.dart';
import 'package:storyapp/screen/list_story.dart';
import 'package:storyapp/screen/login_screen.dart';
import 'package:storyapp/screen/media_screen.dart';
import 'package:storyapp/screen/register_screen.dart';

import '../repository/auth_repository.dart';
import '../screen/splash_screen.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthRepository authRepository;
  Story? selectedStory;
  bool showMediaScreen = false;

  MyRouterDelegate(this.authRepository)
    : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  Future<void> _init() async {
    isLoggedIn = await authRepository.isLoggedIn();
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _buildPages(),
      onDidRemovePage: (page) {
        if (page.key == ValueKey(selectedStory)) {
          selectedStory = null;
          notifyListeners();
        }
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
  Future<void> setNewRoutePath(configuration) async {
    // TODO: implement setNewRoutePath
    throw UnimplementedError();
  }

  void navigateToMedia() {
    showMediaScreen = !showMediaScreen;
    notifyListeners();
  }

  List<Page> _buildPages() {
    if (isLoggedIn == null) {
      return _splashStack;
    } else if (isLoggedIn == true) {
      return _loggedInStack;
    } else {
      return _loggedOutStack;
    }
  }

  List<Page> get _splashStack => [MaterialPage(child: SplashScreen())];

  List<Page> get _loggedInStack => [
    MaterialPage(
      child: ListStoryScreen(
        onLogout: () async {
          isLoggedIn = !await authRepository.logout();
          notifyListeners();
        },
        onTap: (story) {
          selectedStory = story;
          notifyListeners();
        },
        onPressedFloating: navigateToMedia,
      ),
    ),
    if (showMediaScreen)
      MaterialPage(child: MediaScreen(onClose: navigateToMedia)),
    if (selectedStory != null)
      MaterialPage(
        key: ValueKey(selectedStory),
        child: DetailScreen(story: selectedStory!),
      ),
  ];

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

  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;
}
