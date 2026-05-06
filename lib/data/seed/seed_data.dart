import '../../core/app_date_utils.dart';
import '../../models/meal_plan_entry.dart';
import '../../models/pantry_item.dart';
import '../../models/recipe.dart';
import '../../models/recipe_ingredient.dart';
import '../../models/shopping_item.dart';

class SeedData {
  const SeedData._();

  static List<Recipe> recipes() {
    return [
      const Recipe(
        name: 'Pasta al pomodoro',
        description:
            'Cuoci la pasta al dente e condiscila con salsa di pomodoro, olio e basilico.',
        category: 'Primo',
        prepMinutes: 20,
        difficulty: 'Facile',
        servings: 2,
        notes: 'Perfetta per una demo veloce della lista spesa automatica.',
        ingredients: [
          RecipeIngredient(name: 'pasta', quantity: 180, unit: 'g'),
          RecipeIngredient(name: 'pomodoro', quantity: 250, unit: 'g'),
          RecipeIngredient(name: 'olio', quantity: 2, unit: 'cucchiai'),
          RecipeIngredient(name: 'sale', quantity: 1, unit: 'q.b.'),
        ],
      ),
      const Recipe(
        name: 'Insalata di pollo',
        description:
            'Griglia il pollo, taglialo a strisce e servilo con verdure fresche e olio.',
        category: 'Secondo',
        prepMinutes: 25,
        difficulty: 'Facile',
        servings: 2,
        ingredients: [
          RecipeIngredient(name: 'pollo', quantity: 250, unit: 'g'),
          RecipeIngredient(name: 'verdure', quantity: 200, unit: 'g'),
          RecipeIngredient(name: 'olio', quantity: 1, unit: 'cucchiai'),
        ],
      ),
      const Recipe(
        name: 'Omelette',
        description:
            'Sbatti le uova con un pizzico di sale e cuoci in padella antiaderente.',
        category: 'Secondo',
        prepMinutes: 12,
        difficulty: 'Facile',
        servings: 1,
        ingredients: [
          RecipeIngredient(name: 'uova', quantity: 2, unit: 'pz'),
          RecipeIngredient(name: 'latte', quantity: 30, unit: 'ml'),
          RecipeIngredient(name: 'sale', quantity: 1, unit: 'q.b.'),
        ],
      ),
      const Recipe(
        name: 'Riso con verdure',
        description:
            'Cuoci il riso e saltalo con verdure di stagione e un filo d olio.',
        category: 'Piatto unico',
        prepMinutes: 30,
        difficulty: 'Media',
        servings: 2,
        ingredients: [
          RecipeIngredient(name: 'riso', quantity: 180, unit: 'g'),
          RecipeIngredient(name: 'verdure', quantity: 250, unit: 'g'),
          RecipeIngredient(name: 'olio', quantity: 1, unit: 'cucchiai'),
        ],
      ),
      const Recipe(
        name: 'Yogurt bowl',
        description:
            'Componi una bowl con yogurt, avena e frutta fresca tagliata.',
        category: 'Colazione',
        prepMinutes: 8,
        difficulty: 'Facile',
        servings: 1,
        ingredients: [
          RecipeIngredient(name: 'yogurt', quantity: 150, unit: 'g'),
          RecipeIngredient(name: 'avena', quantity: 40, unit: 'g'),
          RecipeIngredient(name: 'frutta', quantity: 100, unit: 'g'),
        ],
      ),
      const Recipe(
        name: 'Zuppa di legumi',
        description:
            'Scalda i legumi con verdure e spezie, poi servi con pane tostato.',
        category: 'Zuppa',
        prepMinutes: 35,
        difficulty: 'Media',
        servings: 3,
        ingredients: [
          RecipeIngredient(name: 'legumi', quantity: 350, unit: 'g'),
          RecipeIngredient(name: 'verdure', quantity: 150, unit: 'g'),
          RecipeIngredient(name: 'pane', quantity: 2, unit: 'pz'),
        ],
      ),
      const Recipe(
        name: 'Toast avocado e uova',
        description:
            'Tosta il pane, aggiungi avocado schiacciato e completa con uova cotte.',
        category: 'Colazione',
        prepMinutes: 15,
        difficulty: 'Facile',
        servings: 1,
        ingredients: [
          RecipeIngredient(name: 'pane', quantity: 2, unit: 'pz'),
          RecipeIngredient(name: 'avocado', quantity: 1, unit: 'pz'),
          RecipeIngredient(name: 'uova', quantity: 1, unit: 'pz'),
        ],
      ),
      const Recipe(
        name: 'Cous cous mediterraneo',
        description:
            'Reidrata il cous cous e condiscilo con verdure, legumi e olio.',
        category: 'Piatto unico',
        prepMinutes: 18,
        difficulty: 'Facile',
        servings: 2,
        ingredients: [
          RecipeIngredient(name: 'cous cous', quantity: 180, unit: 'g'),
          RecipeIngredient(name: 'verdure', quantity: 200, unit: 'g'),
          RecipeIngredient(name: 'legumi', quantity: 120, unit: 'g'),
          RecipeIngredient(name: 'olio', quantity: 1, unit: 'cucchiai'),
        ],
      ),
    ];
  }

  static List<PantryItem> pantryItems() {
    final today = AppDateUtils.startOfDay(DateTime.now());

    return [
      PantryItem(
        name: 'pasta',
        category: 'Pasta e cereali',
        quantity: 320,
        unit: 'g',
        expiryDate: today.add(const Duration(days: 90)),
        lowStockThreshold: 150,
      ),
      PantryItem(
        name: 'pomodoro',
        category: 'Verdura',
        quantity: 180,
        unit: 'g',
        expiryDate: today.add(const Duration(days: 2)),
        lowStockThreshold: 100,
      ),
      PantryItem(
        name: 'olio',
        category: 'Condimenti',
        quantity: 4,
        unit: 'cucchiai',
        lowStockThreshold: 2,
      ),
      PantryItem(
        name: 'sale',
        category: 'Condimenti',
        quantity: 20,
        unit: 'q.b.',
        lowStockThreshold: 1,
      ),
      PantryItem(
        name: 'riso',
        category: 'Pasta e cereali',
        quantity: 120,
        unit: 'g',
        expiryDate: today.add(const Duration(days: 120)),
        lowStockThreshold: 150,
      ),
      PantryItem(
        name: 'uova',
        category: 'Proteine',
        quantity: 3,
        unit: 'pz',
        expiryDate: today.add(const Duration(days: 5)),
        lowStockThreshold: 2,
      ),
      PantryItem(
        name: 'pollo',
        category: 'Proteine',
        quantity: 180,
        unit: 'g',
        expiryDate: today.add(const Duration(days: 1)),
        lowStockThreshold: 200,
      ),
      PantryItem(
        name: 'yogurt',
        category: 'Latticini',
        quantity: 220,
        unit: 'g',
        expiryDate: today.add(const Duration(days: 4)),
        lowStockThreshold: 120,
      ),
      PantryItem(
        name: 'avena',
        category: 'Pasta e cereali',
        quantity: 300,
        unit: 'g',
        lowStockThreshold: 80,
      ),
      PantryItem(
        name: 'latte',
        category: 'Latticini',
        quantity: 200,
        unit: 'ml',
        expiryDate: today.add(const Duration(days: 3)),
        lowStockThreshold: 250,
      ),
      PantryItem(
        name: 'verdure',
        category: 'Verdura',
        quantity: 350,
        unit: 'g',
        expiryDate: today.add(const Duration(days: 6)),
        lowStockThreshold: 150,
      ),
      PantryItem(
        name: 'legumi',
        category: 'Legumi',
        quantity: 260,
        unit: 'g',
        expiryDate: today.add(const Duration(days: 60)),
        lowStockThreshold: 150,
      ),
      PantryItem(
        name: 'pane',
        category: 'Pasta e cereali',
        quantity: 2,
        unit: 'pz',
        expiryDate: today.add(const Duration(days: 2)),
        lowStockThreshold: 2,
      ),
      PantryItem(
        name: 'avocado',
        category: 'Frutta',
        quantity: 0,
        unit: 'pz',
        expiryDate: today.add(const Duration(days: 2)),
        lowStockThreshold: 1,
      ),
      PantryItem(
        name: 'frutta',
        category: 'Frutta',
        quantity: 80,
        unit: 'g',
        expiryDate: today.add(const Duration(days: 3)),
        lowStockThreshold: 120,
      ),
    ];
  }

  static List<MealPlanEntry> mealPlanEntries(Map<String, int> recipeIds) {
    final monday = AppDateUtils.startOfWeek(DateTime.now());

    return [
      MealPlanEntry(
        plannedDate: monday,
        mealType: 'Pranzo',
        recipeId: recipeIds['Pasta al pomodoro'],
        notes: 'Pranzo semplice per iniziare la settimana.',
      ),
      MealPlanEntry(
        plannedDate: monday.add(const Duration(days: 1)),
        mealType: 'Cena',
        recipeId: recipeIds['Insalata di pollo'],
      ),
      MealPlanEntry(
        plannedDate: monday.add(const Duration(days: 2)),
        mealType: 'Colazione',
        recipeId: recipeIds['Yogurt bowl'],
      ),
      MealPlanEntry(
        plannedDate: monday.add(const Duration(days: 3)),
        mealType: 'Pranzo',
        recipeId: recipeIds['Riso con verdure'],
      ),
      MealPlanEntry(
        plannedDate: monday.add(const Duration(days: 4)),
        mealType: 'Cena',
        recipeId: recipeIds['Zuppa di legumi'],
      ),
      MealPlanEntry(
        plannedDate: monday.add(const Duration(days: 5)),
        mealType: 'Colazione',
        recipeId: recipeIds['Toast avocado e uova'],
      ),
      MealPlanEntry(
        plannedDate: monday.add(const Duration(days: 6)),
        mealType: 'Pranzo',
        customMealName: 'Pranzo libero fuori casa',
      ),
    ];
  }

  static List<ShoppingItem> shoppingItems() {
    return const [
      ShoppingItem(
        name: 'cous cous',
        category: 'Pasta e cereali',
        quantity: 180,
        unit: 'g',
        source: 'manuale',
        notes: 'Da tenere per una cena veloce.',
      ),
      ShoppingItem(
        name: 'basilico',
        category: 'Verdura',
        quantity: 1,
        unit: 'pz',
        source: 'manuale',
      ),
      ShoppingItem(
        name: 'avocado',
        category: 'Frutta',
        quantity: 1,
        unit: 'pz',
        source: 'auto',
      ),
      ShoppingItem(
        name: 'latte',
        category: 'Latticini',
        quantity: 100,
        unit: 'ml',
        source: 'auto',
      ),
    ];
  }
}
