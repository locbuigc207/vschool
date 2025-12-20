part of 'study_bloc.dart';

abstract class StudyEvent extends Equatable {
  const StudyEvent();
}

class StudyScoreFetching extends StudyEvent {
  final int studentId;
  final int startStudyYear;
  final int semester;

  const StudyScoreFetching(
      {required this.studentId,
      required this.startStudyYear,
      required this.semester});

  @override
  List<Object?> get props => [];
}
