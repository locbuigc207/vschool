part of 'study_bloc.dart';

abstract class StudyState extends Equatable {
  const StudyState();
}

class GetScoresInitial extends StudyState {
  @override
  List<Object?> get props => [];
}

class GetScoresFailure extends StudyState {
  final String mess;

  const GetScoresFailure({required this.mess});

  @override
  List<Object?> get props => [mess];
}

class GetScoresSuccess extends StudyState {
  final List<ScoreModel>? data;

  const GetScoresSuccess({this.data});

  @override
  List<Object?> get props => [data];
}
