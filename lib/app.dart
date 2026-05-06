import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_constants.dart';
import 'core/app_theme.dart';
import 'state/app_state.dart';
import 'ui/screens/main_shell.dart';

class PlanEatApp extends StatelessWidget {
  const PlanEatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState()..initialize(),
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainShell(),
      ),
    );
  }
}
