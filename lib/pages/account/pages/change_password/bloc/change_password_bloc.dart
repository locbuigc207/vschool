import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vschool/commons/models/user/user_model.dart';
import 'package:vschool/commons/repository/user_repository.dart';

part 'change_password_event.dart';

part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final IUserRepository _userRepository;

  ChangePasswordBloc({required IUserRepository userRepository})
      : _userRepository = userRepository,
        super(ChangePasswordInitial()) {
    on<ChangePasswordSubmitted>(_onChangePasswordSubmitted);
  }

  FutureOr<void> _onChangePasswordSubmitted(
      ChangePasswordSubmitted event, Emitter<ChangePasswordState> emit) async {
    final request = ChangePassModel(
        username: event.username,
        oldPassword: event.oldPassword,
        newPassword: event.newPassword);

    final result = await _userRepository.changePass(request: request);

    result.when(
      success: (success) =>
          emit(ChangePasswordSuccess(mess: result.success?.msg ?? '')),
      failure: (failure) =>
          emit(ChangePasswordFailure(mess: result.failure?.message ?? '')),
    );
  }
}
