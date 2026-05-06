import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/meal_plan_entry.dart';
import '../../../models/recipe.dart';
import '../../../models/recipe_ingredient.dart';
import '../../../state/app_state.dart';
import '../../widgets/confirm_delete_dialog.dart';
import 'recipe_form_screen.dart';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({super.key, required this.recipeId});

  final int recipeId;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final recipe = appState.recipeById(recipeId);

    if (recipe == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ricetta')),
        body: const Center(child: Text('Ricetta non trovata')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        actions: [
          IconButton(
            tooltip: 'Modifica',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RecipeFormScreen(recipe: recipe),
                ),
              );
            },
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Elimina',
            onPressed: () async {
              final confirmed = await ConfirmDeleteDialog.show(
                context,
                title: 'Eliminare ricetta?',
                message: 'La ricetta e i suoi ingredienti saranno rimossi.',
              );
              if (!confirmed || !context.mounted) {
                return;
              }
              await context.read<AppState>().deleteRecipe(recipeId);
              if (!context.mounted) {
                return;
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ricetta eliminata.')),
              );
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          _HeroInfo(recipe: recipe),
          const SizedBox(height: 18),
          Text(
            'Procedimento',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(recipe.description),
          if (recipe.notes != null && recipe.notes!.isNotEmpty) ...[
            const SizedBox(height: 18),
            Text(
              'Note',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(recipe.notes!),
          ],
          const SizedBox(height: 22),
          Text(
            'Ingredienti',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          for (final ingredient in recipe.ingredients)
            _IngredientAvailabilityTile(
              ingredient: ingredient,
              availableQuantity: _availableQuantity(appState, ingredient),
            ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () async {
              await context.read<AppState>().addMealPlanEntry(
                MealPlanEntry(
                  plannedDate: DateTime.now(),
                  mealType: 'Cena',
                  recipeId: recipeId,
                  notes: 'Aggiunta dal dettaglio ricetta.',
                ),
              );
              if (!context.mounted) {
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ricetta aggiunta alla cena di oggi.'),
                ),
              );
            },
            icon: const Icon(Icons.calendar_month_outlined),
            label: const Text('Aggiungi al meal plan'),
          ),
        ],
      ),
    );
  }

  double _availableQuantity(AppState appState, RecipeIngredient ingredient) {
    return appState.pantryItems
        .where(
          (item) =>
              item.name.trim().toLowerCase() ==
                  ingredient.name.trim().toLowerCase() &&
              item.unit.trim().toLowerCase() ==
                  ingredient.unit.trim().toLowerCase(),
        )
        .fold<double>(0, (sum, item) => sum + item.quantity);
  }
}

class _HeroInfo extends StatelessWidget {
  const _HeroInfo({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipe.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _InfoChip(
                  icon: Icons.category_outlined,
                  label: recipe.category,
                ),
                _InfoChip(
                  icon: Icons.timer_outlined,
                  label: '${recipe.prepMinutes} min',
                ),
                _InfoChip(
                  icon: Icons.people_outline,
                  label: '${recipe.servings} porzioni',
                ),
                _InfoChip(
                  icon: Icons.signal_cellular_alt_outlined,
                  label: recipe.difficulty,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IngredientAvailabilityTile extends StatelessWidget {
  const _IngredientAvailabilityTile({
    required this.ingredient,
    required this.availableQuantity,
  });

  final RecipeIngredient ingredient;
  final double availableQuantity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAvailable = availableQuantity >= ingredient.quantity;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isAvailable
              ? const Color(0xFFDCECDD)
              : const Color(0xFFFFE1D6),
          foregroundColor: isAvailable
              ? const Color(0xFF264D3C)
              : const Color(0xFF8A2F16),
          child: Icon(isAvailable ? Icons.check : Icons.close),
        ),
        title: Text(
          ingredient.name,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          'Richiesti ${_format(ingredient.quantity)} ${ingredient.unit} • Disponibili ${_format(availableQuantity)} ${ingredient.unit}',
        ),
        trailing: Text(
          isAvailable ? 'OK' : 'Manca',
          style: theme.textTheme.labelLarge?.copyWith(
            color: isAvailable ? Colors.green.shade800 : Colors.deepOrange,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  String _format(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Chip(
      avatar: Icon(icon, size: 16, color: theme.colorScheme.primary),
      label: Text(label),
    );
  }
}
