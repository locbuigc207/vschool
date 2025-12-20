import 'package:simple_result/simple_result.dart';
import 'package:vschool/commons/api/clients/api_client.dart';
import 'package:vschool/commons/api/failures/failures.dart';
import 'package:vschool/commons/api/interceptors/error_interceptor.dart';
import 'package:vschool/commons/models/report_card/report_card_model.dart';

abstract class IReportCardRepository {
  Future<Result<ReportCardResponse, Failure>> getReportCard({
    required int studentId,
  });

  Future<Result<ReportCardResponse, Failure>> saveReportCard({
    required ReportCardModel request,
  });
}

class ReportCardRepository extends IReportCardRepository {
  final ApiClient _client;

  ReportCardRepository({required ApiClient apiClient}) : _client = apiClient;

  @override
  Future<Result<ReportCardResponse, Failure>> getReportCard(
      {required int studentId}) async {
    try {
      final response = await _client.getReportCard(studentId: studentId);
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
  Future<Result<ReportCardResponse, Failure>> saveReportCard(
      {required ReportCardModel request}) async {
    try {
      final response = await _client.saveReportCard(request: request);
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
