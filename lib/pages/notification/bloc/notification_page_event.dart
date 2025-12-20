part of 'notification_page_bloc.dart';

@immutable
abstract class NotificationPageEvent extends Equatable {
  const NotificationPageEvent();
}

class NotificationFetched extends NotificationPageEvent {
  final String receiverId;

  const NotificationFetched({required this.receiverId});

  @override
  List<Object?> get props => [];
}

class NotificationReading extends NotificationPageEvent {
  final int notificationId;

  const NotificationReading({required this.notificationId});

  @override
  List<Object?> get props => [];
}
