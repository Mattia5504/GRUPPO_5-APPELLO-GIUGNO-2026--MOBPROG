import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/app_state.dart';
import '../../widgets/app_section_header.dart';
import '../../widgets/app_stat_card.dart';
import '../../widgets/pantry_item_card.dart';
import '../../widgets/recipe_card.dart';
import '../stats/stats_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final summary = appState.getDashboardSummary();
    final expiringItems = appState.getExpiringItems().take(3).toList();
    final suggestedRecipes = appState.getSuggestedRecipes().take(3).toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Ciao, cosa pianifichiamo oggi?',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ),
                    IconButton.filledTonal(
                      tooltip: 'Statistiche',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const StatsScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.bar_chart_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth > 680 ? 5 : 2;
                    return GridView.count(
                      crossAxisCount: columns,
                      childAspectRatio: columns == 5 ? 1.05 : 1.18,
                      shrinkWrap: true,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        AppStatCard(
                          icon: Icons.menu_book_outlined,
                          label: 'Ricette',
                          value: '${summary.totalRecipes}',
                        ),
                        AppStatCard(
                          icon: Icons.calendar_month_outlined,
                          label: 'Pasti settimana',
                          value: '${summary.mealsThisWeek}',
                        ),
                        AppStatCard(
                          icon: Icons.event_busy_outlined,
                          label: 'In scadenza',
                          value: '${summary.expiringItems}',
                          color: Colors.deepOrange,
                        ),
                        AppStatCard(
                          icon: Icons.production_quantity_limits_outlined,
                          label: 'Low stock',
                          value: '${summary.lowStockItems}',
                          color: Colors.amber.shade700,
                        ),
                        AppStatCard(
                          icon: Icons.shopping_basket_outlined,
                          label: 'Da comprare',
                          value: '${summary.shoppingItemsToBuy}',
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () async {
                      await context
                          .read<AppState>()
                          .generateShoppingListFromMealPlan();
                      if (!context.mounted) {
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Lista della spesa generata dal meal plan.',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Genera lista della spesa'),
                  ),
                ),
                const SizedBox(height: 26),
                const AppSectionHeader(title: 'Da consumare presto'),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList.separated(
            itemCount: expiringItems.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return PantryItemCard(item: expiringItems[index]);
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
            child: AppSectionHeader(
              title: 'Ricette consigliate dalla tua dispensa',
              actionLabel: 'Statistiche',
              onAction: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StatsScreen()),
                );
              },
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          sliver: SliverList.separated(
            itemCount: suggestedRecipes.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final recipe = suggestedRecipes[index];
              return RecipeCard(
                recipe: recipe,
                availabilityScore: appState.getRecipeAvailabilityScore(recipe),
              );
            },
          ),
        ),
      ],
    );
  }
}
