import 'package:json_annotation/json_annotation.dart';

part 'score_model.g.dart';

@JsonSerializable()
class ScoreModel {
  final double? scoreNumber;
  final int? subjectId;
  final String? subjectName;
  final String? scoreType;

  ScoreModel({
    this.scoreNumber,
    this.subjectId,
    this.subjectName,
    this.scoreType,
  });

  factory ScoreModel.fromJson(Map<String, dynamic> json) =>
      _$ScoreModelFromJson(json);
}

@JsonSerializable()
class ScoreResponse {
  final int resultCode;
  final String message;
  @JsonKey(name: "scoreModelList")
  final List<ScoreModel>? data;

  ScoreResponse({required this.resultCode, required this.message, this.data});

  factory ScoreResponse.fromJson(Map<String, dynamic> json) =>
      _$ScoreResponseFromJson(json);
}
