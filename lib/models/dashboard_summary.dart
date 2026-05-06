class DashboardSummary {
  const DashboardSummary({
    required this.totalRecipes,
    required this.mealsThisWeek,
    required this.expiringItems,
    required this.lowStockItems,
    required this.shoppingItemsToBuy,
    required this.averagePrepTime,
  });

  final int totalRecipes;
  final int mealsThisWeek;
  final int expiringItems;
  final int lowStockItems;
  final int shoppingItemsToBuy;
  final double averagePrepTime;

  DashboardSummary copyWith({
    int? totalRecipes,
    int? mealsThisWeek,
    int? expiringItems,
    int? lowStockItems,
    int? shoppingItemsToBuy,
    double? averagePrepTime,
  }) {
    return DashboardSummary(
      totalRecipes: totalRecipes ?? this.totalRecipes,
      mealsThisWeek: mealsThisWeek ?? this.mealsThisWeek,
      expiringItems: expiringItems ?? this.expiringItems,
      lowStockItems: lowStockItems ?? this.lowStockItems,
      shoppingItemsToBuy: shoppingItemsToBuy ?? this.shoppingItemsToBuy,
      averagePrepTime: averagePrepTime ?? this.averagePrepTime,
    );
  }

  @override
  String toString() {
    return 'DashboardSummary(totalRecipes: $totalRecipes, mealsThisWeek: $mealsThisWeek, expiringItems: $expiringItems, lowStockItems: $lowStockItems)';
  }
}
