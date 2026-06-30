import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app.dart';
import '../../providers/rain_provider.dart';
import '../../widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  bool _isSignUp = false;
  bool _obscure = true;

  late AnimationController _animCtrl;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));
    _fadeAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final p = context.read<RainProvider>();
    bool ok;
    if (_isSignUp) {
      ok = await p.signUp(_nameCtrl.text, _emailCtrl.text, _passCtrl.text);
    } else {
      ok = await p.login(_emailCtrl.text, _passCtrl.text);
    }
    if (ok && mounted) Navigator.pushReplacementNamed(context, '/home');
  }

  void _toggleMode() {
    setState(() => _isSignUp = !_isSignUp);
    _animCtrl
      ..reset()
      ..forward();
    context.read<RainProvider>().clearError();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<RainProvider>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGrad),
        child: Stack(
          children: [
            Positioned(top: -100, right: -80, child: _blob(300, AppColors.primary.withOpacity(0.07))),
            Positioned(bottom: -80, left: -60, child: _blob(280, AppColors.secondary.withOpacity(0.05))),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.07),
                    _buildHeader(),
                    SizedBox(height: size.height * 0.05),
                    SlideTransition(
                      position: _slideAnim,
                      child: FadeTransition(
                        opacity: _fadeAnim,
                        child: _buildCard(p),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildToggle(),
                    const SizedBox(height: 30),
                    // Demo hint
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 15),
                          SizedBox(width: 8),
                          Text(
                            'Demo: use any email & password (6+ chars)',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF0EA5E9), Color(0xFF22D3EE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 28,
                spreadRadius: 3,
              ),
            ],
          ),
          child: const Icon(Icons.water_drop_rounded, color: Colors.white, size: 38),
        ),
        const SizedBox(height: 18),
        ShaderMask(
          shaderCallback: (r) => const LinearGradient(
            colors: [Color(0xFF38BDF8), Color(0xFF22D3EE)],
          ).createShader(r),
          child: const Text(
            'RainTrack Pro',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _isSignUp ? 'Create your account' : 'Welcome back',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildCard(RainProvider p) {
    return GlassCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isSignUp ? 'Sign Up' : 'Sign In',
              style: const TextStyle(
                color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 22),

            if (_isSignUp) ...[
              _field(_nameCtrl, 'Full Name', Icons.person_outline_rounded, validator: (v) =>
                  v == null || v.isEmpty ? 'Name is required' : null),
              const SizedBox(height: 14),
            ],

            _field(_emailCtrl, 'Email', Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Email is required';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 14),

            _field(_passCtrl, 'Password', Icons.lock_outline_rounded,
              obscure: _obscure,
              suffix: IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: AppColors.textSecondary, size: 20,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password is required';
                if (v.length < 6) return 'Minimum 6 characters';
                return null;
              },
            ),

            if (p.error != null) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.danger.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.danger.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.danger, size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text(p.error!, style: const TextStyle(color: AppColors.danger, fontSize: 12))),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),
            GradBtn(
              label: _isSignUp ? 'Create Account' : 'Sign In',
              icon: _isSignUp ? Icons.person_add_outlined : Icons.login_rounded,
              onPressed: p.isLoading ? null : _submit,
              loading: p.isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isSignUp ? 'Already have an account? ' : "Don't have an account? ",
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        GestureDetector(
          onTap: _toggleMode,
          child: ShaderMask(
            shaderCallback: (r) => const LinearGradient(
              colors: [AppColors.primary, AppColors.accent],
            ).createShader(r),
            child: Text(
              _isSignUp ? 'Sign In' : 'Sign Up',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    bool obscure = false,
    Widget? suffix,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        suffixIcon: suffix,
      ),
      validator: validator,
    );
  }

  Widget _blob(double s, Color c) => Container(
    width: s, height: s,
    decoration: BoxDecoration(shape: BoxShape.circle, color: c),
  );
}
