import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_constants.dart';
import '../../../core/validators.dart';
import '../../../models/shopping_item.dart';
import '../../../state/app_state.dart';

class ShoppingFormScreen extends StatefulWidget {
  const ShoppingFormScreen({super.key, this.item});

  final ShoppingItem? item;

  @override
  State<ShoppingFormScreen> createState() => _ShoppingFormScreenState();
}

class _ShoppingFormScreenState extends State<ShoppingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  late final TextEditingController _notesController;
  late String _category;
  late String _unit;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _nameController = TextEditingController(text: item?.name ?? '');
    _quantityController = TextEditingController(
      text: item == null ? '' : _formatQuantity(item.quantity),
    );
    _notesController = TextEditingController(text: item?.notes ?? '');
    _category = item?.category ?? AppConstants.pantryCategories.first;
    _unit = item?.unit ?? AppConstants.units.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Modifica elemento' : 'Nuovo elemento'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome elemento'),
              validator: (value) =>
                  Validators.requiredText(value, label: 'Nome'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Categoria'),
              items: AppConstants.pantryCategories
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _category = value);
                }
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _quantityController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(labelText: 'Quantità'),
                    validator: (value) =>
                        Validators.positiveDouble(value, label: 'Quantità'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _unit,
                    decoration: const InputDecoration(labelText: 'Unità'),
                    items: AppConstants.units
                        .map(
                          (unit) =>
                              DropdownMenuItem(value: unit, child: Text(unit)),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _unit = value);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Note'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: FilledButton.icon(
          onPressed: _saveItem,
          icon: const Icon(Icons.check),
          label: Text(_isEditing ? 'Salva modifiche' : 'Aggiungi elemento'),
        ),
      ),
    );
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final existing = widget.item;
    final item = ShoppingItem(
      id: existing?.id,
      name: _nameController.text.trim(),
      category: _category,
      quantity: double.parse(
        _quantityController.text.trim().replaceAll(',', '.'),
      ),
      unit: _unit,
      isPurchased: existing?.isPurchased ?? false,
      source: existing?.source ?? 'manuale',
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    final appState = context.read<AppState>();
    if (_isEditing) {
      await appState.updateShoppingItem(item);
    } else {
      await appState.addShoppingItem(item);
    }

    if (!mounted) {
      return;
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditing ? 'Elemento aggiornato.' : 'Elemento aggiunto.',
        ),
      ),
    );
  }

  String _formatQuantity(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }
}
