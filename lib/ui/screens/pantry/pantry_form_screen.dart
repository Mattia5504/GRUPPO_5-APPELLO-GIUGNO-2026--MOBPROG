import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_constants.dart';
import '../../../core/app_date_utils.dart';
import '../../../core/validators.dart';
import '../../../models/pantry_item.dart';
import '../../../state/app_state.dart';

class PantryFormScreen extends StatefulWidget {
  const PantryFormScreen({super.key, this.item});

  final PantryItem? item;

  @override
  State<PantryFormScreen> createState() => _PantryFormScreenState();
}

class _PantryFormScreenState extends State<PantryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  late final TextEditingController _lowStockController;
  late final TextEditingController _expiryController;
  late final TextEditingController _notesController;

  late String _category;
  late String _unit;
  DateTime? _expiryDate;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _nameController = TextEditingController(text: item?.name ?? '');
    _quantityController = TextEditingController(
      text: item == null ? '' : _formatQuantity(item.quantity),
    );
    _lowStockController = TextEditingController(
      text: item == null ? '' : _formatQuantity(item.lowStockThreshold),
    );
    _expiryDate = item?.expiryDate;
    _expiryController = TextEditingController(
      text: _expiryDate == null ? '' : AppDateUtils.formatFull(_expiryDate!),
    );
    _notesController = TextEditingController(text: item?.notes ?? '');
    _category = item?.category ?? AppConstants.pantryCategories.first;
    _unit = item?.unit ?? AppConstants.units.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _lowStockController.dispose();
    _expiryController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Modifica prodotto' : 'Nuovo prodotto'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome prodotto'),
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
              controller: _lowStockController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(labelText: 'Soglia minima'),
              validator: (value) =>
                  Validators.positiveDouble(value, label: 'Soglia minima'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _expiryController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Data scadenza',
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_expiryDate != null)
                      IconButton(
                        tooltip: 'Rimuovi scadenza',
                        onPressed: _clearExpiryDate,
                        icon: const Icon(Icons.close),
                      ),
                    IconButton(
                      tooltip: 'Scegli data',
                      onPressed: _pickExpiryDate,
                      icon: const Icon(Icons.calendar_month_outlined),
                    ),
                  ],
                ),
              ),
              onTap: _pickExpiryDate,
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
          label: Text(_isEditing ? 'Salva modifiche' : 'Aggiungi prodotto'),
        ),
      ),
    );
  }

  Future<void> _pickExpiryDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 5),
    );
    if (picked == null) {
      return;
    }
    setState(() {
      _expiryDate = picked;
      _expiryController.text = AppDateUtils.formatFull(picked);
    });
  }

  void _clearExpiryDate() {
    setState(() {
      _expiryDate = null;
      _expiryController.clear();
    });
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final item = PantryItem(
      id: widget.item?.id,
      name: _nameController.text.trim(),
      category: _category,
      quantity: double.parse(
        _quantityController.text.trim().replaceAll(',', '.'),
      ),
      unit: _unit,
      expiryDate: _expiryDate,
      lowStockThreshold: double.parse(
        _lowStockController.text.trim().replaceAll(',', '.'),
      ),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    final appState = context.read<AppState>();
    if (_isEditing) {
      await appState.updatePantryItem(item);
    } else {
      await appState.addPantryItem(item);
    }

    if (!mounted) {
      return;
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditing ? 'Prodotto aggiornato.' : 'Prodotto aggiunto.',
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
