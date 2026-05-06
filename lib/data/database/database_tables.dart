class DatabaseTables {
  const DatabaseTables._();

  static const String recipes = 'recipes';
  static const String recipeIngredients = 'recipe_ingredients';
  static const String pantryItems = 'pantry_items';
  static const String mealPlanEntries = 'meal_plan_entries';
  static const String shoppingItems = 'shopping_items';

  static const String createRecipes = '''
CREATE TABLE recipes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  category TEXT NOT NULL,
  prep_minutes INTEGER NOT NULL,
  difficulty TEXT NOT NULL,
  servings INTEGER NOT NULL,
  notes TEXT
)
''';

  static const String createRecipeIngredients = '''
CREATE TABLE recipe_ingredients (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  recipe_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  quantity REAL NOT NULL,
  unit TEXT NOT NULL,
  FOREIGN KEY(recipe_id) REFERENCES recipes(id) ON DELETE CASCADE
)
''';

  static const String createPantryItems = '''
CREATE TABLE pantry_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  quantity REAL NOT NULL,
  unit TEXT NOT NULL,
  expiry_date TEXT,
  low_stock_threshold REAL NOT NULL,
  notes TEXT
)
''';

  static const String createMealPlanEntries = '''
CREATE TABLE meal_plan_entries (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  planned_date TEXT NOT NULL,
  meal_type TEXT NOT NULL,
  recipe_id INTEGER,
  custom_meal_name TEXT,
  notes TEXT,
  FOREIGN KEY(recipe_id) REFERENCES recipes(id) ON DELETE SET NULL
)
''';

  static const String createShoppingItems = '''
CREATE TABLE shopping_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  quantity REAL NOT NULL,
  unit TEXT NOT NULL,
  is_purchased INTEGER NOT NULL DEFAULT 0,
  source TEXT NOT NULL,
  notes TEXT
)
''';
}
