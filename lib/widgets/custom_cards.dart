import 'package:flutter/material.dart';
import '../models/food_model.dart';
import '../utils/calorie_calculator.dart';
import '../services/health_analyzer.dart';

// ──────────────────────────────────────────────
// Product Info Card
// ──────────────────────────────────────────────

/// Displays product name, brand, and barcode in a styled card.
class ProductInfoCard extends StatelessWidget {
  final FoodProduct product;

  const ProductInfoCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.info_outline,
                      color: Color(0xFF2E7D32), size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'Product Information',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            _buildInfoRow('Product', product.productName, Icons.fastfood),
            const SizedBox(height: 12),
            _buildInfoRow('Brand', product.brandName, Icons.business),
            const SizedBox(height: 12),
            _buildInfoRow('Barcode', product.barcode, Icons.qr_code),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Nutrition Card
// ──────────────────────────────────────────────

/// Displays nutritional values in a grid of styled tiles.
class NutritionCard extends StatelessWidget {
  final FoodProduct product;

  const NutritionCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9800).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.analytics_outlined,
                      color: Color(0xFFFF9800), size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'Nutrition Facts',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'per 100g',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Nutrition grid
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.0,
              children: [
                _NutritionTile(
                  label: 'Calories',
                  value: product.calories.toStringAsFixed(1),
                  unit: 'kcal',
                  color: const Color(0xFFF44336),
                  icon: Icons.local_fire_department,
                ),
                _NutritionTile(
                  label: 'Fat',
                  value: product.fat.toStringAsFixed(1),
                  unit: 'g',
                  color: const Color(0xFFFF9800),
                  icon: Icons.opacity,
                ),
                _NutritionTile(
                  label: 'Carbs',
                  value: product.carbohydrates.toStringAsFixed(1),
                  unit: 'g',
                  color: const Color(0xFF2196F3),
                  icon: Icons.grain,
                ),
                _NutritionTile(
                  label: 'Protein',
                  value: product.protein.toStringAsFixed(1),
                  unit: 'g',
                  color: const Color(0xFF4CAF50),
                  icon: Icons.fitness_center,
                ),
                _NutritionTile(
                  label: 'Sugar',
                  value: product.sugar.toStringAsFixed(1),
                  unit: 'g',
                  color: const Color(0xFFE91E63),
                  icon: Icons.cake,
                ),
                _NutritionTile(
                  label: 'Salt',
                  value: product.salt.toStringAsFixed(2),
                  unit: 'g',
                  color: const Color(0xFF607D8B),
                  icon: Icons.water_drop,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A single nutrition data tile with icon, value, and label.
class _NutritionTile extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;
  final IconData icon;

  const _NutritionTile({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          FittedBox(
            child: Text(
              '$value $unit',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Calorie Burn Card
// ──────────────────────────────────────────────

/// Displays estimated exercise time to burn the product's calories.
class CalorieBurnCard extends StatelessWidget {
  final double calories;

  const CalorieBurnCard({super.key, required this.calories});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final walkTime = CalorieCalculator.walkingTime(calories);
    final runTime = CalorieCalculator.runningTime(calories);
    final cycleTime = CalorieCalculator.cyclingTime(calories);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              const Color(0xFFF44336).withValues(alpha: 0.05),
              const Color(0xFFFF9800).withValues(alpha: 0.05),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF44336).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.whatshot,
                      color: Color(0xFFF44336), size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'Burn Estimation',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Time to burn ${calories.toStringAsFixed(0)} kcal',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),

            // Exercise tiles
            _ExerciseTile(
              emoji: '🚶',
              activity: 'Walking',
              time: CalorieCalculator.formatMinutes(walkTime),
              color: const Color(0xFF4CAF50),
              calPerMin: '${CalorieCalculator.walkingCalPerMin.toInt()} kcal/min',
            ),
            const SizedBox(height: 10),
            _ExerciseTile(
              emoji: '🏃',
              activity: 'Running',
              time: CalorieCalculator.formatMinutes(runTime),
              color: const Color(0xFFF44336),
              calPerMin: '${CalorieCalculator.runningCalPerMin.toInt()} kcal/min',
            ),
            const SizedBox(height: 10),
            _ExerciseTile(
              emoji: '🚴',
              activity: 'Cycling',
              time: CalorieCalculator.formatMinutes(cycleTime),
              color: const Color(0xFF2196F3),
              calPerMin: '${CalorieCalculator.cyclingCalPerMin.toInt()} kcal/min',
            ),
          ],
        ),
      ),
    );
  }
}

/// A single exercise estimation row.
class _ExerciseTile extends StatelessWidget {
  final String emoji;
  final String activity;
  final String time;
  final Color color;
  final String calPerMin;

  const _ExerciseTile({
    required this.emoji,
    required this.activity,
    required this.time,
    required this.color,
    required this.calPerMin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: color,
                  ),
                ),
                Text(
                  calPerMin,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              time,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Health Score Card
// ──────────────────────────────────────────────

/// Displays a circular health score gauge with label (Low / Medium / High).
class HealthScoreCard extends StatelessWidget {
  final HealthAnalysis analysis;

  const HealthScoreCard({super.key, required this.analysis});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final score = analysis.healthScore;
    final level = analysis.healthLevel;

    Color scoreColor;
    IconData scoreIcon;
    switch (level) {
      case HealthLevel.high:
        scoreColor = const Color(0xFF4CAF50);
        scoreIcon = Icons.verified;
        break;
      case HealthLevel.medium:
        scoreColor = const Color(0xFFFF9800);
        scoreIcon = Icons.info;
        break;
      case HealthLevel.low:
        scoreColor = const Color(0xFFF44336);
        scoreIcon = Icons.warning_amber_rounded;
        break;
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              scoreColor.withValues(alpha: 0.08),
              scoreColor.withValues(alpha: 0.02),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: scoreColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.health_and_safety,
                      color: scoreColor, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'Health Score',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Circular score indicator
            SizedBox(
              width: 140,
              height: 140,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: CircularProgressIndicator(
                      value: score / 100,
                      strokeWidth: 12,
                      backgroundColor: scoreColor.withValues(alpha: 0.15),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(scoreColor),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$score',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: scoreColor,
                        ),
                      ),
                      Text(
                        'out of 100',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Level badge
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: scoreColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(scoreIcon, color: scoreColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${analysis.healthLevelLabel} Health Score',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: scoreColor,
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

// ──────────────────────────────────────────────
// Steps Burn Card
// ──────────────────────────────────────────────

/// Displays estimated steps and workouts to burn the calories.
class StepsBurnCard extends StatelessWidget {
  final HealthAnalysis analysis;

  const StepsBurnCard({super.key, required this.analysis});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF9C27B0).withValues(alpha: 0.05),
              const Color(0xFF2196F3).withValues(alpha: 0.05),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.directions_walk,
                      color: Color(0xFF9C27B0), size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'Steps & Workout',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'To burn ${analysis.calories.toStringAsFixed(0)} kcal (per 100g serving)',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),

            // Steps highlight
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: const Color(0xFF9C27B0).withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Text('👟', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Steps Required',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF9C27B0),
                          ),
                        ),
                        Text(
                          '~0.04 kcal per step',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFF9C27B0).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _formatSteps(analysis.stepsToburn),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF9C27B0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Workout options
            _WorkoutTile(
              emoji: '🚶',
              activity: 'Walking',
              duration: '${analysis.walkingMinutes} min',
              color: const Color(0xFF4CAF50),
            ),
            const SizedBox(height: 8),
            _WorkoutTile(
              emoji: '🏃',
              activity: 'Jogging',
              duration: '${analysis.joggingMinutes} min',
              color: const Color(0xFFF44336),
            ),
            const SizedBox(height: 8),
            _WorkoutTile(
              emoji: '🚴',
              activity: 'Cycling',
              duration: '${analysis.cyclingMinutes} min',
              color: const Color(0xFF2196F3),
            ),
          ],
        ),
      ),
    );
  }

  String _formatSteps(int steps) {
    if (steps >= 1000) {
      return '${(steps / 1000).toStringAsFixed(1)}K';
    }
    return steps.toString();
  }
}

class _WorkoutTile extends StatelessWidget {
  final String emoji;
  final String activity;
  final String duration;
  final Color color;

  const _WorkoutTile({
    required this.emoji,
    required this.activity,
    required this.duration,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              activity,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: color,
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              duration,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Risk Ingredients Card
// ──────────────────────────────────────────────

/// Displays risk ingredients with warning levels.
class RiskIngredientsCard extends StatelessWidget {
  final HealthAnalysis analysis;

  const RiskIngredientsCard({super.key, required this.analysis});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE65100).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.warning_amber_rounded,
                      color: Color(0xFFE65100), size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'Risk Ingredients',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            ...analysis.riskIngredients.map((risk) {
              Color riskColor;
              IconData riskIcon;
              switch (risk.level) {
                case RiskLevel.high:
                  riskColor = const Color(0xFFF44336);
                  riskIcon = Icons.dangerous;
                  break;
                case RiskLevel.medium:
                  riskColor = const Color(0xFFFF9800);
                  riskIcon = Icons.warning;
                  break;
                case RiskLevel.low:
                  riskColor = const Color(0xFF4CAF50);
                  riskIcon = Icons.check_circle;
                  break;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: riskColor.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: riskColor.withValues(alpha: 0.15)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(riskIcon, color: riskColor, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              risk.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: riskColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              risk.warning,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Health Effects Card
// ──────────────────────────────────────────────

/// Displays possible health effects of the food product.
class HealthEffectsCard extends StatelessWidget {
  final HealthAnalysis analysis;

  const HealthEffectsCard({super.key, required this.analysis});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1565C0).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.monitor_heart,
                      color: Color(0xFF1565C0), size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'Possible Health Effects',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            ...analysis.healthEffects.map((effect) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1565C0).withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color:
                            const Color(0xFF1565C0).withValues(alpha: 0.1)),
                  ),
                  child: Text(
                    effect,
                    style: const TextStyle(fontSize: 13, height: 1.4),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Suitable Age Group Card
// ──────────────────────────────────────────────

/// Displays the suitable age group for the food product.
class AgeGroupCard extends StatelessWidget {
  final HealthAnalysis analysis;

  const AgeGroupCard({super.key, required this.analysis});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ageText = analysis.suitableAgeGroup;

    // Determine color based on restrictiveness
    Color ageColor;
    IconData ageIcon;
    if (ageText.contains('18+')) {
      ageColor = const Color(0xFFF44336);
      ageIcon = Icons.no_drinks;
    } else if (ageText.contains('12+') || ageText.contains('10+')) {
      ageColor = const Color(0xFFFF9800);
      ageIcon = Icons.escalator_warning;
    } else if (ageText.contains('All ages')) {
      ageColor = const Color(0xFF4CAF50);
      ageIcon = Icons.family_restroom;
    } else {
      ageColor = const Color(0xFF2196F3);
      ageIcon = Icons.child_care;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              ageColor.withValues(alpha: 0.08),
              ageColor.withValues(alpha: 0.02),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ageColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(ageIcon, color: ageColor, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suitable Age Group',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    ageText,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ageColor,
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

// ──────────────────────────────────────────────
// Health Suggestions Card
// ──────────────────────────────────────────────

/// Displays actionable health suggestions based on the product analysis.
class HealthSuggestionsCard extends StatelessWidget {
  final HealthAnalysis analysis;

  const HealthSuggestionsCard({super.key, required this.analysis});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF00897B).withValues(alpha: 0.06),
              const Color(0xFF00897B).withValues(alpha: 0.02),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00897B).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.tips_and_updates,
                      color: Color(0xFF00897B), size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'Health Suggestions',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            ...analysis.healthSuggestions.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00897B).withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color:
                            const Color(0xFF00897B).withValues(alpha: 0.12)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00897B)
                              .withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Color(0xFF00897B),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.value,
                          style:
                              const TextStyle(fontSize: 13, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
