part of 'login_page_bloc.dart';

@immutable
abstract class LoginPageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginProcessing extends LoginPageState {
  @override
  List<Object?> get props => [];
}

class LoginSuccess extends LoginPageState {
  final int code;
  final String mess;
  final UserLoginInfoModel user;

  LoginSuccess({required this.code, required this.mess, required this.user});

  @override
  List<Object> get props => [code, mess, user];
}

class LoginFail extends LoginPageState {
  final String mess;

  LoginFail({required this.mess});

  @override
  List<Object?> get props => [mess];
}
