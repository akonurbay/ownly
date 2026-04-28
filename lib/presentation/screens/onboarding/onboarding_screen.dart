import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/ownly_logo.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _page = 0;

  static const _slides = [
    _Slide(
      emoji: '📍',
      title: 'Твои места — только твои',
      sub: 'Ownly — личный дневник мест. Без лайков, без аудитории. Только ты и воспоминания.',
    ),
    _Slide(
      emoji: '✍️',
      title: 'Фиксируй атмосферу',
      sub: 'Настроение, погода, с кем был. Каждый визит — маленькая история.',
    ),
    _Slide(
      emoji: '⏳',
      title: 'Машина времени',
      sub: 'Через год Ownly напомнит: «Год назад ты был здесь». Ностальгия по расписанию.',
    ),
  ];

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    if (mounted) context.go('/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFFEDE6D9), Color(0xFFF7F2EA)],
            stops: [0.0, 1.0],
            transform: GradientRotation(160 * 3.14159 / 180),
          ),
        ),
        child: Stack(
          children: [
            // Decorative blobs
            Positioned(
              top: -60,
              right: -60,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  color: AppColors.accentBg.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -80,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  color: AppColors.goldBg.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const OwnlyLogo(),
                    const Spacer(),
                    // Slide content with animation
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      switchInCurve: Curves.easeOut,
                      child: _SlideContent(
                        key: ValueKey(_page),
                        slide: _slides[_page],
                      ),
                    ),
                    const Spacer(),
                    // Dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _slides.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: i == _page ? 20 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: i == _page
                                ? AppColors.accent
                                : AppColors.border,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // CTA
                    ElevatedButton(
                      onPressed: () {
                        if (_page < _slides.length - 1) {
                          setState(() => _page++);
                        } else {
                          _finish();
                        }
                      },
                      child: Text(
                        _page == _slides.length - 1 ? 'Начать →' : 'Далее',
                        style: AppTextStyles.button,
                      ),
                    ),
                    if (_page < _slides.length - 1) ...[
                      const SizedBox(height: 12),
                      Center(
                        child: TextButton(
                          onPressed: _finish,
                          child: Text(
                            'Пропустить',
                            style: AppTextStyles.label
                                .copyWith(color: AppColors.textSub),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Slide {
  final String emoji;
  final String title;
  final String sub;

  const _Slide({required this.emoji, required this.title, required this.sub});
}

class _SlideContent extends StatelessWidget {
  final _Slide slide;

  const _SlideContent({super.key, required this.slide});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(slide.emoji, style: const TextStyle(fontSize: 72)),
        const SizedBox(height: 24),
        Text(
          slide.title,
          textAlign: TextAlign.center,
          style: AppTextStyles.h1,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 280,
          child: Text(
            slide.sub,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLg,
          ),
        ),
      ],
    );
  }
}
