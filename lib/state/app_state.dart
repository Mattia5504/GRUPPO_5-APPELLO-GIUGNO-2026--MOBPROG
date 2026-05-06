import 'package:flutter/foundation.dart';

import '../core/app_date_utils.dart';
import '../data/repositories/app_repository.dart';
import '../models/dashboard_summary.dart';
import '../models/meal_plan_entry.dart';
import '../models/pantry_item.dart';
import '../models/recipe.dart';
import '../models/recipe_ingredient.dart';
import '../models/shopping_item.dart';

class AppState extends ChangeNotifier {
  AppState({AppRepository? repository})
    : _repository = repository ?? AppRepository();

  final AppRepository _repository;

  bool isLoading = false;
  List<Recipe> recipes = [];
  List<RecipeIngredient> recipeIngredients = [];
  List<PantryItem> pantryItems = [];
  List<MealPlanEntry> mealPlanEntries = [];
  List<ShoppingItem> shoppingItems = [];

  Future<void> initialize() async {
    isLoading = true;
    notifyListeners();

    await _repository.seedIfNeeded();
    await loadAll();

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadAll() async {
    recipes = await _repository.getRecipes();
    recipeIngredients = recipes.expand((recipe) => recipe.ingredients).toList();
    pantryItems = await _repository.getPantryItems();
    mealPlanEntries = await _repository.getMealPlanEntries();
    shoppingItems = await _repository.getShoppingItems();
    notifyListeners();
  }

  Future<void> addRecipe(Recipe recipe) async {
    await _repository.insertRecipe(recipe);
    await loadAll();
  }

  Future<void> updateRecipe(Recipe recipe) async {
    await _repository.updateRecipe(recipe);
    await loadAll();
  }

  Future<void> deleteRecipe(int id) async {
    await _repository.deleteRecipe(id);
    await loadAll();
  }

  Future<void> addPantryItem(PantryItem item) async {
    await _repository.insertPantryItem(item);
    await loadAll();
  }

  Future<void> updatePantryItem(PantryItem item) async {
    await _repository.updatePantryItem(item);
    await loadAll();
  }

  Future<void> deletePantryItem(int id) async {
    await _repository.deletePantryItem(id);
    await loadAll();
  }

  Future<void> addMealPlanEntry(MealPlanEntry entry) async {
    await _repository.insertMealPlanEntry(entry);
    await loadAll();
  }

  Future<void> updateMealPlanEntry(MealPlanEntry entry) async {
    await _repository.updateMealPlanEntry(entry);
    await loadAll();
  }

  Future<void> deleteMealPlanEntry(int id) async {
    await _repository.deleteMealPlanEntry(id);
    await loadAll();
  }

  Future<void> addShoppingItem(ShoppingItem item) async {
    await _repository.insertShoppingItem(item);
    await loadAll();
  }

  Future<void> updateShoppingItem(ShoppingItem item) async {
    await _repository.updateShoppingItem(item);
    await loadAll();
  }

  Future<void> deleteShoppingItem(int id) async {
    await _repository.deleteShoppingItem(id);
    await loadAll();
  }

  Future<void> toggleShoppingItemPurchased(int id) async {
    final item = shoppingItems.firstWhere(
      (shoppingItem) => shoppingItem.id == id,
    );
    await _repository.updateShoppingItem(
      item.copyWith(isPurchased: !item.isPurchased),
    );
    await loadAll();
  }

  Future<void> generateShoppingListFromMealPlan() async {
    final plannedRecipeIds = _entriesForCurrentWeek()
        .map((entry) => entry.recipeId)
        .whereType<int>()
        .toSet();

    final requiredIngredients = <String, _IngredientNeed>{};
    for (final recipe in recipes.where(
      (recipe) => recipe.id != null && plannedRecipeIds.contains(recipe.id),
    )) {
      for (final ingredient in recipe.ingredients) {
        final key = _ingredientKey(ingredient.name, ingredient.unit);
        final current = requiredIngredients[key];
        requiredIngredients[key] = _IngredientNeed(
          name: ingredient.name,
          unit: ingredient.unit,
          quantity: (current?.quantity ?? 0) + ingredient.quantity,
        );
      }
    }

    await _repository.deleteAutomaticShoppingItems();

    for (final need in requiredIngredients.values) {
      final availableQuantity = _availableQuantityFor(need.name, need.unit);
      final missingQuantity = need.quantity - availableQuantity;

      if (missingQuantity > 0) {
        await _repository.insertShoppingItem(
          ShoppingItem(
            name: need.name,
            category: _categoryForIngredient(need.name, need.unit),
            quantity: missingQuantity,
            unit: need.unit,
            source: 'auto',
            notes: 'Generato dal meal plan settimanale.',
          ),
        );
      }
    }

    await loadAll();
  }

  List<PantryItem> getExpiringItems() {
    final today = AppDateUtils.startOfDay(DateTime.now());
    final limit = today.add(const Duration(days: 7));

    return pantryItems.where((item) {
      final expiryDate = item.expiryDate;
      if (expiryDate == null) {
        return false;
      }
      final normalized = AppDateUtils.startOfDay(expiryDate);
      return !normalized.isAfter(limit);
    }).toList();
  }

  List<PantryItem> getLowStockItems() {
    return pantryItems
        .where((item) => item.quantity <= item.lowStockThreshold)
        .toList();
  }

  List<Recipe> getSuggestedRecipes() {
    final sorted = [...recipes];
    sorted.sort(
      (a, b) => getRecipeAvailabilityScore(
        b,
      ).compareTo(getRecipeAvailabilityScore(a)),
    );
    return sorted;
  }

  double getRecipeAvailabilityScore(Recipe recipe) {
    if (recipe.ingredients.isEmpty) {
      return 0;
    }

    final availableIngredients = recipe.ingredients.where((ingredient) {
      return pantryItems.any((item) {
        return _normalize(item.name) == _normalize(ingredient.name) &&
            _normalize(item.unit) == _normalize(ingredient.unit) &&
            item.quantity >= ingredient.quantity;
      });
    }).length;

    return availableIngredients / recipe.ingredients.length;
  }

  DashboardSummary getDashboardSummary() {
    return DashboardSummary(
      totalRecipes: recipes.length,
      mealsThisWeek: getMealsPlannedThisWeek(),
      expiringItems: getExpiringItems().length,
      lowStockItems: getLowStockItems().length,
      shoppingItemsToBuy: shoppingItems
          .where((item) => !item.isPurchased)
          .length,
      averagePrepTime: getAveragePreparationTime(),
    );
  }

  Map<String, int> getRecipeCategoryDistribution() {
    final distribution = <String, int>{};
    for (final recipe in recipes) {
      distribution[recipe.category] = (distribution[recipe.category] ?? 0) + 1;
    }
    return distribution;
  }

  Map<String, int> getPantryCategoryDistribution() {
    final distribution = <String, int>{};
    for (final item in pantryItems) {
      distribution[item.category] = (distribution[item.category] ?? 0) + 1;
    }
    return distribution;
  }

  int getMealsPlannedThisWeek() {
    return _entriesForCurrentWeek().length;
  }

  double getAveragePreparationTime() {
    if (recipes.isEmpty) {
      return 0;
    }

    final totalMinutes = recipes.fold<int>(
      0,
      (sum, recipe) => sum + recipe.prepMinutes,
    );
    return totalMinutes / recipes.length;
  }

  List<String> getMissingIngredientsForPlannedMeals() {
    final plannedRecipeIds = _entriesForCurrentWeek()
        .map((entry) => entry.recipeId)
        .whereType<int>()
        .toSet();
    final missing = <String>[];

    for (final recipe in recipes.where(
      (recipe) => recipe.id != null && plannedRecipeIds.contains(recipe.id),
    )) {
      for (final ingredient in recipe.ingredients) {
        final availableQuantity = _availableQuantityFor(
          ingredient.name,
          ingredient.unit,
        );
        if (availableQuantity < ingredient.quantity) {
          final quantity = ingredient.quantity - availableQuantity;
          missing.add(
            '${ingredient.name} ${_formatQuantity(quantity)} ${ingredient.unit}',
          );
        }
      }
    }

    return missing.toSet().toList()..sort();
  }

  Recipe? recipeById(int? id) {
    if (id == null) {
      return null;
    }

    for (final recipe in recipes) {
      if (recipe.id == id) {
        return recipe;
      }
    }
    return null;
  }

  List<MealPlanEntry> _entriesForCurrentWeek() {
    final start = AppDateUtils.startOfWeek(DateTime.now());
    final end = AppDateUtils.endOfWeek(DateTime.now());

    return mealPlanEntries.where((entry) {
      final date = AppDateUtils.startOfDay(entry.plannedDate);
      return !date.isBefore(start) && !date.isAfter(end);
    }).toList();
  }

  double _availableQuantityFor(String name, String unit) {
    return pantryItems
        .where(
          (item) =>
              _normalize(item.name) == _normalize(name) &&
              _normalize(item.unit) == _normalize(unit),
        )
        .fold<double>(0, (sum, item) => sum + item.quantity);
  }

  String _categoryForIngredient(String name, String unit) {
    for (final item in pantryItems) {
      if (_normalize(item.name) == _normalize(name) &&
          _normalize(item.unit) == _normalize(unit)) {
        return item.category;
      }
    }
    return 'Altro';
  }

  String _ingredientKey(String name, String unit) {
    return '${_normalize(name)}|${_normalize(unit)}';
  }

  String _normalize(String value) {
    return value.trim().toLowerCase();
  }

  String _formatQuantity(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }
}

class _IngredientNeed {
  const _IngredientNeed({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  final String name;
  final double quantity;
  final String unit;
}
