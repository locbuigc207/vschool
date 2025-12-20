import 'package:json_annotation/json_annotation.dart';

part 'banner_model.g.dart';

@JsonSerializable()
class BannerModel {
  final int id;
  final String? mainContent;
  final String? subContent;

  BannerModel({
    required this.id,
    this.mainContent,
    this.subContent,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);
}

@JsonSerializable()
class BannerResponse {
  final int resultCode;
  final String message;
  @JsonKey(name: 'data')
  final List<BannerModel>? data;

  BannerResponse({required this.resultCode, required this.message, this.data});

  factory BannerResponse.fromJson(Map<String, dynamic> json) =>
      _$BannerResponseFromJson(json);
}
