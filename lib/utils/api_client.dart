import 'package:covid_tracker/injection.dart';
import 'package:dio/dio.dart';
import 'package:ansicolor/ansicolor.dart';

import 'package:covid_tracker/environment.dart';
import 'package:covid_tracker/utils/utils.dart';

class APIClient {
  Dio dio;

  init() {
    final isDev = getIt.get<Environment>().isDev;

    dio = Dio(BaseOptions(
      connectTimeout: CONNECT_TIMEOUT,
      receiveTimeout: RECEIVE_TIMEOUT,
    ));

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      _printDebugRequest(options, isDev);
      return options;
    }, onResponse: (Response response) async {
      _printDebugResponse(response, isDev);
      return response;
    }, onError: (DioError error) async {
      _printDebugError(error, isDev);
      return error;
    }));
  }

  void _printDebugRequest(RequestOptions options, bool isDev) {
    if (!isDev) return;

    assert(() {
      AnsiPen pen = AnsiPen()..cyan();
      print("\n\n");
      print(pen("================ Request ================"));
      print(pen("method: ${options.method}"));
      if (options.queryParameters.length > 0)
        print(pen("params: ${options.queryParameters}"));
      print(pen("headers: ${options.headers}"));
      print(pen("data: ${options.data}"));
      print(pen("uri: ${options.path}"));
      print(pen("Content type: ${options.contentType}"));
      print(pen("============== End Request =============="));
      print("\n\n");
      return true;
    }());
  }

  void _printDebugResponse(Response response, bool isDev) {
    if (!isDev) return;

    assert(() {
      AnsiPen pen = AnsiPen()..green();
      print("\n\n");
      print(pen("================ Response ==============="));
      print(pen("uri: ${response.request.path}"));
      print(pen("status: ${response.statusCode} ${response.statusMessage}"));
      print(pen("data: ${response.data}"));
      print(pen(
          "time: ${DateTime.now().millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch} ms"));
      print(pen("============== End Response ============="));
      print("\n\n");
      return true;
    }());
  }

  void _printDebugError(DioError error, bool isDev) {
    if (!isDev) return;

    assert(() {
      AnsiPen pen = AnsiPen()..red();
      print("\n\n");
      print(pen("============= Response ERROR ============"));
      print(pen("uri: ${error.request.path}"));
      print(pen("type: ${error.type}"));
      print(pen("error: ${error.error}"));
      if (error.response != null && error.response.data != null)
        print(pen("message: ${error.response.data}"));
      print(pen("============== End Response ============="));
      print("\n\n");
      return true;
    }());
  }
}
