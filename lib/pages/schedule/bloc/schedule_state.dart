part of 'schedule_bloc.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();
}

class ScheduleFetchInitial extends ScheduleState {
  @override
  List<Object?> get props => [];
}

class ScheduleFetchFailure extends ScheduleState {
  final String mess;

  const ScheduleFetchFailure({required this.mess});

  @override
  List<Object?> get props => [mess];
}

class ScheduleFetchSuccess extends ScheduleState {
  final List<ScheduleModel>? data;

  const ScheduleFetchSuccess({this.data});

  @override
  List<Object?> get props => [data];
}
