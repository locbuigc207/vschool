import 'package:simple_result/simple_result.dart';
import 'package:vschool/commons/api/clients/api_client.dart';
import 'package:vschool/commons/api/failures/failures.dart';
import 'package:vschool/commons/api/interceptors/error_interceptor.dart';
import 'package:vschool/commons/models/schedule/schedule_model.dart';

abstract class IScheduleRepository {
  Future<Result<ScheduleResponse, Failure>> getSchedule({
    required int classId,
    required String startDate,
    required String endDate,
    required int studyYear,
  });
}

class ScheduleRepository extends IScheduleRepository {
  final ApiClient _apiClient;

  ScheduleRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<Result<ScheduleResponse, Failure>> getSchedule(
      {required int classId,
      required String startDate,
      required String endDate,
      required int studyYear}) async {
    try {
      final response = await _apiClient.getSchedule(
          classId: classId,
          startDate: startDate,
          endDate: endDate,
          studyYear: studyYear);
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
