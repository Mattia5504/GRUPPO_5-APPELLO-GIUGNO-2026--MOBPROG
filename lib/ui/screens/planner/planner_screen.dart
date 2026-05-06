import 'package:flutter/material.dart';

import '../../widgets/app_empty_state.dart';

class PlannerScreen extends StatelessWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppEmptyState(
      icon: Icons.calendar_month_outlined,
      title: 'Planner settimanale',
      message: 'La pianificazione completa dei pasti arriva nella FASE 7.',
    );
  }
}
