import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../app.dart';
import '../../providers/rain_provider.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';

class AnalyticsTab extends StatefulWidget {
  const AnalyticsTab({super.key});

  @override
  State<AnalyticsTab> createState() => _AnalyticsTabState();
}

class _AnalyticsTabState extends State<AnalyticsTab>
    with SingleTickerProviderStateMixin {
  int _selectedTankIdx = 0;
  int _days = 30;
  late TabController _periodCtrl;

  final _periods = [7, 14, 30];
  final _periodLabels = ['7D', '14D', '30D'];

  @override
  void initState() {
    super.initState();
    _periodCtrl = TabController(length: 3, vsync: this, initialIndex: 1);
    _periodCtrl.addListener(() {
      if (_periodCtrl.indexIsChanging) return;
      setState(() => _days = _periods[_periodCtrl.index]);
    });
  }

  @override
  void dispose() {
    _periodCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<RainProvider>();
    if (p.tanks.isEmpty) {
      return const SafeArea(
        child: EmptyState(
          icon: Icons.bar_chart_outlined,
          title: 'No Analytics Yet',
          subtitle: 'Add tanks and log readings to view\nyour water analytics.',
        ),
      );
    }

    final tank = p.tanks[_selectedTankIdx.clamp(0, p.tanks.length - 1)];
    final chartData = p.getChartData(tank.id, _days);
    final stats = p.getSummaryStats(tank.id, _days);

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: const Text('Analytics',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
            ),
          ),

          // Tank selector
          SliverToBoxAdapter(
            child: SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                itemCount: p.tanks.length,
                itemBuilder: (ctx, i) {
                  final selected = i == _selectedTankIdx;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTankIdx = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: selected ? AppColors.primaryGrad : null,
                        color: selected ? null : AppColors.bgCard,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected ? AppColors.primary : AppColors.border,
                        ),
                      ),
                      child: Text(p.tanks[i].name.split(' ').first,
                        style: TextStyle(
                          color: selected ? Colors.white : AppColors.textSecondary,
                          fontSize: 12, fontWeight: FontWeight.w600,
                        )),
                    ),
                  );
                },
              ),
            ),
          ),

          // Period tabs
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Container(
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.bgCard, borderRadius: BorderRadius.circular(10)),
                child: TabBar(
                  controller: _periodCtrl,
                  tabs: _periodLabels.map((l) => Tab(text: l)).toList(),
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.textMuted,
                  labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  indicator: BoxDecoration(
                    gradient: AppColors.primaryGrad,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  padding: const EdgeInsets.all(3),
                ),
              ),
            ),
          ),

          // Summary stats
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(children: [
                Expanded(child: StatCard(label: 'Avg Level',
                  value: '${stats['avgLevel']!.toStringAsFixed(0)}%',
                  icon: Icons.water_drop_rounded, color: AppColors.primary)),
                const SizedBox(width: 10),
                Expanded(child: StatCard(label: 'Efficiency',
                  value: '${stats['efficiency']!.toStringAsFixed(0)}%',
                  icon: Icons.trending_up_rounded, color: AppColors.success,
                  gradient: AppColors.successGrad)),
                const SizedBox(width: 10),
                Expanded(child: StatCard(label: 'Rainfall',
                  value: '${stats['totalRainfall']!.toStringAsFixed(0)}mm',
                  icon: Icons.grain_rounded, color: AppColors.secondary)),
              ]),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Row(children: [
                Expanded(child: StatCard(label: 'Harvested',
                  value: '${(stats['totalHarvested']! / 1000).toStringAsFixed(1)} KL',
                  icon: Icons.arrow_downward_rounded, color: AppColors.primary)),
                const SizedBox(width: 10),
                Expanded(child: StatCard(label: 'Consumed',
                  value: '${(stats['totalConsumed']! / 1000).toStringAsFixed(1)} KL',
                  icon: Icons.arrow_upward_rounded, color: AppColors.warning,
                  gradient: AppColors.warningGrad)),
              ]),
            ),
          ),

          // Level Chart
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Water Level Trend (%)',
                      style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text('Last $_days days',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 180,
                      child: chartData.isEmpty
                          ? const Center(child: Text('No data', style: TextStyle(color: AppColors.textMuted)))
                          : _buildLineChart(chartData),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bar Chart
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Harvested vs Consumed (L)',
                      style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Row(children: [
                      _legend(AppColors.primary, 'Harvested'),
                      const SizedBox(width: 14),
                      _legend(AppColors.warning, 'Consumed'),
                    ]),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 180,
                      child: chartData.isEmpty
                          ? const Center(child: Text('No data', style: TextStyle(color: AppColors.textMuted)))
                          : _buildBarChart(chartData),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildLineChart(List<AnalyticsPoint> data) {
    final spots = data.asMap().entries.map((e) =>
      FlSpot(e.key.toDouble(), e.value.levelPercent)).toList();

    return LineChart(LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 25,
        getDrawingHorizontalLine: (_) => FlLine(color: AppColors.border, strokeWidth: 0.8),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true, interval: 25, reservedSize: 32,
            getTitlesWidget: (v, _) => Text('${v.toInt()}', style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true, interval: (data.length / 4).ceilToDouble(),
            getTitlesWidget: (v, _) {
              final idx = v.toInt();
              if (idx >= 0 && idx < data.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(DateFormat('d/M').format(data[idx].date),
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 9)),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      minY: 0, maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true, curveSmoothness: 0.35,
          color: AppColors.primary,
          barWidth: 2.5,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [AppColors.primary.withOpacity(0.25), Colors.transparent],
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    ));
  }

  Widget _buildBarChart(List<AnalyticsPoint> data) {
    // Downsample to max 14 bars
    final step = (data.length / 14).ceil().clamp(1, 100);
    final sampled = <AnalyticsPoint>[];
    for (int i = 0; i < data.length; i += step) sampled.add(data[i]);

    return BarChart(BarChartData(
      alignment: BarChartAlignment.spaceAround,
      barTouchData: BarTouchData(enabled: false),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(sideTitles: SideTitles(
          showTitles: true, reservedSize: 36,
          getTitlesWidget: (v, _) => Text('${v.toInt()}',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 9)),
        )),
        bottomTitles: AxisTitles(sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (v, _) {
            final idx = v.toInt();
            if (idx >= 0 && idx < sampled.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(DateFormat('d/M').format(sampled[idx].date),
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 8)),
              );
            }
            return const SizedBox();
          },
        )),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: FlGridData(
        show: true, drawVerticalLine: false,
        getDrawingHorizontalLine: (_) => FlLine(color: AppColors.border, strokeWidth: 0.8),
      ),
      borderData: FlBorderData(show: false),
      barGroups: sampled.asMap().entries.map((e) =>
        BarChartGroupData(
          x: e.key,
          barRods: [
            BarChartRodData(
              toY: e.value.harvested, width: 7,
              gradient: AppColors.primaryGrad,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
            BarChartRodData(
              toY: e.value.consumed, width: 7,
              gradient: AppColors.warningGrad,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ],
          barsSpace: 3,
        )
      ).toList(),
    ));
  }

  Widget _legend(Color c, String label) => Row(children: [
    Container(width: 12, height: 4, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(2))),
    const SizedBox(width: 5),
    Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
  ]);
}
