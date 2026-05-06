import 'package:flutter/material.dart';

import '../../widgets/app_empty_state.dart';

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppEmptyState(
      icon: Icons.menu_book_outlined,
      title: 'Ricette',
      message: 'La lista ricette completa arriva nella FASE 5.',
    );
  }
}
