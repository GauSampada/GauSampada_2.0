import 'package:flutter/material.dart';
import 'package:gausampada/const/local_pref_keys.dart';
import 'package:gausampada/l10n/l10n.dart';
import 'package:gausampada/main.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  Locale get locale =>
      _locale ?? Locale(prefs.getString(LocalPrefKeys.localeLanguage) ?? 'en');

  void setLocale(Locale locale) {
    if (!L10n.locales.contains(locale)) return;
    prefs.setString(LocalPrefKeys.localeLanguage, locale.toString());
    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = const Locale('en');
    notifyListeners();
  }
}
