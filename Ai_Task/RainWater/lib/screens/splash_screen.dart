import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app.dart';
import '../providers/rain_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoCtrl;
  late AnimationController _textCtrl;
  late AnimationController _dotsCtrl;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _glowOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _textFade;

  @override
  void initState() {
    super.initState();

    _logoCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _textCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _dotsCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))
      ..repeat(reverse: true);

    _logoScale = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut));
    _logoOpacity = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _logoCtrl, curve: const Interval(0, 0.5)));
    _glowOpacity = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _logoCtrl, curve: const Interval(0.5, 1)));
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOutCubic));
    _textFade = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut));

    _logoCtrl.forward().then((_) => _textCtrl.forward());

    Future.delayed(const Duration(milliseconds: 2800), _navigate);
  }

  void _navigate() {
    if (!mounted) return;
    final provider = context.read<RainProvider>();
    Navigator.pushReplacementNamed(
      context,
      provider.isLoggedIn ? '/home' : '/login',
    );
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _dotsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGrad),
        child: Stack(
          children: [
            // Decorative blobs
            Positioned(
              top: -120,
              right: -100,
              child: _blob(320, AppColors.primary.withOpacity(0.06)),
            ),
            Positioned(
              bottom: -140,
              left: -80,
              child: _blob(360, AppColors.secondary.withOpacity(0.05)),
            ),
            Positioned(
              top: 200,
              left: -60,
              child: _blob(200, AppColors.accent.withOpacity(0.04)),
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  AnimatedBuilder(
                    animation: _logoCtrl,
                    builder: (_, __) => Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: _buildLogo(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  // Title & tagline
                  SlideTransition(
                    position: _textSlide,
                    child: FadeTransition(
                      opacity: _textFade,
                      child: Column(
                        children: [
                          ShaderMask(
                            shaderCallback: (r) => const LinearGradient(
                              colors: [Color(0xFF38BDF8), Color(0xFF22D3EE)],
                            ).createShader(r),
                            child: const Text(
                              'RainTrack Pro',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 38,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Smart Rainwater Harvesting Monitor',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  // Loading dots
                  FadeTransition(
                    opacity: _textFade,
                    child: _WaveDots(controller: _dotsCtrl),
                  ),
                ],
              ),
            ),

            // Version tag bottom
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _textFade,
                child: const Text(
                  'v1.0.0  ·  Built for University Demo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _glowOpacity,
      builder: (_, child) => Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow ring
          Opacity(
            opacity: _glowOpacity.value * 0.3,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary,
                    blurRadius: 60,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          // Logo circle
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF0EA5E9), Color(0xFF06B6D4), Color(0xFF22D3EE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.5),
                  blurRadius: 30,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Icon(Icons.water_drop_rounded, color: Colors.white, size: 52),
          ),
        ],
      ),
    );
  }

  Widget _blob(double size, Color color) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}

class _WaveDots extends StatelessWidget {
  final AnimationController controller;
  const _WaveDots({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          final offset = (controller.value + i * 0.33) % 1.0;
          final opacity = (1 - (offset - 0.5).abs() * 2).clamp(0.2, 1.0);
          return Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(opacity),
            ),
          );
        }),
      ),
    );
  }
}
