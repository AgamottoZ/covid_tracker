import 'package:covid_tracker/data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:covid_tracker/utils/utils.dart';

class Environment {
  SharedPreferences _sharedPrefs;

  bool _isDev = true;

  bool get isDev => _isDev;

  bool _isLight = true;

  bool get isLight => _isLight;

  bool _isVnese;

  bool get isVnese => _isVnese;

  String _selectedCountryCode;

  String get selectedCountryCode => _selectedCountryCode;

  init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    getConfig();
  }

  getConfig() {
    _isDev = DotEnv().env['DEV'] == 'true';
    _isLight = _sharedPrefs.getBool(THEME_KEY) ?? true;
    _isVnese = _sharedPrefs.get(LOCALE_KEY) ?? true;
    _selectedCountryCode =
        _sharedPrefs.get(COUNTRY_CODE_KEY) ?? countryList.first.isoCode;
  }

  setTheme(bool lightTheme) async {
    _isLight = lightTheme;
    await _sharedPrefs.setBool(THEME_KEY, lightTheme);
    getConfig();
  }

  setLocale(bool isVnese) async {
    _isVnese = isVnese;
    await _sharedPrefs.setBool(LOCALE_KEY, isVnese);
    getConfig();
  }

  setCountrySelection(String countryCode) async {
    _selectedCountryCode = countryCode;
    await _sharedPrefs.setString(COUNTRY_CODE_KEY, countryCode);
  }
}
