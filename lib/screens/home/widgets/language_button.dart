import 'package:covid_tracker/color.dart';
import 'package:covid_tracker/environment.dart';
import 'package:covid_tracker/injection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:covid_tracker/utils/constants.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageButton extends StatefulWidget {
  @override
  _LanguageButtonState createState() => _LanguageButtonState();
}

class _LanguageButtonState extends State<LanguageButton> {
  final _env = getIt.get<Environment>();
  FixedExtentScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    _scrollController = FixedExtentScrollController(
      initialItem: LOCALES.indexOf(context.locale.languageCode),
    );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => Container(
            height: 150,
            padding: EdgeInsets.all(10),
            child: ListWheelScrollView(
              itemExtent: 40,
              useMagnifier: true,
              magnification: 1.2,
              controller: _scrollController,
              onSelectedItemChanged: (index) {
                context.locale = Locale(LOCALES[index]);
                _env.setLocale(context.locale.languageCode == LOCALES.first);
              },
              children: List<Widget>.generate(
                COUNTRIES.length,
                (index) => Container(
                  child: Text(
                    COUNTRIES[index],
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
        );
      },
      child: Container(
        width: 50,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset(
                context.locale.languageCode == 'vi'
                    ? 'assets/images/vn.png'
                    : 'assets/images/en.png',
                width: 18,
                height: 18),
            Text(
              context.locale.languageCode.toUpperCase(),
              style: GoogleFonts.montserrat(
                  color: UIColors.navy,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
            Container()
          ],
        ),
      ),
    );
  }
}
