import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_constants.dart';
import '../../../core/app_date_utils.dart';
import '../../../core/validators.dart';
import '../../../models/meal_plan_entry.dart';
import '../../../state/app_state.dart';

class MealPlanFormScreen extends StatefulWidget {
  const MealPlanFormScreen({
    super.key,
    this.entry,
    this.initialDate,
    this.initialMealType,
  });

  final MealPlanEntry? entry;
  final DateTime? initialDate;
  final String? initialMealType;

  @override
  State<MealPlanFormScreen> createState() => _MealPlanFormScreenState();
}

class _MealPlanFormScreenState extends State<MealPlanFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _dateController;
  late final TextEditingController _customMealController;
  late final TextEditingController _notesController;

  late DateTime _plannedDate;
  late String _mealType;
  int? _recipeId;
  bool _useRecipe = true;

  bool get _isEditing => widget.entry != null;

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;
    _plannedDate = entry?.plannedDate ?? widget.initialDate ?? DateTime.now();
    _mealType =
        entry?.mealType ??
        widget.initialMealType ??
        AppConstants.mealTypes.first;
    _recipeId = entry?.recipeId;
    _useRecipe = entry?.recipeId != null || entry?.customMealName == null;
    _dateController = TextEditingController(
      text: AppDateUtils.formatFull(_plannedDate),
    );
    _customMealController = TextEditingController(
      text: entry?.customMealName ?? '',
    );
    _notesController = TextEditingController(text: entry?.notes ?? '');
  }

  @override
  void dispose() {
    _dateController.dispose();
    _customMealController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipes = context.watch<AppState>().recipes;
    if (_recipeId == null && recipes.isNotEmpty && _useRecipe) {
      _recipeId = recipes.first.id;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Modifica pasto' : 'Nuovo pasto'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          children: [
            TextFormField(
              controller: _dateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Data',
                suffixIcon: Icon(Icons.calendar_month_outlined),
              ),
              onTap: _pickDate,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _mealType,
              decoration: const InputDecoration(labelText: 'Tipo pasto'),
              items: AppConstants.mealTypes
                  .map(
                    (type) => DropdownMenuItem(value: type, child: Text(type)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _mealType = value);
                }
              },
            ),
            const SizedBox(height: 16),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: true,
                  label: Text('Ricetta'),
                  icon: Icon(Icons.menu_book_outlined),
                ),
                ButtonSegment(
                  value: false,
                  label: Text('Libero'),
                  icon: Icon(Icons.restaurant),
                ),
              ],
              selected: {_useRecipe},
              onSelectionChanged: (values) {
                setState(() => _useRecipe = values.first);
              },
            ),
            const SizedBox(height: 12),
            if (_useRecipe)
              DropdownButtonFormField<int>(
                initialValue: _recipeId,
                decoration: const InputDecoration(labelText: 'Ricetta'),
                items: recipes
                    .where((recipe) => recipe.id != null)
                    .map(
                      (recipe) => DropdownMenuItem(
                        value: recipe.id,
                        child: Text(recipe.name),
                      ),
                    )
                    .toList(),
                validator: (value) =>
                    value == null ? 'Seleziona una ricetta' : null,
                onChanged: (value) => setState(() => _recipeId = value),
              )
            else
              TextFormField(
                controller: _customMealController,
                decoration: const InputDecoration(
                  labelText: 'Nome pasto libero',
                ),
                validator: (value) =>
                    Validators.requiredText(value, label: 'Nome pasto'),
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
          onPressed: _saveEntry,
          icon: const Icon(Icons.check),
          label: Text(_isEditing ? 'Salva modifiche' : 'Aggiungi pasto'),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _plannedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) {
      return;
    }
    setState(() {
      _plannedDate = picked;
      _dateController.text = AppDateUtils.formatFull(picked);
    });
  }

  Future<void> _saveEntry() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final entry = MealPlanEntry(
      id: widget.entry?.id,
      plannedDate: _plannedDate,
      mealType: _mealType,
      recipeId: _useRecipe ? _recipeId : null,
      customMealName: _useRecipe ? null : _customMealController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    final appState = context.read<AppState>();
    if (_isEditing) {
      await appState.updateMealPlanEntry(entry);
    } else {
      await appState.addMealPlanEntry(entry);
    }

    if (!mounted) {
      return;
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEditing ? 'Pasto aggiornato.' : 'Pasto aggiunto.'),
      ),
    );
  }
}
