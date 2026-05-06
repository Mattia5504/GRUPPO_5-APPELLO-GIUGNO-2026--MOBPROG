import 'package:flutter/material.dart';

import '../../widgets/app_empty_state.dart';

class PantryScreen extends StatelessWidget {
  const PantryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppEmptyState(
      icon: Icons.kitchen_outlined,
      title: 'Dispensa',
      message: 'La gestione completa della dispensa arriva nella FASE 6.',
    );
  }
}
