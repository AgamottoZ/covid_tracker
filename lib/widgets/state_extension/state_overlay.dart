import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class StateOverlay<T extends StatefulWidget> extends State<T>
    with RouteAware, WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  displayOverlay() {
    showDialog(
        context: context,
        builder: (context) => Container(
              child: CupertinoActivityIndicator(),
            ));
  }
}
