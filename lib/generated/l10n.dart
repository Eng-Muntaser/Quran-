// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Reciters List`
  String get recitersList {
    return Intl.message(
      'Reciters List',
      name: 'recitersList',
      desc: '',
      args: [],
    );
  }

  /// `Reciters List:`
  String get recitersListBottom {
    return Intl.message(
      'Reciters List:',
      name: 'recitersListBottom',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Rewayat Hafs A'n Assem - Murattal`
  String get rewayatDefault {
    return Intl.message(
      'Rewayat Hafs A\'n Assem - Murattal',
      name: 'rewayatDefault',
      desc: '',
      args: [],
    );
  }

  /// `Connected`
  String get connected {
    return Intl.message(
      'Connected',
      name: 'connected',
      desc: '',
      args: [],
    );
  }

  /// `No Connection`
  String get noConnection {
    return Intl.message(
      'No Connection',
      name: 'noConnection',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Alert`
  String get alert {
    return Intl.message(
      'Alert',
      name: 'alert',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `You are connected to the internet`
  String get youConnected {
    return Intl.message(
      'You are connected to the internet',
      name: 'youConnected',
      desc: '',
      args: [],
    );
  }

  /// `You are not connected to the internet`
  String get younotConnected {
    return Intl.message(
      'You are not connected to the internet',
      name: 'younotConnected',
      desc: '',
      args: [],
    );
  }

  /// `Connected but no internet access`
  String get connectedNoInternet {
    return Intl.message(
      'Connected but no internet access',
      name: 'connectedNoInternet',
      desc: '',
      args: [],
    );
  }

  /// `No Internet`
  String get noInternet {
    return Intl.message(
      'No Internet',
      name: 'noInternet',
      desc: '',
      args: [],
    );
  }

  /// `Internet connection is currently unavailable`
  String get internetConnectionState {
    return Intl.message(
      'Internet connection is currently unavailable',
      name: 'internetConnectionState',
      desc: '',
      args: [],
    );
  }

  /// `Please check your internet connection`
  String get internetConnectionRecommended {
    return Intl.message(
      'Please check your internet connection',
      name: 'internetConnectionRecommended',
      desc: '',
      args: [],
    );
  }

  /// `Reciter's Voice`
  String get reciterVoice {
    return Intl.message(
      'Reciter\'s Voice',
      name: 'reciterVoice',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get Favorites {
    return Intl.message(
      'Favorites',
      name: 'Favorites',
      desc: '',
      args: [],
    );
  }

  /// `No favorites`
  String get Nofavorites {
    return Intl.message(
      'No favorites',
      name: 'Nofavorites',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
