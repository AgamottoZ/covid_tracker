import 'package:intl/intl.dart';

final _dateFormatD = DateFormat("dd");
final _dateFormatM = DateFormat("MM");
final _dateFormatY = DateFormat("yyyy");
final _dateFormatDM = DateFormat("dd/MM");
final _dateFormatDMY = DateFormat("dd/MM/yyyy");
final _dateFormatFull = DateFormat("dd/MM/yyyy HH:mm:ss");

final _numFormat = NumberFormat("#,###", "en_US");
final _numFormatCurrency = NumberFormat("###,###,###.##", "en_US");
final _numFormatCurrencyRounded = NumberFormat("###,###,###", "en_US");

extension NumExt on num {
  String get currencyValue => _numFormatCurrency.format(this);

  String get currencyValueRounded => _numFormatCurrencyRounded.format(this);

  String get numValue => _numFormat.format(this);

  String get percentageValue => '${this / 100} %';
}

extension DateTimeExt on DateTime {
  String get formatDM => (this != null) ? _dateFormatDM.format(this) : "";

  String get formatYY => (this != null) ? _dateFormatY.format(this) : "";

  String get formatMM => (this != null) ? _dateFormatM.format(this) : "";

  String get formatDD => (this != null) ? _dateFormatD.format(this) : "";

  String get formatDMY => (this != null) ? _dateFormatDMY.format(this) : "";

  String get formatFull => (this != null) ? _dateFormatFull.format(this) : "";
}

double toDouble(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String && value.isNotEmpty) return double.tryParse(value);
  throw FormatException('Cannot parse to double');
}

int toInt(dynamic value) {
  if (value is num) return value.toInt();
  if (value is String && value.isNotEmpty) return int.tryParse(value);
  throw FormatException('Cannot parse to int');
}

bool toBool(value) {
  if (value is bool) return value;
  final strValue = value.toString()?.toLowerCase();
  if (strValue == 'true' || strValue == '1') return true;
  if (strValue == 'false' || strValue == '0') return false;
  throw FormatException('Cannot parse to bool');
}

parseJsonArray(List<dynamic> data) => data == null
    ? null
    : List<Map<String, dynamic>>.from(
        data.map((e) => Map<String, dynamic>.from(e)));
