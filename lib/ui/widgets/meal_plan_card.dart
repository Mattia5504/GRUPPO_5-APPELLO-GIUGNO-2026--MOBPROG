import 'package:flutter/material.dart';

import '../../models/meal_plan_entry.dart';
import '../../models/recipe.dart';

class MealPlanCard extends StatelessWidget {
  const MealPlanCard({
    super.key,
    required this.entry,
    this.recipe,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  final MealPlanEntry entry;
  final Recipe? recipe;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = recipe?.name ?? entry.customMealName ?? 'Pasto senza nome';
    final isRecipe = recipe != null;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.secondary.withValues(
                  alpha: 0.18,
                ),
                foregroundColor: theme.colorScheme.primary,
                child: Icon(
                  isRecipe ? Icons.menu_book_outlined : Icons.restaurant,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isRecipe ? 'Ricetta salvata' : 'Pasto personalizzato',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Modifica',
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                tooltip: 'Elimina',
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
