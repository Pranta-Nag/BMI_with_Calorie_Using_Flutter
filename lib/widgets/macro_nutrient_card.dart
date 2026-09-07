import 'package:flutter/material.dart';
import '../models/health_models.dart';

class MacroNutrientCard extends StatelessWidget {
  final HealthCalculationResult result;
  final HealthGoal goal;

  const MacroNutrientCard({
    super.key,
    required this.result,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Daily Calorie Target Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.surface,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Daily Calorie Target',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${result.targetCalories}',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  'kcal / day',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _MetricTag(
                      label: 'BMR (Base)',
                      value: '${result.bmr} kcal',
                      tooltip: 'Calories burned at complete rest',
                    ),
                    Container(
                      height: 30,
                      width: 1,
                      color: theme.dividerColor,
                    ),
                    _MetricTag(
                      label: 'TDEE (Maintain)',
                      value: '${result.tdee} kcal',
                      tooltip: 'Calories burned with activity level',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Macronutrients Breakdown Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.pie_chart_outline,
                      color: theme.colorScheme.primary,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Recommended Macronutrients',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Tailored for your goal: ${goal.title}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 18),

                // Multi-colored bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: result.macros.carbPercent,
                        child: Container(
                          height: 12,
                          color: const Color(0xFF42A5F5), // Blue
                        ),
                      ),
                      Expanded(
                        flex: result.macros.proteinPercent,
                        child: Container(
                          height: 12,
                          color: const Color(0xFF66BB6A), // Green
                        ),
                      ),
                      Expanded(
                        flex: result.macros.fatPercent,
                        child: Container(
                          height: 12,
                          color: const Color(0xFFFFA726), // Orange
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _MacroItem(
                        title: 'Carbs',
                        grams: result.macros.carbGrams,
                        percent: result.macros.carbPercent,
                        kcal: result.macros.carbKcal,
                        color: const Color(0xFF1E88E5),
                        icon: Icons.grain,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MacroItem(
                        title: 'Protein',
                        grams: result.macros.proteinGrams,
                        percent: result.macros.proteinPercent,
                        kcal: result.macros.proteinKcal,
                        color: const Color(0xFF43A047),
                        icon: Icons.egg_outlined,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MacroItem(
                        title: 'Fats',
                        grams: result.macros.fatGrams,
                        percent: result.macros.fatPercent,
                        kcal: result.macros.fatKcal,
                        color: const Color(0xFFFB8C00),
                        icon: Icons.opacity,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Water Hydration Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.blue.withValues(alpha: 0.15),
                  child: const Icon(
                    Icons.water_drop,
                    color: Colors.blueAccent,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Water Intake',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${result.dailyWaterLiters.toStringAsFixed(1)} Liters (${result.dailyWaterGlasses} glasses)',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[800],
                        ),
                      ),
                      Text(
                        'Essential for metabolism and optimal digestion',
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
        ),
      ],
    );
  }
}

class _MetricTag extends StatelessWidget {
  final String label;
  final String value;
  final String tooltip;

  const _MetricTag({
    required this.label,
    required this.value,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _MacroItem extends StatelessWidget {
  final String title;
  final int grams;
  final int percent;
  final int kcal;
  final Color color;
  final IconData icon;

  const _MacroItem({
    required this.title,
    required this.grams,
    required this.percent,
    required this.kcal,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${grams}g',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            '$percent% • ${kcal}kcal',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
