import 'dart:math';
import 'package:flutter/material.dart';
import '../models/health_models.dart';

class HealthCalculator {
  /// Converts feet and inches to total height in meters
  static double feetInchesToMeters(double feet, double inches) {
    final double totalInches = (feet * 12.0) + inches;
    return totalInches * 0.0254;
  }

  /// Converts feet and inches to total height in centimeters
  static double feetInchesToCm(double feet, double inches) {
    return feetInchesToMeters(feet, inches) * 100.0;
  }

  /// Calculates BMI: weight(kg) / (height(m)^2)
  static double calculateBMI(double weightKg, double heightMeters) {
    if (heightMeters <= 0) return 0.0;
    return weightKg / (heightMeters * heightMeters);
  }

  /// Determines BMI Category
  static BMICategory getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return BMICategory.underweight;
    } else if (bmi < 25.0) {
      return BMICategory.normal;
    } else if (bmi < 30.0) {
      return BMICategory.overweight;
    } else if (bmi < 35.0) {
      return BMICategory.obesityClass1;
    } else {
      return BMICategory.obesityClass2;
    }
  }

  /// Calculates healthy weight range for given height in meters
  static (double minKg, double maxKg) calculateIdealWeightRange(
    double heightMeters,
  ) {
    final double min = 18.5 * (heightMeters * heightMeters);
    final double max = 24.9 * (heightMeters * heightMeters);
    return (min, max);
  }

  /// Calculates Basal Metabolic Rate (BMR) using Mifflin-St Jeor Equation
  /// Male: (10 * weight) + (6.25 * height_cm) - (5 * age) + 5
  /// Female: (10 * weight) + (6.25 * height_cm) - (5 * age) - 161
  static int calculateBMR({
    required double weightKg,
    required double heightCm,
    required int age,
    required Gender gender,
  }) {
    double bmr = (10.0 * weightKg) + (6.25 * heightCm) - (5.0 * age);
    if (gender == Gender.male) {
      bmr += 5;
    } else {
      bmr -= 161;
    }
    return max(500, bmr.round());
  }

  /// Calculates Total Daily Energy Expenditure (TDEE)
  static int calculateTDEE(int bmr, ActivityLevel activityLevel) {
    return (bmr * activityLevel.multiplier).round();
  }

  /// Calculates target daily calories based on chosen goal
  static int calculateTargetCalories({
    required int tdee,
    required HealthGoal goal,
    required Gender gender,
  }) {
    int target = tdee + goal.calorieAdjustment;
    // Set safe minimum threshold (1200 for women, 1400 for men)
    final int safeFloor = gender == Gender.female ? 1200 : 1400;
    return max(safeFloor, target);
  }

  /// Calculates Macronutrient breakdown (Proteins, Carbs, Fats)
  static Macronutrients calculateMacros({
    required int targetCalories,
    required HealthGoal goal,
  }) {
    int proteinPct;
    int fatPct;
    int carbPct;

    switch (goal) {
      case HealthGoal.weightLoss:
      case HealthGoal.mildWeightLoss:
        proteinPct = 35;
        fatPct = 25;
        carbPct = 40;
        break;
      case HealthGoal.weightGain:
      case HealthGoal.mildWeightGain:
        proteinPct = 30;
        fatPct = 25;
        carbPct = 45;
        break;
      case HealthGoal.maintain:
        proteinPct = 25;
        fatPct = 30;
        carbPct = 45;
        break;
    }

    final int proteinKcal = (targetCalories * (proteinPct / 100)).round();
    final int fatKcal = (targetCalories * (fatPct / 100)).round();
    final int carbKcal = (targetCalories * (carbPct / 100)).round();

    final int proteinGrams = (proteinKcal / 4.0).round();
    final int fatGrams = (fatKcal / 9.0).round();
    final int carbGrams = (carbKcal / 4.0).round();

    return Macronutrients(
      proteinGrams: proteinGrams,
      proteinKcal: proteinKcal,
      proteinPercent: proteinPct,
      carbGrams: carbGrams,
      carbKcal: carbKcal,
      carbPercent: carbPct,
      fatGrams: fatGrams,
      fatKcal: fatKcal,
      fatPercent: fatPct,
    );
  }

  /// Computes full calculation result
  static HealthCalculationResult compute({
    required double weightKg,
    required double heightFeet,
    required double heightInches,
    required int age,
    required Gender gender,
    required ActivityLevel activityLevel,
    required HealthGoal goal,
  }) {
    final double heightMeters = feetInchesToMeters(heightFeet, heightInches);
    final double heightCm = feetInchesToCm(heightFeet, heightInches);

    final double bmi = calculateBMI(weightKg, heightMeters);
    final BMICategory bmiCategory = getBMICategory(bmi);
    final (double minIdeal, double maxIdeal) = calculateIdealWeightRange(
      heightMeters,
    );

    final int bmr = calculateBMR(
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      gender: gender,
    );

    final int tdee = calculateTDEE(bmr, activityLevel);
    final int targetCalories = calculateTargetCalories(
      tdee: tdee,
      goal: goal,
      gender: gender,
    );

    final Macronutrients macros = calculateMacros(
      targetCalories: targetCalories,
      goal: goal,
    );

    // Water computation: approx 35ml per kg of body weight
    final double dailyWaterLiters = max(1.5, weightKg * 0.035);
    final int dailyWaterGlasses = (dailyWaterLiters / 0.25).round();

    final List<HealthSuggestionItem> dietSuggestions = _getDietSuggestions(
      bmiCategory,
      goal,
    );
    final List<HealthSuggestionItem> workoutSuggestions =
        _getWorkoutSuggestions(bmiCategory, goal, activityLevel);
    final List<HealthSuggestionItem> lifestyleSuggestions =
        _getLifestyleSuggestions(dailyWaterLiters, dailyWaterGlasses);

    final (List<String> toEat, List<String> toLimit) = _getFoodLists(
      bmiCategory,
      goal,
    );

    return HealthCalculationResult(
      bmi: bmi,
      bmiCategory: bmiCategory,
      minIdealWeightKg: minIdeal,
      maxIdealWeightKg: maxIdeal,
      bmr: bmr,
      tdee: tdee,
      targetCalories: targetCalories,
      macros: macros,
      dailyWaterLiters: dailyWaterLiters,
      dailyWaterGlasses: dailyWaterGlasses,
      dietSuggestions: dietSuggestions,
      workoutSuggestions: workoutSuggestions,
      lifestyleSuggestions: lifestyleSuggestions,
      foodsToPrioritize: toEat,
      foodsToLimit: toLimit,
    );
  }

  static List<HealthSuggestionItem> _getDietSuggestions(
    BMICategory category,
    HealthGoal goal,
  ) {
    if (goal == HealthGoal.weightLoss || goal == HealthGoal.mildWeightLoss) {
      return [
        const HealthSuggestionItem(
          title: 'High-Protein Focus',
          description:
              'Include lean protein (chicken breast, fish, tofu, lentils) in every meal to stay full and preserve muscle.',
          icon: Icons.egg_alt_outlined,
        ),
        const HealthSuggestionItem(
          title: 'High-Volume Fiber Foods',
          description:
              'Load half of your plate with fibrous green vegetables and salads to add volume with minimal calories.',
          icon: Icons.eco_outlined,
        ),
        const HealthSuggestionItem(
          title: 'Mindful Calorie Deficit',
          description:
              'Avoid sugary drinks, processed snacks, and liquid calories. Track your portions consistently.',
          icon: Icons.local_dining_outlined,
        ),
      ];
    } else if (goal == HealthGoal.weightGain ||
        goal == HealthGoal.mildWeightGain) {
      return [
        const HealthSuggestionItem(
          title: 'Calorie-Dense Whole Foods',
          description:
              'Incorporate healthy calorie-dense foods like peanut butter, nuts, seeds, avocados, oats, and whole milk.',
          icon: Icons.restaurant_menu,
        ),
        const HealthSuggestionItem(
          title: 'Frequent Balanced Meals',
          description:
              'Eat 4-5 moderate meals per day with protein and complex carbs (brown rice, sweet potatoes, whole wheat).',
          icon: Icons.alarm_on_outlined,
        ),
        const HealthSuggestionItem(
          title: 'Nutritious Smoothies',
          description:
              'Make protein shakes with bananas, milk, oats, and nut butter for easy, quality surplus calories.',
          icon: Icons.blender_outlined,
        ),
      ];
    } else {
      return [
        const HealthSuggestionItem(
          title: 'Balanced Macronutrients',
          description:
              'Maintain an equal balance of complex carbs, clean protein, and heart-healthy unsaturated fats.',
          icon: Icons.balance,
        ),
        const HealthSuggestionItem(
          title: 'Consistent Meal Routine',
          description:
              'Eat at regular hours and practice mindful eating without distractions to keep metabolism steady.',
          icon: Icons.schedule,
        ),
        const HealthSuggestionItem(
          title: 'Whole Foods Priority',
          description:
              'Minimize ultra-processed foods while prioritizing whole grains, seasonal fruits, and vegetables.',
          icon: Icons.eco_outlined,
        ),
      ];
    }
  }

  static List<HealthSuggestionItem> _getWorkoutSuggestions(
    BMICategory category,
    HealthGoal goal,
    ActivityLevel activity,
  ) {
    if (category == BMICategory.obesityClass1 ||
        category == BMICategory.obesityClass2) {
      return [
        const HealthSuggestionItem(
          title: 'Low-Impact Cardio',
          description:
              'Start with 20-30 minutes of brisk walking, stationary cycling, or swimming 4-5 days a week to protect joints.',
          icon: Icons.pool_outlined,
        ),
        const HealthSuggestionItem(
          title: 'Gentle Resistance Training',
          description:
              'Perform bodyweight or resistance band exercises 2-3 times per week to boost resting metabolic rate.',
          icon: Icons.accessibility_new,
        ),
        const HealthSuggestionItem(
          title: 'Daily Step Goal',
          description:
              'Aim for 6,000 to 8,000 steps daily. Small walks after meals significantly help insulin sensitivity.',
          icon: Icons.directions_walk,
        ),
      ];
    } else if (goal == HealthGoal.weightGain ||
        goal == HealthGoal.mildWeightGain) {
      return [
        const HealthSuggestionItem(
          title: 'Progressive Strength Training',
          description:
              'Focus on compound lifts (squats, bench press, deadlifts, rows) 3-4 days a week to stimulate muscle growth.',
          icon: Icons.fitness_center,
        ),
        const HealthSuggestionItem(
          title: 'Moderate Cardio',
          description:
              'Limit intense cardio to 1-2 light sessions/week to maintain cardiovascular health without burning too many calories.',
          icon: Icons.favorite_border,
        ),
        const HealthSuggestionItem(
          title: 'Adequate Rest Days',
          description:
              'Give each muscle group 48 hours to recover and rebuild before training it again.',
          icon: Icons.bedtime_outlined,
        ),
      ];
    } else {
      return [
        const HealthSuggestionItem(
          title: 'Combination Training',
          description:
              'Combine 3 days of resistance/strength training with 2 days of moderate cardio (jogging, cycling, HIIT).',
          icon: Icons.fitness_center,
        ),
        const HealthSuggestionItem(
          title: 'Active Daily Living',
          description:
              'Target 8,000 to 10,000 steps daily. Take stairs and short stretch breaks during work.',
          icon: Icons.directions_walk,
        ),
        const HealthSuggestionItem(
          title: 'Mobility & Flexibility',
          description:
              'Spend 10 minutes stretching or doing yoga after workouts to prevent injury and improve posture.',
          icon: Icons.self_improvement,
        ),
      ];
    }
  }

  static List<HealthSuggestionItem> _getLifestyleSuggestions(
    double waterLiters,
    int waterGlasses,
  ) {
    return [
      HealthSuggestionItem(
        title: 'Daily Hydration Target',
        description:
            'Drink at least ${waterLiters.toStringAsFixed(1)} Liters (~$waterGlasses glasses) of water throughout the day.',
        icon: Icons.water_drop_outlined,
      ),
      const HealthSuggestionItem(
        title: '7-8 Hours Restorative Sleep',
        description:
            'Deep sleep is essential for hormone balance, appetite regulation (ghrelin/leptin), and muscle recovery.',
        icon: Icons.nights_stay_outlined,
      ),
      const HealthSuggestionItem(
        title: 'Stress Management',
        description:
            'High cortisol levels from chronic stress promote abdominal fat storage. Practice deep breathing & relaxation.',
        icon: Icons.spa_outlined,
      ),
    ];
  }

  static (List<String> toEat, List<String> toLimit) _getFoodLists(
    BMICategory category,
    HealthGoal goal,
  ) {
    if (goal == HealthGoal.weightLoss ||
        goal == HealthGoal.mildWeightLoss ||
        category == BMICategory.overweight ||
        category == BMICategory.obesityClass1 ||
        category == BMICategory.obesityClass2) {
      return (
        [
          'Chicken breast, fish & eggs',
          'Tofu, lentils & chickpeas',
          'Spinach, broccoli & leafy greens',
          'Berries, apples & oranges',
          'Oats, quinoa & brown rice',
          'Greek yogurt & cottage cheese',
        ],
        [
          'Sugary soda & sweetened drinks',
          'Deep-fried foods & fast food',
          'White bread & refined pastries',
          'Processed meats & sausages',
          'Candy, cookies & excess sweets',
          'High-calorie creamy salad dressings',
        ],
      );
    } else if (goal == HealthGoal.weightGain ||
        goal == HealthGoal.mildWeightGain ||
        category == BMICategory.underweight) {
      return (
        [
          'Peanut butter & almonds/walnuts',
          'Whole eggs, salmon & red meat',
          'Bananas, dried fruits & dates',
          'Whole milk, cheese & paneer',
          'Oatmeal with honey & chia seeds',
          'Sweet potatoes & brown rice',
        ],
        [
          'Zero-calorie junk foods',
          'Excess coffee (appetite suppressor)',
          'Skipping breakfast or meals',
          'Unhealthy trans fats & palm oil',
          'Overly sugary beverages (empty calories)',
          'Extremely large single meals (causes bloating)',
        ],
      );
    } else {
      return (
        [
          'Lean meats, fish, tofu & legumes',
          'Colorful fruits & vegetables',
          'Whole grain oats, brown rice & quinoa',
          'Nuts, seeds & extra virgin olive oil',
          'Low-fat dairy or fortified plant milk',
          'Water, herbal teas & green tea',
        ],
        [
          'Trans fats & deep-fried foods',
          'Excess refined sugars & sodas',
          'Processed snacks & chips',
          'High sodium / ultra-processed meals',
          'Excessive alcohol intake',
          'Late-night heavy snacking',
        ],
      );
    }
  }
}
