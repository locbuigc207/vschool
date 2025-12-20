import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vschool/commons/models/user/user_model.dart';
import 'package:vschool/commons/repository/user_repository.dart';

part 'forgot_password_event.dart';

part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  // ignore: unused_field
  final IUserRepository _userRepository;

  ForgotPasswordBloc({required IUserRepository userRepository})
      : _userRepository = userRepository,
        super(ForgotPassInitial()) {
    on<ForgetPasswordSubmitted>(_onForgetPasswordSubmitted);
  }

  FutureOr<void> _onForgetPasswordSubmitted(event, emit) async {
    emit(ForgotPassInitial());

    // final result =
    //     await _userRepository.resetPass(phoneNumber: event.parentPhoneNum);

    // result.when(
    //   success: (success) => emit(ForgotPasswordSuccess(
    //       code: result.success!.resultCode,
    //       mess: result.success!.message,
    //       user: result.success!.user!)),
    //   failure: (failure) =>
    //       emit(ForgotPasswordFailure(message: result.failure?.message ?? '')),
    // );
  }
}
