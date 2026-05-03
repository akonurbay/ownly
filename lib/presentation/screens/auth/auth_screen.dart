import 'package:firebase_auth/firebase_auth.dart';
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
  bool _loading = false;
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
    setState(() { _error = null; _loading = true; });

    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
        );
      } else {
        final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
        );
        await cred.user?.updateDisplayName(_nameCtrl.text.trim());
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userEmail', _emailCtrl.text.trim());
      if (!_isLogin) {
        await prefs.setString('userName', _nameCtrl.text.trim());
      }

      if (mounted) context.go('/');
    } on FirebaseAuthException catch (e) {
      setState(() { _loading = false; _error = _firebaseError(e.code); });
    } catch (_) {
      setState(() { _loading = false; _error = 'Что-то пошло не так. Попробуйте снова.'; });
    }
  }

  String _firebaseError(String code) {
    return switch (code.toLowerCase()) {
      'user-not-found'               => 'Пользователь не найден',
      'wrong-password'               => 'Неверный пароль',
      'invalid-credential'           => 'Неверный email или пароль',
      'invalid_login_credentials'    => 'Неверный email или пароль',
      'email-already-in-use'         => 'Email уже зарегистрирован',
      'weak-password'                => 'Пароль слишком простой',
      'invalid-email'                => 'Некорректный email',
      'user-disabled'                => 'Аккаунт заблокирован',
      'network-request-failed'       => 'Нет соединения с сетью',
      'too-many-requests'            => 'Слишком много попыток. Попробуйте позже',
      'channel-error'                => 'Нет соединения с сетью',
      _                              => 'Ошибка входа. Попробуйте снова',
    };
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
              Center(child: Text('Ownly', style: AppTextStyles.h2)),
              const SizedBox(height: 6),
              Center(
                child: Text('Личный дневник мест', style: AppTextStyles.caption),
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

              // Name (register only)
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
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(hintText: 'Ваше имя'),
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
                autocorrect: false,
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

              // Error banner
              if (_error != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.dangerRed.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.dangerRed.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    _error!,
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.dangerRed),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Submit button
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _isLogin ? 'Войти' : 'Создать аккаунт',
                        style: AppTextStyles.button,
                      ),
              ),

              if (_isLogin) ...[
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: _loading ? null : _resetPassword,
                    child: Text(
                      'Забыли пароль?',
                      style: AppTextStyles.label.copyWith(color: AppColors.textSub),
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

  Future<void> _resetPassword() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _error = 'Введите email выше, чтобы сбросить пароль');
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Письмо отправлено — проверьте почту')),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _firebaseError(e.code));
    }
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
