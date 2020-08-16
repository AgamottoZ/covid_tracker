import 'package:covid_tracker/bloc/home_bloc.dart';
import 'package:covid_tracker/color.dart';
import 'package:covid_tracker/data.dart';
import 'package:covid_tracker/environment.dart';
import 'package:covid_tracker/injection.dart';
import 'package:covid_tracker/utils/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CountrySelectButton extends StatefulWidget {
  @override
  _CountrySelectButtonState createState() => _CountrySelectButtonState();
}

class _CountrySelectButtonState extends State<CountrySelectButton> {
  FixedExtentScrollController _scrollController;
  final Environment _env = getIt.get<Environment>();
  HomeBloc _homeBloc;
  String _selectedCountryCode;
  String _selectedCountryCode3;
  Size _screenSize;

  @override
  void initState() {
    _selectedCountryCode = _env.selectedCountryCode;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenSize = MediaQuery.of(context).size;
    _homeBloc = Provider.of<HomeBloc>(context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scrollController = FixedExtentScrollController(
        initialItem: countryList.indexOf(countryList.firstWhere(
            (element) => element.isoCode == _selectedCountryCode,
            orElse: () => null)));
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _onTapButton(),
      child: Container(
        width: 100,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.filter_list),
            SizedBox(width: 5),
            Text(
              tr(_selectedCountryCode),
              style: GoogleFonts.montserrat(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  _onTapButton() {
    _scrollController.jumpToItem(countryList.indexOf(countryList
        .firstWhere((element) => element.isoCode == _selectedCountryCode)));
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (context) => Container(
        width: _screenSize.width,
        height: _screenSize.height * 0.5,
        padding: EdgeInsets.fromLTRB(10, 3, 10, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 100,
              height: 5,
              color: Theme.of(context).dividerColor,
            ),
            Text(
              tr('choose_country'),
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color: UIColors.navy,
                fontSize: 25,
              ),
            ),
            Container(
              height: _screenSize.height * 0.3,
              child: ListWheelScrollView(
                itemExtent: 45,
                useMagnifier: true,
                magnification: 1.3,
                controller: _scrollController,
                onSelectedItemChanged: (index) => setState(() {
                  _selectedCountryCode = countryList[index].isoCode;
                  _selectedCountryCode3 = countryList[index].iso3Code;
                }),
                children: List<Widget>.generate(
                  countryList.length,
                  (index) => Container(
                    child: Text(
                      countryList[index].name == GLOBAL_COUNTRY_CODE
                          ? tr(GLOBAL_COUNTRY_CODE)
                          : countryList[index].name,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        color: UIColors.navy,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (_selectedCountryCode == GLOBAL_COUNTRY_CODE) {
                  _homeBloc.getGlobalStats();
                  _homeBloc.getGlobalTimeline();
                } else {
                  print(_selectedCountryCode3);
                  _homeBloc.getCountryStats(_selectedCountryCode);
                  _homeBloc.getCountryTimeline(_selectedCountryCode3);
                }
                Navigator.of(context).pop();
              },
              child: Container(
                width: _screenSize.width,
                height: 60,
                color: UIColors.navy,
                alignment: Alignment.center,
                child: Text(
                  tr('select'),
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
