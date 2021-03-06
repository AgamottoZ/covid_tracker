import 'dart:async';
import 'package:covid_tracker/color.dart';
import 'package:covid_tracker/injection.dart';
import 'package:covid_tracker/models/daily_stats.dart';
import 'package:covid_tracker/models/models.dart';
import 'package:covid_tracker/models/response_result.dart';
import 'package:covid_tracker/models/stats.dart';
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
import 'package:shimmer/shimmer.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with ScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  HomeBloc _homeBloc;
  final _env = getIt.get<Environment>();
  bool _isVnese = false;

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

  _startTimer() async {
    if (mounted)
      await Future.delayed(
        Duration(seconds: 2),
        () => showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            Future.delayed(
                Duration(seconds: 2), () => Navigator.of(context).pop());
            return Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(Icons.arrow_back, color: Colors.white, size: 50),
                        Text(
                          "Swipe for more data",
                          style: GoogleFonts.montserrat(
                              color: Colors.white, fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      );
  }

  @override
  initState() {
    super.initState();
    if (mounted) {
      _startTimer();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _homeBloc = Provider.of<HomeBloc>(context);
    if (_env.selectedCountryCode == GLOBAL_COUNTRY_CODE) {
      _homeBloc.getGlobalStats();
      _homeBloc.getGlobalTimeline();
    } else {
      _homeBloc.getCountryStats(_env.selectedCountryCode);
      _homeBloc.getCountryTimeline(_env.selectedCountryCode3);
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
    _isVnese = context.locale.languageCode == LOCALES.first;
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBannerText(),
                Image.asset('assets/images/top_banner.png'),
              ],
            ),
          ),
          Positioned(
            top: 35,
            right: 5,
            child: LanguageButton(),
          ),
          Positioned(
            top: _screenSize.height * 0.27,
            left: _screenSize.width / 2 - 50,
            child: CountrySelectButton(),
          )
        ],
      ),
    );
  }

  Container _buildBannerText() {
    return Container(
      width: _screenSize.width * 0.46,
      height: 100,
      padding: EdgeInsets.only(left: _isVnese ? 10 : 0),
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.montserrat(fontSize: 28, color: Colors.white),
          children: [
            TextSpan(text: tr('slogan')),
            if (!_isVnese)
              TextSpan(
                text: 'Together.',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.white,
                ),
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
      child: Swiper(
        itemCount: 2,
        loop: false,
        itemBuilder: (context, index) {
          switch (index) {
            case 1:
              return _buildCharts();
            case 0:
            default:
              return _buildGeneralStats();
          }
        },
      ),
    );
  }

  _buildGeneralStats() {
    return StreamBuilder<Stats>(
      stream: _homeBloc.statStream,
      builder: (context, snapshot) {
        Stats _stats;
        var _loading = snapshot.data == null;
        if (snapshot.hasData) {
          _stats = snapshot.data;
        }

        return Container(
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 45),
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
                    _loading);
              }),
        );
      },
    );
  }

  Container _buildStatisticItem(int index, int amount, bool _loading) {
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
              _loading
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey,
                      highlightColor: Color(0xff4F4F4),
                      child: Container(
                        height: 60,
                        width: 150,
                        color: Colors.black54,
                      ),
                    )
                  : Text(
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

  List<charts.Series> seriesList;

  _buildCharts() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: StreamBuilder(
        stream: _homeBloc.timelineStream,
        builder: (context, snapshot) {
          List<DailyStats> _data;
          if (snapshot.hasData) {
            _data = snapshot.data;
          }
          return _data == null
              ? Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Color(0xff4F4F4),
                  child: Container(
                    width: _screenSize.width * 0.9,
                    color: Colors.black54,
                  ),
                )
              : charts.BarChart(
                  _createData(_data),
                  animate: true,
                  barGroupingType: charts.BarGroupingType.stacked,
                  domainAxis: charts.AxisSpec<String>(
                      renderSpec: charts.NoneRenderSpec()),
                  behaviors: [
                    charts.SeriesLegend(
                      position: charts.BehaviorPosition.bottom,
                      outsideJustification:
                          charts.OutsideJustification.endDrawArea,
                    )
                  ],
                  // hide y axis
                );
        },
      ),
    );
  }

  List<charts.Series<DailyStats, String>> _createData(List<DailyStats> data) {
    return [
      charts.Series<DailyStats, String>(
        id: tr('infected'),
        domainFn: (DailyStats sales, _) => sales.date,
        measureFn: (DailyStats sales, _) => sales.cases,
        colorFn: (DailyStats sales, _) => charts.Color(r: 128, g: 0, b: 128),
        data: data,
      ),
      charts.Series<DailyStats, String>(
        id: tr('recovered'),
        domainFn: (DailyStats sales, _) => sales.date,
        measureFn: (DailyStats sales, _) => sales.recovered,
        colorFn: (DailyStats sales, _) => charts.Color(r: 0, g: 255, b: 0),
        data: data,
      ),
      charts.Series<DailyStats, String>(
        id: tr('fatal'),
        domainFn: (DailyStats sales, _) => sales.date,
        measureFn: (DailyStats sales, _) => sales.deaths,
        colorFn: (DailyStats sales, _) => charts.Color(r: 255, g: 0, b: 0),
        data: data,
      ),
    ];
  }

  Widget _buildBottomBanner() {
    return Container(
      width: _screenSize.width,
      child: Stack(
        alignment: AlignmentDirectional.center,
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
                width: _screenSize.width * 0.6,
                height: 90,
                padding: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 32,
                          height: 32,
                          child: FlareActor(
                            'assets/animation/bulb.flr',
                            animation: 'Loop',
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text(
                          tr('tip_question'),
                          style: GoogleFonts.montserrat(
                            color: Color(0xFF0E0B87),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    FutureBuilder<ResponseResult<List<Tip>>>(
                      future: _homeBloc.getHomeTips(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        var _tips = snapshot.data.data;
                        return Container(
                          width: 210,
                          height: 40,
                          padding: EdgeInsets.only(left: 5),
                          child: Swiper(
                            itemCount: _tips.length,
                            autoplay: true,
                            loop: true,
                            itemBuilder: (context, index) => Text(
                              _isVnese
                                  ? _tips[index].text ?? ''
                                  : _tips[index].textEn ?? '',
                              style: GoogleFonts.montserrat(
                                color: Color(0xFF0E0B87),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    if (_env.selectedCountryCode == GLOBAL_COUNTRY_CODE) {
      _homeBloc.getGlobalStats();
      _homeBloc.getGlobalTimeline();
    } else {
      _homeBloc.getCountryStats(_env.selectedCountryCode);
      _homeBloc.getCountryTimeline(_env.selectedCountryCode3);
    }
  }
}

/// Sample
