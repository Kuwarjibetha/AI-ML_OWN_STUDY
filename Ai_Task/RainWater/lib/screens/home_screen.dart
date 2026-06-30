import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app.dart';
import '../providers/rain_provider.dart';
import 'tabs/dashboard_tab.dart';
import 'tabs/tanks_tab.dart';
import 'tabs/analytics_tab.dart';
import 'tabs/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _idx = 0;
  late PageController _pageCtrl;

  final _tabs = const [
    DashboardTab(),
    TanksTab(),
    AnalyticsTab(),
    ProfileTab(),
  ];

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  void _onNavTap(int i) {
    setState(() => _idx = i);
    _pageCtrl.animateToPage(i,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGrad),
        child: PageView(
          controller: _pageCtrl,
          physics: const NeverScrollableScrollPhysics(),
          children: _tabs,
        ),
      ),
      bottomNavigationBar: _BottomNav(current: _idx, onTap: _onNavTap),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int current;
  final void Function(int) onTap;
  const _BottomNav({required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        border: const Border(top: BorderSide(color: AppColors.border, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(idx: 0, current: current, icon: Icons.dashboard_rounded, inactiveIcon: Icons.dashboard_outlined, label: 'Dashboard', onTap: onTap),
              _NavItem(idx: 1, current: current, icon: Icons.storage_rounded, inactiveIcon: Icons.storage_outlined, label: 'Tanks', onTap: onTap),
              _NavItem(idx: 2, current: current, icon: Icons.bar_chart_rounded, inactiveIcon: Icons.bar_chart_outlined, label: 'Analytics', onTap: onTap),
              _NavItem(idx: 3, current: current, icon: Icons.person_rounded, inactiveIcon: Icons.person_outline_rounded, label: 'Profile', onTap: onTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int idx, current;
  final IconData icon, inactiveIcon;
  final String label;
  final void Function(int) onTap;

  const _NavItem({
    required this.idx, required this.current,
    required this.icon, required this.inactiveIcon,
    required this.label, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final active = idx == current;
    return GestureDetector(
      onTap: () => onTap(idx),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
        decoration: active
            ? BoxDecoration(
                color: AppColors.primary.withOpacity(0.13),
                borderRadius: BorderRadius.circular(14),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                active ? icon : inactiveIcon,
                key: ValueKey(active),
                color: active ? AppColors.primary : AppColors.textMuted,
                size: 22,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                color: active ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
