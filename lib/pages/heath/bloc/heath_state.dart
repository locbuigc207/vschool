part of 'heath_bloc.dart';

abstract class HeathState extends Equatable {
  const HeathState();
}

class HeathFetching extends HeathState {
  @override
  List<Object?> get props => [];
}

class HeathFetchSuccess extends HeathState {
  final List<HeathModel>? heathInfo;

  const HeathFetchSuccess({this.heathInfo});

  @override
  List<Object?> get props => [heathInfo];
}

class HeathFetchFailure extends HeathState {
  final String mess;

  const HeathFetchFailure({required this.mess});

  @override
  List<Object?> get props => [mess];
}
