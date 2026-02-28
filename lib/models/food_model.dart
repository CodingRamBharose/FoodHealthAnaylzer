/// Data model for a food product fetched from Open Food Facts API.
class FoodProduct {
  final String barcode;
  final String productName;
  final String brandName;
  final String? imageUrl;
  final double calories; // kcal per 100g
  final double fat; // g per 100g
  final double saturatedFat; // g per 100g
  final double carbohydrates; // g per 100g
  final double protein; // g per 100g
  final double sugar; // g per 100g
  final double salt; // g per 100g
  final double fiber; // g per 100g
  final String ingredientsText;
  final List<String> additives;
  final String nutriScoreGrade; // a, b, c, d, e
  final int novaGroup; // 1-4
  final List<String> allergens;

  FoodProduct({
    required this.barcode,
    required this.productName,
    required this.brandName,
    this.imageUrl,
    required this.calories,
    required this.fat,
    this.saturatedFat = 0.0,
    required this.carbohydrates,
    required this.protein,
    required this.sugar,
    required this.salt,
    this.fiber = 0.0,
    this.ingredientsText = '',
    this.additives = const [],
    this.nutriScoreGrade = '',
    this.novaGroup = 0,
    this.allergens = const [],
  });

  /// Factory constructor to parse the Open Food Facts API JSON response.
  factory FoodProduct.fromJson(Map<String, dynamic> json, String barcode) {
    final product = json['product'] as Map<String, dynamic>? ?? {};
    final nutriments = product['nutriments'] as Map<String, dynamic>? ?? {};

    // Parse additives list
    final additivesTags = product['additives_tags'] as List<dynamic>? ?? [];
    final additives = additivesTags
        .map((e) => e.toString().replaceFirst('en:', '').toUpperCase())
        .toList();

    // Parse allergens
    final allergensTags = product['allergens_tags'] as List<dynamic>? ?? [];
    final allergens = allergensTags
        .map((e) => e.toString().replaceFirst('en:', '').replaceAll('-', ' '))
        .where((a) => a.isNotEmpty)
        .map((a) => a[0].toUpperCase() + a.substring(1))
        .toList();

    return FoodProduct(
      barcode: barcode,
      productName: _getString(product, 'product_name'),
      brandName: _getString(product, 'brands'),
      imageUrl: product['image_url'] as String?,
      calories: _getDouble(nutriments, 'energy-kcal_100g'),
      fat: _getDouble(nutriments, 'fat_100g'),
      saturatedFat: _getDouble(nutriments, 'saturated-fat_100g'),
      carbohydrates: _getDouble(nutriments, 'carbohydrates_100g'),
      protein: _getDouble(nutriments, 'proteins_100g'),
      sugar: _getDouble(nutriments, 'sugars_100g'),
      salt: _getDouble(nutriments, 'salt_100g'),
      fiber: _getDouble(nutriments, 'fiber_100g'),
      ingredientsText: product['ingredients_text'] as String? ?? '',
      additives: additives.cast<String>(),
      nutriScoreGrade: product['nutriscore_grade'] as String? ?? '',
      novaGroup: (product['nova_group'] as num?)?.toInt() ?? 0,
      allergens: allergens.cast<String>(),
    );
  }

  /// Safely extract a String value from JSON, returning 'Unknown' if null/empty.
  static String _getString(Map<String, dynamic> map, String key) {
    final value = map[key];
    if (value == null || (value is String && value.trim().isEmpty)) {
      return 'Unknown';
    }
    return value.toString();
  }

  /// Safely extract a double value from JSON, returning 0.0 if null.
  static double _getDouble(Map<String, dynamic> map, String key) {
    final value = map[key];
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  /// Convert to a Map for local storage.
  Map<String, dynamic> toMap() {
    return {
      'barcode': barcode,
      'productName': productName,
      'brandName': brandName,
      'imageUrl': imageUrl,
      'calories': calories,
      'fat': fat,
      'saturatedFat': saturatedFat,
      'carbohydrates': carbohydrates,
      'protein': protein,
      'sugar': sugar,
      'salt': salt,
      'fiber': fiber,
      'ingredientsText': ingredientsText,
      'additives': additives,
      'nutriScoreGrade': nutriScoreGrade,
      'novaGroup': novaGroup,
      'allergens': allergens,
    };
  }

  /// Create a FoodProduct from a locally stored Map.
  factory FoodProduct.fromMap(Map<String, dynamic> map) {
    return FoodProduct(
      barcode: map['barcode'] ?? '',
      productName: map['productName'] ?? 'Unknown',
      brandName: map['brandName'] ?? 'Unknown',
      imageUrl: map['imageUrl'],
      calories: (map['calories'] as num?)?.toDouble() ?? 0.0,
      fat: (map['fat'] as num?)?.toDouble() ?? 0.0,
      saturatedFat: (map['saturatedFat'] as num?)?.toDouble() ?? 0.0,
      carbohydrates: (map['carbohydrates'] as num?)?.toDouble() ?? 0.0,
      protein: (map['protein'] as num?)?.toDouble() ?? 0.0,
      sugar: (map['sugar'] as num?)?.toDouble() ?? 0.0,
      salt: (map['salt'] as num?)?.toDouble() ?? 0.0,
      fiber: (map['fiber'] as num?)?.toDouble() ?? 0.0,
      ingredientsText: map['ingredientsText'] as String? ?? '',
      additives: (map['additives'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      nutriScoreGrade: map['nutriScoreGrade'] as String? ?? '',
      novaGroup: (map['novaGroup'] as num?)?.toInt() ?? 0,
      allergens: (map['allergens'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
