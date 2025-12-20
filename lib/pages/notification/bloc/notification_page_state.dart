part of 'notification_page_bloc.dart';

class NotificationPageState extends Equatable {
  final List<NotificationInfoModel> notificationList;
  final int? total;
  final String? error;
  final bool isLoading;
  final bool isRefreshing;
  final bool isRead;

  const NotificationPageState({
    required this.notificationList,
    this.total,
    this.error,
    this.isLoading = false,
    this.isRefreshing = false,
    this.isRead = false,
  });

  @override
  List<Object?> get props => [
        notificationList,
        total,
        error,
        isLoading,
        isRefreshing,
        isRead,
      ];

  NotificationPageState copyWith({
    List<NotificationInfoModel>? notificationList,
    int? total,
    String? error,
    bool? isLoading,
    bool? isRefreshing,
    bool? isRead,
  }) =>
      NotificationPageState(
        notificationList: notificationList ?? this.notificationList,
        total: total ?? this.total,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
        isRefreshing: isRefreshing ?? this.isRefreshing,
        isRead: isRead ?? this.isRead,
      );
}
