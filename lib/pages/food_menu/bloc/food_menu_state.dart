part of 'food_menu_bloc.dart';

abstract class FoodMenuState extends Equatable {
  const FoodMenuState();
}

class FoodMenuFetchingInitial extends FoodMenuState {
  @override
  List<Object?> get props => [];
}

class FoodMenuFetchSuccess extends FoodMenuState {
  final List<FoodMenuModel>? data;

  const FoodMenuFetchSuccess({this.data});

  @override
  List<Object?> get props => [data];
}

class FoodMenuFetchFailure extends FoodMenuState {
  final String mess;

  const FoodMenuFetchFailure({required this.mess});

  @override
  List<Object?> get props => [mess];
}
