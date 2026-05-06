import 'package:flutter/material.dart';

import '../../widgets/app_empty_state.dart';

class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppEmptyState(
      icon: Icons.shopping_basket_outlined,
      title: 'Lista della spesa',
      message: 'La lista spesa completa arriva nella FASE 8.',
    );
  }
}
