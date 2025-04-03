import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyapp/enum/lang.dart';

abstract class FlagEvent {}

class LoadLanguageEvent extends FlagEvent {}

class ChangeLanguageEvent extends FlagEvent {
  final Language language;

  ChangeLanguageEvent(this.language);
}

abstract class FlagState {}

class LanguageInitState extends FlagState {}

class LanguageLoadedState extends FlagState {
  final Locale locale;

  LanguageLoadedState(this.locale);
}

class FlagBloc extends Bloc<FlagEvent, FlagState> {
  FlagBloc() : super(LanguageInitState()) {
    on<LoadLanguageEvent>(_onLoadLanguage);
    on<ChangeLanguageEvent>(_onChangeLanguage);
  }

  Future<void> _onLoadLanguage(
    LoadLanguageEvent event,
    Emitter<FlagState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'en';
    emit(LanguageLoadedState(Locale(languageCode)));
  }

  Future<void> _onChangeLanguage(
    ChangeLanguageEvent event,
    Emitter<FlagState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', event.language.code);
    emit(LanguageLoadedState(Locale(event.language.code)));
  }
}
