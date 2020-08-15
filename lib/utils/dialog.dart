import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  static showAlert(BuildContext context, [String message]) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(tr(message)),
      ),
    );
  }
}
