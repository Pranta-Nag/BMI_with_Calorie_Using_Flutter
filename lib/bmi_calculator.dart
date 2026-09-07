import 'package:flutter/material.dart';
import 'catagory_card.dart';
import 'models/health_models.dart';
import 'utils/health_calculator.dart';
import 'widgets/macro_nutrient_card.dart';
import 'widgets/suggestions_view.dart';

class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key});

  @override
  State<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator>
    with SingleTickerProviderStateMixin {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController inchController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  Gender selectedGender = Gender.male;
  ActivityLevel selectedActivity = ActivityLevel.moderatelyActive;
  HealthGoal selectedGoal = HealthGoal.maintain;

  HealthCalculationResult? result;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void calculate() {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    final double? weight = double.tryParse(weightController.text.trim());
    final double? feet = double.tryParse(heightController.text.trim());
    final double? inches = double.tryParse(inchController.text.trim());
    final int? age = int.tryParse(ageController.text.trim());

    if (weight == null || feet == null || inches == null || age == null) {
      showMessage('Please fill in all fields with valid numbers.');
      return;
    }

    if (weight <= 0 || weight > 400) {
      showMessage('Please enter a valid weight in kg (1 - 400 kg).');
      return;
    }

    if (feet <= 0 || feet > 9 || inches < 0 || inches >= 12) {
      showMessage('Please enter a valid height (Feet: 1-9, Inches: 0-11).');
      return;
    }

    if (age < 10 || age > 120) {
      showMessage('Please enter a valid age (10 - 120 years).');
      return;
    }

    final calculatedResult = HealthCalculator.compute(
      weightKg: weight,
      heightFeet: feet,
      heightInches: inches,
      age: age,
      gender: selectedGender,
      activityLevel: selectedActivity,
      goal: selectedGoal,
    );

    setState(() {
      result = calculatedResult;
    });

    // Auto switch to first results tab
    _tabController.animateTo(0);
  }

  void reset() {
    setState(() {
      weightController.clear();
      heightController.clear();
      inchController.clear();
      ageController.clear();
      selectedGender = Gender.male;
      selectedActivity = ActivityLevel.moderatelyActive;
      selectedGoal = HealthGoal.maintain;
      result = null;
    });
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    inchController.dispose();
    ageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.health_and_safety, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'BMI & Calorie Coach',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Intro Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: theme.colorScheme.primary,
                    child: const Icon(
                      Icons.monitor_weight_outlined,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal Health & Calorie Calculator',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Track BMI, daily calorie target, BMR, TDEE, macros, and get actionable health tips.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Gender Selector
            Row(
              children: [
                Expanded(
                  child: _GenderOptionCard(
                    label: 'Male',
                    icon: Icons.male,
                    isSelected: selectedGender == Gender.male,
                    color: Colors.blue,
                    onTap: () {
                      setState(() {
                        selectedGender = Gender.male;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _GenderOptionCard(
                    label: 'Female',
                    icon: Icons.female,
                    isSelected: selectedGender == Gender.female,
                    color: Colors.pink,
                    onTap: () {
                      setState(() {
                        selectedGender = Gender.female;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Age & Weight Inputs
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Age',
                      hintText: 'e.g. 25',
                      prefixIcon: const Icon(Icons.cake_outlined),
                      suffixText: 'yrs',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: weightController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Weight',
                      hintText: 'e.g. 70',
                      prefixIcon: const Icon(Icons.fitness_center),
                      suffixText: 'kg',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Height Inputs (Feet & Inches)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: heightController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Height (Feet)',
                      hintText: 'e.g. 5',
                      prefixIcon: const Icon(Icons.height),
                      suffixText: 'ft',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: inchController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Inches',
                      hintText: 'e.g. 9',
                      prefixIcon: const Icon(Icons.straighten),
                      suffixText: 'in',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Activity Level Selector
            DropdownButtonFormField<ActivityLevel>(
              initialValue: selectedActivity,
              decoration: InputDecoration(
                labelText: 'Activity Level',
                prefixIcon: Icon(selectedActivity.icon),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              isExpanded: true,
              items: ActivityLevel.values.map((activity) {
                return DropdownMenuItem(
                  value: activity,
                  child: Text(
                    '${activity.title} (${activity.subtitle.split(',').first})',
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    selectedActivity = val;
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            // Health Goal Selector
            DropdownButtonFormField<HealthGoal>(
              initialValue: selectedGoal,
              decoration: InputDecoration(
                labelText: 'Fitness / Health Goal',
                prefixIcon: Icon(selectedGoal.icon),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              isExpanded: true,
              items: HealthGoal.values.map((goal) {
                return DropdownMenuItem(
                  value: goal,
                  child: Text(
                    '${goal.title} (${goal.description.split('(').first.trim()})',
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    selectedGoal = val;
                  });
                }
              },
            ),

            const SizedBox(height: 22),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: calculate,
                    icon: const Icon(Icons.calculate),
                    label: const Text(
                      'Calculate All',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: reset,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Calculated Results Section
            if (result != null) ...[
              // Main BMI & Summary Hero Card
              _SummaryHeroCard(result: result!),

              const SizedBox(height: 20),

              // TabBar for detailed breakdown
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.local_fire_department_outlined, size: 20),
                      text: 'Calories & Macros',
                    ),
                    Tab(
                      icon: Icon(Icons.lightbulb_outline, size: 20),
                      text: 'Suggestions',
                    ),
                    Tab(
                      icon: Icon(Icons.bar_chart_outlined, size: 20),
                      text: 'BMI Guide',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Tab Content
              AnimatedBuilder(
                animation: _tabController,
                builder: (context, child) {
                  switch (_tabController.index) {
                    case 0:
                      return MacroNutrientCard(
                        result: result!,
                        goal: selectedGoal,
                      );
                    case 1:
                      return SuggestionsView(
                        result: result!,
                        goal: selectedGoal,
                      );
                    case 2:
                    default:
                      return _BmiCategoryGuideView(
                        currentCategory: result!.bmiCategory,
                      );
                  }
                },
              ),
            ] else ...[
              // Static BMI Guide when no result is yet computed
              const SizedBox(height: 10),
              _BmiCategoryGuideView(currentCategory: null),
            ],
          ],
        ),
      ),
    );
  }
}

class _GenderOptionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _GenderOptionCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey[700],
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? color : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryHeroCard extends StatelessWidget {
  final HealthCalculationResult result;

  const _SummaryHeroCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final category = result.bmiCategory;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: category.color.withValues(alpha: 0.4),
          width: 2,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              category.color.withValues(alpha: 0.08),
              theme.colorScheme.surface,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Health Summary',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: category.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, color: category.color, size: 10),
                      const SizedBox(width: 6),
                      Text(
                        category.title,
                        style: TextStyle(
                          color: category.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text(
                      'BMI Score',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      result.bmi.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        color: category.color,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 50,
                  width: 1,
                  color: Colors.grey.withValues(alpha: 0.3),
                ),
                Column(
                  children: [
                    const Text(
                      'Daily Calorie Goal',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${result.targetCalories}',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const Text(
                      'kcal / day',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              category.indication,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.health_and_safety, color: Colors.green, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Ideal Weight Range: ${result.minIdealWeightKg.toStringAsFixed(1)} - ${result.maxIdealWeightKg.toStringAsFixed(1)} kg',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BmiCategoryGuideView extends StatelessWidget {
  final BMICategory? currentCategory;

  const _BmiCategoryGuideView({this.currentCategory});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.menu_book, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            const Text(
              'Standard BMI Reference Ranges',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        categoryCard(
          BMICategory.underweight.title,
          BMICategory.underweight.range,
          BMICategory.underweight.color,
          isSelected: currentCategory == BMICategory.underweight,
        ),
        categoryCard(
          BMICategory.normal.title,
          BMICategory.normal.range,
          BMICategory.normal.color,
          isSelected: currentCategory == BMICategory.normal,
        ),
        categoryCard(
          BMICategory.overweight.title,
          BMICategory.overweight.range,
          BMICategory.overweight.color,
          isSelected: currentCategory == BMICategory.overweight,
        ),
        categoryCard(
          BMICategory.obesityClass1.title,
          BMICategory.obesityClass1.range,
          BMICategory.obesityClass1.color,
          isSelected: currentCategory == BMICategory.obesityClass1,
        ),
        categoryCard(
          BMICategory.obesityClass2.title,
          BMICategory.obesityClass2.range,
          BMICategory.obesityClass2.color,
          isSelected: currentCategory == BMICategory.obesityClass2,
        ),
      ],
    );
  }
}