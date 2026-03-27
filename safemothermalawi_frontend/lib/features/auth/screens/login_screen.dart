import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../core/theme/app_theme.dart';
import '../repositories/auth_repository.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();
  final _pinFocusNode = FocusNode();

  bool _isLoading = false;

  Timer? _lockoutTimer;
  int _lockoutSecondsRemaining = 0;

  @override
  void dispose() {
    _phoneController.dispose();
    _pinController.dispose();
    _pinFocusNode.dispose();
    _lockoutTimer?.cancel();
    super.dispose();
  }

  bool get _isLockedOut => _lockoutSecondsRemaining > 0;

  void _startLockoutTimer(int seconds) {
    _lockoutTimer?.cancel();
    setState(() => _lockoutSecondsRemaining = seconds);
    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) { timer.cancel(); return; }
      setState(() {
        _lockoutSecondsRemaining--;
        if (_lockoutSecondsRemaining <= 0) timer.cancel();
      });
    });
  }

  String _formatLockout(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return m > 0 ? '$m minutes $s seconds' : '$s seconds';
  }

  Future<void> _submit(bool isOnline) async {
    if (!isOnline || _isLockedOut || _isLoading) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).login(
            _phoneController.text.trim(),
            _pinController.text.trim(),
          );
      if (mounted) context.goNamed(AppRoutes.home);
    } on LockoutException catch (e) {
      _startLockoutTimer(e.remainingSeconds);
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: ref.read(connectivityServiceProvider).isOnline,
      initialData: true,
      builder: (context, snapshot) {
        final isOnline = snapshot.data ?? true;
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              if (!isOnline) _Banner(message: 'No internet connection', color: AppColors.error),
              if (_isLockedOut)
                _Banner(
                  message: 'Account locked. Try again in ${_formatLockout(_lockoutSecondsRemaining)}',
                  color: AppColors.amber,
                ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _NavHeader(),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: _LoginCard(
                          formKey: _formKey,
                          phoneController: _phoneController,
                          pinController: _pinController,
                          pinFocusNode: _pinFocusNode,
                          isLoading: _isLoading,
                          isOnline: isOnline,
                          isLockedOut: _isLockedOut,
                          onSubmit: () => _submit(isOnline),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Banner (offline / lockout)
// ---------------------------------------------------------------------------

class _Banner extends StatelessWidget {
  const _Banner({required this.message, required this.color});
  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: color,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: SafeArea(
        bottom: false,
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'DM Sans',
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header — uses navBar colour
// ---------------------------------------------------------------------------

class _NavHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.navBar,
      padding: const EdgeInsets.only(top: 60, bottom: 32, left: 24, right: 24),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.sidebar,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.navy, width: 2),
            ),
            child: const Center(child: Text('🤰', style: TextStyle(fontSize: 28))),
          ),
          const SizedBox(height: 12),
          const Text(
            'Sign In',
            style: TextStyle(
              fontFamily: 'Fraunces',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Safe Mother Malawi',
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 13,
              color: AppColors.blueLight,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Login card
// ---------------------------------------------------------------------------

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.formKey,
    required this.phoneController,
    required this.pinController,
    required this.pinFocusNode,
    required this.isLoading,
    required this.isOnline,
    required this.isLockedOut,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final TextEditingController pinController;
  final FocusNode pinFocusNode;
  final bool isLoading;
  final bool isOnline;
  final bool isLockedOut;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _PhoneField(controller: phoneController),
              const SizedBox(height: 20),
              _PinInput(controller: pinController, focusNode: pinFocusNode),
              const SizedBox(height: 28),
              _SubmitButton(
                isLoading: isLoading,
                isEnabled: isOnline && !isLockedOut,
                onPressed: onSubmit,
              ),
              const SizedBox(height: 16),
              _IvrNoticePill(),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Phone field
// ---------------------------------------------------------------------------

class _PhoneField extends StatelessWidget {
  const _PhoneField({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: const InputDecoration(
        labelText: 'Phone number',
        prefixText: '+265 ',
        prefixStyle: TextStyle(
          fontFamily: 'DM Sans',
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
      ),
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'Enter your phone number' : null,
    );
  }
}

// ---------------------------------------------------------------------------
// PIN input
// ---------------------------------------------------------------------------

class _PinInput extends StatefulWidget {
  const _PinInput({required this.controller, required this.focusNode});
  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  State<_PinInput> createState() => _PinInputState();
}

class _PinInputState extends State<_PinInput> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final pin = widget.controller.text;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PIN',
          style: TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => widget.focusNode.requestFocus(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              final filled = i < pin.length;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: filled ? AppColors.blueLight : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: filled ? AppColors.navy : AppColors.outline,
                    width: filled ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: filled
                      ? Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: AppColors.navBar,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
                ),
              );
            }),
          ),
        ),
        SizedBox(
          height: 0,
          child: TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            maxLength: 4,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            obscureText: true,
            decoration: const InputDecoration(counterText: '', border: InputBorder.none),
            validator: (v) =>
                (v == null || v.length < 4) ? 'Enter your 4-digit PIN' : null,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Submit button
// ---------------------------------------------------------------------------

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.isLoading,
    required this.isEnabled,
    required this.onPressed,
  });

  final bool isLoading;
  final bool isEnabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled && !isLoading ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.navy,
        disabledBackgroundColor: AppColors.navy.withValues(alpha: 0.4),
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: isLoading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
            )
          : const Text(
              'Sign In',
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// IVR notice pill
// ---------------------------------------------------------------------------

class _IvrNoticePill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.blueLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.blue.withValues(alpha: 0.3)),
      ),
      child: const Text(
        '📞  No smartphone? Dial 800-SAFE-MOM',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'DM Sans',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.navy,
        ),
      ),
    );
  }
}
