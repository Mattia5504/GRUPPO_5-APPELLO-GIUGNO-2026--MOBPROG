import 'package:flutter/material.dart';

import '../../core/app_constants.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.appName)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppConstants.appSubtitle,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Setup iniziale completato. Nelle prossime fasi colleghiamo dati, dashboard e navigazione completa.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.eco_outlined,
                        color: theme.colorScheme.primary,
                        size: 36,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'PlanEat sta prendendo forma: tema, struttura base e dipendenze sono pronti.',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
