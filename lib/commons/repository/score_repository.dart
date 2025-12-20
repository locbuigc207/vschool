import 'package:simple_result/simple_result.dart';
import 'package:vschool/commons/api/clients/api_client.dart';
import 'package:vschool/commons/api/failures/failures.dart';
import 'package:vschool/commons/api/interceptors/error_interceptor.dart';
import 'package:vschool/commons/models/scores/score_model.dart';

abstract class IScoreRepository {
  Future<Result<ScoreResponse, Failure>> getScore({
    required int studentId,
    required int startStudyYear,
    required int semester,
  });
}

class ScoreRepository extends IScoreRepository {
  final ApiClient _apiClient;

  ScoreRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<Result<ScoreResponse, Failure>> getScore({
    required int studentId,
    required int startStudyYear,
    required int semester,
  }) async {
    try {
      final response = await _apiClient.getScoreByStudent(
          studentId: studentId,
          startStudyYear: startStudyYear,
          semester: semester);
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
