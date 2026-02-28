import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/food_model.dart';

/// Service for persisting scan history locally using SharedPreferences.
class HistoryService {
  static const String _key = 'scan_history';

  /// Save a scanned product to history.
  static Future<void> addProduct(FoodProduct product) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();

    // Remove duplicate if exists (keep latest scan on top)
    history.removeWhere((p) => p.barcode == product.barcode);
    history.insert(0, product);

    // Keep only last 50 items
    if (history.length > 50) {
      history.removeRange(50, history.length);
    }

    final encoded = history.map((p) => json.encode(p.toMap())).toList();
    await prefs.setStringList(_key, encoded);
  }

  /// Retrieve all scan history.
  static Future<List<FoodProduct>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getStringList(_key) ?? [];
    return encoded
        .map((e) => FoodProduct.fromMap(json.decode(e) as Map<String, dynamic>))
        .toList();
  }

  /// Clear all scan history.
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
