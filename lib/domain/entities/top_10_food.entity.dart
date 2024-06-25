import 'package:tajiri_waitress/domain/entities/food_data.entity.dart';

class Top10FoodEntity {
  final FoodDataEntity? food;
  final int count;
  final int totalAmount;

  Top10FoodEntity(
      {required this.food, required this.count, required this.totalAmount});
}
