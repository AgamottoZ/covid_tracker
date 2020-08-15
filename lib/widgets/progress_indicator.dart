import 'package:flutter/material.dart';

class LinearProgressing extends StatelessWidget {
  final Stream<bool> stream;
  final double width;

  LinearProgressing({@required this.stream, this.width}) : assert(stream != null);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: false,
      stream: stream,
      builder: (context, snapshot) {
        return Container(
          height: 3,
          width: width,
          child: snapshot.data ? LinearProgressIndicator() : Container(),
        );
      },
    );
  }
}
