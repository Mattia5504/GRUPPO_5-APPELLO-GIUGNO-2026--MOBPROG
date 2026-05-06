import 'package:flutter/material.dart';

import 'core/app_constants.dart';
import 'core/app_theme.dart';
import 'ui/screens/main_shell.dart';

class PlanEatApp extends StatelessWidget {
  const PlanEatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainShell(),
    );
  }
}
