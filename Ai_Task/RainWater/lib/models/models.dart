// ─────────────────────────────────────────────────────────────────────────────
// Tank Model
// ─────────────────────────────────────────────────────────────────────────────
class TankModel {
  final String id;
  String name;
  String location;
  double capacityLiters;
  double levelPercent;
  DateTime lastUpdated;
  String? notes;

  TankModel({
    required this.id,
    required this.name,
    required this.location,
    required this.capacityLiters,
    required this.levelPercent,
    required this.lastUpdated,
    this.notes,
  });

  double get currentLiters => capacityLiters * (levelPercent / 100);
  double get availableLiters => capacityLiters - currentLiters;

  String get status {
    if (levelPercent >= 85) return 'full';
    if (levelPercent >= 30) return 'normal';
    if (levelPercent >= 15) return 'low';
    return 'critical';
  }

  String get statusLabel {
    switch (status) {
      case 'full':     return 'Full';
      case 'normal':   return 'Normal';
      case 'low':      return 'Low Level';
      case 'critical': return 'Critical';
      default:         return 'Normal';
    }
  }

  static String computeStatus(double percent) {
    if (percent >= 85) return 'full';
    if (percent >= 30) return 'normal';
    if (percent >= 15) return 'low';
    return 'critical';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Water Log Model
// ─────────────────────────────────────────────────────────────────────────────
class WaterLog {
  final String id;
  final String tankId;
  final String tankName;
  final double levelPercent;
  final double levelLiters;
  final double? rainfallMm;
  final double? harvestedLiters;
  final double? consumedLiters;
  final DateTime timestamp;
  final String? notes;

  WaterLog({
    required this.id,
    required this.tankId,
    required this.tankName,
    required this.levelPercent,
    required this.levelLiters,
    this.rainfallMm,
    this.harvestedLiters,
    this.consumedLiters,
    required this.timestamp,
    this.notes,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Analytics Point
// ─────────────────────────────────────────────────────────────────────────────
class AnalyticsPoint {
  final DateTime date;
  final double levelPercent;
  final double rainfall;
  final double harvested;
  final double consumed;

  AnalyticsPoint({
    required this.date,
    required this.levelPercent,
    this.rainfall = 0,
    this.harvested = 0,
    this.consumed = 0,
  });
}
