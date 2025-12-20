part of 'home_bloc.dart';

abstract class HomePageEvent extends Equatable {
  const HomePageEvent();
}

class GetAllChildren extends HomePageEvent {
  const GetAllChildren();

  @override
  List<Object?> get props => [];
}

class ChildChanged extends HomePageEvent {
  final ChildrenInfoModel child;

  const ChildChanged({required this.child});

  @override
  List<Object?> get props => [];
}

class GetSchoolInfo extends HomePageEvent {
  final int studentId;

  const GetSchoolInfo({required this.studentId});

  @override
  List<Object?> get props => [];
}

class GetBannerContent extends HomePageEvent {
  @override
  List<Object?> get props => [];
}

class GetStudentByCode extends HomePageEvent {
  final String studentCode;

  const GetStudentByCode({required this.studentCode});

  @override
  List<Object?> get props => [];
}