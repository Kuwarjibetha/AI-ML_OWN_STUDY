import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../app.dart';
import '../../providers/rain_provider.dart';
import '../../widgets/widgets.dart';
import '../tank_detail_screen.dart';
import '../log_reading_sheet.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<RainProvider>();
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header ──────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$greeting,',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      const SizedBox(height: 2),
                      Text(
                        p.userName.isEmpty ? 'User' : p.userName.split(' ').first,
                        style: const TextStyle(
                          color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        DateFormat('EEE, d MMM yyyy').format(DateTime.now()),
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0EA5E9), Color(0xFF22D3EE)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [BoxShadow(
                        color: AppColors.primary.withOpacity(0.4), blurRadius: 16,
                      )],
                    ),
                    child: const Icon(Icons.water_drop_rounded, color: Colors.white, size: 22),
                  ),
                ],
              ),
            ),
          ),

          // ── Overall Gauge Card ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: GlassCard(
                glowColor: _gaugeColor(p.overallPercent),
                child: Column(
                  children: [
                    const Text('Overall Storage',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 20),
                    WaterGauge(percent: p.overallPercent, size: 170),
                    const SizedBox(height: 20),
                    const Divider(color: AppColors.border, height: 1),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _miniStat('Current', '${(p.totalCurrent / 1000).toStringAsFixed(1)} KL', AppColors.primary),
                        _vLine(),
                        _miniStat('Capacity', '${(p.totalCapacity / 1000).toStringAsFixed(1)} KL', AppColors.textSecondary),
                        _vLine(),
                        _miniStat('Tanks', '${p.totalTanks}', AppColors.success),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Status Stats Row ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Expanded(child: StatCard(label: 'Normal', value: '${p.normalCount}',
                    icon: Icons.check_circle_outline_rounded, color: AppColors.success,
                    gradient: AppColors.successGrad)),
                  const SizedBox(width: 10),
                  Expanded(child: StatCard(label: 'Low Level', value: '${p.lowCount}',
                    icon: Icons.water_outlined, color: AppColors.warning,
                    gradient: AppColors.warningGrad)),
                  const SizedBox(width: 10),
                  Expanded(child: StatCard(label: 'Critical', value: '${p.criticalCount}',
                    icon: Icons.warning_amber_rounded, color: AppColors.danger,
                    gradient: const LinearGradient(colors: [Color(0xFFDC2626), Color(0xFFEF4444)]))),
                ],
              ),
            ),
          ),

          // ── Alert Banner ─────────────────────────────────────────────────────
          if (p.criticalCount > 0)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.danger.withOpacity(0.3)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.warning_amber_rounded, color: AppColors.danger, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${p.criticalCount} tank${p.criticalCount > 1 ? 's are' : ' is'} critically low — refill needed!',
                        style: const TextStyle(color: AppColors.danger, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ]),
                ),
              ),
            ),

          // ── Tanks section ────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'My Tanks',
              trailing: p.criticalCount + p.lowCount > 0
                  ? _badge('${p.criticalCount + p.lowCount} need attention')
                  : null,
            ),
          ),

          p.tanks.isEmpty
              ? SliverToBoxAdapter(
                  child: EmptyState(
                    icon: Icons.water_drop_outlined,
                    title: 'No tanks yet',
                    subtitle: 'Go to the Tanks tab to add your first storage tank.',
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final tank = p.tanks[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TankCard(
                          tank: tank,
                          onTap: () {
                            p.selectTank(tank.id);
                            Navigator.push(ctx, _slide(TankDetailScreen(tankId: tank.id)));
                          },
                          onLog: () => showModalBottomSheet(
                            context: ctx,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => LogReadingSheet(tankId: tank.id),
                          ),
                        ),
                      );
                    },
                    childCount: p.tanks.length,
                  ),
                ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value, Color color) => Column(children: [
    Text(value, style: TextStyle(color: color, fontSize: 17, fontWeight: FontWeight.w800)),
    const SizedBox(height: 2),
    Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
  ]);

  Widget _vLine() => Container(width: 1, height: 32, color: AppColors.border);

  Widget _badge(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: AppColors.warning.withOpacity(0.15),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.warning.withOpacity(0.4)),
    ),
    child: Text(label, style: const TextStyle(color: AppColors.warning, fontSize: 10, fontWeight: FontWeight.w600)),
  );

  Color _gaugeColor(double p) {
    if (p >= 70) return AppColors.success;
    if (p >= 30) return AppColors.primary;
    if (p >= 15) return AppColors.warning;
    return AppColors.danger;
  }

  Route _slide(Widget page) => PageRouteBuilder(
    pageBuilder: (_, a, __) => page,
    transitionsBuilder: (_, a, __, child) =>
      SlideTransition(position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: a, curve: Curves.easeInOutCubic)), child: child),
    transitionDuration: const Duration(milliseconds: 350),
  );
}
