import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../app.dart';
import '../providers/rain_provider.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import 'log_reading_sheet.dart';

class TankDetailScreen extends StatelessWidget {
  final String tankId;
  const TankDetailScreen({super.key, required this.tankId});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<RainProvider>();
    final tankList = p.tanks.where((t) => t.id == tankId).toList();
    if (tankList.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: const Center(child: Text('Tank not found', style: TextStyle(color: AppColors.textSecondary))),
      );
    }
    final tank = tankList.first;
    final logs = p.logsForTank(tankId);
    final chartData = p.getChartData(tankId, 14);
    final sc = _statusColor(tank.status);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGrad),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── App Bar ──────────────────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: AppColors.textPrimary,
              elevation: 0,
              floating: true,
              snap: true,
              title: Text(tank.name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis),
              actions: [
                IconButton(
                  icon: Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: const Icon(Icons.edit_note_rounded, color: AppColors.primary, size: 18),
                  ),
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => LogReadingSheet(tankId: tankId),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),

            // ── Hero Gauge ───────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: GlassCard(
                  glowColor: sc,
                  child: Column(
                    children: [
                      // Status + location
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            const Icon(Icons.location_on_outlined, size: 13, color: AppColors.textMuted),
                            const SizedBox(width: 4),
                            Text(tank.location,
                              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                              overflow: TextOverflow.ellipsis),
                          ]),
                          _chip(tank.statusLabel, sc),
                        ],
                      ),
                      const SizedBox(height: 22),
                      // Gauge
                      WaterGauge(percent: tank.levelPercent, size: 180, color: sc),
                      const SizedBox(height: 22),
                      // Capacity info
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.bgCardLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _infoItem('Current', '${tank.currentLiters.toStringAsFixed(0)} L', sc),
                            Container(width: 1, height: 30, color: AppColors.border),
                            _infoItem('Available', '${tank.availableLiters.toStringAsFixed(0)} L', AppColors.textSecondary),
                            Container(width: 1, height: 30, color: AppColors.border),
                            _infoItem('Capacity', '${tank.capacityLiters.toStringAsFixed(0)} L', AppColors.textSecondary),
                          ],
                        ),
                      ),
                      if (tank.notes != null && tank.notes!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Row(children: [
                          const Icon(Icons.notes_rounded, size: 13, color: AppColors.textMuted),
                          const SizedBox(width: 6),
                          Expanded(child: Text(tank.notes!, style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12))),
                        ]),
                      ],
                      const SizedBox(height: 12),
                      Text(
                        'Last updated: ${DateFormat('d MMM, h:mm a').format(tank.lastUpdated)}',
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Mini Chart ───────────────────────────────────────────────────
            if (chartData.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('14-Day Level Trend',
                          style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 110,
                          child: LineChart(LineChartData(
                            gridData: const FlGridData(show: false),
                            titlesData: const FlTitlesData(show: false),
                            borderData: FlBorderData(show: false),
                            minY: 0, maxY: 100,
                            lineBarsData: [
                              LineChartBarData(
                                spots: chartData.asMap().entries.map((e) =>
                                  FlSpot(e.key.toDouble(), e.value.levelPercent)).toList(),
                                isCurved: true, curveSmoothness: 0.35,
                                color: sc, barWidth: 2.5,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [sc.withOpacity(0.25), Colors.transparent],
                                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ],
                          )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // ── Reading History ───────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Reading History', style: TextStyle(
                      color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
                    Text('${logs.length} entries',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  ],
                ),
              ),
            ),

            logs.isEmpty
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(children: [
                        const Icon(Icons.history_rounded, color: AppColors.textMuted, size: 38),
                        const SizedBox(height: 10),
                        const Text('No readings yet', style: TextStyle(color: AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        const Text('Tap the edit button to log your first reading.',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                      ]),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => _LogItem(log: logs[i]),
                      childCount: logs.length,
                    ),
                  ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, Color c) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: c.withOpacity(0.12),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: c.withOpacity(0.35)),
    ),
    child: Text(label, style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w700)),
  );

  Widget _infoItem(String label, String value, Color c) => Column(children: [
    Text(value, style: TextStyle(color: c, fontSize: 14, fontWeight: FontWeight.w700)),
    const SizedBox(height: 2),
    Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
  ]);

  Color _statusColor(String s) {
    switch (s) {
      case 'full':     return AppColors.primary;
      case 'normal':   return AppColors.success;
      case 'low':      return AppColors.warning;
      case 'critical': return AppColors.danger;
      default:         return AppColors.primary;
    }
  }
}

class _LogItem extends StatelessWidget {
  final WaterLog log;
  const _LogItem({required this.log});

  @override
  Widget build(BuildContext context) {
    final sc = _sc(log.levelPercent);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(children: [
          // Level circle
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: sc.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('${log.levelPercent.toInt()}%',
                style: TextStyle(color: sc, fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(DateFormat('d MMM yyyy, h:mm a').format(log.timestamp),
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Wrap(runSpacing: 4, spacing: 8, children: [
                if (log.rainfallMm != null && log.rainfallMm! > 0)
                  _badge(Icons.grain_rounded, '${log.rainfallMm!.toStringAsFixed(1)}mm', AppColors.secondary),
                if (log.harvestedLiters != null && log.harvestedLiters! > 0)
                  _badge(Icons.arrow_downward_rounded, '+${log.harvestedLiters!.toStringAsFixed(0)}L', AppColors.success),
                if (log.consumedLiters != null && log.consumedLiters! > 0)
                  _badge(Icons.arrow_upward_rounded, '-${log.consumedLiters!.toStringAsFixed(0)}L', AppColors.warning),
              ]),
              if (log.notes != null && log.notes!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(log.notes!, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
              ],
            ]),
          ),
          Text('${log.levelLiters.toStringAsFixed(0)} L',
            style: TextStyle(color: sc, fontSize: 11, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  Widget _badge(IconData icon, String text, Color c) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      color: c.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 10, color: c),
      const SizedBox(width: 3),
      Text(text, style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w600)),
    ]),
  );

  Color _sc(double pct) {
    if (pct >= 70) return AppColors.success;
    if (pct >= 30) return AppColors.primary;
    if (pct >= 15) return AppColors.warning;
    return AppColors.danger;
  }
}
