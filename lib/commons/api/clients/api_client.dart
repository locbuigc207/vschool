import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:vschool/commons/api/endpoint.dart' as endpoint;
import 'package:vschool/commons/models/admissions/admissions_model.dart';
import 'package:vschool/commons/models/banner/banner_model.dart';
import 'package:vschool/commons/models/childs/children_model.dart';
import 'package:vschool/commons/models/food_menu/food_menu_model.dart';
import 'package:vschool/commons/models/heath/heath_model.dart';
import 'package:vschool/commons/models/invoice/invoice_model.dart';
import 'package:vschool/commons/models/message_data/message_data.dart';
import 'package:vschool/commons/models/notification/notification_model.dart';
import 'package:vschool/commons/models/payment_channel/payment_channel_model.dart';

import 'package:vschool/commons/models/qrCode/qr_code_model.dart';
import 'package:vschool/commons/models/report_card/report_card_model.dart';
import 'package:vschool/commons/models/schedule/schedule_model.dart';
import 'package:vschool/commons/models/school/school_model.dart';
import 'package:vschool/commons/models/scores/score_model.dart';
import 'package:vschool/commons/models/user/user_model.dart';
import 'package:vschool/commons/models/payment_setting/payment_setting_response.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(
    Dio dio, {
    String baseUrl,
  }) = _ApiClient;

  /// /auth/login
  @POST(endpoint.login)
  @FormUrlEncoded()
  Future<UserLoginDataModel> login({
    @Field('phoneNumber') required String username,
    @Field('password') required String password,
    @Field('deviceId') required String deviceId,
  });

  /// /api/app/auth/log-out
  @POST(endpoint.logout)
  Future<UserLoginDataModel> logout(
      {@Header('Authorization') required String token});

  /// /api/app/auth/refreshToken
  @POST(endpoint.refreshToken)
  Future<RefreshTokenModel> refreshToken(@Body() Map<String, dynamic> body);

  /// /api/reset-password
  @POST(endpoint.resetPass)
  Future<UserLoginDataModel> resetPass({
    @Query('phoneNumber') required String phoneNumber,
  });

  /// /api/get-parent-by-userid
  ///
  // @GET(endpoint.currentUser)
  // Future<CurrentUserDataModel> getCurrentUser({
  //   @Query('userId') required int userId,
  // });

  @GET(endpoint.getAllChild)
  Future<ChildrenResponse> getAllChild({
    @Query('parentPhonenum') required String parentPhonenum,
  });

  @GET(endpoint.getChildById)
  Future<ChildInfoResponse> getChildInfo({
    @Query('studentId') required int studentId,
  });

  @GET(endpoint.getAllNotification)
  Future<NotificationDataModel> getAllNotification({
    @Query('receiverId') required String receiverId,
  });

  @GET(endpoint.getInvoiceByChild)
  Future<InvoiceDataResponse> getInvoiceByChild({
    @Header('Authorization') required String token,
    @Query('studentId') required int studentId,
  });

  @GET("https://api.v-school.vn/api/bank-info")
  Future<PaymentChannelResponse> getAllPaymentChannel();

  @GET(endpoint.genQr)
  Future<QrCodeResponse> genQRCode(
      {@Header('Authorization') required String token,
      @Query('studentId') required int studentId,
      @Query('listInvoiceIds') required List listvoiceIds
      // @Body() required QrCodeGenerateRequest request,
      });

  @GET(endpoint.getSchoolInfo)
  Future<SchoolResponse> getSchoolInfo({
    @Query('studentId') required int studentId,
  });

  @POST(endpoint.submitAdmissions)
  Future<AdmissionsResponse> submitAdmissions({
    @Body() required AdmissionsModel request,
  });

  @POST(endpoint.readNotification)
  Future<NotificationDetailModel> readNotification({
    @Query('notificationId') required int notificationId,
  });

  @GET(endpoint.getReportCard)
  Future<ReportCardResponse> getReportCard({
    @Query('studentId') required int studentId,
  });

  @POST(endpoint.saveReportCard)
  Future<ReportCardResponse> saveReportCard({
    @Body() required ReportCardModel request,
  });

  @GET(endpoint.getFoodMenu)
  Future<FoodMenuResponse> getFoodMenu({
    @Query('classId') required int classId,
    @Query('date') required String date,
  });

  @GET(endpoint.getHeathInfo)
  Future<HeathResponse> getHeathInfo({
    @Query('studentId') required int studentId,
  });

  @GET('https://api.v-school.vn/api/get-all-banner')
  Future<BannerResponse> getBannerInfo();

  @GET(endpoint.getScore)
  Future<ScoreResponse> getScoreByStudent({
    @Query('studentId') required int studentId,
    @Query('startStudyYear') required int startStudyYear,
    @Query('semester') required int semester,
  });

  @GET(endpoint.getSchedule)
  Future<ScheduleResponse> getSchedule({
    @Query('classId') required int classId,
    @Query('startDate') required String startDate,
    @Query('endDate') required String endDate,
    @Query('studyYear') required int studyYear,
  });

  /// /api/change_password
  @POST(endpoint.changePass)
  Future<UserLoginDataModel> changePass({
    @Query('username') required String username,
    @Query('old_password') required String oldPassword,
    @Query('new_password') required String newPassword,
  });

  /// /api/update-student-v2
  @POST(endpoint.updateInfoStudent)
  Future<MessageData> updateInfoStudent({
    @Body() required ChildrenInfoModel request,
  });

  /// /api/get-student-invoice-by-student-code
  @GET(endpoint.getInvoiceByStudentCode)
  Future<InvoiceDataResponse> getInvoiceByStudentCode({
    @Query('studentCode') required String studentCode,
  });

  /// /api/get-student-by-code
  @GET(endpoint.getStudentByCode)
  Future<ChildResponse> getStudentByCode({
    @Query('studentCode') required String studentCode,
  });

  @GET(endpoint.getPaymentSetting)
  Future<PaymentSettingResponse> getPaymentSetting({
    @Header('Authorization') required String token,
    @Query('studentId') required int studentId,
  });
}
