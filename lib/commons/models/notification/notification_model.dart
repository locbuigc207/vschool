import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationInfoModel {
  final int? notificationId;
  final int? receiverId;
  final int? notificationType;
  final String? content;
  final int? createdBy;
  final int? createdDate;
  final bool? read;

  NotificationInfoModel({
    this.notificationId,
    this.receiverId,
    this.notificationType,
    this.content,
    this.createdBy,
    this.createdDate,
    this.read,
  });

  factory NotificationInfoModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationInfoModelFromJson(json);
}

@JsonSerializable()
class NotificationDataModel {
  final int? resultCode;
  final String? message;
  @JsonKey(name: 'notificationList')
  final List<NotificationInfoModel>? notificationList;

  NotificationDataModel({
    this.resultCode,
    this.message,
    this.notificationList,
  });

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataModelFromJson(json);
}

@JsonSerializable()
class NotificationDetailModel {
  final int? resultCode;
  final String? message;
  @JsonKey(name: 'newNotification')
  final NotificationInfoModel? newNotification;

  NotificationDetailModel({
    this.resultCode,
    this.message,
    this.newNotification,
  });

  factory NotificationDetailModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationDetailModelFromJson(json);
}

@JsonSerializable()

class NotificationFcmModel {
  final int? resultCode;
  final String? message;
  
  NotificationFcmModel (this.resultCode, this.message);

  factory NotificationFcmModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationFcmModelFromJson(json);
}