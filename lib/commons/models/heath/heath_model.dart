import 'package:json_annotation/json_annotation.dart';

part 'heath_model.g.dart';

@JsonSerializable()
class HeathModel {
  final int id;
  final int studentId;
  final String? heathInfo;

  HeathModel({
    required this.id,
    required this.studentId,
    this.heathInfo,
  });

  factory HeathModel.fromJson(Map<String, dynamic> json) =>
      _$HeathModelFromJson(json);
}

@JsonSerializable()
class HeathResponse {
  final int resultCode;
  final String message;
  @JsonKey(name: 'data')
  final List<HeathModel>? data;

  HeathResponse({required this.resultCode, required this.message, this.data});

  factory HeathResponse.fromJson(Map<String, dynamic> json) =>
      _$HeathResponseFromJson(json);
}
