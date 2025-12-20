import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vschool/commons/models/childs/children_model.dart';
import 'package:vschool/commons/repository/user_repository.dart';

part 'list_children_event.dart';

part 'list_children_state.dart';

class ListChildrenBloc extends Bloc<ListChildrenEvent, ListChildrenState> {
  final IUserRepository _userRepository;

  ListChildrenBloc({required IUserRepository userRepository})
      : _userRepository = userRepository,
        super(UpdateInfoChildrenInitial()) {
    on<UpdatingInfoStudent>(_onUpdatingInfoStudent);
  }

  FutureOr<void> _onUpdatingInfoStudent(
      UpdatingInfoStudent event, Emitter<ListChildrenState> emit) async {
    emit(UpdateInfoChildrenInitial());

    final request = ChildrenInfoModel(
      studentId: event.studentId,
      // bhytNum: event.bhytNum,
      className: event.cmnd,
      status: event.status,
      gender: event.gender,
      name: event.name,
      studentCode: event.studentCode,
      dob: event.dob,
      email: event.email,
      // address: event.address,
      classId: event.classId,
      parentPhonenum: event.parentPhonenum,
    );

    final result = await _userRepository.updateInfoStudent(request: request);

    result.when(
      success: (success) =>
          emit(UpdateInfoChildrenSuccess(mess: result.success?.message ?? '')),
      failure: (failure) =>
          emit(UpdateInfoChildrenFailure(mess: result.failure?.message ?? '')),
    );
  }
}
