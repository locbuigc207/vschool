part of 'report_card_bloc.dart';

abstract class ReportCardState extends Equatable {
  const ReportCardState();
}

class ReportCardInit extends ReportCardState {
  @override
  List<Object?> get props => [];
}

class GetReportCardSuccess extends ReportCardState {
  final String? teacherComment;
  final String? parentComment;

  const GetReportCardSuccess({this.teacherComment, this.parentComment});

  @override
  List<Object?> get props => [teacherComment, parentComment];
}

class GetReportCardFailure extends ReportCardState {
  final String mess;

  const GetReportCardFailure({required this.mess});

  @override
  List<Object?> get props => [mess];
}

class ReportCardSubmittedSuccess extends ReportCardState {
  final String mess;

  const ReportCardSubmittedSuccess({required this.mess});

  @override
  List<Object?> get props => [mess];
}

class ReportCardSummitedFailure extends ReportCardState {
  final String mess;

  const ReportCardSummitedFailure({required this.mess});

  @override
  List<Object?> get props => [mess];
}
