import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/shopping_item.dart';
import '../../../state/app_state.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/confirm_delete_dialog.dart';
import '../../widgets/shopping_item_tile.dart';
import 'shopping_form_screen.dart';

enum _ShoppingFilter { all, pending, purchased }

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  _ShoppingFilter _filter = _ShoppingFilter.pending;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final items = appState.shoppingItems.where((item) {
      return switch (_filter) {
        _ShoppingFilter.all => true,
        _ShoppingFilter.pending => !item.isPurchased,
        _ShoppingFilter.purchased => item.isPurchased,
      };
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
                    'Lista della spesa',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _generateShoppingList,
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('Genera da meal plan'),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SegmentedButton<_ShoppingFilter>(
                    segments: const [
                      ButtonSegment(
                        value: _ShoppingFilter.all,
                        label: Text('Tutti'),
                        icon: Icon(Icons.list_alt),
                      ),
                      ButtonSegment(
                        value: _ShoppingFilter.pending,
                        label: Text('Da acquistare'),
                        icon: Icon(Icons.shopping_basket_outlined),
                      ),
                      ButtonSegment(
                        value: _ShoppingFilter.purchased,
                        label: Text('Acquistati'),
                        icon: Icon(Icons.check_circle_outline),
                      ),
                    ],
                    selected: {_filter},
                    onSelectionChanged: (values) {
                      setState(() => _filter = values.first);
                    },
                  ),
                ],
              ),
            ),
          ),
          if (items.isEmpty)
            const SliverFillRemaining(
              child: AppEmptyState(
                icon: Icons.shopping_basket_outlined,
                title: 'Lista vuota',
                message: 'Aggiungi elementi manuali o genera dal meal plan.',
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
                    child: ShoppingItemTile(
                      item: item,
                      onToggle: () => _toggleItem(context, item),
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
        label: const Text('Elemento'),
      ),
    );
  }

  Future<void> _generateShoppingList() async {
    await context.read<AppState>().generateShoppingListFromMealPlan();
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lista generata dal meal plan.')),
    );
  }

  void _openForm(BuildContext context, {ShoppingItem? item}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ShoppingFormScreen(item: item)),
    );
  }

  Future<void> _toggleItem(BuildContext context, ShoppingItem item) async {
    final id = item.id;
    if (id == null) {
      return;
    }
    await context.read<AppState>().toggleShoppingItemPurchased(id);
  }

  Future<void> _deleteItem(BuildContext context, ShoppingItem item) async {
    final id = item.id;
    if (id == null) {
      return;
    }
    final confirmed = await ConfirmDeleteDialog.show(
      context,
      title: 'Eliminare elemento?',
      message: 'L elemento sarà rimosso dalla lista della spesa.',
    );
    if (!confirmed || !context.mounted) {
      return;
    }

    await context.read<AppState>().deleteShoppingItem(id);
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Elemento eliminato.')));
  }
}
