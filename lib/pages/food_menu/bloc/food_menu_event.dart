part of 'food_menu_bloc.dart';

abstract class FoodMenuEvent extends Equatable {
  const FoodMenuEvent();
}

class FoodMenuFetching extends FoodMenuEvent {
  final int classId;
  final String date;

  const FoodMenuFetching({required this.classId, required this.date});

  @override
  List<Object?> get props => [];
}
