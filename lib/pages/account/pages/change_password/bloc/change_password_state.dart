part of 'change_password_bloc.dart';

abstract class ChangePasswordState extends Equatable {}

class ChangePasswordInitial extends ChangePasswordState {
  @override
  List<Object?> get props => [];
}

class ChangePasswordFailure extends ChangePasswordState {
  final String mess;

  ChangePasswordFailure({required this.mess});

  @override
  List<Object?> get props => [mess];
}

class ChangePasswordSuccess extends ChangePasswordState {
  final String mess;

  ChangePasswordSuccess({required this.mess});

  @override
  List<Object?> get props => [mess];
}
