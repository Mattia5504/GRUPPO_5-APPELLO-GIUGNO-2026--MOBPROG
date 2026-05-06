import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planteat/core/app_theme.dart';
import 'package:planteat/ui/widgets/app_stat_card.dart';

void main() {
  testWidgets('AppStatCard renders label and value', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: AppStatCard(
            icon: Icons.menu_book_outlined,
            label: 'Ricette',
            value: '8',
          ),
        ),
      ),
    );

    expect(find.text('Ricette'), findsOneWidget);
    expect(find.text('8'), findsOneWidget);
  });
}
