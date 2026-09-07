import 'package:flutter_test/flutter_test.dart';
import 'package:bmi_with_calorie/models/health_models.dart';
import 'package:bmi_with_calorie/utils/health_calculator.dart';

void main() {
  group('HealthCalculator Tests', () {
    test('Converts height correctly', () {
      // 5 feet 10 inches = 70 inches = 1.778 meters = 177.8 cm
      final meters = HealthCalculator.feetInchesToMeters(5, 10);
      final cm = HealthCalculator.feetInchesToCm(5, 10);

      expect(meters, closeTo(1.778, 0.001));
      expect(cm, closeTo(177.8, 0.1));
    });

    test('Calculates BMI and Category correctly', () {
      // 70 kg, 1.778 m -> BMI ~ 22.14 (Normal)
      final bmi = HealthCalculator.calculateBMI(70, 1.778);
      expect(bmi, closeTo(22.14, 0.1));
      expect(
        HealthCalculator.getBMICategory(bmi),
        equals(BMICategory.normal),
      );
    });

    test('Calculates Mifflin-St Jeor BMR correctly for Male and Female', () {
      // Male: 70kg, 175cm, 25yr -> 10*70 + 6.25*175 - 5*25 + 5 = 700 + 1093.75 - 125 + 5 = 1673.75 -> 1674
      final bmrMale = HealthCalculator.calculateBMR(
        weightKg: 70,
        heightCm: 175,
        age: 25,
        gender: Gender.male,
      );
      expect(bmrMale, equals(1674));

      // Female: 60kg, 165cm, 25yr -> 10*60 + 6.25*165 - 5*25 - 161 = 600 + 1031.25 - 125 - 161 = 1345.25 -> 1345
      final bmrFemale = HealthCalculator.calculateBMR(
        weightKg: 60,
        heightCm: 165,
        age: 25,
        gender: Gender.female,
      );
      expect(bmrFemale, equals(1345));
    });

    test('Calculates TDEE and Goal calories', () {
      final tdee = HealthCalculator.calculateTDEE(
        1674,
        ActivityLevel.moderatelyActive,
      );
      // 1674 * 1.55 = 2594.7 -> 2595
      expect(tdee, equals(2595));

      final targetLoss = HealthCalculator.calculateTargetCalories(
        tdee: tdee,
        goal: HealthGoal.weightLoss,
        gender: Gender.male,
      );
      expect(targetLoss, equals(2095));
    });

    test('Computes full HealthCalculationResult with suggestions', () {
      final result = HealthCalculator.compute(
        weightKg: 70,
        heightFeet: 5,
        heightInches: 10,
        age: 25,
        gender: Gender.male,
        activityLevel: ActivityLevel.moderatelyActive,
        goal: HealthGoal.weightLoss,
      );

      expect(result.bmi, greaterThan(20));
      expect(result.targetCalories, greaterThan(1500));
      expect(result.dietSuggestions.isNotEmpty, isTrue);
      expect(result.workoutSuggestions.isNotEmpty, isTrue);
      expect(result.foodsToPrioritize.isNotEmpty, isTrue);
      expect(result.foodsToLimit.isNotEmpty, isTrue);
      expect(result.dailyWaterLiters, greaterThan(2.0));
    });
  });
}
