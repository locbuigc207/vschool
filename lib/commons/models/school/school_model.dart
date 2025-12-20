import 'package:json_annotation/json_annotation.dart';

part 'school_model.g.dart';

@JsonSerializable()
class SchoolInfoModel {
  final int schoolId;
  final String? name;
  final String? msthue;
  final String? tinhthanh;
  final String? quanhuyen;
  final String? xaphuong;
  final String? address;
  final int? schoolType;
  final int? userId;

  SchoolInfoModel(
      {required this.schoolId,
      this.name,
      this.msthue,
      this.tinhthanh,
      this.quanhuyen,
      this.xaphuong,
      this.address,
      this.schoolType,
      this.userId});

  factory SchoolInfoModel.fromJson(Map<String, dynamic> json) =>
      _$SchoolInfoModelFromJson(json);
}

@JsonSerializable()
class SchoolResponse {
  final int resultCode;
  final String message;
  final String? data;

  SchoolResponse({
    required this.resultCode,
    required this.message,
    this.data,
  });

  factory SchoolResponse.fromJson(Map<String, dynamic> json) =>
      _$SchoolResponseFromJson(json);
}
