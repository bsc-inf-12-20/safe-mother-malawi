import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../shared/sidebar.dart';
import '../admin/admin_overview.dart';
import '../dho/dho_overview.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserRole _selectedRole = UserRole.admin;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  void _login() async {
    if (_emailCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      setState(() => _error = 'Please fill in all fields.');
      return;
    }
    setState(() { _loading = true; _error = null; });
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);

    if (!mounted) return;
    if (_selectedRole == UserRole.admin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminOverview()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DhoOverview()),
      );
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: Row(
        children: [
          // Left panel — branding
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.primaryContainer],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.favorite_rounded,
                              color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Safe Mother Malawi',
                          style: GoogleFonts.publicSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      'Maternal &\nNeonatal Health\nPlatform',
                      style: GoogleFonts.publicSans(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Ministry of Health, Malawi\nStaff Portal — Authorized Access Only',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.7),
                        height: 1.6,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        _StatChip(label: 'Districts', value: '28'),
                        const SizedBox(width: 16),
                        _StatChip(label: 'Clinicians', value: '1,240'),
                        const SizedBox(width: 16),
                        _StatChip(label: 'Mothers', value: '48K+'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Right panel — login form
          Container(
            width: 460,
            color: AppColors.surfaceContainerLowest,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back',
                      style: GoogleFonts.publicSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.headings,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Sign in to your staff dashboard',
                      style: GoogleFonts.inter(
                          fontSize: 14, color: AppColors.mutedText),
                    ),
                    const SizedBox(height: 32),

                    // Role selector
                    Text(
                      'SELECT ROLE',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.mutedText,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _RoleChip(
                          label: 'System Admin',
                          icon: Icons.admin_panel_settings_rounded,
                          selected: _selectedRole == UserRole.admin,
                          onTap: () =>
                              setState(() => _selectedRole = UserRole.admin),
                        ),
                        const SizedBox(width: 12),
                        _RoleChip(
                          label: 'DHO',
                          icon: Icons.location_city_rounded,
                          selected: _selectedRole == UserRole.dho,
                          onTap: () =>
                              setState(() => _selectedRole = UserRole.dho),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Email
                    _FieldLabel('EMAIL ADDRESS'),
                    const SizedBox(height: 8),
                    _InputField(
                      controller: _emailCtrl,
                      hint: 'you@moh.gov.mw',
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 20),

                    // Password
                    _FieldLabel('PASSWORD'),
                    const SizedBox(height: 8),
                    _InputField(
                      controller: _passCtrl,
                      hint: '••••••••',
                      icon: Icons.lock_outline_rounded,
                      obscure: _obscure,
                      suffix: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                          color: AppColors.mutedText,
                        ),
                        onPressed: () =>
                            setState(() => _obscure = !_obscure),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot password?',
                          style: GoogleFonts.inter(
                              fontSize: 13, color: AppColors.primary),
                        ),
                      ),
                    ),

                    if (_error != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.criticalBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline_rounded,
                                size: 16, color: AppColors.criticalText),
                            const SizedBox(width: 8),
                            Text(_error!,
                                style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.criticalText)),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Login button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: _loading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                )
                              : Text(
                                  'Sign In',
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.mutedText,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: GoogleFonts.inter(fontSize: 14, color: AppColors.onSurface),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            GoogleFonts.inter(fontSize: 14, color: AppColors.mutedText),
        prefixIcon: Icon(icon, size: 18, color: AppColors.mutedText),
        suffixIcon: suffix,
        filled: true,
        fillColor: AppColors.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _RoleChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          decoration: BoxDecoration(
            color: selected ? AppColors.infoBg : AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Icon(icon,
                  size: 18,
                  color: selected
                      ? AppColors.primary
                      : AppColors.mutedText),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: selected
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: selected
                      ? AppColors.primary
                      : AppColors.mutedText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: GoogleFonts.publicSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.6))),
      ],
    );
  }
}
