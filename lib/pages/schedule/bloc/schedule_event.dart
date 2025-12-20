part of 'schedule_bloc.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();
}

class ScheduleFetching extends ScheduleEvent {
  final int classId;
  final String startDate;
  final String endDate;
  final int studyYear;

  const ScheduleFetching({
    required this.classId,
    required this.startDate,
    required this.endDate,
    required this.studyYear,
  });

  @override
  List<Object?> get props => [];
}
