import 'package:flutter_test/flutter_test.dart';
import 'package:planteat/app.dart';

void main() {
  testWidgets('PlanEat app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PlanEatApp());

    expect(find.text('PlanEat'), findsOneWidget);
    expect(find.text('Meal Planner & Smart Pantry'), findsOneWidget);
  });
}
