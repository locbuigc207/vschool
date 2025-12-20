import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vschool/commons/models/food_menu/food_menu_model.dart';
import 'package:vschool/commons/repository/food_repository.dart';

part 'food_menu_event.dart';

part 'food_menu_state.dart';

class FoodMenuBloc extends Bloc<FoodMenuEvent, FoodMenuState> {
  final IFoodRepository _foodRepository;

  FoodMenuBloc({required IFoodRepository foodRepository})
      : _foodRepository = foodRepository,
        super(FoodMenuFetchingInitial()) {
    on<FoodMenuFetching>(_onFoodMenuFetching);
  }

  FutureOr<void> _onFoodMenuFetching(
      FoodMenuFetching event, Emitter<FoodMenuState> emit) async {
    final result = await _foodRepository.getFoodMenu(
        classId: event.classId, date: event.date);

    result.when(
      success: (success) =>
          emit(FoodMenuFetchSuccess(data: result.success?.data)),
      failure: (failure) =>
          emit(FoodMenuFetchFailure(mess: result.failure?.message ?? '')),
    );
  }
}
