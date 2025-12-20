import 'package:json_annotation/json_annotation.dart';

part 'report_card_model.g.dart';

@JsonSerializable()
class ReportCardModel {
  final String? teacherComment;
  final String? parentComment;
  final int studentId;

  ReportCardModel({
    this.teacherComment,
    this.parentComment,
    required this.studentId,
  });

  factory ReportCardModel.fromJson(Map<String, dynamic> json) =>
      _$ReportCardModelFromJson(json);
}

@JsonSerializable()
class ReportCardResponse {
  final int resultCode;
  final String message;
  @JsonKey(name: 'data')
  final ReportCardModel? data;

  ReportCardResponse(
      {required this.resultCode, required this.message, this.data});

  factory ReportCardResponse.fromJson(Map<String, dynamic> json) =>
      _$ReportCardResponseFromJson(json);
}
