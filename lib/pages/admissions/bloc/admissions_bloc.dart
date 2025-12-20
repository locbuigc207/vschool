import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vschool/commons/models/admissions/admissions_model.dart';
import 'package:vschool/commons/repository/admissions_repository.dart';

part 'admissions_event.dart';

part 'admissions_state.dart';

class AdmissionsBloc extends Bloc<AdmissionsEvent, AdmissionsState> {
  final IAdmissionsRepository _admissionsRepository;

  AdmissionsBloc({required IAdmissionsRepository admissionsRepository})
      : _admissionsRepository = admissionsRepository,
        super(AdmissionsSubmitInit()) {
    on<AdmissionsSubmitting>(_onAdmissionsSubmitting);
  }

  FutureOr<void> _onAdmissionsSubmitting(
      AdmissionsSubmitting event, Emitter<AdmissionsState> emit) async {
    emit(AdmissionsSubmitInit());

    final request = AdmissionsModel(
        studentCode: event.studentCode,
        studentName: event.studentName,
        studentDob: event.studentDob,
        gender: event.gender,
        address: event.address,
        householderName: event.householderName,
        dadName: event.dadName,
        dadJob: event.dadJob,
        dadPhoneNum: event.dadPhoneNum,
        momName: event.momName,
        momJob: event.momJob,
        momPhoneNum: event.momPhoneNum,
        patronsName: event.patronsName,
        patronsJob: event.patronsJob,
        patronsPhoneNum: event.patronsPhoneNum,
        contactAddress: event.contactAddress,
        note: event.note,
        graduateLevel: event.graduateLevel,
        graduateSchool: event.graduateSchool,
        graduateGrades: event.graduateGrades,
        desiredSchool: event.desiredSchool);

    final result =
        await _admissionsRepository.submitAdmissions(request: request);

    result.when(
      success: (success) => emit(AdmissionsSubmitSuccess(
          code: result.success!.resultCode, mess: result.success!.message)),
      failure: (failure) =>
          emit(AdmissionsSubmitFailed(mess: result.failure?.message ?? '')),
    );
  }
}
