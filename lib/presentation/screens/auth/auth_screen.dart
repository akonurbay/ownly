import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/ownly_logo.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  String? _validate() {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    if (email.isEmpty || !email.contains('@')) return 'Введите корректный email';
    if (password.length < 6) return 'Пароль — минимум 6 символов';
    if (!_isLogin && _nameCtrl.text.trim().isEmpty) return 'Введите имя';
    return null;
  }

  Future<void> _submit() async {
    final error = _validate();
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    setState(() => _error = null);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userEmail', _emailCtrl.text.trim());
    if (!_isLogin) {
      await prefs.setString('userName', _nameCtrl.text.trim());
    }
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: OwnlyLogo(size: 56, radius: 18)),
              const SizedBox(height: 16),
              Center(
                child: Text('Ownly', style: AppTextStyles.h2),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  'Личный дневник мест',
                  style: AppTextStyles.caption,
                ),
              ),
              const SizedBox(height: 32),

              // Tab switcher
              Container(
                height: 44,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.bgDeep,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    _Tab(
                      label: 'Войти',
                      active: _isLogin,
                      onTap: () => setState(() { _isLogin = true; _error = null; }),
                    ),
                    _Tab(
                      label: 'Регистрация',
                      active: !_isLogin,
                      onTap: () => setState(() { _isLogin = false; _error = null; }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Name field (register only)
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: _isLogin
                    ? const SizedBox.shrink()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _FieldLabel('Имя'),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _nameCtrl,
                            decoration: const InputDecoration(
                              hintText: 'Ваше имя',
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
              ),

              _FieldLabel('Email'),
              const SizedBox(height: 6),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'email@example.com'),
              ),
              const SizedBox(height: 16),

              _FieldLabel('Пароль'),
              const SizedBox(height: 6),
              TextField(
                controller: _passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(hintText: '••••••••'),
              ),
              const SizedBox(height: 28),

              if (_error != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.dangerRed.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.dangerRed.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    _error!,
                    style: AppTextStyles.caption.copyWith(color: AppColors.dangerRed),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              ElevatedButton(
                onPressed: _submit,
                child: Text(
                  _isLogin ? 'Войти' : 'Создать аккаунт',
                  style: AppTextStyles.button,
                ),
              ),

              if (_isLogin) ...[
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Забыли пароль?',
                      style: AppTextStyles.label
                          .copyWith(color: AppColors.textSub),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _Tab({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: active ? AppColors.bgCard : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            boxShadow: active
                ? [
                    const BoxShadow(
                      color: Color(0x142C2416),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    )
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: active ? AppColors.textPrimary : AppColors.textSub,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
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
      style: AppTextStyles.micro.copyWith(color: AppColors.textSub),
    );
  }
}
