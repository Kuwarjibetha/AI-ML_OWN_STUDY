import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';

class RainProvider extends ChangeNotifier {
  final _uuid = const Uuid();
  final _random = Random();

  // ── Auth State ──────────────────────────────────────────────────────────────
  bool _isLoggedIn = false;
  String _userName = '';
  String _userEmail = '';
  bool _isLoading = false;
  String? _error;

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get userEmail => _userEmail;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ── Tanks ───────────────────────────────────────────────────────────────────
  List<TankModel> _tanks = [];
  List<WaterLog> _logs = [];
  String? _selectedTankId;

  List<TankModel> get tanks => _tanks;
  List<WaterLog> get logs => _logs;
  TankModel? get selectedTank =>
      _selectedTankId == null ? null : _tanks.firstWhere(
        (t) => t.id == _selectedTankId,
        orElse: () => _tanks.first,
      );

  List<WaterLog> logsForTank(String tankId) =>
      _logs.where((l) => l.tankId == tankId).toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

  // ── Dashboard stats ─────────────────────────────────────────────────────────
  int get totalTanks => _tanks.length;
  double get totalCapacity => _tanks.fold(0, (s, t) => s + t.capacityLiters);
  double get totalCurrent => _tanks.fold(0, (s, t) => s + t.currentLiters);
  double get overallPercent =>
      totalCapacity > 0 ? (totalCurrent / totalCapacity * 100) : 0;
  int get criticalCount => _tanks.where((t) => t.status == 'critical').length;
  int get lowCount => _tanks.where((t) => t.status == 'low').length;
  int get normalCount =>
      _tanks.where((t) => t.status == 'normal' || t.status == 'full').length;

  // ─────────────────────────────────────────────────────────────────────────────

  Future<void> init() async {
    // Load demo data so app looks great on first launch
    _loadDemoData();
  }

  void _loadDemoData() {
    final now = DateTime.now();

    // Demo tanks
    _tanks = [
      TankModel(
        id: 'tank_1',
        name: 'Main Rooftop Tank',
        location: 'Building A — Terrace',
        capacityLiters: 10000,
        levelPercent: 72,
        lastUpdated: now.subtract(const Duration(hours: 2)),
        notes: 'Primary collection tank',
      ),
      TankModel(
        id: 'tank_2',
        name: 'Garden Reserve',
        location: 'North Wing — Ground',
        capacityLiters: 5000,
        levelPercent: 45,
        lastUpdated: now.subtract(const Duration(hours: 5)),
      ),
      TankModel(
        id: 'tank_3',
        name: 'Emergency Storage',
        location: 'South Block — Basement',
        capacityLiters: 8000,
        levelPercent: 18,
        lastUpdated: now.subtract(const Duration(days: 1)),
        notes: 'Low — needs refill soon',
      ),
      TankModel(
        id: 'tank_4',
        name: 'Lab Building Tank',
        location: 'Science Block — Roof',
        capacityLiters: 3000,
        levelPercent: 9,
        lastUpdated: now.subtract(const Duration(hours: 8)),
      ),
    ];

    // Demo logs (30 days of history for tank_1)
    _logs = [];
    double lvl = 60;
    for (int i = 29; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      lvl = (lvl + _random.nextDouble() * 14 - 6).clamp(10, 95);
      final harvested = _random.nextDouble() * 400 + 50;
      final consumed = _random.nextDouble() * 200 + 30;
      final rainfall = _random.nextDouble() * 20;

      _logs.add(WaterLog(
        id: _uuid.v4(),
        tankId: 'tank_1',
        tankName: 'Main Rooftop Tank',
        levelPercent: lvl,
        levelLiters: 10000 * lvl / 100,
        rainfallMm: rainfall,
        harvestedLiters: harvested,
        consumedLiters: consumed,
        timestamp: date,
        notes: i % 5 == 0 ? 'Routine check' : null,
      ));
    }

    // Demo logs for tank_2
    double lvl2 = 40;
    for (int i = 29; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      lvl2 = (lvl2 + _random.nextDouble() * 10 - 4).clamp(5, 90);
      _logs.add(WaterLog(
        id: _uuid.v4(),
        tankId: 'tank_2',
        tankName: 'Garden Reserve',
        levelPercent: lvl2,
        levelLiters: 5000 * lvl2 / 100,
        rainfallMm: _random.nextDouble() * 15,
        harvestedLiters: _random.nextDouble() * 200 + 20,
        consumedLiters: _random.nextDouble() * 100 + 15,
        timestamp: date,
      ));
    }
  }

  // ── Auth ────────────────────────────────────────────────────────────────────

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _error = null;

    await Future.delayed(const Duration(milliseconds: 1200));

    if (email.trim().isEmpty || password.isEmpty) {
      _error = 'Please enter email and password.';
      _setLoading(false);
      return false;
    }
    if (!email.contains('@')) {
      _error = 'Please enter a valid email address.';
      _setLoading(false);
      return false;
    }
    if (password.length < 6) {
      _error = 'Password must be at least 6 characters.';
      _setLoading(false);
      return false;
    }

    _isLoggedIn = true;
    _userEmail = email.trim();
    _userName = email.split('@').first
        .replaceAll('.', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
        .join(' ');
    _setLoading(false);
    return true;
  }

  Future<bool> signUp(String name, String email, String password) async {
    _setLoading(true);
    _error = null;

    await Future.delayed(const Duration(milliseconds: 1200));

    if (name.trim().isEmpty) {
      _error = 'Name is required.';
      _setLoading(false);
      return false;
    }
    if (!email.contains('@')) {
      _error = 'Please enter a valid email address.';
      _setLoading(false);
      return false;
    }
    if (password.length < 6) {
      _error = 'Password must be at least 6 characters.';
      _setLoading(false);
      return false;
    }

    _isLoggedIn = true;
    _userName = name.trim();
    _userEmail = email.trim();
    _setLoading(false);
    return true;
  }

  void logout() {
    _isLoggedIn = false;
    _userName = '';
    _userEmail = '';
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // ── Tanks ───────────────────────────────────────────────────────────────────

  void selectTank(String id) {
    _selectedTankId = id;
    notifyListeners();
  }

  void addTank({
    required String name,
    required String location,
    required double capacityLiters,
    double initialLevel = 0,
    String? notes,
  }) {
    _tanks.add(TankModel(
      id: _uuid.v4(),
      name: name,
      location: location,
      capacityLiters: capacityLiters,
      levelPercent: initialLevel,
      lastUpdated: DateTime.now(),
      notes: notes,
    ));
    notifyListeners();
  }

  void deleteTank(String id) {
    _tanks.removeWhere((t) => t.id == id);
    _logs.removeWhere((l) => l.tankId == id);
    if (_selectedTankId == id) _selectedTankId = null;
    notifyListeners();
  }

  // ── Logging ─────────────────────────────────────────────────────────────────

  void logReading({
    required String tankId,
    required double levelPercent,
    double? rainfallMm,
    double? harvestedLiters,
    double? consumedLiters,
    String? notes,
  }) {
    final tank = _tanks.firstWhere((t) => t.id == tankId);
    tank.levelPercent = levelPercent;
    tank.lastUpdated = DateTime.now();

    _logs.insert(
      0,
      WaterLog(
        id: _uuid.v4(),
        tankId: tankId,
        tankName: tank.name,
        levelPercent: levelPercent,
        levelLiters: tank.capacityLiters * (levelPercent / 100),
        rainfallMm: rainfallMm,
        harvestedLiters: harvestedLiters,
        consumedLiters: consumedLiters,
        timestamp: DateTime.now(),
        notes: notes,
      ),
    );
    notifyListeners();
  }

  // ── Analytics ───────────────────────────────────────────────────────────────

  List<AnalyticsPoint> getChartData(String tankId, int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    final tankLogs = _logs
        .where((l) => l.tankId == tankId && l.timestamp.isAfter(cutoff))
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return tankLogs.map((l) => AnalyticsPoint(
          date: l.timestamp,
          levelPercent: l.levelPercent,
          rainfall: l.rainfallMm ?? 0,
          harvested: l.harvestedLiters ?? 0,
          consumed: l.consumedLiters ?? 0,
        )).toList();
  }

  Map<String, double> getSummaryStats(String tankId, int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    final tankLogs = _logs
        .where((l) => l.tankId == tankId && l.timestamp.isAfter(cutoff))
        .toList();

    if (tankLogs.isEmpty) {
      return {
        'avgLevel': 0, 'totalHarvested': 0,
        'totalConsumed': 0, 'totalRainfall': 0, 'efficiency': 0,
      };
    }

    final avgLevel = tankLogs.map((l) => l.levelPercent).reduce((a, b) => a + b) / tankLogs.length;
    final totalHarvested = tankLogs.fold(0.0, (s, l) => s + (l.harvestedLiters ?? 0));
    final totalConsumed = tankLogs.fold(0.0, (s, l) => s + (l.consumedLiters ?? 0));
    final totalRainfall = tankLogs.fold(0.0, (s, l) => s + (l.rainfallMm ?? 0));
    final efficiency = totalHarvested > 0
        ? ((totalHarvested - totalConsumed) / totalHarvested * 100).clamp(0.0, 100.0)
        : 0.0;

    return {
      'avgLevel': avgLevel,
      'totalHarvested': totalHarvested,
      'totalConsumed': totalConsumed,
      'totalRainfall': totalRainfall,
      'efficiency': efficiency,
    };
  }

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }
}
