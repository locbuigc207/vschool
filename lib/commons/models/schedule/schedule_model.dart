import 'package:json_annotation/json_annotation.dart';

part 'schedule_model.g.dart';

@JsonSerializable()
class ScheduleModel {
  final int scheduleId;
  final int sIndex;
  final int eIndex;
  final String subjectName;
  final String scheduleType;

  ScheduleModel(
      {required this.scheduleId,
      required this.sIndex,
      required this.eIndex,
      required this.subjectName,
      required this.scheduleType});

  factory ScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleModelFromJson(json);
}

@JsonSerializable()
class ScheduleResponse {
  final int resultCode;
  final String message;
  @JsonKey(name: 'data')
  final List<ScheduleModel>? data;

  ScheduleResponse(
      {required this.resultCode, required this.message, this.data});

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) =>
      _$ScheduleResponseFromJson(json);
}
