import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final List<AnimationController> _dotControllers;
  late final List<Animation<double>> _dotAnimations;

  static const _splashDuration = Duration(seconds: 2);
  static const _dotCount = 3;

  @override
  void initState() {
    super.initState();
    _initDotAnimations();
    Future.delayed(_splashDuration, _navigate);
  }

  void _initDotAnimations() {
    _dotControllers = List.generate(_dotCount, (i) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) controller.repeat(reverse: true);
      });
      return controller;
    });

    _dotAnimations = _dotControllers
        .map((c) => Tween<double>(begin: 0.3, end: 1.0).animate(
              CurvedAnimation(parent: c, curve: Curves.easeInOut),
            ))
        .toList();
  }

  Future<void> _navigate() async {
    if (!mounted) return;
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');
    if (!mounted) return;
    if (token != null && token.isNotEmpty) {
      context.goNamed(AppRoutes.home);
    } else {
      context.goNamed(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    for (final c in _dotControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navBar,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LogoMark(),
                  const SizedBox(height: 24),
                  const Text(
                    'Safe Mother',
                    style: TextStyle(
                      fontFamily: 'Fraunces',
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Malawi',
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blueLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Maternal health companion',
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 13,
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _LoadingDots(
                    animations: _dotAnimations,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'v1.0.0',
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 11,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(child: _MohBadge()),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.sidebar,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.navy, width: 2),
      ),
      child: const Center(
        child: Text(
          '🤰',
          style: TextStyle(fontSize: 36),
        ),
      ),
    );
  }
}

class _LoadingDots extends StatelessWidget {
  const _LoadingDots({required this.animations});
  final List<Animation<double>> animations;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(animations.length, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: FadeTransition(
            opacity: animations[i],
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.teal,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _MohBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.sidebar,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.navy.withValues(alpha: 0.4), width: 1),
      ),
      child: const Text(
        'Ministry of Health · Republic of Malawi',
        style: TextStyle(
          fontFamily: 'DM Sans',
          fontSize: 11,
          color: AppColors.teal,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
