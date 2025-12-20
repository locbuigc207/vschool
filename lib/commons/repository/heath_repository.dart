import 'package:simple_result/simple_result.dart';
import 'package:vschool/commons/api/clients/api_client.dart';
import 'package:vschool/commons/api/failures/failures.dart';
import 'package:vschool/commons/api/interceptors/error_interceptor.dart';
import 'package:vschool/commons/models/heath/heath_model.dart';

abstract class IHeathRepository {
  Future<Result<HeathResponse, Failure>> getHeathInfo({
    required int studentId,
  });
}

class HeathRepository extends IHeathRepository {
  final ApiClient _client;

  HeathRepository({required ApiClient apiClient}) : _client = apiClient;

  @override
  Future<Result<HeathResponse, Failure>> getHeathInfo(
      {required int studentId}) async {
    try {
      final response = await _client.getHeathInfo(studentId: studentId);
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
