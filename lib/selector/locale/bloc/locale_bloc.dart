import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show Locale, WidgetsBinding;
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'locale_event.dart';

const _supportedLocales = [
  Locale('en', 'US'),
  Locale('pl', 'PL'),
];

class LocaleBloc extends HydratedBloc<LocaleEvent, Locale> {
  LocaleBloc() : super(_initialLocale()) {
    on<LocaleChanged>((event, emit) => emit(event.locale ?? state));
  }

  @override
  Locale? fromJson(Map<String, dynamic> json) =>
      Locale(json['language_code'] as String, json['country_code'] as String?);

  @override
  Map<String, dynamic>? toJson(Locale state) => {
    'language_code': state.languageCode,
    if (state.countryCode != null) 'country_code': state.countryCode,
  };
}

Locale _initialLocale() {
  // Define supported locales

  // Get the system's preferred locale
  final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;

  // Determine the initial locale based on supported languages
  Locale initialLocale;
  if (_supportedLocales.any(
    (locale) => locale.languageCode == systemLocale.languageCode,
  )) {
    initialLocale = systemLocale;
  } else {
    // Fallback to English if the system locale is not supported
    initialLocale = const Locale('en', 'US');
  }
  return initialLocale;
}
