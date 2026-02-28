/// Utility class for calculating exercise time needed to burn calories.
class CalorieCalculator {
  // Calories burned per minute for each activity (approximate values)
  static const double walkingCalPerMin = 4.0;
  static const double runningCalPerMin = 10.0;
  static const double cyclingCalPerMin = 8.0;

  /// Calculate walking time in minutes to burn given calories.
  static double walkingTime(double calories) {
    if (calories <= 0) return 0;
    return calories / walkingCalPerMin;
  }

  /// Calculate running time in minutes to burn given calories.
  static double runningTime(double calories) {
    if (calories <= 0) return 0;
    return calories / runningCalPerMin;
  }

  /// Calculate cycling time in minutes to burn given calories.
  static double cyclingTime(double calories) {
    if (calories <= 0) return 0;
    return calories / cyclingCalPerMin;
  }

  /// Format minutes into a human-readable string (e.g. "1h 30min" or "25 min").
  static String formatMinutes(double minutes) {
    if (minutes <= 0) return '0 min';
    final totalMinutes = minutes.round();
    if (totalMinutes < 60) {
      return '$totalMinutes min';
    }
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;
    if (mins == 0) return '${hours}h';
    return '${hours}h ${mins}min';
  }
}
