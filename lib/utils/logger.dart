import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final bool _displayLog = DotEnv().env["DEV"] == 'true' ?? false;

class DevFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) => true;
}

class ProdFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) => false;
}

final logger = Logger(
  filter: _displayLog ? DevFilter() : ProdFilter(),
  printer: PrettyPrinter(),
);
