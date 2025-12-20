import 'package:simple_result/simple_result.dart';
import 'package:vschool/commons/api/clients/api_client.dart';
import 'package:vschool/commons/api/failures/failures.dart';
import 'package:vschool/commons/api/interceptors/error_interceptor.dart';
import 'package:vschool/commons/models/admissions/admissions_model.dart';

abstract class IAdmissionsRepository {
  Future<Result<AdmissionsResponse, Failure>> submitAdmissions({
    required AdmissionsModel request,
  });
}

class AdmissionsRepository extends IAdmissionsRepository {
  final ApiClient _client;

  AdmissionsRepository({required ApiClient apiClient}) : _client = apiClient;

  @override
  Future<Result<AdmissionsResponse, Failure>> submitAdmissions({
    required AdmissionsModel request,
  }) async {
    try {
      final response = await _client.submitAdmissions(request: request);
      if (response.resultCode == 0) {
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
