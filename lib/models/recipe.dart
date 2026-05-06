import 'recipe_ingredient.dart';

class Recipe {
  const Recipe({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.prepMinutes,
    required this.difficulty,
    required this.servings,
    this.notes,
    this.ingredients = const [],
  });

  final int? id;
  final String name;
  final String description;
  final String category;
  final int prepMinutes;
  final String difficulty;
  final int servings;
  final String? notes;
  final List<RecipeIngredient> ingredients;

  factory Recipe.fromMap(
    Map<String, Object?> map, {
    List<RecipeIngredient> ingredients = const [],
  }) {
    return Recipe(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      prepMinutes: map['prep_minutes'] as int,
      difficulty: map['difficulty'] as String,
      servings: map['servings'] as int,
      notes: map['notes'] as String?,
      ingredients: ingredients,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'prep_minutes': prepMinutes,
      'difficulty': difficulty,
      'servings': servings,
      'notes': notes,
    };
  }

  Recipe copyWith({
    int? id,
    String? name,
    String? description,
    String? category,
    int? prepMinutes,
    String? difficulty,
    int? servings,
    String? notes,
    List<RecipeIngredient>? ingredients,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      prepMinutes: prepMinutes ?? this.prepMinutes,
      difficulty: difficulty ?? this.difficulty,
      servings: servings ?? this.servings,
      notes: notes ?? this.notes,
      ingredients: ingredients ?? this.ingredients,
    );
  }

  @override
  String toString() {
    return 'Recipe(id: $id, name: $name, category: $category, prepMinutes: $prepMinutes, difficulty: $difficulty)';
  }
}
