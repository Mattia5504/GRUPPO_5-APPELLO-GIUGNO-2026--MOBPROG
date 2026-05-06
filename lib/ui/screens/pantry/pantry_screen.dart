import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/enums.dart';
import '../../../models/pantry_item.dart';
import '../../../state/app_state.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_search_field.dart';
import '../../widgets/category_chip_filter.dart';
import '../../widgets/confirm_delete_dialog.dart';
import '../../widgets/expiry_badge.dart';
import '../../widgets/pantry_item_card.dart';
import 'pantry_form_screen.dart';

enum _PantryQuickFilter { all, expiring, lowStock }

class PantryScreen extends StatefulWidget {
  const PantryScreen({super.key});

  @override
  State<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends State<PantryScreen> {
  String _query = '';
  String _selectedCategory = 'Tutti';
  _PantryQuickFilter _quickFilter = _PantryQuickFilter.all;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final categories =
        appState.pantryItems.map((item) => item.category).toSet().toList()
          ..sort();
    final items = appState.pantryItems.where((item) {
      final matchesQuery = item.name.toLowerCase().contains(
        _query.toLowerCase(),
      );
      final matchesCategory =
          _selectedCategory == 'Tutti' || item.category == _selectedCategory;
      final matchesQuickFilter = switch (_quickFilter) {
        _PantryQuickFilter.all => true,
        _PantryQuickFilter.expiring =>
          ExpiryBadge.statusFor(item) != ExpiryStatus.ok &&
              ExpiryBadge.statusFor(item) != ExpiryStatus.noDate,
        _PantryQuickFilter.lowStock => item.quantity <= item.lowStockThreshold,
      };
      return matchesQuery && matchesCategory && matchesQuickFilter;
    }).toList();

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
                    'Dispensa',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  AppSearchField(
                    hintText: 'Cerca prodotti',
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
                  const SizedBox(height: 12),
                  SegmentedButton<_PantryQuickFilter>(
                    segments: const [
                      ButtonSegment(
                        value: _PantryQuickFilter.all,
                        label: Text('Tutti'),
                        icon: Icon(Icons.inventory_2_outlined),
                      ),
                      ButtonSegment(
                        value: _PantryQuickFilter.expiring,
                        label: Text('Scadenze'),
                        icon: Icon(Icons.event_busy_outlined),
                      ),
                      ButtonSegment(
                        value: _PantryQuickFilter.lowStock,
                        label: Text('Low stock'),
                        icon: Icon(Icons.warning_amber_outlined),
                      ),
                    ],
                    selected: {_quickFilter},
                    onSelectionChanged: (values) {
                      setState(() => _quickFilter = values.first);
                    },
                  ),
                ],
              ),
            ),
          ),
          if (items.isEmpty)
            const SliverFillRemaining(
              child: AppEmptyState(
                icon: Icons.kitchen_outlined,
                title: 'Nessun prodotto trovato',
                message: 'Aggiungi un prodotto o modifica i filtri attivi.',
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 96),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PantryItemCard(
                      item: item,
                      onTap: () => _openForm(context, item: item),
                      onDelete: () => _deleteItem(context, item),
                    ),
                  );
                }, childCount: items.length),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Prodotto'),
      ),
    );
  }

  void _openForm(BuildContext context, {PantryItem? item}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PantryFormScreen(item: item)),
    );
  }

  Future<void> _deleteItem(BuildContext context, PantryItem item) async {
    final id = item.id;
    if (id == null) {
      return;
    }
    final confirmed = await ConfirmDeleteDialog.show(
      context,
      title: 'Eliminare prodotto?',
      message: 'Il prodotto sarà rimosso dalla dispensa.',
    );
    if (!confirmed || !context.mounted) {
      return;
    }

    await context.read<AppState>().deletePantryItem(id);
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Prodotto eliminato.')));
  }
}
