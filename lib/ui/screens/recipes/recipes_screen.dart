import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/app_state.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_search_field.dart';
import '../../widgets/category_chip_filter.dart';
import '../../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';
import 'recipe_form_screen.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  String _query = '';
  String _selectedCategory = 'Tutti';
  bool _sortByPrepTime = false;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final categories =
        appState.recipes.map((recipe) => recipe.category).toSet().toList()
          ..sort();
    final recipes = appState.recipes.where((recipe) {
      final matchesQuery = recipe.name.toLowerCase().contains(
        _query.toLowerCase(),
      );
      final matchesCategory =
          _selectedCategory == 'Tutti' || recipe.category == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();

    if (_sortByPrepTime) {
      recipes.sort((a, b) => a.prepMinutes.compareTo(b.prepMinutes));
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ricette',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  AppSearchField(
                    hintText: 'Cerca ricette',
                    onChanged: (value) => setState(() => _query = value),
                  ),
                  const SizedBox(height: 12),
                  CategoryChipFilter(
                    categories: categories,
                    selectedCategory: _selectedCategory,
                    onSelected: (value) {
                      setState(() => _selectedCategory = value);
                    },
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    value: _sortByPrepTime,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Ordina per tempo preparazione'),
                    onChanged: (value) {
                      setState(() => _sortByPrepTime = value);
                    },
                  ),
                ],
              ),
            ),
          ),
          if (recipes.isEmpty)
            const SliverFillRemaining(
              child: AppEmptyState(
                icon: Icons.menu_book_outlined,
                title: 'Nessuna ricetta trovata',
                message: 'Aggiungi una ricetta o modifica i filtri di ricerca.',
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 96),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final recipe = recipes[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: RecipeCard(
                      recipe: recipe,
                      availabilityScore: appState.getRecipeAvailabilityScore(
                        recipe,
                      ),
                      onTap: () {
                        final id = recipe.id;
                        if (id == null) {
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecipeDetailScreen(recipeId: id),
                          ),
                        );
                      },
                    ),
                  );
                }, childCount: recipes.length),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RecipeFormScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Ricetta'),
      ),
    );
  }
}
