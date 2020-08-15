import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:covid_tracker/app.dart';
import 'package:covid_tracker/injection.dart';
import 'package:covid_tracker/environment.dart';
import 'package:covid_tracker/utils/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  initInjector();

  var _env = getIt.get<Environment>();
  var _apiClient = getIt.get<APIClient>();

  await _env.init();
  _apiClient.init();

  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('vi'),
        Locale('en'),
      ],
      fallbackLocale: Locale('en'),
      startLocale: _env.isVnese ? Locale('vi') : Locale('en'),
      path: 'assets/locales',
      useOnlyLangCode: true,
      child: CovidTrackerApp(),
    ),
  );
}
