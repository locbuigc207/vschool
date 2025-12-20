import 'package:json_annotation/json_annotation.dart';

part 'admissions_model.g.dart';

@JsonSerializable()
class AdmissionsModel {
  final String studentCode;
  final String studentName;
  final String studentDob;
  final String gender;
  final String address;
  final String householderName;
  final String? dadName;
  final String? dadJob;
  final String? dadPhoneNum;
  final String? momName;
  final String? momJob;
  final String? momPhoneNum;
  final String? patronsName;
  final String? patronsJob;
  final String? patronsPhoneNum;
  final String contactAddress;
  final String? note;
  final String? graduateLevel;
  final String? graduateSchool;
  final String? graduateGrades;
  final String desiredSchool;

  AdmissionsModel({
    required this.studentCode,
    required this.studentName,
    required this.studentDob,
    required this.gender,
    required this.address,
    required this.householderName,
    this.dadName,
    this.dadJob,
    this.dadPhoneNum,
    this.momName,
    this.momJob,
    this.momPhoneNum,
    this.patronsName,
    this.patronsJob,
    this.patronsPhoneNum,
    required this.contactAddress,
    this.note,
    this.graduateLevel,
    this.graduateSchool,
    this.graduateGrades,
    required this.desiredSchool,
  });

  factory AdmissionsModel.fromJson(Map<String, dynamic> json) =>
      _$AdmissionsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AdmissionsModelToJson(this);
}

@JsonSerializable()
class AdmissionsResponse {
  final int resultCode;
  final String message;

  AdmissionsResponse({
    required this.resultCode,
    required this.message,
  });

  factory AdmissionsResponse.fromJson(Map<String, dynamic> json) =>
      _$AdmissionsResponseFromJson(json);
}
