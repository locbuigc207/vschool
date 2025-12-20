import 'package:dio/dio.dart';
import 'package:vschool/commons/models/auth_info/auth_info.dart';
import 'package:vschool/commons/models/no_data/no_data.dart';

class ErrorInterceptor extends Interceptor {
  ErrorInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw TimeoutException(err.requestOptions);
      case DioExceptionType.badResponse:
        switch (err.response?.statusCode) {
          case 401:
          case 403:
            throw UnauthorizedException(
              requestOptions: err.requestOptions,
              response: err.response,
            );
          case 400:
          case 404:
          case 409:
          case 500:
            throw ResponseException(
              requestOptions: err.requestOptions,
              response: err.response,
            );
          case 502:
            throw ServiceUnavailableException(
                requestOptions: err.requestOptions);
        }
        break;
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.unknown:
        throw BadNetworkException(err.requestOptions);
      default:
        throw BadNetworkException(err.requestOptions);
    }

    return handler.next(err);
  }
}

class ResponseException extends DioException {
  ResponseException({
    required super.requestOptions,
    super.response,
  });

  @override
  String toString() {
    final data = response?.data;

    if (data != null) {
      try {
        final res = NoData.fromJson(data);
        final desc = res.mess?.message;
        if (desc != null) return desc;
      } on Exception {
        return 'Có lỗi xảy ra';
      }
    }

    return 'Có lỗi xảy ra';
  }
}

class ServiceUnavailableException extends DioException {
  ServiceUnavailableException({required super.requestOptions});

  @override
  String toString() {
    return 'Dịch vụ hiện đang bị gián đoạn';
  }
}

class UnauthorizedException extends DioException {
  UnauthorizedException({
    required super.requestOptions,
    super.response,
  });

  @override
  String toString() {
    final data = response?.data;

    if (data != null) {
      final mess = AuthMessage.fromJson(data);
      final errorDesc = mess.errorDescription;
      if (errorDesc != null) return errorDesc;
    }

    return 'Không có quyền truy cập';
  }
}

class NotFoundException extends DioException {
  NotFoundException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The requested information could not be found';
  }
}

class BadNetworkException extends DioException {
  BadNetworkException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Không có kết nối, vui lòng thử lại';
  }
}

class TimeoutException extends DioException {
  TimeoutException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Kết nối bị gián đoạn, vui lòng thử lại';
  }
}
