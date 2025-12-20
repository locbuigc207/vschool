import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vschool/commons/models/banner/banner_model.dart';
import 'package:vschool/commons/models/childs/children_model.dart';

import 'package:vschool/commons/repository/user_repository.dart';
import 'package:vschool/pages/bloc/app/app_bloc.dart';

part 'home_state.dart';

part 'home_event.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final IUserRepository _userRepository;
  final AppBloc _appBloc;

  HomePageBloc(
      {required IUserRepository userRepository, required AppBloc appBloc})
      : _userRepository = userRepository,
        _appBloc = appBloc,
        super(GetAllChildrenInitial()) {
    on<GetAllChildren>(_onGetAllChildren);
    on<ChildChanged>(_onChildChanged);
    on<GetSchoolInfo>(_onGetSchoolInfo);
    on<GetBannerContent>(_onGetBannerContent);
    on<GetStudentByCode>(_onGetStudentByCode);
  }

  FutureOr<void> _onGetAllChildren(
      GetAllChildren event, Emitter<HomePageState> emit) async {
    emit(GetAllChildrenInitial());

    // ignore: unused_local_variable
    var parentPhoneNum = _appBloc.state.user!.phoneNumber;

    // final result =
    // await _userRepository.getAllChildren(parentPhonenum: parentPhoneNum!);

    // result.when(
    // success: (success) =>
    List<ChildrenInfoModel> newStudent = _appBloc.state.user!.students ?? [];
    emit(GetAllChildrenSuccess(children: newStudent));
    // failure: (failure) =>
    // emit(GetAllChildrenFailure(result.failure?.message ?? '')),
    // );
  }

  FutureOr<void> _onChildChanged(
      ChildChanged event, Emitter<HomePageState> emit) {
    emit(ChildSelectedChanging(child: event.child));
  }

  FutureOr<void> _onGetSchoolInfo(
      GetSchoolInfo event, Emitter<HomePageState> emit) async {
    final result =
        await _userRepository.getSchoolInfo(studentId: event.studentId);

    result.when(
      success: (success) =>
          emit(GetSchoolSuccess(schoolInfoModel: result.success!.data ?? '')),
      failure: (failure) =>
          emit(GetSchoolFailure(result.failure?.message ?? '')),
    );
  }

  FutureOr<void> _onGetBannerContent(
      GetBannerContent event, Emitter<HomePageState> emit) async {
    emit(GetBannerContentInitial());
    // final result = await _userRepository.getBannerContent();
    //
    // result.when(
    //   success: (success) =>
    //       emit(GetBannerContentSuccess(data: result.success?.data)),
    //   failure: (failure) =>
    //       emit(GetBannerContentFailure(mess: result.failure?.message ?? '')),
    // );
  }

  FutureOr<void> _onGetStudentByCode(
      GetStudentByCode event, Emitter<HomePageState> emit) async {
    final result =
        await _userRepository.getStudentByCode(studentCode: event.studentCode);

    result.when(
      success: (success) =>
          emit(GetChildByCodeSuccess(child: result.success!.child)),
      failure: (failure) =>
          GetChildByCodeFailure(mess: result.failure?.message ?? ''),
    );
  }
}
