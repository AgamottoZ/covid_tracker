import 'package:flutter/services.dart';

enum ResponseState {
  LOADING,
  ERROR,
  SUCCESS,
}

class ResponseResult<D> {
  D data;
  String errorCode;
  String errorMessage;
  ResponseState state;

  ResponseResult({
    this.data,
    this.errorCode,
    this.errorMessage,
    this.state,
  });

  ResponseResult.fromError(error) {
    if (error is PlatformException) {
      if (error.details is Map) {
        throw ResponseResult(
          errorMessage: error.details['message'],
          errorCode: error.details['code'],
        );
      }
    }
  }

  toJson() => {
        'state': state,
        'errorCode': errorCode,
        'data': data,
      };

  @override
  String toString() => this.toJson().toString();
}
