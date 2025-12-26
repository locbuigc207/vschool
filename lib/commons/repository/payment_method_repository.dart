import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_result/simple_result.dart';
import 'package:vschool/commons/api/clients/api_client.dart';
import 'package:vschool/commons/api/failures/failures.dart';
import 'package:vschool/commons/api/interceptors/error_interceptor.dart';
import 'package:vschool/commons/models/payment_channel/payment_channel_model.dart';
import 'package:vschool/commons/models/payment_setting/payment_setting_model.dart';
import 'package:vschool/commons/models/qrCode/qr_code_model.dart';

abstract class IPaymentMethodRepository {
  Future<Result<PaymentSettingModel, Failure>> getPaymentSetting({
    required int studentId,
  });

  Future<Result<QrCodeResponse, Failure>> genQrCode({
    required QrCodeGenerateRequest request,
  });

  Future<Result<PaymentChannelResponse, Failure>> getAllPaymentChannel();
}

class PaymentMethodRepository extends IPaymentMethodRepository {
  final ApiClient _client;

  PaymentMethodRepository({required ApiClient apiClient}) : _client = apiClient;

  @override
  Future<Result<PaymentSettingModel, Failure>> getPaymentSetting({
    required int studentId,
  }) async {
    try {
      final Future<SharedPreferences> preferencesFuture =
          SharedPreferences.getInstance();
      final SharedPreferences preferences = await preferencesFuture;
      final response = await _client.getPaymentSetting(
        token: "Bearer ${preferences.getString('accessToken')!}",
        studentId: studentId,
      );

      if (response.code == 200) {
        return Result.success(response.info);
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
  Future<Result<QrCodeResponse, Failure>> genQrCode({
    required QrCodeGenerateRequest request,
  }) async {
    try {
      final Future<SharedPreferences> preferencesFuture =
          SharedPreferences.getInstance();
      final SharedPreferences preferences = await preferencesFuture;
      final response = await _client.genQRCode(
        token: "Bearer ${preferences.getString('accessToken')!}",
        studentId: request.studentId ?? 0,
        listInvoiceIds: request.listInvoiceIds ?? [],
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
  Future<Result<PaymentChannelResponse, Failure>> getAllPaymentChannel() async {
    try {
      print('PaymentMethodRepository - Calling getAllPaymentChannel API...');
      final response = await _client.getAllPaymentChannel();
      print('PaymentMethodRepository - API response: $response');
      print(
          'PaymentMethodRepository - Response data length: ${response.data?.length ?? 0}');
      return Result.success(response);
    } on UnauthorizedException catch (err) {
      print('PaymentMethodRepository - UnauthorizedException: $err');
      return Result.failure(UnauthorizedFailure(message: err.toString()));
    } on ResponseException catch (err) {
      print('PaymentMethodRepository - ResponseException: $err');
      return Result.failure(ResponseFailure(message: err.toString()));
    } on Exception catch (e) {
      print('PaymentMethodRepository - General Exception: $e');
      return Result.failure(UnknownFailure(message: e.toString()));
    }
  }
}
