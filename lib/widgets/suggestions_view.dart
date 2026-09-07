import 'package:flutter/material.dart';
import '../models/health_models.dart';

class SuggestionsView extends StatelessWidget {
  final HealthCalculationResult result;
  final HealthGoal goal;

  const SuggestionsView({
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
        // Section: Nutrition & Diet
        _SectionHeader(
          icon: Icons.restaurant,
          title: 'Diet & Nutrition Strategy',
          subtitle: 'Specific guidelines for ${goal.title}',
          color: Colors.teal,
        ),
        const SizedBox(height: 10),
        ...result.dietSuggestions.map(
          (item) => _SuggestionCard(item: item, accentColor: Colors.teal),
        ),

        const SizedBox(height: 20),

        // Section: Foods to Prioritize vs Limit
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.checklist, color: Colors.green, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'Foods to Prioritize',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: result.foodsToPrioritize.map((food) {
                    return Chip(
                      avatar: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 18,
                      ),
                      label: Text(food, style: const TextStyle(fontSize: 12)),
                      backgroundColor: Colors.green.withValues(alpha: 0.1),
                      side: BorderSide(
                        color: Colors.green.withValues(alpha: 0.3),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Icons.block, color: Colors.redAccent, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'Foods to Limit / Avoid',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: result.foodsToLimit.map((food) {
                    return Chip(
                      avatar: const Icon(
                        Icons.cancel,
                        color: Colors.redAccent,
                        size: 18,
                      ),
                      label: Text(food, style: const TextStyle(fontSize: 12)),
                      backgroundColor: Colors.red.withValues(alpha: 0.08),
                      side: BorderSide(
                        color: Colors.red.withValues(alpha: 0.25),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Section: Physical Activity & Exercise
        _SectionHeader(
          icon: Icons.fitness_center,
          title: 'Exercise & Physical Routine',
          subtitle: 'Designed for ${result.bmiCategory.title}',
          color: Colors.indigo,
        ),
        const SizedBox(height: 10),
        ...result.workoutSuggestions.map(
          (item) => _SuggestionCard(item: item, accentColor: Colors.indigo),
        ),

        const SizedBox(height: 24),

        // Section: Lifestyle, Hydration & Recovery
        _SectionHeader(
          icon: Icons.spa,
          title: 'Hydration & Daily Habits',
          subtitle: 'Healthy lifestyle fundamentals',
          color: Colors.deepPurple,
        ),
        const SizedBox(height: 10),
        ...result.lifestyleSuggestions.map(
          (item) => _SuggestionCard(item: item, accentColor: Colors.deepPurple),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final HealthSuggestionItem item;
  final Color accentColor;

  const _SuggestionCard({
    required this.item,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: accentColor.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: accentColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      color: Colors.grey[800],
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
