import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_constants.dart';
import '../../../core/validators.dart';
import '../../../models/recipe.dart';
import '../../../models/recipe_ingredient.dart';
import '../../../state/app_state.dart';

class RecipeFormScreen extends StatefulWidget {
  const RecipeFormScreen({super.key, this.recipe});

  final Recipe? recipe;

  @override
  State<RecipeFormScreen> createState() => _RecipeFormScreenState();
}

class _RecipeFormScreenState extends State<RecipeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _prepMinutesController;
  late final TextEditingController _servingsController;
  late final TextEditingController _notesController;
  final List<_IngredientControllers> _ingredientControllers = [];

  late String _category;
  late String _difficulty;

  bool get _isEditing => widget.recipe != null;

  @override
  void initState() {
    super.initState();
    final recipe = widget.recipe;
    _nameController = TextEditingController(text: recipe?.name ?? '');
    _descriptionController = TextEditingController(
      text: recipe?.description ?? '',
    );
    _prepMinutesController = TextEditingController(
      text: recipe?.prepMinutes.toString() ?? '',
    );
    _servingsController = TextEditingController(
      text: recipe?.servings.toString() ?? '',
    );
    _notesController = TextEditingController(text: recipe?.notes ?? '');
    _category = recipe?.category ?? AppConstants.recipeCategories.first;
    _difficulty = recipe?.difficulty ?? 'Facile';

    final ingredients = recipe?.ingredients ?? const <RecipeIngredient>[];
    if (ingredients.isEmpty) {
      _ingredientControllers.add(_IngredientControllers.empty());
    } else {
      _ingredientControllers.addAll(
        ingredients.map(_IngredientControllers.fromIngredient),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _prepMinutesController.dispose();
    _servingsController.dispose();
    _notesController.dispose();
    for (final controllers in _ingredientControllers) {
      controllers.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Modifica ricetta' : 'Nuova ricetta'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome ricetta'),
              validator: (value) =>
                  Validators.requiredText(value, label: 'Nome'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Descrizione/procedimento',
              ),
              validator: (value) =>
                  Validators.requiredText(value, label: 'Descrizione'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Categoria'),
              items: AppConstants.recipeCategories
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
            DropdownButtonFormField<String>(
              initialValue: _difficulty,
              decoration: const InputDecoration(labelText: 'Difficoltà'),
              items: const ['Facile', 'Media', 'Difficile']
                  .map(
                    (difficulty) => DropdownMenuItem(
                      value: difficulty,
                      child: Text(difficulty),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _difficulty = value);
                }
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _prepMinutesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Minuti'),
                    validator: (value) =>
                        Validators.positiveInt(value, label: 'Tempo'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _servingsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Porzioni'),
                    validator: (value) =>
                        Validators.positiveInt(value, label: 'Porzioni'),
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
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Ingredienti',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: 'Aggiungi ingrediente',
                  onPressed: _addIngredient,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 10),
            for (var index = 0; index < _ingredientControllers.length; index++)
              _IngredientFormCard(
                key: ValueKey(_ingredientControllers[index]),
                controllers: _ingredientControllers[index],
                canRemove: _ingredientControllers.length > 1,
                onRemove: () => _removeIngredient(index),
              ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: FilledButton.icon(
          onPressed: _saveRecipe,
          icon: const Icon(Icons.check),
          label: Text(_isEditing ? 'Salva modifiche' : 'Crea ricetta'),
        ),
      ),
    );
  }

  void _addIngredient() {
    setState(() => _ingredientControllers.add(_IngredientControllers.empty()));
  }

  void _removeIngredient(int index) {
    final removed = _ingredientControllers.removeAt(index);
    removed.dispose();
    setState(() {});
  }

  Future<void> _saveRecipe() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final ingredients = _ingredientControllers.map((controllers) {
      final quantity = double.parse(
        controllers.quantity.text.trim().replaceAll(',', '.'),
      );
      return RecipeIngredient(
        name: controllers.name.text.trim(),
        quantity: quantity,
        unit: controllers.unit,
      );
    }).toList();

    final recipe = Recipe(
      id: widget.recipe?.id,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _category,
      prepMinutes: int.parse(_prepMinutesController.text.trim()),
      difficulty: _difficulty,
      servings: int.parse(_servingsController.text.trim()),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      ingredients: ingredients,
    );

    final appState = context.read<AppState>();
    if (_isEditing) {
      await appState.updateRecipe(recipe);
    } else {
      await appState.addRecipe(recipe);
    }

    if (!mounted) {
      return;
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEditing ? 'Ricetta aggiornata.' : 'Ricetta creata.'),
      ),
    );
  }
}

class _IngredientFormCard extends StatelessWidget {
  const _IngredientFormCard({
    super.key,
    required this.controllers,
    required this.canRemove,
    required this.onRemove,
  });

  final _IngredientControllers controllers;
  final bool canRemove;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controllers.name,
                    decoration: const InputDecoration(labelText: 'Ingrediente'),
                    validator: (value) =>
                        Validators.requiredText(value, label: 'Ingrediente'),
                  ),
                ),
                if (canRemove) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Rimuovi ingrediente',
                    onPressed: onRemove,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controllers.quantity,
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
                    initialValue: controllers.unit,
                    decoration: const InputDecoration(labelText: 'Unità'),
                    items: AppConstants.units
                        .map(
                          (unit) =>
                              DropdownMenuItem(value: unit, child: Text(unit)),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controllers.unit = value;
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IngredientControllers {
  _IngredientControllers({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  factory _IngredientControllers.empty() {
    return _IngredientControllers(
      name: TextEditingController(),
      quantity: TextEditingController(),
      unit: AppConstants.units.first,
    );
  }

  factory _IngredientControllers.fromIngredient(RecipeIngredient ingredient) {
    return _IngredientControllers(
      name: TextEditingController(text: ingredient.name),
      quantity: TextEditingController(
        text: ingredient.quantity == ingredient.quantity.roundToDouble()
            ? ingredient.quantity.toInt().toString()
            : ingredient.quantity.toString(),
      ),
      unit: ingredient.unit,
    );
  }

  final TextEditingController name;
  final TextEditingController quantity;
  String unit;

  void dispose() {
    name.dispose();
    quantity.dispose();
  }
}
