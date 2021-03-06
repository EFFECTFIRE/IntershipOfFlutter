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

  /// `FriendlyChat`
  String get app_bar_title {
    return Intl.message(
      'FriendlyChat',
      name: 'app_bar_title',
      desc: '',
      args: [],
    );
  }

  /// `Send a message`
  String get message_place_holder {
    return Intl.message(
      'Send a message',
      name: 'message_place_holder',
      desc: '',
      args: [],
    );
  }

  /// `NONE`
  String get none {
    return Intl.message(
      'NONE',
      name: 'none',
      desc: '',
      args: [],
    );
  }

  /// `Please, Sign In`
  String get auth_screen_title {
    return Intl.message(
      'Please, Sign In',
      name: 'auth_screen_title',
      desc: '',
      args: [],
    );
  }

  /// `email`
  String get email_place_holder {
    return Intl.message(
      'email',
      name: 'email_place_holder',
      desc: '',
      args: [],
    );
  }

  /// `password`
  String get password_place_holder {
    return Intl.message(
      'password',
      name: 'password_place_holder',
      desc: '',
      args: [],
    );
  }

  /// `LOGIN`
  String get sign_in_button {
    return Intl.message(
      'LOGIN',
      name: 'sign_in_button',
      desc: '',
      args: [],
    );
  }

  /// `Sign Out`
  String get sign_out_button {
    return Intl.message(
      'Sign Out',
      name: 'sign_out_button',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get sign_up_button {
    return Intl.message(
      'Sign Up',
      name: 'sign_up_button',
      desc: '',
      args: [],
    );
  }

  /// `'@' not use`
  String get email_validation_error {
    return Intl.message(
      '\'@\' not use',
      name: 'email_validation_error',
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

  /// `This Email not exist`
  String get error_of_email {
    return Intl.message(
      'This Email not exist',
      name: 'error_of_email',
      desc: '',
      args: [],
    );
  }

  /// `Wrong password`
  String get error_of_password {
    return Intl.message(
      'Wrong password',
      name: 'error_of_password',
      desc: '',
      args: [],
    );
  }

  /// `Email already exist`
  String get error_email_already_exist {
    return Intl.message(
      'Email already exist',
      name: 'error_email_already_exist',
      desc: '',
      args: [],
    );
  }

  /// `ListTileTitle`
  String get listTile_title {
    return Intl.message(
      'ListTileTitle',
      name: 'listTile_title',
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
