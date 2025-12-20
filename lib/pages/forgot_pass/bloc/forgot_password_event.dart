part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();
}

class ForgetPasswordSubmitted extends ForgotPasswordEvent {
  final String parentPhoneNum;

  const ForgetPasswordSubmitted({required this.parentPhoneNum});

  @override
  List<Object?> get props => [];
}
