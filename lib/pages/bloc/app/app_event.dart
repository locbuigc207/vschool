part of 'app_bloc.dart';

@immutable
abstract class AppEvent extends Equatable {
  const AppEvent();
}

class UpdateAppUser extends AppEvent {
  final UserLoginInfoModel user;

  const UpdateAppUser(this.user);

  @override
  List<Object> get props => [user];
}
