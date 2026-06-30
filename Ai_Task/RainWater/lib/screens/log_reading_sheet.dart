import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../app.dart';
import '../providers/rain_provider.dart';
import '../widgets/widgets.dart';

class LogReadingSheet extends StatefulWidget {
  final String tankId;
  const LogReadingSheet({super.key, required this.tankId});

  @override
  State<LogReadingSheet> createState() => _LogReadingSheetState();
}

class _LogReadingSheetState extends State<LogReadingSheet> {
  final _rainfallCtrl = TextEditingController();
  final _harvestedCtrl = TextEditingController();
  final _consumedCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  double _level = 50;

  @override
  void initState() {
    super.initState();
    final tank = context.read<RainProvider>().tanks
        .firstWhere((t) => t.id == widget.tankId);
    _level = tank.levelPercent;
  }

  @override
  void dispose() {
    _rainfallCtrl.dispose();
    _harvestedCtrl.dispose();
    _consumedCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<RainProvider>().logReading(
      tankId: widget.tankId,
      levelPercent: _level,
      rainfallMm: double.tryParse(_rainfallCtrl.text),
      harvestedLiters: double.tryParse(_harvestedCtrl.text),
      consumedLiters: double.tryParse(_consumedCtrl.text),
      notes: _notesCtrl.text.isEmpty ? null : _notesCtrl.text.trim(),
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Reading logged successfully ✓'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Color get _levelColor {
    if (_level >= 70) return AppColors.success;
    if (_level >= 30) return AppColors.primary;
    if (_level >= 15) return AppColors.warning;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    final tank = context.watch<RainProvider>().tanks
        .firstWhere((t) => t.id == widget.tankId);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 22, right: 22, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 30,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(child: Container(
              width: 38, height: 4,
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
            )),
            const SizedBox(height: 18),

            // Tank name
            Row(children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: _levelColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.edit_note_rounded, color: _levelColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Log Reading', style: const TextStyle(
                    color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.w700)),
                  Text(tank.name, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ]),
              ),
            ]),
            const SizedBox(height: 24),

            // Gauge
            Center(
              child: WaterGauge(percent: _level, size: 140, color: _levelColor),
            ),
            const SizedBox(height: 4),

            // Level slider
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Water Level', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    Row(children: [
                      Text('${_level.toInt()}%',
                        style: TextStyle(color: _levelColor, fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(width: 4),
                      Text('· ${(tank.capacityLiters * _level / 100).toStringAsFixed(0)} L',
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                    ]),
                  ],
                ),
                const SizedBox(height: 8),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: _levelColor,
                    inactiveTrackColor: AppColors.bgCardLight,
                    thumbColor: Colors.white,
                    overlayColor: _levelColor.withOpacity(0.15),
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 11),
                    trackHeight: 6,
                  ),
                  child: Slider(
                    value: _level, min: 0, max: 100, divisions: 100,
                    onChanged: (v) => setState(() => _level = v),
                  ),
                ),
                // Color bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.danger, AppColors.warning, AppColors.primary, AppColors.success],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Critical', style: const TextStyle(color: AppColors.danger, fontSize: 9)),
                    Text('Low', style: const TextStyle(color: AppColors.warning, fontSize: 9)),
                    Text('Normal', style: const TextStyle(color: AppColors.primary, fontSize: 9)),
                    Text('Full', style: const TextStyle(color: AppColors.success, fontSize: 9)),
                  ],
                ),
              ]),
            ),
            const SizedBox(height: 14),

            // Additional fields (grid)
            Row(children: [
              Expanded(child: _numField(_rainfallCtrl, 'Rainfall (mm)', Icons.grain_rounded)),
              const SizedBox(width: 10),
              Expanded(child: _numField(_harvestedCtrl, 'Harvested (L)', Icons.arrow_downward_rounded)),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _numField(_consumedCtrl, 'Consumed (L)', Icons.arrow_upward_rounded)),
              const SizedBox(width: 10),
              Expanded(child: _notesFieldSmall()),
            ]),
            const SizedBox(height: 20),

            GradBtn(label: 'Save Reading', icon: Icons.check_rounded, onPressed: _submit),
          ],
        ),
      ),
    );
  }

  Widget _numField(TextEditingController ctrl, String label, IconData icon) {
    return TextFormField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}'))],
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 11),
        prefixIcon: Icon(icon, size: 16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      ),
    );
  }

  Widget _notesFieldSmall() {
    return TextFormField(
      controller: _notesCtrl,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
      decoration: const InputDecoration(
        labelText: 'Notes',
        labelStyle: TextStyle(fontSize: 11),
        prefixIcon: Icon(Icons.notes_rounded, size: 16),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      ),
    );
  }
}
