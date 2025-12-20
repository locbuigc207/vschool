import 'package:simple_result/simple_result.dart';
import 'package:vschool/commons/api/clients/api_client.dart';
import 'package:vschool/commons/api/failures/failures.dart';
import 'package:vschool/commons/api/interceptors/error_interceptor.dart';
import 'package:vschool/commons/models/notification/notification_model.dart';

abstract class INotificationRepository {
  Future<Result<NotificationDataModel, Failure>> getAllNotification(
      {required String receiverId});

  Future<Result<NotificationDetailModel, Failure>> readNotification({
    required int notificationId,
  });
}

class NotificationRepository extends INotificationRepository {
  final ApiClient _client;

  NotificationRepository({required ApiClient apiClient}) : _client = apiClient;

  @override
  Future<Result<NotificationDataModel, Failure>> getAllNotification(
      {required String receiverId}) async {
    try {
      final response = await _client.getAllNotification(receiverId: receiverId);
      if (response.resultCode == 200) {
        return Result.success(response);
      }
      return Result.failure(UnknownFailure(message: response.message));
    } on UnauthorizedException catch (err) {
      return Result.failure(UnauthorizedFailure(message: err.toString()));
    } on ResponseException catch (err) {
      return Result.failure(ResponseFailure(message: err.toString()));
    } on Exception {
      return const Result.failure(UnknownFailure());
    }
  }

  @override
  Future<Result<NotificationDetailModel, Failure>> readNotification(
      {required int notificationId}) async {
    try {
      final response =
          await _client.readNotification(notificationId: notificationId);
      if (response.resultCode == 200) {
        return Result.success(response);
      }
      return Result.failure(UnknownFailure(message: response.message));
    } on UnauthorizedException catch (err) {
      return Result.failure(UnauthorizedFailure(message: err.toString()));
    } on ResponseException catch (err) {
      return Result.failure(ResponseFailure(message: err.toString()));
    } on Exception {
      return const Result.failure(UnknownFailure());
    }
  }
}
