import 'package:covid_tracker/bloc/home_bloc.dart';
import 'package:covid_tracker/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:covid_tracker/utils/constants.dart';
import 'package:provider/provider.dart';

class CovidTrackerApp extends StatefulWidget {
  @override
  _CovidTrackerAppState createState() => _CovidTrackerAppState();
}

class _CovidTrackerAppState extends State<CovidTrackerApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  var _homeBloc = HomeBloc();

  @override
  void dispose() {
    _homeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => _homeBloc,
      child: MaterialApp(
        title: APP_TITLE,
        debugShowCheckedModeBanner: false,
        navigatorObservers: [
          //! Register Firebase Analytics Observer here
        ],
        navigatorKey: _navigatorKey,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: HomeScreen(),
      ),
    );
  }
}
