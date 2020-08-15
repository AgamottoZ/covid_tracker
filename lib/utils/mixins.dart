import 'package:flutter/cupertino.dart';

mixin ScrollControllerMixin<T extends StatefulWidget> on State<T> {
  ScrollController scrollController = ScrollController();

  addListener(VoidCallback loadMore) {
    //! Reach bottom
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      loadMore();
    }

    //! Reach top
    if (scrollController.offset <= scrollController.position.minScrollExtent &&
        !scrollController.position.outOfRange) {}
  }
}
