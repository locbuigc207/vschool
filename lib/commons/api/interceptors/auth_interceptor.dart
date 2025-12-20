import 'package:dio/dio.dart';
import 'package:vschool/pages/bloc/app/app_bloc.dart';

class AuthInterceptor extends Interceptor {
  // Don't need stream subscription cause everytime we request, we get token
  // from [AuthenticationBloc] state and apply it to the request's header
  // ignore: unused_field
  final AppBloc _appBloc;

  AuthInterceptor({
    required AppBloc bloc,
  }) : _appBloc = bloc;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // trungnh config token

    // final authInfo = _appBloc.state.authInfo;
    // if (authInfo != null &&
    //     authInfo.accessToken != null &&
    //     !options.headers.containsKey('Authorization')) {
    //   options.headers['Authorization'] = 'Bearer ${authInfo.accessToken}';
    // }
    super.onRequest(options, handler);
  }
}
