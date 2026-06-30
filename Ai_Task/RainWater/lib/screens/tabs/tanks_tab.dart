import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../app.dart';
import '../../providers/rain_provider.dart';
import '../../widgets/widgets.dart';
import '../tank_detail_screen.dart';
import '../log_reading_sheet.dart';

class TanksTab extends StatelessWidget {
  const TanksTab({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<RainProvider>();
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('My Tanks',
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
                GestureDetector(
                  onTap: () => _showAddTank(context, p),
                  child: Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0EA5E9), Color(0xFF06B6D4)],
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(13),
                      boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 14)],
                    ),
                    child: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
                  ),
                ),
              ],
            ),
          ),
          // List
          Expanded(
            child: p.tanks.isEmpty
                ? EmptyState(
                    icon: Icons.storage_outlined,
                    title: 'No tanks added',
                    subtitle: 'Tap + to add your first rainwater\nstorage tank.',
                    action: GradBtn(
                      label: 'Add Tank', icon: Icons.add_rounded,
                      onPressed: () => _showAddTank(context, p),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: p.tanks.length,
                    itemBuilder: (ctx, i) {
                      final tank = p.tanks[i];
                      return TankCard(
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
                        onDelete: () => _confirmDelete(ctx, tank.id, tank.name, p),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showAddTank(BuildContext context, RainProvider p) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddTankSheet(provider: p),
    );
  }

  Future<void> _confirmDelete(BuildContext ctx, String id, String name, RainProvider p) async {
    final ok = await showDialog<bool>(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Delete Tank', style: TextStyle(color: AppColors.textPrimary, fontSize: 17)),
        content: Text('Delete "$name"? All logs will also be removed.',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
          TextButton(onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w600))),
        ],
      ),
    );
    if (ok == true) p.deleteTank(id);
  }

  Route _slide(Widget page) => PageRouteBuilder(
    pageBuilder: (_, a, __) => page,
    transitionsBuilder: (_, a, __, child) =>
      SlideTransition(position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: a, curve: Curves.easeInOutCubic)), child: child),
    transitionDuration: const Duration(milliseconds: 350),
  );
}

// ─── Add Tank Sheet ──────────────────────────────────────────────────────────
class _AddTankSheet extends StatefulWidget {
  final RainProvider provider;
  const _AddTankSheet({required this.provider});

  @override
  State<_AddTankSheet> createState() => _AddTankSheetState();
}

class _AddTankSheetState extends State<_AddTankSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _capacityCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  double _initLevel = 0;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _locationCtrl.dispose();
    _capacityCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.provider.addTank(
      name: _nameCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
      capacityLiters: double.parse(_capacityCtrl.text),
      initialLevel: _initLevel,
      notes: _notesCtrl.text.isEmpty ? null : _notesCtrl.text.trim(),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      padding: EdgeInsets.only(
        left: 22, right: 22, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
              )),
              const SizedBox(height: 20),
              Row(children: [
                Container(width: 40, height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF0EA5E9), Color(0xFF06B6D4)]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Text('Add New Tank', style: TextStyle(
                  color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 22),

              _field(_nameCtrl, 'Tank Name', 'e.g. Main Rooftop Tank', Icons.water_drop_outlined,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null),
              const SizedBox(height: 14),

              _field(_locationCtrl, 'Location', 'e.g. North Wing — Terrace', Icons.location_on_outlined,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null),
              const SizedBox(height: 14),

              _field(_capacityCtrl, 'Total Capacity (Liters)', 'e.g. 5000', Icons.straighten_rounded,
                keyboard: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (double.tryParse(v) == null || double.parse(v) <= 0) return 'Enter valid capacity';
                  return null;
                }),
              const SizedBox(height: 20),

              // Level slider
              const Text('Initial Water Level',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Level', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFF0EA5E9), Color(0xFF06B6D4)]),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('${_initLevel.toInt()}%',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: AppColors.bgCardLight,
                      thumbColor: Colors.white,
                      overlayColor: AppColors.primary.withOpacity(0.15),
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                      trackHeight: 5,
                    ),
                    child: Slider(
                      value: _initLevel, min: 0, max: 100, divisions: 100,
                      onChanged: (v) => setState(() => _initLevel = v),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _notesCtrl,
                maxLines: 2,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                decoration: const InputDecoration(hintText: 'Notes (optional)...', contentPadding: EdgeInsets.all(12)),
              ),
              const SizedBox(height: 22),
              GradBtn(label: 'Add Tank', icon: Icons.add_rounded, onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController ctrl, String label, String hint, IconData icon, {
    TextInputType? keyboard,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(labelText: label, hintText: hint, prefixIcon: Icon(icon, size: 19)),
      validator: validator,
    );
  }
}
