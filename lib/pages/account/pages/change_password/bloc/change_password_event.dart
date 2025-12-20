part of 'change_password_bloc.dart';

abstract class ChangePasswordEvent extends Equatable {}

class ChangePasswordSubmitted extends ChangePasswordEvent {
  final String username;
  final String oldPassword;
  final String newPassword;

  ChangePasswordSubmitted(
      {required this.username,
      required this.oldPassword,
      required this.newPassword});

  @override
  List<Object?> get props => [];
}
