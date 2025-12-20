import 'package:json_annotation/json_annotation.dart';
import 'package:vschool/commons/models/childs/children_model.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserLoginInfoModel {
  final int? id;
  final String? phoneNumber;
  final String? name;
  final String? role;
  final int? parentId;
  final bool? gender;
  final String? dob;
  final String? email;
  final int? schoolId;
  @JsonKey(name: 'students')
  final List<ChildrenInfoModel>? students;
  final String? token;
  final String? refreshToken;

  UserLoginInfoModel(
      this.id,
      this.phoneNumber,
      this.name,
      this.role,
      this.parentId,
      this.gender,
      this.dob,
      this.email,
      this.schoolId,
      this.students,
      this.token,
      this.refreshToken);

  factory UserLoginInfoModel.fromJson(Map<String, dynamic> json) =>
      _$UserLoginInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserLoginInfoModelToJson(this);
}

@JsonSerializable()
class UserLoginDataModel {
  final int code;
  final String msg;
  final UserLoginInfoModel? info;

  UserLoginDataModel({required this.code, required this.msg, this.info});

  factory UserLoginDataModel.fromJson(Map<String, dynamic> json) =>
      _$UserLoginDataModelFromJson(json);
}

// @JsonSerializable()
// class CurrentUserInfoModel {
//   final int parentId;
//   final String? name;
//   final bool? gender;
//   final String? dob;
//   final String? phoneNumber;
//   final String? email;
//   final int? id;
//   final int? schoolId;

//   const CurrentUserInfoModel({
//     required this.parentId,
//     this.name,
//     this.gender,
//     this.dob,
//     this.phoneNumber,
//     this.email,
//     this.id,
//     this.schoolId,
//   });

//   factory CurrentUserInfoModel.fromJson(Map<String, dynamic> json) =>
//       _$CurrentUserInfoModelFromJson(json);

//   Map<String, dynamic> toJson() => _$CurrentUserInfoModelToJson(this);
// }

// @JsonSerializable()
// class CurrentUserDataModel {
//   final int resultCode;
//   final String message;
//   @JsonKey(name: 'parent')
//   final CurrentUserInfoModel? parent;

//   CurrentUserDataModel({
//     required this.resultCode,
//     required this.message,
//     this.parent,
//   });

//   factory CurrentUserDataModel.fromJson(Map<String, dynamic> json) =>
//       _$CurrentUserDataModelFromJson(json);
// }

@JsonSerializable()
class ChangePassModel {
  final String username;
  final String oldPassword;
  final String newPassword;

  ChangePassModel({
    required this.username,
    required this.oldPassword,
    required this.newPassword,
  });

  factory ChangePassModel.fromJson(Map<String, dynamic> json) =>
      _$ChangePassModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePassModelToJson(this);
}

@JsonSerializable()
class RefreshTokenModel {
  final int code;
  final String msg;
  final String? info;

  RefreshTokenModel(this.code, this.msg, this.info);

  factory RefreshTokenModel.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenModelFromJson(json);
}
