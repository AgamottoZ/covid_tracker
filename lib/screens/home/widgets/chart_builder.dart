import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:rxdart/rxdart.dart';

class ChartBuilder extends StatefulWidget {
  final String option;
  final String theme;
  final double width;
  final double height;
  final EdgeInsets padding;

  ChartBuilder({
    this.option,
    this.theme,
    this.width,
    this.height = 350,
    this.padding,
  });

  @override
  _ChartBuilderState createState() => _ChartBuilderState();
}

class _ChartBuilderState extends State<ChartBuilder> {
  BehaviorSubject<bool> _visible = BehaviorSubject.seeded(true);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _visible.close();
  }

  var _extraScript = '''
      chart.on('finished', (params) => {
          Messager.postMessage(JSON.stringify({
            type: 'finished'
          }));
      })
      ''';

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      width: widget.width ?? _screenSize.width,
      height: widget.height,
      color: Theme.of(context).cardColor,
      padding: widget.padding ?? EdgeInsets.all(10),
      child: Stack(
        children: <Widget>[
          Echarts(
            extraScript: _extraScript,
            onMessage: (String message) {
              Map<String, Object> messageAction = jsonDecode(message);
              if (messageAction['type'] == 'finished') {
                Future.delayed(Duration(milliseconds: 300), () {
                  _visible.add(false);
                  if (!mounted) return;
                });
              }
            },
//            extensions: [darkThemeScript],
//            theme: widget.theme != null
//                ? widget.theme
//                : (_prefs.light ? '' : 'dark'),
            option: widget.option,
          ),
//          StreamBuilder<bool>(
//            stream: _visible,
//            initialData: false,
//            builder: (context, snapshot) {
//              return Visibility(
//                visible: snapshot.data,
//                child: Container(
//                    color: Theme.of(context).cardColor,
//                    width: widget.width ?? _screenSize.width,
//                    child: CupertinoActivityIndicator(),
//                    height: widget.height),
//              );
//            },
//          ),
        ],
      ),
    );
  }
}
