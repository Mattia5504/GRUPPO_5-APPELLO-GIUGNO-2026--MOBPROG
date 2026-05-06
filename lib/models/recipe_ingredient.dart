class RecipeIngredient {
  const RecipeIngredient({
    this.id,
    this.recipeId,
    required this.name,
    required this.quantity,
    required this.unit,
  });

  final int? id;
  final int? recipeId;
  final String name;
  final double quantity;
  final String unit;

  factory RecipeIngredient.fromMap(Map<String, Object?> map) {
    return RecipeIngredient(
      id: map['id'] as int?,
      recipeId: map['recipe_id'] as int?,
      name: map['name'] as String,
      quantity: (map['quantity'] as num).toDouble(),
      unit: map['unit'] as String,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'recipe_id': recipeId,
      'name': name,
      'quantity': quantity,
      'unit': unit,
    };
  }

  RecipeIngredient copyWith({
    int? id,
    int? recipeId,
    String? name,
    double? quantity,
    String? unit,
  }) {
    return RecipeIngredient(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }

  @override
  String toString() {
    return 'RecipeIngredient(id: $id, recipeId: $recipeId, name: $name, quantity: $quantity, unit: $unit)';
  }
}
