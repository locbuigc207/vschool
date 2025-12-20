import 'package:simple_result/simple_result.dart';
import 'package:vschool/commons/api/clients/api_client.dart';
import 'package:vschool/commons/api/failures/failures.dart';
import 'package:vschool/commons/api/interceptors/error_interceptor.dart';
import 'package:vschool/commons/models/food_menu/food_menu_model.dart';

abstract class IFoodRepository {
  Future<Result<FoodMenuResponse, Failure>> getFoodMenu({
    required int classId,
    required String date,
  });
}

class FoodRepository extends IFoodRepository {
  final ApiClient _client;

  FoodRepository({required ApiClient apiClient}) : _client = apiClient;

  @override
  Future<Result<FoodMenuResponse, Failure>> getFoodMenu(
      {required int classId, required String date}) async {
    try {
      final response = await _client.getFoodMenu(classId: classId, date: date);
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
