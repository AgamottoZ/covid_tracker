import 'dart:async';
import 'package:covid_tracker/color.dart';
import 'package:covid_tracker/injection.dart';
import 'package:covid_tracker/models/daily_stats.dart';
import 'package:covid_tracker/models/stats.dart';
import 'package:covid_tracker/screens/home/charts/line_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:covid_tracker/environment.dart';
import 'package:covid_tracker/utils/utils.dart';
import 'package:covid_tracker/utils/mixins.dart';
import 'package:covid_tracker/bloc/home_bloc.dart';
import 'package:covid_tracker/screens/home/widgets/index.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with ScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  HomeBloc _homeBloc;
  final _env = getIt.get<Environment>();

  StreamSubscription _subCurrentTab;
  Size _screenSize;

  final _titles = [
    'infected',
    'recovered',
    'fatal',
  ];

  final _assetLinks = [
    'assets/images/infected.png',
    'assets/images/recovered.png',
    'assets/images/fatal.png'
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homeBloc = Provider.of<HomeBloc>(context);
    if (_env.selectedCountryCode == GLOBAL_COUNTRY_CODE) {
      _homeBloc.getGlobalStats();
      _homeBloc.getGlobalTimeline();
    } else {
      _homeBloc.getCountryStats(_env.selectedCountryCode);
    }
    _screenSize = MediaQuery.of(context).size;
  }

  @override
  dispose() {
    super.dispose();
    scrollController.dispose();
    _subCurrentTab?.cancel();
    _homeBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.v(context.locale.languageCode);
    return Material(
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildBanner(),
              _buildStatistics(),
              _buildBottomBanner(),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildBanner() {
    return Container(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Container(
            width: _screenSize.width,
            height: _screenSize.height * 0.33,
            child: CustomPaint(
              painter: CurvePainter(),
            ),
          ),
          Positioned(
            left: 30,
            top: 60,
            child: _buildBannerText(),
          ),
          Positioned(
            top: 35,
            right: 10,
            child: Image.asset('assets/images/top_banner.png'),
          ),
          Positioned(
            top: 30,
            right: 5,
            child: LanguageButton(),
          ),
          Positioned(
            top: _screenSize.height * 0.26,
            left: _screenSize.width / 2 - 50,
            child: CountrySelectButton(),
          )
        ],
      ),
    );
  }

  Container _buildBannerText() {
    return Container(
      width: _screenSize.width * 0.5,
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.montserrat(fontSize: 28, color: Colors.white),
          children: [
            TextSpan(text: tr('slogan')),
            TextSpan(text: '\n'),
            if (!_env.isVnese) TextSpan(text: tr('slogan2')),
            if (!_env.isVnese) TextSpan(text: '\n'),
            if (!_env.isVnese)
              TextSpan(
                text: tr('together'),
                style: GoogleFonts.montserrat(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildStatistics() {
    return Container(
        width: _screenSize.width,
        height: _screenSize.height * 0.47,
        child:
//      Swiper(
//        itemCount: 3,
//        itemBuilder: (context, index) {
//          switch (index) {
//            case 0:
//              return _buildGeneralStats();
//            case 1:
//              return
            _buildCharts()
//            case 2:
//            default:
//              return Container(
//                color: UIColors.green,
//              );
//          }
//        },
//      ),
        );
  }

  _buildGeneralStats() {
    return StreamBuilder<Stats>(
      stream: _homeBloc.statStream,
      builder: (context, snapshot) {
        Stats _stats;
        if (snapshot.hasData) {
          _stats = snapshot.data;
        }

        return Container(
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 50),
              shrinkWrap: true,
              itemCount: _titles.length,
              itemBuilder: (context, index) {
                var data = 0;
                if (_stats != null) {
                  switch (index) {
                    case 0:
                      data = _stats.totalCases;
                      break;
                    case 1:
                      data = _stats.totalRecovered;
                      break;
                    case 2:
                      data = _stats.totalDeaths;
                      break;
                  }
                }
                return _buildStatisticItem(
                  index,
                  data, //! MOCKING
                );
              }),
        );
      },
    );
  }

  Container _buildStatisticItem(int index, int amount) {
    var _color;
    switch (index) {
      case 0:
        _color = UIColors.purple;
        break;
      case 1:
        _color = UIColors.green;
        break;
      case 2:
        _color = UIColors.red;
        break;
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                tr(_titles[index]).toUpperCase(),
                style: GoogleFonts.montserrat(
                  color: _color,
                  fontSize: 25,
                ),
              ),
              Text(
                NumberFormat.compact().format(amount),
                style: GoogleFonts.montserrat(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Image.asset(_assetLinks[index]),
        ],
      ),
    );
  }

  _buildCharts() {
    return Container(
      child: StreamBuilder(
        stream: _homeBloc.timelineStream,
        builder: (context, snapshot) {
          List<DailyStats> _data;
          if (snapshot.hasData) {
            _data = snapshot.data;
          }
          return Column(
            children: <Widget>[
              ChartBuilder(
                option: lineChartOption(
                  dates: _data?.map((e) => e.date)?.toList() ?? [],
                  confirmed: _data?.map((e) => e.cases)?.toList() ?? [],
                  deaths: _data?.map((e) => e.deaths)?.toList() ?? [],
                  recovered: _data?.map((e) => e.recovered)?.toList() ?? [],
                ),
                width: _screenSize.width * 0.8,
                height: _screenSize.height * 0.45,
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomBanner() {
    return Container(
      width: _screenSize.width,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Container(
            width: _screenSize.width,
            height: _screenSize.height * 0.2,
            child: CustomPaint(
              painter: BottomCurvePainter(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset('assets/images/man.png'),
              Container(
                width: _screenSize.width * 0.55,
                height: 90,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      left: 2,
                      child: Container(
                        width: 30,
                        height: 30,
                        child: FlareActor(
                          'assets/animation/bulb.flr',
                          animation: 'Loop',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 33,
                      child: Text(
                        tr('tip_question'),
                        style: GoogleFonts.montserrat(
                          color: Color(0xFF0E0B87),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 13,
                      top: 32,
                      child: Container(
                        width: 210,
                        height: 40,
                        child: Swiper(
                          itemCount: 3,
                          autoplay: true,
                          loop: true,
                          itemBuilder: (context, index) => Text(
                            tr('tip$index'),
                            style: GoogleFonts.montserrat(
                              color: Color(0xFF0E0B87),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
//                    Positioned(
//                      bottom: 0,
//                      child: SizedBox(
//                        width: 35,
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: List<Widget>.generate(
//                            3,
//                            (index) => CircleAvatar(
//                              minRadius: 4,
//                              maxRadius: 4,
//                              backgroundColor: _currentIndex == index
//                                  ? UIColors.purple
//                                  : Colors.grey[300],
//                            ),
//                          ),
//                        ),
//                      ),
//                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {}
}