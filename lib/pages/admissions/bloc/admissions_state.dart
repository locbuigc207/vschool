part of 'admissions_bloc.dart';

abstract class AdmissionsState extends Equatable {
  const AdmissionsState();
}

class AdmissionsSubmitInit extends AdmissionsState {
  @override
  List<Object?> get props => [];
}

class AdmissionsSubmitSuccess extends AdmissionsState {
  final int code;
  final String mess;

  const AdmissionsSubmitSuccess({required this.code, required this.mess});

  @override
  List<Object?> get props => [code, mess];
}

class AdmissionsSubmitFailed extends AdmissionsState {
  final String mess;

  const AdmissionsSubmitFailed({required this.mess});

  @override
  List<Object?> get props => [mess];
}
