import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:vschool/commons/models/user/user_model.dart';

part 'app_event.dart';

part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppState()) {
    on<UpdateAppUser>(
      (event, emit) {
        emit(state.copyWith(
          user: event.user,
        ));
      },
    );
  }
}
