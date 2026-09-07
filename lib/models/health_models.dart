import 'package:flutter/material.dart';

enum Gender { male, female }

enum ActivityLevel {
  sedentary(
    title: 'Sedentary',
    subtitle: 'Little or no exercise, desk job',
    multiplier: 1.2,
    icon: Icons.chair_outlined,
  ),
  lightlyActive(
    title: 'Lightly Active',
    subtitle: 'Light exercise / sports 1-3 days/week',
    multiplier: 1.375,
    icon: Icons.directions_walk_outlined,
  ),
  moderatelyActive(
    title: 'Moderately Active',
    subtitle: 'Moderate exercise / sports 3-5 days/week',
    multiplier: 1.55,
    icon: Icons.fitness_center_outlined,
  ),
  veryActive(
    title: 'Very Active',
    subtitle: 'Hard exercise / sports 6-7 days/week',
    multiplier: 1.725,
    icon: Icons.directions_run_outlined,
  ),
  extraActive(
    title: 'Extra Active',
    subtitle: 'Very hard exercise, physical job or training 2x/day',
    multiplier: 1.9,
    icon: Icons.sports_mma_outlined,
  );

  final String title;
  final String subtitle;
  final double multiplier;
  final IconData icon;

  const ActivityLevel({
    required this.title,
    required this.subtitle,
    required this.multiplier,
    required this.icon,
  });
}

enum HealthGoal {
  weightLoss(
    title: 'Lose Weight',
    calorieAdjustment: -500,
    description: 'Target ~0.5 kg loss per week (safe deficit)',
    icon: Icons.trending_down,
  ),
  mildWeightLoss(
    title: 'Mild Weight Loss',
    calorieAdjustment: -250,
    description: 'Target ~0.25 kg loss per week (gradual)',
    icon: Icons.trending_down_outlined,
  ),
  maintain(
    title: 'Maintain Weight',
    calorieAdjustment: 0,
    description: 'Keep current weight steady',
    icon: Icons.horizontal_rule,
  ),
  mildWeightGain(
    title: 'Mild Weight Gain',
    calorieAdjustment: 250,
    description: 'Target ~0.25 kg gain per week (lean gain)',
    icon: Icons.trending_up_outlined,
  ),
  weightGain(
    title: 'Gain Weight / Muscle',
    calorieAdjustment: 500,
    description: 'Target ~0.5 kg gain per week with surplus',
    icon: Icons.trending_up,
  );

  final String title;
  final int calorieAdjustment;
  final String description;
  final IconData icon;

  const HealthGoal({
    required this.title,
    required this.calorieAdjustment,
    required this.description,
    required this.icon,
  });
}

enum BMICategory {
  underweight(
    title: 'Underweight',
    range: '< 18.5',
    indication: 'You may need to gain some weight in a healthy way.',
    color: Colors.amber,
  ),
  normal(
    title: 'Normal Weight',
    range: '18.5 – 24.9',
    indication: 'Great job! Your BMI is within the healthy range.',
    color: Colors.green,
  ),
  overweight(
    title: 'Overweight',
    range: '25.0 – 29.9',
    indication: 'Consider adopting a balanced diet and regular activity.',
    color: Colors.orange,
  ),
  obesityClass1(
    title: 'Obesity Class I',
    range: '30.0 – 34.9',
    indication: 'Aim for steady, healthy lifestyle changes to reduce health risks.',
    color: Colors.deepOrange,
  ),
  obesityClass2(
    title: 'Obesity Class II+',
    range: '≥ 35.0',
    indication: 'Focus on medical guidance, nutrition planning, and structured exercise.',
    color: Colors.red,
  );

  final String title;
  final String range;
  final String indication;
  final Color color;

  const BMICategory({
    required this.title,
    required this.range,
    required this.indication,
    required this.color,
  });
}

class Macronutrients {
  final int proteinGrams;
  final int proteinKcal;
  final int proteinPercent;

  final int carbGrams;
  final int carbKcal;
  final int carbPercent;

  final int fatGrams;
  final int fatKcal;
  final int fatPercent;

  const Macronutrients({
    required this.proteinGrams,
    required this.proteinKcal,
    required this.proteinPercent,
    required this.carbGrams,
    required this.carbKcal,
    required this.carbPercent,
    required this.fatGrams,
    required this.fatKcal,
    required this.fatPercent,
  });
}

class HealthSuggestionItem {
  final String title;
  final String description;
  final IconData icon;

  const HealthSuggestionItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class HealthCalculationResult {
  final double bmi;
  final BMICategory bmiCategory;
  final double minIdealWeightKg;
  final double maxIdealWeightKg;

  final int bmr; // Basal Metabolic Rate
  final int tdee; // Total Daily Energy Expenditure
  final int targetCalories; // Calories for selected goal

  final Macronutrients macros;
  final double dailyWaterLiters;
  final int dailyWaterGlasses;

  final List<HealthSuggestionItem> dietSuggestions;
  final List<HealthSuggestionItem> workoutSuggestions;
  final List<HealthSuggestionItem> lifestyleSuggestions;
  final List<String> foodsToPrioritize;
  final List<String> foodsToLimit;

  const HealthCalculationResult({
    required this.bmi,
    required this.bmiCategory,
    required this.minIdealWeightKg,
    required this.maxIdealWeightKg,
    required this.bmr,
    required this.tdee,
    required this.targetCalories,
    required this.macros,
    required this.dailyWaterLiters,
    required this.dailyWaterGlasses,
    required this.dietSuggestions,
    required this.workoutSuggestions,
    required this.lifestyleSuggestions,
    required this.foodsToPrioritize,
    required this.foodsToLimit,
  });
}
