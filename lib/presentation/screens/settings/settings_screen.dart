import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Настройки', style: AppTextStyles.h2),
              const SizedBox(height: 20),

              // Profile card
              _ProfileCard(),
              const SizedBox(height: 24),

              // Appearance
              _SectionHeader('Внешний вид'),
              const SizedBox(height: 8),
              _SettingsGroup(children: [
                _ToggleRow(
                  label: 'Тёмная тема',
                  value: settings.darkTheme,
                  onChanged: (_) => notifier.toggleDarkTheme(),
                ),
              ]),

              const SizedBox(height: 16),

              // Notifications
              _SectionHeader('Уведомления'),
              const SizedBox(height: 8),
              _SettingsGroup(children: [
                _ToggleRow(
                  label: 'Машина времени',
                  value: settings.timeMachineNotifications,
                  onChanged: (_) => notifier.toggleTimeMachineNotifs(),
                ),
              ]),

              const SizedBox(height: 16),

              // Data
              _SectionHeader('Данные'),
              const SizedBox(height: 8),
              _SettingsGroup(children: [
                _ToggleRow(
                  label: 'GPS / Геокодинг',
                  value: settings.gpsEnabled,
                  onChanged: (_) => notifier.toggleGps(),
                ),
                _Divider(),
                _ArrowRow(
                  label: 'Экспорт данных',
                  onTap: () {},
                ),
                _Divider(),
                _ArrowRow(
                  label: 'Удалить данные',
                  labelColor: AppColors.dangerRed,
                  onTap: () => _confirmDelete(context, ref),
                ),
              ]),

              const SizedBox(height: 16),

              // About
              _SectionHeader('О приложении'),
              const SizedBox(height: 8),
              _SettingsGroup(children: [
                _InfoRow(label: 'Ownly', value: 'v1.0.0'),
                _Divider(),
                _ArrowRow(
                  label: 'Написать отзыв',
                  onTap: () {},
                ),
              ]),

              const SizedBox(height: 24),

              // Logout
              OutlinedButton(
                onPressed: () => _logout(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.dangerRed,
                  side: const BorderSide(color: AppColors.dangerRed),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999)),
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Выйти из аккаунта'),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) context.go('/auth');
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Удалить данные?'),
        content: const Text(
            'Все места и визиты будут удалены без возможности восстановления.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: AppColors.dangerRed),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatefulWidget {
  @override
  State<_ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<_ProfileCard> {
  String _name = 'Пользователь';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      _name = user?.displayName ?? 'Пользователь';
      _email = user?.email ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: AppColors.accentBg,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text('👤', style: TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_name,
                    style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
                if (_email.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(_email, style: AppTextStyles.caption),
                ],
              ],
            ),
          ),
          Icon(Icons.edit_outlined,
              size: 18, color: AppColors.textMuted),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: AppTextStyles.micro.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.08 * 11,
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;
  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.body)),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: _IOSToggle(value: value),
          ),
        ],
      ),
    );
  }
}

class _IOSToggle extends StatelessWidget {
  final bool value;
  const _IOSToggle({required this.value});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 44,
      height: 26,
      decoration: BoxDecoration(
        color: value ? AppColors.toggleActive : AppColors.border,
        borderRadius: BorderRadius.circular(13),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 200),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _ArrowRow extends StatelessWidget {
  final String label;
  final Color? labelColor;
  final VoidCallback onTap;

  const _ArrowRow({required this.label, this.labelColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body.copyWith(color: labelColor),
              ),
            ),
            Icon(Icons.chevron_right,
                size: 18, color: labelColor ?? AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.body)),
          Text(value, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Divider(height: 1, color: AppColors.borderSub),
    );
  }
}
