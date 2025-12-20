part of 'forgot_password_bloc.dart';

@immutable
abstract class ForgotPasswordState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ForgotPassInitial extends ForgotPasswordState {
  @override
  List<Object?> get props => [];
}

class ForgotPasswordSuccess extends ForgotPasswordState {
  final int code;
  final String mess;
  final UserLoginInfoModel user;

  ForgotPasswordSuccess(
      {required this.code, required this.mess, required this.user});

  @override
  List<Object?> get props => [];
}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String? message;

  ForgotPasswordFailure({this.message});

  @override
  List<Object?> get props => [message];
}
