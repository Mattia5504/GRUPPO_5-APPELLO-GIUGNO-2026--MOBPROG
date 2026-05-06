import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/app_state.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_section_header.dart';
import '../../widgets/app_stat_card.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final summary = appState.getDashboardSummary();
    final recipeDistribution = appState.getRecipeCategoryDistribution();
    final pantryDistribution = appState.getPantryCategoryDistribution();
    final missingIngredients = appState.getMissingIngredientsForPlannedMeals();

    return Scaffold(
      appBar: AppBar(title: const Text('Statistiche')),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
            sliver: SliverToBoxAdapter(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth > 720 ? 3 : 2;
                  return GridView.count(
                    crossAxisCount: columns,
                    childAspectRatio: columns == 3 ? 1.45 : 1.2,
                    shrinkWrap: true,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      AppStatCard(
                        icon: Icons.menu_book_outlined,
                        label: 'Ricette totali',
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
                        icon: Icons.warning_amber_outlined,
                        label: 'In esaurimento',
                        value: '${summary.lowStockItems}',
                        color: Colors.amber.shade700,
                      ),
                      AppStatCard(
                        icon: Icons.shopping_basket_outlined,
                        label: 'Da acquistare',
                        value: '${summary.shoppingItemsToBuy}',
                      ),
                      AppStatCard(
                        icon: Icons.timer_outlined,
                        label: 'Tempo medio',
                        value:
                            '${summary.averagePrepTime.toStringAsFixed(0)} min',
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const AppSectionHeader(title: 'Distribuzione ricette'),
                const SizedBox(height: 12),
                _PieChartCard(distribution: recipeDistribution),
                const SizedBox(height: 24),
                const AppSectionHeader(title: 'Distribuzione dispensa'),
                const SizedBox(height: 12),
                _PieChartCard(distribution: pantryDistribution),
                const SizedBox(height: 24),
                const AppSectionHeader(title: 'Ingredienti mancanti'),
                const SizedBox(height: 12),
                if (missingIngredients.isEmpty)
                  const AppEmptyState(
                    icon: Icons.check_circle_outline,
                    title: 'Nessun ingrediente mancante',
                    message:
                        'La dispensa copre gli ingredienti richiesti dal meal plan.',
                  )
                else
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          for (final ingredient in missingIngredients)
                            ListTile(
                              leading: const Icon(Icons.add_shopping_cart),
                              title: Text(
                                ingredient,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 28),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _PieChartCard extends StatelessWidget {
  const _PieChartCard({required this.distribution});

  final Map<String, int> distribution;

  static const List<Color> _colors = [
    Color(0xFF264D3C),
    Color(0xFF8DAA91),
    Color(0xFFF2B84B),
    Color(0xFFD96C4A),
    Color(0xFF6D8A96),
    Color(0xFFB57955),
    Color(0xFF6F8F72),
  ];

  @override
  Widget build(BuildContext context) {
    if (distribution.isEmpty) {
      return const AppEmptyState(
        icon: Icons.pie_chart_outline,
        title: 'Nessun dato',
        message: 'Aggiungi dati per visualizzare il grafico.',
      );
    }

    final entries = distribution.entries.toList();
    final total = entries.fold<int>(0, (sum, entry) => sum + entry.value);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 560;
            final chart = SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 46,
                  sections: [
                    for (var index = 0; index < entries.length; index++)
                      PieChartSectionData(
                        color: _colors[index % _colors.length],
                        value: entries[index].value.toDouble(),
                        title:
                            '${((entries[index].value / total) * 100).round()}%',
                        radius: 72,
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                  ],
                ),
              ),
            );
            final legend = _Legend(entries: entries, colors: _colors);

            if (isWide) {
              return Row(
                children: [
                  Expanded(child: chart),
                  const SizedBox(width: 18),
                  Expanded(child: legend),
                ],
              );
            }

            return Column(
              children: [chart, const SizedBox(height: 16), legend],
            );
          },
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.entries, required this.colors});

  final List<MapEntry<String, int>> entries;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < entries.length; index++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: colors[index % colors.length],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    entries[index].key,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                Text('${entries[index].value}'),
              ],
            ),
          ),
      ],
    );
  }
}
