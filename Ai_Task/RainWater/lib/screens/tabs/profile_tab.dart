import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app.dart';
import '../../providers/rain_provider.dart';
import '../../widgets/widgets.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<RainProvider>();
    final initials = p.userName.trim().split(' ')
        .where((w) => w.isNotEmpty).map((w) => w[0]).take(2).join().toUpperCase();

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Avatar
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF0EA5E9), Color(0xFF06B6D4), Color(0xFF22D3EE)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 24, spreadRadius: 2)],
              ),
              child: Center(
                child: Text(initials.isEmpty ? 'U' : initials,
                  style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)),
              ),
            ),
            const SizedBox(height: 14),
            Text(p.userName, style: const TextStyle(
              color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(p.userEmail, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            const SizedBox(height: 28),

            // System stats
            GlassCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _stat('Tanks', '${p.totalTanks}', AppColors.primary),
                  Container(width: 1, height: 36, color: AppColors.border),
                  _stat('Capacity', '${(p.totalCapacity / 1000).toStringAsFixed(1)} KL', AppColors.secondary),
                  Container(width: 1, height: 36, color: AppColors.border),
                  _stat('Level', '${p.overallPercent.toStringAsFixed(0)}%', AppColors.success),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Account info
            _section('Account', [
              _tile(Icons.person_outline_rounded, 'Display Name', p.userName),
              _tile(Icons.email_outlined, 'Email', p.userEmail),
              _tile(Icons.shield_outlined, 'Account Type', 'Standard User'),
            ]),
            const SizedBox(height: 16),

            _section('App', [
              _tile(Icons.info_outline_rounded, 'Version', '1.0.0'),
              _tile(Icons.water_drop_rounded, 'Built With', 'Flutter + Provider'),
              _tile(Icons.school_rounded, 'Purpose', 'University Project Demo'),
            ]),
            const SizedBox(height: 24),

            // Sign Out
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _confirmSignOut(context, p),
                icon: const Icon(Icons.logout_rounded, color: AppColors.danger, size: 17),
                label: const Text('Sign Out',
                  style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w600, fontSize: 14)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppColors.danger, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, String value, Color c) => Column(children: [
    Text(value, style: TextStyle(color: c, fontSize: 19, fontWeight: FontWeight.w800)),
    const SizedBox(height: 2),
    Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
  ]);

  Widget _section(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 8),
          child: Text(title.toUpperCase(),
            style: const TextStyle(
              color: AppColors.textMuted, fontSize: 10,
              fontWeight: FontWeight.w600, letterSpacing: 1.2,
            )),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgCard, borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: items.asMap().entries.map((e) => Column(
              children: [
                e.value,
                if (e.key < items.length - 1)
                  const Divider(height: 1, color: AppColors.border, indent: 54),
              ],
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _tile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 17, color: AppColors.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
          ]),
        ),
      ]),
    );
  }

  Future<void> _confirmSignOut(BuildContext context, RainProvider p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Sign Out', style: TextStyle(color: AppColors.textPrimary)),
        content: const Text('Are you sure you want to sign out?',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
          TextButton(onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w600))),
        ],
      ),
    );
    if (ok == true) {
      p.logout();
      if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
