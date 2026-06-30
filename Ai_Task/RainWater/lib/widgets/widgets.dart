import 'dart:math';
import 'package:flutter/material.dart';
import '../app.dart';
import '../models/models.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Glass Card
// ─────────────────────────────────────────────────────────────────────────────
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? glowColor;

  const GlassCard({super.key, required this.child, this.padding, this.glowColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppColors.cardGrad,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: (glowColor ?? AppColors.primary).withOpacity(0.07),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Gradient Button
// ─────────────────────────────────────────────────────────────────────────────
class GradBtn extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool loading;

  const GradBtn({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: onPressed != null
              ? const LinearGradient(
                  colors: [Color(0xFF0EA5E9), Color(0xFF06B6D4)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : const LinearGradient(colors: [Color(0xFF1A2E44), Color(0xFF1A2E44)]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: onPressed != null
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 18,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: ElevatedButton(
          onPressed: loading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: loading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 18),
                      const SizedBox(width: 8),
                    ],
                    Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  ],
                ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Water Level Gauge (Custom painted arc)
// ─────────────────────────────────────────────────────────────────────────────
class WaterGauge extends StatefulWidget {
  final double percent;
  final double size;
  final Color? color;
  final bool showLabel;

  const WaterGauge({
    super.key,
    required this.percent,
    this.size = 160,
    this.color,
    this.showLabel = true,
  });

  @override
  State<WaterGauge> createState() => _WaterGaugeState();
}

class _WaterGaugeState extends State<WaterGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _anim = Tween<double>(begin: 0, end: widget.percent)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(WaterGauge old) {
    super.didUpdateWidget(old);
    if (old.percent != widget.percent) {
      _anim = Tween<double>(begin: _anim.value, end: widget.percent)
          .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
      _ctrl
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final color = widget.color ?? _colorForLevel(_anim.value);
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _ArcPainter(value: _anim.value, fillColor: color),
            child: widget.showLabel
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${_anim.value.toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: color,
                            fontSize: widget.size * 0.19,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'full',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: widget.size * 0.075,
                          ),
                        ),
                      ],
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }

  Color _colorForLevel(double v) {
    if (v >= 70) return AppColors.success;
    if (v >= 30) return AppColors.primary;
    if (v >= 15) return AppColors.warning;
    return AppColors.danger;
  }
}

class _ArcPainter extends CustomPainter {
  final double value;
  final Color fillColor;
  _ArcPainter({required this.value, required this.fillColor});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 12;
    const start = pi * 0.75;
    const sweep = pi * 1.5;

    // Track
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r),
      start, sweep, false,
      Paint()
        ..color = const Color(0xFF1A2E44)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 13
        ..strokeCap = StrokeCap.round,
    );

    // Fill
    final fillSweep = sweep * (value / 100).clamp(0, 1);
    if (fillSweep > 0.01) {
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r),
        start, fillSweep, false,
        Paint()
          ..shader = SweepGradient(
            startAngle: start,
            endAngle: start + sweep,
            colors: [
              fillColor.withOpacity(0.5),
              fillColor,
              fillColor.withOpacity(0.85),
            ],
          ).createShader(Rect.fromCircle(center: c, radius: r))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 13
          ..strokeCap = StrokeCap.round,
      );

      // Tip dot
      final angle = start + fillSweep;
      final dotX = c.dx + r * cos(angle);
      final dotY = c.dy + r * sin(angle);
      canvas.drawCircle(
        Offset(dotX, dotY), 7,
        Paint()
          ..color = fillColor.withOpacity(0.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
      canvas.drawCircle(
        Offset(dotX, dotY), 5,
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(_ArcPainter old) =>
      old.value != value || old.fillColor != fillColor;
}

// ─────────────────────────────────────────────────────────────────────────────
// Tank Card
// ─────────────────────────────────────────────────────────────────────────────
class TankCard extends StatelessWidget {
  final TankModel tank;
  final VoidCallback? onTap;
  final VoidCallback? onLog;
  final VoidCallback? onDelete;

  const TankCard({
    super.key,
    required this.tank,
    this.onTap,
    this.onLog,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final sc = _statusColor(tank.status);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: AppColors.cardGrad,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: tank.status == 'critical'
                ? AppColors.danger.withOpacity(0.45)
                : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: sc.withOpacity(0.06),
              blurRadius: 24,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: sc.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.water_outlined, color: sc, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tank.name,
                      style: const TextStyle(
                        color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(children: [
                      const Icon(Icons.location_on_outlined, size: 11, color: AppColors.textMuted),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(tank.location,
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
              // Status chip
              _chip(tank.statusLabel, sc),
            ]),
            const SizedBox(height: 14),
            // Level bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Water Level', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                    Text(
                      '${tank.levelPercent.toStringAsFixed(0)}%  ·  ${tank.currentLiters.toStringAsFixed(0)}/${tank.capacityLiters.toStringAsFixed(0)} L',
                      style: TextStyle(color: sc, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 900),
                    tween: Tween(begin: 0, end: tank.levelPercent / 100),
                    curve: Curves.easeOutCubic,
                    builder: (_, v, __) => LinearProgressIndicator(
                      value: v, minHeight: 7,
                      backgroundColor: AppColors.bgCardLight,
                      valueColor: AlwaysStoppedAnimation<Color>(sc),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(children: [
              if (onLog != null)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onLog,
                    icon: const Icon(Icons.edit_note_rounded, size: 15),
                    label: const Text('Log Reading', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              if (onDelete != null) ...[
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.danger.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger, size: 18),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
                  ),
                ),
              ],
            ]),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, Color c) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(
      color: c.withOpacity(0.12),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: c.withOpacity(0.35)),
    ),
    child: Text(label, style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w700)),
  );

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

// ─────────────────────────────────────────────────────────────────────────────
// Stat Card
// ─────────────────────────────────────────────────────────────────────────────
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final LinearGradient? gradient;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            gradient: gradient ?? LinearGradient(colors: [color.withOpacity(0.7), color]),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(height: 12),
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 3),
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section Header
// ─────────────────────────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const SectionHeader({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(
          color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.w700,
        )),
        if (trailing != null) trailing!,
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty State
// ─────────────────────────────────────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.bgCardLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 38, color: AppColors.textMuted),
          ),
          const SizedBox(height: 18),
          Text(title, style: const TextStyle(
            color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w600,
          )),
          const SizedBox(height: 8),
          Text(subtitle, textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5)),
          if (action != null) ...[const SizedBox(height: 24), action!],
        ],
      ),
    ),
  );
}
