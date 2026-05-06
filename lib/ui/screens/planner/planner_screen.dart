import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_constants.dart';
import '../../../core/app_date_utils.dart';
import '../../../models/meal_plan_entry.dart';
import '../../../state/app_state.dart';
import '../../widgets/confirm_delete_dialog.dart';
import '../../widgets/meal_plan_card.dart';
import '../recipes/recipe_detail_screen.dart';
import 'meal_plan_form_screen.dart';

class PlannerScreen extends StatelessWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final monday = AppDateUtils.startOfWeek(DateTime.now());
    final weekDays = List.generate(
      7,
      (index) => monday.add(Duration(days: index)),
    );

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
                    'Planner settimanale',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${AppDateUtils.formatFull(weekDays.first)} - ${AppDateUtils.formatFull(weekDays.last)}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 96),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final day = weekDays[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _DayPlanCard(day: day, appState: appState),
                );
              }, childCount: weekDays.length),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MealPlanFormScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Pasto'),
      ),
    );
  }
}

class _DayPlanCard extends StatelessWidget {
  const _DayPlanCard({required this.day, required this.appState});

  final DateTime day;
  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _dayTitle(day),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            for (final mealType in AppConstants.mealTypes)
              _MealSlot(day: day, mealType: mealType, appState: appState),
          ],
        ),
      ),
    );
  }

  String _dayTitle(DateTime date) {
    const names = [
      'Lunedì',
      'Martedì',
      'Mercoledì',
      'Giovedì',
      'Venerdì',
      'Sabato',
      'Domenica',
    ];
    return '${names[date.weekday - 1]} ${AppDateUtils.formatDayMonth(date)}';
  }
}

class _MealSlot extends StatelessWidget {
  const _MealSlot({
    required this.day,
    required this.mealType,
    required this.appState,
  });

  final DateTime day;
  final String mealType;
  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final entries = appState.mealPlanEntries.where((entry) {
      return AppDateUtils.isSameDay(entry.plannedDate, day) &&
          entry.mealType == mealType;
    }).toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  mealType,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
                ),
              ),
              IconButton(
                tooltip: 'Aggiungi $mealType',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MealPlanFormScreen(
                        initialDate: day,
                        initialMealType: mealType,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          if (entries.isEmpty)
            Text(
              'Nessun pasto pianificato',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            )
          else
            for (final entry in entries) _EntryCard(entry: entry),
        ],
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.entry});

  final MealPlanEntry entry;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final recipe = appState.recipeById(entry.recipeId);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: MealPlanCard(
        entry: entry,
        recipe: recipe,
        onTap: recipe?.id == null
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecipeDetailScreen(recipeId: recipe!.id!),
                  ),
                );
              },
        onEdit: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MealPlanFormScreen(entry: entry)),
          );
        },
        onDelete: () => _deleteEntry(context, entry),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, MealPlanEntry entry) async {
    final id = entry.id;
    if (id == null) {
      return;
    }
    final confirmed = await ConfirmDeleteDialog.show(
      context,
      title: 'Eliminare pasto?',
      message: 'Il pasto sarà rimosso dal planner settimanale.',
    );
    if (!confirmed || !context.mounted) {
      return;
    }
    await context.read<AppState>().deleteMealPlanEntry(id);
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Pasto eliminato.')));
  }
}
