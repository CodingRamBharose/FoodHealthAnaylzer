import '../models/food_model.dart';

/// Health score levels.
enum HealthLevel { high, medium, low }

/// A comprehensive health analysis result for a food product.
class HealthAnalysis {
  final HealthLevel healthLevel;
  final int healthScore; // 0-100
  final double calories;
  final int stepsToburn;
  final int walkingMinutes;
  final int joggingMinutes;
  final int cyclingMinutes;
  final List<RiskIngredient> riskIngredients;
  final List<String> healthEffects;
  final String suitableAgeGroup;
  final List<String> healthSuggestions;

  HealthAnalysis({
    required this.healthLevel,
    required this.healthScore,
    required this.calories,
    required this.stepsToburn,
    required this.walkingMinutes,
    required this.joggingMinutes,
    required this.cyclingMinutes,
    required this.riskIngredients,
    required this.healthEffects,
    required this.suitableAgeGroup,
    required this.healthSuggestions,
  });

  String get healthLevelLabel {
    switch (healthLevel) {
      case HealthLevel.high:
        return 'High';
      case HealthLevel.medium:
        return 'Medium';
      case HealthLevel.low:
        return 'Low';
    }
  }
}

/// Represents a risky ingredient with its warning.
class RiskIngredient {
  final String name;
  final String warning;
  final RiskLevel level;

  RiskIngredient({
    required this.name,
    required this.warning,
    required this.level,
  });
}

enum RiskLevel { high, medium, low }

/// Analyzes a [FoodProduct] and produces a full [HealthAnalysis].
class HealthAnalyzer {
  static HealthAnalysis analyze(FoodProduct product) {
    final score = _calculateHealthScore(product);
    final level = _scoreToLevel(score);
    final steps = _calculateSteps(product.calories);
    final riskIngredients = _identifyRiskIngredients(product);
    final healthEffects = _identifyHealthEffects(product);
    final ageGroup = _determineSuitableAgeGroup(product, score);
    final suggestions = _generateSuggestions(product, score);

    return HealthAnalysis(
      healthLevel: level,
      healthScore: score,
      calories: product.calories,
      stepsToburn: steps,
      walkingMinutes: (product.calories / 4.0).round(),
      joggingMinutes: (product.calories / 10.0).round(),
      cyclingMinutes: (product.calories / 8.0).round(),
      riskIngredients: riskIngredients,
      healthEffects: healthEffects,
      suitableAgeGroup: ageGroup,
      healthSuggestions: suggestions,
    );
  }

  // ── Health Score (0–100) ──────────────────────────────────

  static int _calculateHealthScore(FoodProduct product) {
    double score = 100;

    // Penalize high calories (per 100g)
    if (product.calories > 500) {
      score -= 25;
    } else if (product.calories > 300) {
      score -= 15;
    } else if (product.calories > 200) {
      score -= 8;
    }

    // Penalize high fat
    if (product.fat > 20) {
      score -= 20;
    } else if (product.fat > 10) {
      score -= 10;
    } else if (product.fat > 5) {
      score -= 5;
    }

    // Penalize high sugar
    if (product.sugar > 20) {
      score -= 25;
    } else if (product.sugar > 10) {
      score -= 15;
    } else if (product.sugar > 5) {
      score -= 8;
    }

    // Penalize high salt
    if (product.salt > 2.0) {
      score -= 20;
    } else if (product.salt > 1.0) {
      score -= 10;
    } else if (product.salt > 0.5) {
      score -= 5;
    }

    // Reward protein
    if (product.protein > 15) {
      score += 10;
    } else if (product.protein > 8) {
      score += 5;
    }

    // Penalize high saturated fat
    if (product.saturatedFat > 10) {
      score -= 15;
    } else if (product.saturatedFat > 5) {
      score -= 8;
    }

    // Penalize high fiber absence (low fiber = less healthy)
    if (product.fiber > 5) {
      score += 8;
    } else if (product.fiber > 2) {
      score += 4;
    }

    // Penalize based on additives count
    if (product.additives.length > 5) {
      score -= 15;
    } else if (product.additives.length > 2) {
      score -= 8;
    }

    // Use Nutri-Score if available
    if (product.nutriScoreGrade.isNotEmpty) {
      switch (product.nutriScoreGrade.toLowerCase()) {
        case 'a':
          score += 10;
          break;
        case 'b':
          score += 5;
          break;
        case 'd':
          score -= 10;
          break;
        case 'e':
          score -= 20;
          break;
      }
    }

    // Use NOVA group
    if (product.novaGroup >= 4) {
      score -= 15;
    } else if (product.novaGroup == 3) {
      score -= 8;
    } else if (product.novaGroup == 1) {
      score += 5;
    }

    return score.clamp(0, 100).round();
  }

  static HealthLevel _scoreToLevel(int score) {
    if (score >= 65) return HealthLevel.high;
    if (score >= 40) return HealthLevel.medium;
    return HealthLevel.low;
  }

  // ── Steps to Burn ────────────────────────────────────────

  /// ~0.04 kcal burned per step (average).
  static int _calculateSteps(double calories) {
    if (calories <= 0) return 0;
    return (calories / 0.04).round();
  }

  // ── Risk Ingredients ─────────────────────────────────────

  static List<RiskIngredient> _identifyRiskIngredients(FoodProduct product) {
    final List<RiskIngredient> risks = [];

    // Check nutritional values
    if (product.sugar > 15) {
      risks.add(RiskIngredient(
        name: 'High Sugar',
        warning:
            '${product.sugar.toStringAsFixed(1)}g per 100g – exceeds recommended daily limit quickly.',
        level: RiskLevel.high,
      ));
    } else if (product.sugar > 8) {
      risks.add(RiskIngredient(
        name: 'Moderate Sugar',
        warning:
            '${product.sugar.toStringAsFixed(1)}g per 100g – moderate sugar content.',
        level: RiskLevel.medium,
      ));
    }

    if (product.salt > 1.5) {
      risks.add(RiskIngredient(
        name: 'High Sodium/Salt',
        warning:
            '${product.salt.toStringAsFixed(2)}g per 100g – may raise blood pressure.',
        level: RiskLevel.high,
      ));
    } else if (product.salt > 0.8) {
      risks.add(RiskIngredient(
        name: 'Moderate Salt',
        warning:
            '${product.salt.toStringAsFixed(2)}g per 100g – watch sodium intake.',
        level: RiskLevel.medium,
      ));
    }

    if (product.saturatedFat > 5) {
      risks.add(RiskIngredient(
        name: 'High Saturated Fat',
        warning:
            '${product.saturatedFat.toStringAsFixed(1)}g per 100g – linked to heart disease.',
        level: RiskLevel.high,
      ));
    }

    if (product.fat > 17) {
      risks.add(RiskIngredient(
        name: 'High Total Fat',
        warning:
            '${product.fat.toStringAsFixed(1)}g per 100g – high fat content.',
        level: RiskLevel.medium,
      ));
    }

    // Check additives
    final dangerousAdditives = {
      'e102': 'Tartrazine – may cause allergic reactions',
      'e110': 'Sunset Yellow – linked to hyperactivity in children',
      'e120': 'Cochineal – allergenic for some people',
      'e124': 'Ponceau 4R – may affect activity in children',
      'e129': 'Allura Red – linked to hyperactivity',
      'e150d': 'Caramel colour – possible carcinogen',
      'e211': 'Sodium benzoate – may worsen asthma',
      'e220': 'Sulphur dioxide – allergic reactions',
      'e250': 'Sodium nitrite – linked to cancer risk',
      'e320': 'BHA – possible carcinogen',
      'e321': 'BHT – possible endocrine disruptor',
      'e621': 'MSG – may cause headaches in sensitive people',
      'e951': 'Aspartame – controversial artificial sweetener',
      'e950': 'Acesulfame K – artificial sweetener concerns',
    };

    for (final additive in product.additives) {
      final code = additive.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
      for (final entry in dangerousAdditives.entries) {
        if (code.contains(entry.key)) {
          risks.add(RiskIngredient(
            name: additive,
            warning: entry.value,
            level: RiskLevel.high,
          ));
          break;
        }
      }
    }

    // Check ingredients text for common concerns
    final ingredientsLower = product.ingredientsText.toLowerCase();
    final concernKeywords = {
      'palm oil': 'Palm oil – high in saturated fats, environmental concerns',
      'hydrogenated':
          'Hydrogenated oil – contains trans fats, increases heart disease risk',
      'high fructose corn syrup':
          'HFCS – linked to obesity and metabolic issues',
      'artificial': 'Contains artificial ingredients',
      'monosodium glutamate': 'MSG – may cause reactions in sensitive people',
    };

    for (final entry in concernKeywords.entries) {
      if (ingredientsLower.contains(entry.key)) {
        risks.add(RiskIngredient(
          name: entry.key.split(' ').map((w) => '${w[0].toUpperCase()}${w.substring(1)}').join(' '),
          warning: entry.value,
          level: RiskLevel.medium,
        ));
      }
    }

    if (risks.isEmpty) {
      risks.add(RiskIngredient(
        name: 'No major risks detected',
        warning: 'This product appears to have no major risky ingredients.',
        level: RiskLevel.low,
      ));
    }

    return risks;
  }

  // ── Health Effects ───────────────────────────────────────

  static List<String> _identifyHealthEffects(FoodProduct product) {
    final List<String> effects = [];

    // Calorie-based effects
    if (product.calories > 400) {
      effects.add(
          '⚡ Very high calorie density – may contribute to weight gain if consumed frequently.');
    } else if (product.calories > 250) {
      effects.add(
          '⚡ Moderately high calories – portion control recommended.');
    }

    // Sugar effects
    if (product.sugar > 15) {
      effects.add(
          '🍬 High sugar may spike blood glucose, increasing risk of type 2 diabetes over time.');
    } else if (product.sugar > 8) {
      effects.add(
          '🍬 Moderate sugar – may contribute to dental cavities and energy crashes.');
    }

    // Salt effects
    if (product.salt > 1.5) {
      effects.add(
          '🧂 High sodium may elevate blood pressure and strain the cardiovascular system.');
    }

    // Fat effects
    if (product.saturatedFat > 5) {
      effects.add(
          '🫀 High saturated fat may raise LDL cholesterol, increasing heart disease risk.');
    }

    if (product.fat > 20) {
      effects.add(
          '🍔 Very high fat content – may contribute to obesity and digestive issues.');
    }

    // Protein effects (positive)
    if (product.protein > 15) {
      effects.add(
          '💪 Good protein source – supports muscle repair and satiety.');
    }

    // Fiber effects (positive)
    if (product.fiber > 5) {
      effects.add(
          '🥦 Good fiber content – promotes digestive health and blood sugar regulation.');
    }

    // NOVA ultra-processed
    if (product.novaGroup >= 4) {
      effects.add(
          '🏭 Ultra-processed food (NOVA 4) – linked to increased risk of chronic diseases.');
    }

    // Additives
    if (product.additives.length > 5) {
      effects.add(
          '⚗️ Contains many additives – may cause sensitivities or allergic reactions in some people.');
    }

    if (effects.isEmpty) {
      effects.add(
          '✅ No major negative health effects identified for moderate consumption.');
    }

    return effects;
  }

  // ── Suitable Age Group ───────────────────────────────────

  static String _determineSuitableAgeGroup(FoodProduct product, int score) {
    final hasHighSugar = product.sugar > 15;
    final hasHighSalt = product.salt > 1.5;
    final hasHighCaffeine =
        product.ingredientsText.toLowerCase().contains('caffeine');
    final isUltraProcessed = product.novaGroup >= 4;
    final hasAlcohol =
        product.ingredientsText.toLowerCase().contains('alcohol');

    if (hasAlcohol) {
      return 'Adults 18+ only (contains alcohol)';
    }

    if (hasHighCaffeine) {
      return 'Ages 12+ (contains caffeine)';
    }

    if (hasHighSugar && hasHighSalt) {
      return 'Ages 10+ (high sugar & salt – not recommended for young children)';
    }

    if (isUltraProcessed && score < 40) {
      return 'Ages 8+ (ultra-processed, low health score – limit for young children)';
    }

    if (hasHighSugar || hasHighSalt) {
      return 'Ages 6+ (moderate caution for younger children)';
    }

    if (score >= 65) {
      return 'All ages (suitable for children 3+)';
    }

    return 'Ages 5+ (generally suitable with moderation)';
  }

  // ── Health Suggestions ───────────────────────────────────

  static List<String> _generateSuggestions(FoodProduct product, int score) {
    final List<String> suggestions = [];

    if (product.calories > 300) {
      suggestions.add(
          'Consider smaller portions – this product is calorie-dense at ${product.calories.toStringAsFixed(0)} kcal/100g.');
    }

    if (product.sugar > 10) {
      suggestions.add(
          'Look for lower-sugar alternatives. The WHO recommends less than 25g of added sugar per day.');
    }

    if (product.salt > 1.0) {
      suggestions.add(
          'Try to balance your sodium intake throughout the day. Daily limit: 5g of salt.');
    }

    if (product.saturatedFat > 5) {
      suggestions.add(
          'Choose products with unsaturated fats (olive oil, nuts) instead of saturated fats.');
    }

    if (product.fiber < 2) {
      suggestions.add(
          'This product is low in fiber. Pair it with fiber-rich foods like fruits, vegetables, or whole grains.');
    }

    if (product.protein < 5 && product.calories > 200) {
      suggestions.add(
          'Low protein for the calorie count. Add a protein source to your meal for better satiety.');
    }

    if (product.novaGroup >= 4) {
      suggestions.add(
          'This is ultra-processed. Try to limit ultra-processed foods and choose whole/minimally processed alternatives.');
    }

    if (product.additives.length > 3) {
      suggestions.add(
          'This product contains ${product.additives.length} additives. Consider products with fewer additives.');
    }

    if (score >= 70) {
      suggestions.add(
          '✅ Overall a decent choice! Enjoy in moderation as part of a balanced diet.');
    }

    if (suggestions.isEmpty) {
      suggestions.add(
          'This product has a balanced nutritional profile. Enjoy as part of a varied diet.');
    }

    return suggestions;
  }
}
