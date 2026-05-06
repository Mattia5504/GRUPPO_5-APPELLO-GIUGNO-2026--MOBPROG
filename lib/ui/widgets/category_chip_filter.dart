import 'package:flutter/material.dart';

class CategoryChipFilter extends StatelessWidget {
  const CategoryChipFilter({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
    this.allLabel = 'Tutti',
  });

  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelected;
  final String allLabel;

  @override
  Widget build(BuildContext context) {
    final values = [allLabel, ...categories];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final category in values) ...[
            ChoiceChip(
              label: Text(category),
              selected: selectedCategory == category,
              onSelected: (_) => onSelected(category),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}
