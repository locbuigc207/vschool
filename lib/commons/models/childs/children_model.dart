import 'package:json_annotation/json_annotation.dart';

part 'children_model.g.dart';

@JsonSerializable()
class ChildrenInfoModel {
  final int? studentId;
  // final int? bhytNum;
  final String? className;
  final int? status;
  final bool? gender;
  final String? name;
  final String? studentCode;
  final String? dob;
  final String? email;
  // final String? address;
  final int? classId;
  final String? parentPhonenum;

  ChildrenInfoModel({
    this.studentId,
    // this.bhytNum,
    this.className,
    this.status,
    this.gender,
    this.name,
    this.studentCode,
    this.dob,
    this.email,
    // this.address,
    this.classId,
    this.parentPhonenum,
  });

  factory ChildrenInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ChildrenInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChildrenInfoModelToJson(this);
}

@JsonSerializable()
class ChildrenResponse {
  final int resultCode;
  final String message;
  @JsonKey(name: 'newStudent')
  final List<ChildrenInfoModel>? newStudent;

  ChildrenResponse(
      {required this.resultCode, required this.message, this.newStudent});

  factory ChildrenResponse.fromJson(Map<String, dynamic> json) =>
      _$ChildrenResponseFromJson(json);
}

@JsonSerializable()
class ChildInfoModel {
  final int studentId;
  // final int bhytNum;
  final String className;
  final int status;
  final bool gender;
  final String name;
  final String studentCode;
  final String dob;
  final String email;
  // final String address;
  final int classId;
  final String parentPhonenum;
  // @JsonKey(name: 'parent')
  // final CurrentUserInfoModel parent;

  ChildInfoModel({
    required this.studentId,
    // required this.bhytNum,
    required this.className,
    required this.status,
    required this.gender,
    required this.name,
    required this.studentCode,
    required this.dob,
    required this.email,
    // required this.address,
    required this.classId,
    required this.parentPhonenum,
    // required this.parent,
  });

  factory ChildInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ChildInfoModelFromJson(json);
}

@JsonSerializable()
class ChildInfoResponse {
  final int resultCode;
  final String message;
  @JsonKey(name: 'studentRM')
  final ChildInfoModel child;

  ChildInfoResponse(
      {required this.resultCode, required this.message, required this.child});

  factory ChildInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$ChildInfoResponseFromJson(json);
}

@JsonSerializable()
class ChildResponse {
  final int resultCode;
  final String message;
  @JsonKey(name: 'data')
  final ChildrenInfoModel child;

  ChildResponse({
    required this.resultCode,
    required this.message,
    required this.child,
  });

  factory ChildResponse.fromJson(Map<String, dynamic> json) =>
      _$ChildResponseFromJson(json);
}
