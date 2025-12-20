import 'package:json_annotation/json_annotation.dart';

part 'food_menu_model.g.dart';

@JsonSerializable()
class FoodMenuModel {
  final int dishFoodMenuFkId;
  final String dishName;
  final int isUsing;

  FoodMenuModel({
    required this.dishFoodMenuFkId,
    required this.dishName,
    required this.isUsing,
  });

  factory FoodMenuModel.fromJson(Map<String, dynamic> json) =>
      _$FoodMenuModelFromJson(json);
}

@JsonSerializable()
class FoodMenuResponse {
  final int resultCode;
  final String message;
  @JsonKey(name: 'data')
  final List<FoodMenuModel>? data;

  FoodMenuResponse({
    required this.resultCode,
    required this.message,
    this.data,
  });

  factory FoodMenuResponse.fromJson(Map<String, dynamic> json) =>
      _$FoodMenuResponseFromJson(json);
}
