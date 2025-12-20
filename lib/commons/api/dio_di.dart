import 'package:dio/dio.dart';
import 'package:flutter_loggy_dio/flutter_loggy_dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:vschool/commons/api/interceptors/auth_interceptor.dart';
import 'package:vschool/commons/api/interceptors/error_interceptor.dart';
import 'package:vschool/commons/api/interceptors/json_interceptor.dart';
import 'package:vschool/injections.dart';
import 'package:vschool/pages/bloc/app/app_bloc.dart';

abstract class DioDi {
  Dio get dio {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);

    dio.interceptors.add(JsonResponseConverter());
    dio.interceptors.add(ErrorInterceptor());
    dio.interceptors.add(AuthInterceptor(bloc: getIt<AppBloc>()));
    dio.interceptors.add(LoggyDioInterceptor(
      responseBody: true,
      requestBody: true,
    ));
    // dio.interceptors.addAll(dioLogger(), InterceptorsWrapper(
    //
    // ));

    return dio;
  }

  PrettyDioLogger dioLogger() {
    return PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      maxWidth: 100,
    );
  }
}
