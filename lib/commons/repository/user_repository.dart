import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_result/simple_result.dart';
import 'package:vschool/commons/api/clients/api_client.dart';
import 'package:vschool/commons/api/failures/failures.dart';
import 'package:vschool/commons/api/interceptors/error_interceptor.dart';
import 'package:vschool/commons/models/banner/banner_model.dart';
import 'package:vschool/commons/models/childs/children_model.dart';
import 'package:vschool/commons/models/message_data/message_data.dart';
import 'package:vschool/commons/models/school/school_model.dart';
import 'package:vschool/commons/models/user/user_model.dart';

abstract class IUserRepository {
  Future<Result<UserLoginDataModel, Failure>> login(
      {required String username,
      required String password,
      required String? deviceId});

  Future<Result<UserLoginDataModel, Failure>> logout();

  Future<Result<RefreshTokenModel, Failure>> refreshToken(
      {required String refreshToken});

  Future<Result<ChildrenResponse, Failure>> getAllChildren(
      {required String parentPhonenum});

  // Future<Result<CurrentUserDataModel, Failure>> getCurrentUser({
  //   required int userId,
  // });

  Future<Result<UserLoginDataModel, Failure>> resetPass({
    required String phoneNumber,
  });

  Future<Result<ChildInfoResponse, Failure>> getChildInfo({
    required int studentId,
  });

  Future<Result<SchoolResponse, Failure>> getSchoolInfo({
    required int studentId,
  });

  Future<Result<BannerResponse, Failure>> getBannerContent();

  Future<Result<UserLoginDataModel, Failure>> changePass(
      {required ChangePassModel request});

  Future<Result<MessageData, Failure>> updateInfoStudent(
      {required ChildrenInfoModel request});

  Future<Result<ChildResponse, Failure>> getStudentByCode({
    required String studentCode,
  });
}

class UserRepository extends IUserRepository {
  final ApiClient _client;

  UserRepository({
    required ApiClient apiClient,
  }) : _client = apiClient;

  @override
  Future<Result<UserLoginDataModel, Failure>> login(
      {required String username,
      required String password,
      required deviceId}) async {
    try {
      final Future<SharedPreferences> preferencesFuture =
          SharedPreferences.getInstance();
      final SharedPreferences preferences = await preferencesFuture;
      print(preferences.getString('fcmToken'));
      final response = await _client.login(
          username: username,
          password: password,
          deviceId: preferences.getString('fcmToken') ?? "");
      if (response.code == 200) {
        return Result.success(response);
      }
      return Result.failure(UnknownFailure(message: response.msg));
    } on UnauthorizedException catch (err) {
      return Result.failure(UnauthorizedFailure(message: err.toString()));
    } on ResponseException catch (err) {
      return Result.failure(ResponseFailure(message: err.toString()));
    } on Exception {
      return const Result.failure(UnknownFailure());
    }
  }

  @override
  Future<Result<UserLoginDataModel, Failure>> logout() async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      print(preferences.getString('accessToken')!);
      final response = await _client.logout(
          token: "Bearer ${preferences.getString('accessToken')!}");
      if (response.code == 200) {
        return Result.success(response);
      }
      return Result.failure(UnknownFailure(message: response.msg));
    } on Exception {
      return const Result.failure(UnknownFailure());
    }
  }

  @override
  Future<Result<RefreshTokenModel, Failure>> refreshToken(
      {required refreshToken}) async {
    try {
      Map<String, dynamic> body = {
        "refreshToken": refreshToken,
      };
      final response = await _client.refreshToken(body);
      if (response.code == 200) {
        return Result.success(response);
      }
      return Result.failure(UnknownFailure(message: response.msg));
    } on Exception {
      return const Result.failure(UnknownFailure());
    }
  }

  @override
  Future<Result<ChildrenResponse, Failure>> getAllChildren(
      {required String parentPhonenum}) async {
    try {
      final response =
          await _client.getAllChild(parentPhonenum: parentPhonenum);
      if (response.resultCode == 200) {
        return Result.success(response);
      }
      return Result.failure(UnknownFailure(message: response.message));
    } on UnauthorizedException catch (err) {
      return Result.failure(UnauthorizedFailure(message: err.toString()));
    } on ResponseException catch (err) {
      return Result.failure(ResponseFailure(message: err.toString()));
    } on Exception {
      return const Result.failure(UnknownFailure());
    }
  }

  // @override
  // Future<Result<CurrentUserDataModel, Failure>> getCurrentUser(
  //     {required int userId}) async {
  //   try {
  //     final response = await _client.getCurrentUser(userId: userId);
  //     if (response.resultCode == 200) {
  //       return Result.success(response);
  //     }
  //     return Result.failure(UnknownFailure(message: response.message));
  //   } on UnauthorizedException catch (err) {
  //     return Result.failure(UnauthorizedFailure(message: err.toString()));
  //   } on ResponseException catch (err) {
  //     return Result.failure(ResponseFailure(message: err.toString()));
  //   } on Exception {
  //     return const Result.failure(UnknownFailure());
  //   }
  // }

  @override
  Future<Result<UserLoginDataModel, Failure>> resetPass(
      {required String phoneNumber}) async {
    try {
      final response = await _client.resetPass(phoneNumber: phoneNumber);
      if (response.code == 200) {
        return Result.success(response);
      }
      return Result.failure(UnknownFailure(message: response.msg));
    } on UnauthorizedException catch (err) {
      return Result.failure(UnauthorizedFailure(message: err.toString()));
    } on ResponseException catch (err) {
      return Result.failure(ResponseFailure(message: err.toString()));
    } on Exception {
      return const Result.failure(UnknownFailure());
    }
  }

  @override
  Future<Result<ChildInfoResponse, Failure>> getChildInfo(
      {required int studentId}) async {
    try {
      final response = await _client.getChildInfo(studentId: studentId);
      if (response.resultCode == 200) {
        return Result.success(response);
      }
      return Result.failure(UnknownFailure(message: response.message));
    } on UnauthorizedException catch (err) {
      return Result.failure(UnauthorizedFailure(message: err.toString()));
    } on ResponseException catch (err) {
      return Result.failure(ResponseFailure(message: err.toString()));
    } on Exception {
      return const Result.failure(UnknownFailure());
    }
  }

  @override
  Future<Result<SchoolResponse, Failure>> getSchoolInfo(
      {required int studentId}) async {
    try {
      final response = await _client.getSchoolInfo(studentId: studentId);
      if (response.resultCode == 200) {
        return Result.success(response);
      }
      return Result.failure(UnknownFailure(message: response.message));
    } on UnauthorizedException catch (err) {
      return Result.failure(UnauthorizedFailure(message: err.toString()));
    } on ResponseException catch (err) {
      return Result.failure(ResponseFailure(message: err.toString()));
    } on Exception {
      return const Result.failure(UnknownFailure());
    }
  }

  @override
  Future<Result<BannerResponse, Failure>> getBannerContent() async {
    try {
      final response = await _client.getBannerInfo();
      if (response.resultCode == 200) {
        return Result.success(response);
      }
      return Result.failure(UnknownFailure(message: response.message));
    } on UnauthorizedException catch (err) {
      return Result.failure(UnauthorizedFailure(message: err.toString()));
    } on ResponseException catch (err) {
      return Result.failure(ResponseFailure(message: err.toString()));
    } on Exception {
      return const Result.failure(UnknownFailure());
    }
  }

  @override
  Future<Result<UserLoginDataModel, Failure>> changePass(
      {required ChangePassModel request}) async {
    try {
      final response = await _client.changePass(
        username: request.username,
        oldPassword: request.oldPassword,
        newPassword: request.newPassword,
      );
      if (response.code == 200) {
        return Result.success(response);
      }
      return Result.failure(UnknownFailure(message: response.msg));
    } on UnauthorizedException catch (err) {
      return Result.failure(UnauthorizedFailure(message: err.toString()));
    } on ResponseException catch (err) {
      return Result.failure(ResponseFailure(message: err.toString()));
    } on Exception {
      return const Result.failure(UnknownFailure());
    }
  }

  @override
  Future<Result<MessageData, Failure>> updateInfoStudent(
      {required ChildrenInfoModel request}) async {
    try {
      final response = await _client.updateInfoStudent(request: request);
      if (response.resultCode == 200) {
        return Result.success(response);
      }
      return Result.failure(UnknownFailure(message: response.message));
    } on UnauthorizedException catch (err) {
      return Result.failure(UnauthorizedFailure(message: err.toString()));
    } on ResponseException catch (err) {
      return Result.failure(ResponseFailure(message: err.toString()));
    } on Exception {
      return const Result.failure(UnknownFailure());
    }
  }

  @override
  Future<Result<ChildResponse, Failure>> getStudentByCode(
      {required String studentCode}) async {
    try {
      final response = await _client.getStudentByCode(studentCode: studentCode);
      if (response.resultCode == 200) {
        return Result.success(response);
      }
      return Result.failure(UnknownFailure(message: response.message));
    } on UnauthorizedException catch (err) {
      return Result.failure(UnauthorizedFailure(message: err.toString()));
    } on ResponseException catch (err) {
      return Result.failure(ResponseFailure(message: err.toString()));
    } on Exception {
      return const Result.failure(UnknownFailure());
    }
  }
}
