import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vschool/commons/models/notification/notification_model.dart';
import 'package:vschool/commons/repository/notification_repository.dart';

part 'notification_page_event.dart';

part 'notification_page_state.dart';

class NotificationPageBloc
    extends Bloc<NotificationPageEvent, NotificationPageState> {
  final INotificationRepository _notificationRepository;

  NotificationPageBloc(
      {required INotificationRepository notificationRepository})
      : _notificationRepository = notificationRepository,
        super(const NotificationPageState(notificationList: [])) {
    on<NotificationFetched>(_onNotificationFetched);
    on<NotificationReading>(_onNotificationReading);
  }

  FutureOr<void> _onNotificationFetched(
      NotificationFetched event, Emitter<NotificationPageState> emit) async {
    emit(state.copyWith(
      isLoading: true,
      notificationList: const [],
      error: null,
    ));

    final result = await _notificationRepository.getAllNotification(
        receiverId: event.receiverId);

    result.when(
      success: (success) {
        emit(state.copyWith(
          isRefreshing: false,
          notificationList: result.success!.notificationList,
          error: null,
          isLoading: false,
        ));
      },
      failure: (failure) {
        emit(state.copyWith(
          isRefreshing: false,
          error: failure.message,
          isLoading: false,
        ));
      },
    );
  }

  FutureOr<void> _onNotificationReading(
      NotificationReading event, Emitter<NotificationPageState> emit) async {
    emit(state.copyWith(
      isLoading: true,
      error: null,
    ));

    final result = await _notificationRepository.readNotification(
        notificationId: event.notificationId);

    result.when(
      success: (success) {
        emit(state.copyWith(
          isRead: true,
        ));
      },
      failure: (failure) {
        emit(state.copyWith(
          isRead: false,
          error: failure.message,
        ));
      },
    );
  }
}
