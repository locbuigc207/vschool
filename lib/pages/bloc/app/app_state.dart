part of 'app_bloc.dart';

@immutable
class AppState extends Equatable {
  final UserLoginInfoModel? user;

  const AppState({this.user});

  AppState copyWith({
    required UserLoginInfoModel? user,
  }) =>
      AppState(
        user: user,
      );

  @override
  List<Object?> get props => [
        user,
      ];
}
