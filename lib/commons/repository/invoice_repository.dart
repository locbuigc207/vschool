import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_result/simple_result.dart';
import 'package:vschool/commons/api/clients/api_client.dart';
import 'package:vschool/commons/api/failures/failures.dart';
import 'package:vschool/commons/api/interceptors/error_interceptor.dart';
import 'package:vschool/commons/models/invoice/invoice_model.dart';

abstract class IInvoiceRepository {
  Future<Result<InvoiceDataResponse, Failure>> getInvoiceByChild({
    required int studentId,
  });

  Future<Result<InvoiceDataResponse, Failure>> getInvoiceByStudentCode({
    required String studentCode,
  });
}

class InvoiceRepository extends IInvoiceRepository {
  final ApiClient _client;

  InvoiceRepository({required ApiClient apiClient}) : _client = apiClient;

  @override
  Future<Result<InvoiceDataResponse, Failure>> getInvoiceByChild(
      {required int studentId}) async {
    try {
      final Future<SharedPreferences> preferencesFuture =
          SharedPreferences.getInstance();
      final SharedPreferences preferences = await preferencesFuture;
      final response = await _client.getInvoiceByChild(
          studentId: studentId,
          token: "Bearer ${preferences.getString('accessToken')!}");
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
  Future<Result<InvoiceDataResponse, Failure>> getInvoiceByStudentCode(
      {required String studentCode}) async {
    try {
      final response =
          await _client.getInvoiceByStudentCode(studentCode: studentCode);
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
}
