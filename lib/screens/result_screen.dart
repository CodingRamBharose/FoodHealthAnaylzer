import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/food_model.dart';
import '../services/history_service.dart';
import '../services/health_analyzer.dart';
import '../widgets/custom_cards.dart';

/// Result screen displaying full nutrition analysis for a scanned product.
class ResultScreen extends StatefulWidget {
  final FoodProduct product;

  const ResultScreen({super.key, required this.product});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late final HealthAnalysis _analysis;

  @override
  void initState() {
    super.initState();
    // Save scanned product to history
    HistoryService.addProduct(widget.product);
    // Run health analysis
    _analysis = HealthAnalyzer.analyze(widget.product);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF1B5E20), const Color(0xFF121212)]
                : [const Color(0xFFE8F5E9), const Color(0xFFF5F5F5)],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // Custom App Bar with product image
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  product.productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(color: Colors.black54, blurRadius: 8),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                background: _buildProductImage(product),
              ),
            ),

            // Content
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Section 1: Health Score
                  HealthScoreCard(analysis: _analysis),
                  const SizedBox(height: 16),

                  // Section 2: Product Info Card
                  ProductInfoCard(product: product),
                  const SizedBox(height: 16),

                  // Section 3: Nutrition Card
                  NutritionCard(product: product),
                  const SizedBox(height: 16),

                  // Section 4: Steps & Workout Burn
                  StepsBurnCard(analysis: _analysis),
                  const SizedBox(height: 16),

                  // Section 5: Risk Ingredients Warning
                  RiskIngredientsCard(analysis: _analysis),
                  const SizedBox(height: 16),

                  // Section 6: Possible Health Effects
                  HealthEffectsCard(analysis: _analysis),
                  const SizedBox(height: 16),

                  // Section 7: Suitable Age Group
                  AgeGroupCard(analysis: _analysis),
                  const SizedBox(height: 16),

                  // Section 8: Health Suggestions
                  HealthSuggestionsCard(analysis: _analysis),
                  const SizedBox(height: 24),

                  // Scan Another Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text(
                        'Scan Another Product',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the product image for the SliverAppBar.
  Widget _buildProductImage(FoodProduct product) {
    if (product.imageUrl != null && product.imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: product.imageUrl!,
        fit: BoxFit.cover,
        placeholder: (_, _) => Container(
          color: const Color(0xFF2E7D32),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
        errorWidget: (_, _, _) => _buildPlaceholderImage(),
      );
    }
    return _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
        ),
      ),
      child: const Center(
        child: Icon(Icons.fastfood, size: 80, color: Colors.white54),
      ),
    );
  }
}
