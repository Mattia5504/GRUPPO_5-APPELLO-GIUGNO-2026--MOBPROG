import 'package:sqflite/sqflite.dart';

import '../../models/meal_plan_entry.dart';
import '../../models/pantry_item.dart';
import '../../models/recipe.dart';
import '../../models/recipe_ingredient.dart';
import '../../models/shopping_item.dart';
import '../database/app_database.dart';
import '../database/database_tables.dart';
import '../seed/seed_data.dart';

class AppRepository {
  AppRepository({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<Database> get _db => _database.database;

  Future<void> seedIfNeeded() async {
    final db = await _db;
    final countResult = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM ${DatabaseTables.recipes}',
    );
    final recipesCount = Sqflite.firstIntValue(countResult) ?? 0;

    if (recipesCount > 0) {
      return;
    }

    final recipeIds = <String, int>{};
    for (final recipe in SeedData.recipes()) {
      final id = await insertRecipe(recipe);
      recipeIds[recipe.name] = id;
    }

    for (final item in SeedData.pantryItems()) {
      await insertPantryItem(item);
    }

    for (final entry in SeedData.mealPlanEntries(recipeIds)) {
      await insertMealPlanEntry(entry);
    }

    for (final item in SeedData.shoppingItems()) {
      await insertShoppingItem(item);
    }
  }

  Future<List<Recipe>> getRecipes() async {
    final db = await _db;
    final recipeMaps = await db.query(
      DatabaseTables.recipes,
      orderBy: 'name COLLATE NOCASE',
    );

    final recipes = <Recipe>[];
    for (final recipeMap in recipeMaps) {
      final id = recipeMap['id'] as int;
      final ingredients = await getRecipeIngredients(id);
      recipes.add(Recipe.fromMap(recipeMap, ingredients: ingredients));
    }

    return recipes;
  }

  Future<Recipe?> getRecipeById(int id) async {
    final db = await _db;
    final maps = await db.query(
      DatabaseTables.recipes,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }

    final ingredients = await getRecipeIngredients(id);
    return Recipe.fromMap(maps.first, ingredients: ingredients);
  }

  Future<List<RecipeIngredient>> getRecipeIngredients([int? recipeId]) async {
    final db = await _db;
    final maps = await db.query(
      DatabaseTables.recipeIngredients,
      where: recipeId == null ? null : 'recipe_id = ?',
      whereArgs: recipeId == null ? null : [recipeId],
      orderBy: 'name COLLATE NOCASE',
    );

    return maps.map(RecipeIngredient.fromMap).toList();
  }

  Future<int> insertRecipe(Recipe recipe) async {
    final db = await _db;

    return db.transaction((tx) async {
      final recipeId = await tx.insert(
        DatabaseTables.recipes,
        recipe.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      for (final ingredient in recipe.ingredients) {
        await tx.insert(
          DatabaseTables.recipeIngredients,
          ingredient.copyWith(recipeId: recipeId).toMap(),
        );
      }

      return recipeId;
    });
  }

  Future<void> updateRecipe(Recipe recipe) async {
    final id = recipe.id;
    if (id == null) {
      throw ArgumentError('Recipe id is required for update');
    }

    final db = await _db;
    await db.transaction((tx) async {
      await tx.update(
        DatabaseTables.recipes,
        recipe.toMap(),
        where: 'id = ?',
        whereArgs: [id],
      );
      await tx.delete(
        DatabaseTables.recipeIngredients,
        where: 'recipe_id = ?',
        whereArgs: [id],
      );

      for (final ingredient in recipe.ingredients) {
        await tx.insert(
          DatabaseTables.recipeIngredients,
          ingredient.copyWith(recipeId: id).toMap(),
        );
      }
    });
  }

  Future<void> deleteRecipe(int id) async {
    final db = await _db;
    await db.delete(DatabaseTables.recipes, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<PantryItem>> getPantryItems() async {
    final db = await _db;
    final maps = await db.query(
      DatabaseTables.pantryItems,
      orderBy: 'name COLLATE NOCASE',
    );
    return maps.map(PantryItem.fromMap).toList();
  }

  Future<int> insertPantryItem(PantryItem item) async {
    final db = await _db;
    return db.insert(DatabaseTables.pantryItems, item.toMap());
  }

  Future<void> updatePantryItem(PantryItem item) async {
    final id = item.id;
    if (id == null) {
      throw ArgumentError('Pantry item id is required for update');
    }

    final db = await _db;
    await db.update(
      DatabaseTables.pantryItems,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deletePantryItem(int id) async {
    final db = await _db;
    await db.delete(
      DatabaseTables.pantryItems,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<MealPlanEntry>> getMealPlanEntries() async {
    final db = await _db;
    final maps = await db.query(
      DatabaseTables.mealPlanEntries,
      orderBy: 'planned_date, meal_type',
    );
    return maps.map(MealPlanEntry.fromMap).toList();
  }

  Future<int> insertMealPlanEntry(MealPlanEntry entry) async {
    final db = await _db;
    return db.insert(DatabaseTables.mealPlanEntries, entry.toMap());
  }

  Future<void> updateMealPlanEntry(MealPlanEntry entry) async {
    final id = entry.id;
    if (id == null) {
      throw ArgumentError('Meal plan entry id is required for update');
    }

    final db = await _db;
    await db.update(
      DatabaseTables.mealPlanEntries,
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteMealPlanEntry(int id) async {
    final db = await _db;
    await db.delete(
      DatabaseTables.mealPlanEntries,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<ShoppingItem>> getShoppingItems() async {
    final db = await _db;
    final maps = await db.query(
      DatabaseTables.shoppingItems,
      orderBy: 'is_purchased, name COLLATE NOCASE',
    );
    return maps.map(ShoppingItem.fromMap).toList();
  }

  Future<int> insertShoppingItem(ShoppingItem item) async {
    final db = await _db;
    return db.insert(DatabaseTables.shoppingItems, item.toMap());
  }

  Future<void> updateShoppingItem(ShoppingItem item) async {
    final id = item.id;
    if (id == null) {
      throw ArgumentError('Shopping item id is required for update');
    }

    final db = await _db;
    await db.update(
      DatabaseTables.shoppingItems,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteShoppingItem(int id) async {
    final db = await _db;
    await db.delete(
      DatabaseTables.shoppingItems,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAutomaticShoppingItems() async {
    final db = await _db;
    await db.delete(
      DatabaseTables.shoppingItems,
      where: 'source = ?',
      whereArgs: ['auto'],
    );
  }
}
