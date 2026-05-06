import 'package:flutter/material.dart';

import '../../widgets/app_empty_state.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistiche')),
      body: const AppEmptyState(
        icon: Icons.bar_chart_rounded,
        title: 'Statistiche',
        message: 'Grafici e riepiloghi avanzati arrivano nella FASE 9.',
      ),
    );
  }
}
