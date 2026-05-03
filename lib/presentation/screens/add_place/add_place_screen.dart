import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/place.dart';
import '../../providers/places_provider.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  int _step = 0;
  bool _saving = false;

  // Step 1
  final _nameCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  PlaceCategory _category = PlaceCategory.cafe;
  String? _photoPath;

  // Step 2
  MoodType _mood = MoodType.good;
  WeatherType _weather = WeatherType.sunny;
  CompanionType _companion = CompanionType.alone;
  final _visitNoteCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _cityCtrl.dispose();
    _noteCtrl.dispose();
    _visitNoteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1200,
    );
    if (image != null) setState(() => _photoPath = image.path);
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              _PhotoOption(
                icon: Icons.camera_alt_outlined,
                label: 'Сделать фото',
                onTap: () {
                  Navigator.pop(context);
                  _pickPhoto(ImageSource.camera);
                },
              ),
              const SizedBox(height: 12),
              _PhotoOption(
                icon: Icons.photo_library_outlined,
                label: 'Выбрать из галереи',
                onTap: () {
                  Navigator.pop(context);
                  _pickPhoto(ImageSource.gallery);
                },
              ),
              if (_photoPath != null) ...[
                const SizedBox(height: 12),
                _PhotoOption(
                  icon: Icons.delete_outline,
                  label: 'Удалить фото',
                  color: AppColors.dangerRed,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _photoPath = null);
                  },
                ),
              ],
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _goToStep2() {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Введите название места'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() => _step = 1);
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);

    try {
      final placeId = const Uuid().v4();
      final place = Place(
        id: placeId,
        name: _nameCtrl.text.trim(),
        description: _noteCtrl.text.trim(),
        category: _category,
        city: _cityCtrl.text.trim().isEmpty
            ? 'Неизвестно'
            : _cityCtrl.text.trim(),
        createdAt: DateTime.now(),
        isFavorite: false,
        photoPath: _photoPath,
      );

      await ref.read(placesProvider.notifier).addPlace(place);
      await ref.read(visitsProvider.notifier).addVisit(
            placeId: placeId,
            mood: _mood,
            weather: _weather,
            companion: _companion,
            note: _visitNoteCtrl.text.trim().isEmpty
                ? null
                : _visitNoteCtrl.text.trim(),
          );

      if (mounted) context.go('/');
    } catch (e) {
      setState(() => _saving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ошибка сохранения. Попробуйте снова.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Icon(Icons.close,
                        color: AppColors.textSub, size: 22),
                  ),
                  const Spacer(),
                  Text(
                    _step == 0 ? 'Новое место' : 'Первый визит',
                    style: AppTextStyles.h4,
                  ),
                  const Spacer(),
                  const SizedBox(width: 22),
                ],
              ),
            ),

            // Step dots
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                2,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _step ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i <= _step ? AppColors.accent : AppColors.border,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _step == 0
                    ? _Step1(
                        key: const ValueKey(0),
                        nameCtrl: _nameCtrl,
                        cityCtrl: _cityCtrl,
                        noteCtrl: _noteCtrl,
                        category: _category,
                        photoPath: _photoPath,
                        onPhotoTap: _showPhotoOptions,
                        onCategoryChanged: (c) =>
                            setState(() => _category = c),
                        onNext: _goToStep2,
                      )
                    : _Step2(
                        key: const ValueKey(1),
                        mood: _mood,
                        weather: _weather,
                        companion: _companion,
                        noteCtrl: _visitNoteCtrl,
                        saving: _saving,
                        onMoodChanged: (m) => setState(() => _mood = m),
                        onWeatherChanged: (w) => setState(() => _weather = w),
                        onCompanionChanged: (c) =>
                            setState(() => _companion = c),
                        onBack: () => setState(() => _step = 0),
                        onSave: _save,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Step 1 ───────────────────────────────────────────────────────────────────

class _Step1 extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController cityCtrl;
  final TextEditingController noteCtrl;
  final PlaceCategory category;
  final String? photoPath;
  final VoidCallback onPhotoTap;
  final ValueChanged<PlaceCategory> onCategoryChanged;
  final VoidCallback onNext;

  const _Step1({
    super.key,
    required this.nameCtrl,
    required this.cityCtrl,
    required this.noteCtrl,
    required this.category,
    required this.photoPath,
    required this.onPhotoTap,
    required this.onCategoryChanged,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo area
          GestureDetector(
            onTap: onPhotoTap,
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.bgDeep,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: photoPath != null
                      ? AppColors.accent
                      : AppColors.border,
                  width: 1.5,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: photoPath != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(
                          File(photoPath!),
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.edit,
                                    color: Colors.white, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  'Изменить',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.accentBg,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt_outlined,
                              color: AppColors.accent, size: 24),
                        ),
                        const SizedBox(height: 10),
                        Text('Добавить фото',
                            style: AppTextStyles.label
                                .copyWith(color: AppColors.accent)),
                        const SizedBox(height: 4),
                        Text('камера или галерея',
                            style: AppTextStyles.caption),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 20),

          _FieldLabel('Название места *'),
          const SizedBox(height: 6),
          TextField(
            controller: nameCtrl,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
                hintText: 'Например: Кофейня «Утро»'),
          ),

          const SizedBox(height: 16),

          _FieldLabel('Город'),
          const SizedBox(height: 6),
          TextField(
            controller: cityCtrl,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(hintText: 'Москва'),
          ),

          const SizedBox(height: 16),

          _FieldLabel('Категория'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: PlaceCategory.values.map((cat) {
              final active = category == cat;
              return GestureDetector(
                onTap: () => onCategoryChanged(cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: active ? AppColors.accent : AppColors.bgCard,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: active ? AppColors.accent : AppColors.border,
                    ),
                  ),
                  child: Text(
                    '${cat.emoji} ${cat.label}',
                    style: AppTextStyles.label.copyWith(
                      color: active ? Colors.white : AppColors.textSub,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          _FieldLabel('Личная заметка'),
          const SizedBox(height: 6),
          TextField(
            controller: noteCtrl,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            style:
                AppTextStyles.quote.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Что особенного в этом месте?',
              hintStyle: AppTextStyles.quote,
            ),
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: onNext,
            child: Text('Далее: первый визит →',
                style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }
}

// ─── Step 2 ───────────────────────────────────────────────────────────────────

class _Step2 extends StatelessWidget {
  final MoodType mood;
  final WeatherType weather;
  final CompanionType companion;
  final TextEditingController noteCtrl;
  final bool saving;
  final ValueChanged<MoodType> onMoodChanged;
  final ValueChanged<WeatherType> onWeatherChanged;
  final ValueChanged<CompanionType> onCompanionChanged;
  final VoidCallback onBack;
  final VoidCallback onSave;

  const _Step2({
    super.key,
    required this.mood,
    required this.weather,
    required this.companion,
    required this.noteCtrl,
    required this.saving,
    required this.onMoodChanged,
    required this.onWeatherChanged,
    required this.onCompanionChanged,
    required this.onBack,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Как прошёл этот визит?',
              style: AppTextStyles.quote
                  .copyWith(fontSize: 15, color: AppColors.textSub),
            ),
          ),
          const SizedBox(height: 20),

          _SectionLabel('Настроение'),
          const SizedBox(height: 8),
          _Grid2x2(
            items: MoodType.values,
            selected: mood,
            activeColor: AppColors.accentBg,
            activeBorder: AppColors.accent,
            labelOf: (m) => m.label,
            emojiOf: (m) => m.emoji,
            onTap: onMoodChanged,
          ),

          const SizedBox(height: 20),

          _SectionLabel('Погода'),
          const SizedBox(height: 8),
          _Grid2x2(
            items: WeatherType.values,
            selected: weather,
            activeColor: AppColors.blueBg,
            activeBorder: AppColors.blue,
            labelOf: (w) => w.label,
            emojiOf: (w) => w.emoji,
            onTap: onWeatherChanged,
          ),

          const SizedBox(height: 20),

          _SectionLabel('С кем'),
          const SizedBox(height: 8),
          _Grid2x2(
            items: CompanionType.values,
            selected: companion,
            activeColor: AppColors.accentBg,
            activeBorder: AppColors.accent,
            labelOf: (c) => c.label,
            emojiOf: (c) => switch (c) {
              CompanionType.alone => '🧍',
              CompanionType.friend => '👥',
              CompanionType.couple => '💑',
              CompanionType.family => '👨‍👩‍👧',
            },
            onTap: onCompanionChanged,
          ),

          const SizedBox(height: 20),

          _SectionLabel('Заметка к визиту'),
          const SizedBox(height: 8),
          TextField(
            controller: noteCtrl,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            style:
                AppTextStyles.quote.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Что запомнилось?',
              hintStyle: AppTextStyles.quote,
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: saving ? null : onBack,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSub,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999)),
                    minimumSize: const Size(0, 52),
                  ),
                  child: const Text('← Назад'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: saving ? null : onSave,
                  child: saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text('Сохранить ✓', style: AppTextStyles.button),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

class _PhotoOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const _PhotoOption({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textPrimary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.bgPrimary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: c, size: 20),
            const SizedBox(width: 12),
            Text(label,
                style: AppTextStyles.body.copyWith(color: c)),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: AppTextStyles.micro.copyWith(color: AppColors.textSub),
      );
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) =>
      Text(text, style: AppTextStyles.h4.copyWith(fontSize: 15));
}

class _Grid2x2<T> extends StatelessWidget {
  final List<T> items;
  final T selected;
  final Color activeColor;
  final Color activeBorder;
  final String Function(T) labelOf;
  final String Function(T) emojiOf;
  final ValueChanged<T> onTap;

  const _Grid2x2({
    required this.items,
    required this.selected,
    required this.activeColor,
    required this.activeBorder,
    required this.labelOf,
    required this.emojiOf,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: items.map((item) {
        final active = item == selected;
        return GestureDetector(
          onTap: () => onTap(item),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: active ? activeColor : AppColors.bgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: active ? activeBorder : AppColors.border,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(emojiOf(item),
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  labelOf(item),
                  style: AppTextStyles.label
                      .copyWith(color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
