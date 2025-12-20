part of 'login_page_bloc.dart';

abstract class LoginPageEvent extends Equatable {
  const LoginPageEvent();
}

class Login extends LoginPageEvent {
  final String username;
  final String password;

  const Login({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}
