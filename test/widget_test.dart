import 'package:flutter_test/flutter_test.dart';
import 'package:bmi_with_calorie/main.dart';

void main() {
  testWidgets('BMI and Calorie app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BMICalorieApp());

    expect(find.text('BMI & Calorie Coach'), findsOneWidget);
    expect(find.text('Calculate All'), findsOneWidget);
    expect(find.text('Standard BMI Reference Ranges'), findsOneWidget);
  });
}
