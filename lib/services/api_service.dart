import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_model.dart';

/// Service class to interact with the Open Food Facts API.
class ApiService {
  static const String _baseUrl =
      'https://world.openfoodfacts.org/api/v0/product';

  /// Fetches a product by its barcode from Open Food Facts.
  /// Returns a [FoodProduct] if found, or `null` if the product doesn't exist.
  /// Throws an [Exception] on network errors.
  static Future<FoodProduct?> fetchProduct(String barcode) async {
    final url = Uri.parse('$_baseUrl/$barcode.json');

    try {
      final response = await http.get(url).timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        // Open Food Facts returns status = 1 when product is found
        if (data['status'] == 1) {
          return FoodProduct.fromJson(data, barcode);
        } else {
          return null; // Product not found in database
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception && e.toString().contains('Product not found')) {
        return null;
      }
      rethrow;
    }
  }
}
