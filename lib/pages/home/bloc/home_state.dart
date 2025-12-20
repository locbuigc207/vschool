part of 'home_bloc.dart';

abstract class HomePageState extends Equatable {
  const HomePageState();
}

class GetAllChildrenInitial extends HomePageState {
  @override
  List<Object?> get props => [];
}

class ChildSelectedChanging extends HomePageState {
  final ChildrenInfoModel child;

  const ChildSelectedChanging({required this.child});

  @override
  List<Object?> get props => [child];
}

class GetAllChildrenSuccess extends HomePageState {
  final List<ChildrenInfoModel> children;

  const GetAllChildrenSuccess({required this.children});

  @override
  List<Object?> get props => [children];
}

class GetAllChildrenFailure extends HomePageState {
  final String? mess;

  const GetAllChildrenFailure(this.mess);

  @override
  List<Object?> get props => [mess];
}

class GetSchoolSuccess extends HomePageState {
  final String schoolInfoModel;

  const GetSchoolSuccess({required this.schoolInfoModel});

  @override
  List<Object?> get props => [schoolInfoModel];
}

class GetSchoolFailure extends HomePageState {
  final String? mess;

  const GetSchoolFailure(this.mess);

  @override
  List<Object?> get props => [mess];
}

class GetBannerContentInitial extends HomePageState {
  @override
  List<Object?> get props => [];
}

class GetBannerContentSuccess extends HomePageState {
  final List<BannerModel>? data;

  const GetBannerContentSuccess({this.data});

  @override
  List<Object?> get props => [data];
}

class GetBannerContentFailure extends HomePageState {
  final String mess;

  const GetBannerContentFailure({required this.mess});

  @override
  List<Object?> get props => [mess];
}

class GetChildByCodeFailure extends HomePageState {
  final String mess;

  const GetChildByCodeFailure({required this.mess});

  @override
  List<Object?> get props => [mess];
}

class GetChildByCodeSuccess extends HomePageState {
  final ChildrenInfoModel child;

  const GetChildByCodeSuccess({required this.child});

  @override
  List<Object?> get props => [child];
}
