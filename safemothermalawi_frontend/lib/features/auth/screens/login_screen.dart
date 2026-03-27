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
  bool _isPregnantMode = true; // only Pregnant is functional

  // Lockout state
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
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _lockoutSecondsRemaining--;
        if (_lockoutSecondsRemaining <= 0) {
          timer.cancel();
        }
      });
    });
  }

  String _formatLockout(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    if (m > 0) return '$m minutes $s seconds';
    return '$s seconds';
  }

  Future<void> _submit(bool isOnline) async {
    if (!isOnline || _isLockedOut || _isLoading) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.login(_phoneController.text.trim(), _pinController.text.trim());
      if (mounted) context.goNamed(AppRoutes.home);
    } on LockoutException catch (e) {
      _startLockoutTimer(e.remainingSeconds);
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: AppColors.error,
          ),
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
        return _buildScaffold(context, isOnline);
      },
    );
  }

  Widget _buildScaffold(BuildContext context, bool isOnline) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Offline banner
          if (!isOnline) _OfflineBanner(),
          // Lockout banner
          if (_isLockedOut)
            _LockoutBanner(
              message:
                  'Account locked. Try again in ${_formatLockout(_lockoutSecondsRemaining)}',
            ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _TealHeader(),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: _LoginCard(
                      formKey: _formKey,
                      phoneController: _phoneController,
                      pinController: _pinController,
                      pinFocusNode: _pinFocusNode,
                      isPregnantMode: _isPregnantMode,
                      isLoading: _isLoading,
                      isOnline: isOnline,
                      isLockedOut: _isLockedOut,
                      onModeChanged: (pregnant) =>
                          setState(() => _isPregnantMode = pregnant),
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
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

class _OfflineBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.error,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: const SafeArea(
        bottom: false,
        child: Text(
          'No internet connection',
          style: TextStyle(
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

class _LockoutBanner extends StatelessWidget {
  const _LockoutBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.error,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
    );
  }
}

class _TealHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.tealDark,
      padding: const EdgeInsets.only(top: 60, bottom: 32, left: 24, right: 24),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF073D32),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.teal, width: 2),
            ),
            child: const Center(
              child: Text('🤰', style: TextStyle(fontSize: 28)),
            ),
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
              color: AppColors.teal,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.formKey,
    required this.phoneController,
    required this.pinController,
    required this.pinFocusNode,
    required this.isPregnantMode,
    required this.isLoading,
    required this.isOnline,
    required this.isLockedOut,
    required this.onModeChanged,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final TextEditingController pinController;
  final FocusNode pinFocusNode;
  final bool isPregnantMode;
  final bool isLoading;
  final bool isOnline;
  final bool isLockedOut;
  final ValueChanged<bool> onModeChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ModeSelector(
                isPregnantMode: isPregnantMode,
                onChanged: onModeChanged,
              ),
              const SizedBox(height: 24),
              _PhoneField(controller: phoneController),
              const SizedBox(height: 20),
              _PinInput(
                controller: pinController,
                focusNode: pinFocusNode,
              ),
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

class _ModeSelector extends StatelessWidget {
  const _ModeSelector({
    required this.isPregnantMode,
    required this.onChanged,
  });

  final bool isPregnantMode;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ModeCard(
            emoji: '🤰',
            label: 'Pregnant',
            isSelected: isPregnantMode,
            selectedColor: AppColors.teal,
            onTap: () => onChanged(true),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ModeCard(
            emoji: '👶',
            label: 'Postnatal',
            isSelected: !isPregnantMode,
            selectedColor: AppColors.rose,
            onTap: () => onChanged(false),
          ),
        ),
      ],
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? selectedColor : AppColors.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? selectedColor : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Enter your phone number';
        return null;
      },
    );
  }
}

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
                  color: filled
                      ? AppColors.tealLight
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: filled ? AppColors.teal : AppColors.outline,
                    width: filled ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: filled
                      ? Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: AppColors.tealDark,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
                ),
              );
            }),
          ),
        ),
        // Hidden text field that captures input
        SizedBox(
          height: 0,
          child: TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            maxLength: 4,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            obscureText: true,
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
            ),
            validator: (v) {
              if (v == null || v.length < 4) return 'Enter your 4-digit PIN';
              return null;
            },
          ),
        ),
      ],
    );
  }
}

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
        backgroundColor: AppColors.teal,
        disabledBackgroundColor: AppColors.teal.withOpacity(0.4),
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: isLoading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
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

class _IvrNoticePill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.blue.withOpacity(0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.blue.withOpacity(0.3)),
      ),
      child: const Text(
        '📞  No smartphone? Dial 800-SAFE-MOM',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'DM Sans',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.blue,
        ),
      ),
    );
  }
}
