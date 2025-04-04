import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:storyapp/bloc/auth_bloc.dart';
import 'package:storyapp/bloc/flag_bloc.dart';
import 'package:storyapp/bloc/story_bloc.dart';
import 'package:storyapp/enum/lang.dart';
import 'package:storyapp/repository/auth_repository.dart';
import 'package:storyapp/route/router_delegate.dart';

import 'l10n/app_localizations.dart';

void main() {
  runApp(
    BlocProvider(
      create: (_) =>
      FlagBloc()
        ..add(LoadLanguageEvent()),
      child: const StoryApp(),
    ),
  );
}

class StoryApp extends StatefulWidget {
  const StoryApp({super.key});

  @override
  State<StoryApp> createState() => _StoryAppState();
}

class _StoryAppState extends State<StoryApp> {
  late final MyRouterDelegate myRouterDelegate;
  late final AuthRepository authRepository;

  @override
  void initState() {
    super.initState();
    authRepository = AuthRepository();
    myRouterDelegate = MyRouterDelegate(authRepository);
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => authRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (context) => AuthBloc(authRepository)),
          BlocProvider<StoryBloc>(
            create:
                (context) =>
            StoryBloc(authRepository)
              ..add(FetchAllStoriesEvent()),
          ),
        ],
        child: BlocBuilder<FlagBloc, FlagState>(
          builder: (context, state) {
            Locale locale = const Locale('en');
            if (state is LanguageLoadedState) {
              locale = state.locale;
            }
            return MaterialApp(
              title: 'Story App',
              locale: locale,
              supportedLocales:
              Language.values.map((lang) => Locale(lang.code, '')).toList(),
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              theme: ThemeData(primarySwatch: Colors.blue),
              home: Router(
                routerDelegate: myRouterDelegate,
                backButtonDispatcher: RootBackButtonDispatcher(),
              ),
            );
          },
        ),
      ),
    );
  }
}
