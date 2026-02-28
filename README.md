# 🍎 Smart Food Analyzer

A Flutter app that lets you **scan packaged food products** (via barcode) and instantly get a comprehensive health analysis — including a health score, calorie burn estimates, risk ingredient warnings, and personalized health suggestions.

## ✨ Features

| Feature | Description |
|---|---|
| **Barcode Scanner** | Scan any packaged food barcode using your device camera |
| **Health Score** | Overall score (0–100) rated as Low, Medium, or High |
| **Nutrition Facts** | Calories, fat, carbs, protein, sugar, salt per 100g |
| **Calorie Burn Estimation** | Steps, walking, jogging & cycling time to burn the calories |
| **Risk Ingredients Warning** | Flags high sugar, sodium, saturated fat, dangerous additives & more |
| **Possible Health Effects** | Lists potential health impacts (positive & negative) |
| **Suitable Age Group** | Recommends age suitability based on ingredients & nutritional profile |
| **Health Suggestions** | Actionable tips tailored to the product's nutritional data |
| **Scan History** | Locally saved history of all scanned products with health score badges |
| **Dark Mode** | Follows system theme automatically |

## 📸 Screenshots

<!-- Add your screenshots here -->
<!-- ![Home](screenshots/home.png) -->
<!-- ![Result](screenshots/result.png) -->

## 🛠️ Tech Stack

- **Flutter** (Dart)
- **Open Food Facts API** — product & nutrition data
- **Material 3** — modern UI design
- **SharedPreferences** — local scan history storage

## 📦 Dependencies

| Package | Purpose |
|---|---|
| `http` | API requests to Open Food Facts |
| `mobile_scanner` | Barcode scanning via camera |
| `cached_network_image` | Product image caching |
| `shared_preferences` | Persist scan history locally |
| `provider` | State management |
| `cupertino_icons` | iOS-style icons |

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.11.0`
- Android Studio / VS Code with Flutter extension
- A physical device or emulator with camera (for barcode scanning)

### Installation

```bash
# Clone the repository
git clone https://github.com/<your-username>/food_health_analyzer.git
cd food_health_analyzer

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point & theme config
├── models/
│   └── food_model.dart          # FoodProduct data model
├── screens/
│   ├── home_screen.dart         # Main home screen
│   ├── scan_screen.dart         # Barcode scanner screen
│   ├── search_screen.dart       # Manual barcode search
│   ├── result_screen.dart       # Full analysis result display
│   ├── history_screen.dart      # Scan history list
│   ├── splash_screen.dart       # App splash screen
│   └── error_screen.dart        # Error handling screen
├── services/
│   ├── api_service.dart         # Open Food Facts API integration
│   ├── history_service.dart     # Local history persistence
│   └── health_analyzer.dart     # Health score & analysis engine
├── utils/
│   └── calorie_calculator.dart  # Exercise burn calculations
└── widgets/
    └── custom_cards.dart        # Reusable UI card components
```

## 🧠 How Health Score Works

The health score (0–100) is calculated by analyzing:

- **Calorie density** — penalizes high kcal/100g
- **Sugar content** — penalizes excess sugar
- **Salt/sodium** — penalizes high sodium
- **Fat & saturated fat** — penalizes unhealthy fat levels
- **Protein & fiber** — rewards higher values
- **Additives** — penalizes products with many additives
- **Nutri-Score grade** — adjusts based on A–E rating
- **NOVA group** — penalizes ultra-processed foods (NOVA 4)

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgements

- [Open Food Facts](https://world.openfoodfacts.org/) — free & open food products database
- [Flutter](https://flutter.dev/) — UI toolkit by Google
