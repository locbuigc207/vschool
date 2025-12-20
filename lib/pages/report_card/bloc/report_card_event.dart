part of 'report_card_bloc.dart';

abstract class ReportCardEvent extends Equatable {
  const ReportCardEvent();
}

class ReportCardInitial extends ReportCardEvent {
  @override
  List<Object?> get props => [];
}

class GetReportCard extends ReportCardEvent {
  final int studentId;

  const GetReportCard({required this.studentId});

  @override
  List<Object?> get props => [];
}

class SubmitReportCard extends ReportCardEvent {
  final String? teacherComment;
  final String? parentComment;
  final int studentId;

  const SubmitReportCard(
      {this.teacherComment, this.parentComment, required this.studentId});

  @override
  List<Object?> get props => [];
}
