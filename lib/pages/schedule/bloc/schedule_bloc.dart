import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vschool/commons/models/schedule/schedule_model.dart';
import 'package:vschool/commons/repository/schedule_repository.dart';

part 'schedule_event.dart';

part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final IScheduleRepository _scheduleRepository;

  ScheduleBloc({required IScheduleRepository scheduleRepository})
      : _scheduleRepository = scheduleRepository,
        super(ScheduleFetchInitial()) {
    on<ScheduleFetching>(_onScheduleFetching);
  }

  FutureOr<void> _onScheduleFetching(
      ScheduleFetching event, Emitter<ScheduleState> emit) async {
    final result = await _scheduleRepository.getSchedule(
        classId: event.classId,
        startDate: event.startDate,
        endDate: event.endDate,
        studyYear: event.studyYear);

    result.when(
      success: (success) =>
          emit(ScheduleFetchSuccess(data: result.success?.data)),
      failure: (failure) =>
          emit(ScheduleFetchFailure(mess: result.failure?.message ?? '')),
    );
  }
}
