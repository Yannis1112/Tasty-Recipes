import 'package:tasty_recipes/model/ingredient.dart';

class Recipe {
  Recipe({
    required this.nameRecipe,
    required this.imageRecipe,
    required this.category,
    required this.totalTime,
    required this.cookingTime,
    required this.difficulty,
    required this.cost,
    required this.ingredients,
    required this.steps,
    required this.utensils,
    this.idRecipe,
  });

  late String? idRecipe;
  late String nameRecipe;
  late String imageRecipe;
  late String category;
  late String totalTime;
  late String cookingTime;
  late String difficulty;
  late String cost;
  List<Ingredient> ingredients;
  List<String> steps;
  List<String> utensils;
  Map<String, bool>? diets;
}
