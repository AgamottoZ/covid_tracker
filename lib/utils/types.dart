import 'package:flutter/material.dart';

enum TabPage { home, video, activity, contact, more }

enum TextScale { small, medium, large, veryLarge }

enum LocaleValue { vi, en }

enum ImageSize { origin, large, medium, small }

extension LocaleParser on LocaleValue {
  get locale => this == LocaleValue.en ? Locale('en') : Locale('vi');
}

extension TextScaleDelta on TextScale {
  int get delta {
    switch (this) {
      case TextScale.small:
        return 1;
      case TextScale.large:
        return 3;
      case TextScale.veryLarge:
        return 4;
      case TextScale.medium:
      default:
        return 2;
    }
  }
}

getTextScaleFromDelta(int delta) {
  switch (delta) {
    case 1:
      return TextScale.small;
    case 3:
      return TextScale.large;
    case 4:
      return TextScale.veryLarge;
    case 2:
    default:
      return TextScale.medium;
  }
}
