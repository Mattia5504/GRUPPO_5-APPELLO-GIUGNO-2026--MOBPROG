class MealPlanEntry {
  const MealPlanEntry({
    this.id,
    required this.plannedDate,
    required this.mealType,
    this.recipeId,
    this.customMealName,
    this.notes,
  });

  final int? id;
  final DateTime plannedDate;
  final String mealType;
  final int? recipeId;
  final String? customMealName;
  final String? notes;

  factory MealPlanEntry.fromMap(Map<String, Object?> map) {
    return MealPlanEntry(
      id: map['id'] as int?,
      plannedDate: DateTime.parse(map['planned_date'] as String),
      mealType: map['meal_type'] as String,
      recipeId: map['recipe_id'] as int?,
      customMealName: map['custom_meal_name'] as String?,
      notes: map['notes'] as String?,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'planned_date': plannedDate.toIso8601String(),
      'meal_type': mealType,
      'recipe_id': recipeId,
      'custom_meal_name': customMealName,
      'notes': notes,
    };
  }

  MealPlanEntry copyWith({
    int? id,
    DateTime? plannedDate,
    String? mealType,
    int? recipeId,
    String? customMealName,
    String? notes,
  }) {
    return MealPlanEntry(
      id: id ?? this.id,
      plannedDate: plannedDate ?? this.plannedDate,
      mealType: mealType ?? this.mealType,
      recipeId: recipeId ?? this.recipeId,
      customMealName: customMealName ?? this.customMealName,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    return 'MealPlanEntry(id: $id, plannedDate: $plannedDate, mealType: $mealType, recipeId: $recipeId)';
  }
}
