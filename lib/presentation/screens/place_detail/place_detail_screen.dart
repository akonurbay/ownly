import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/visit.dart';
import '../../providers/places_provider.dart';
import '../../widgets/visit_card.dart';

class PlaceDetailScreen extends ConsumerStatefulWidget {
  final String placeId;

  const PlaceDetailScreen({super.key, required this.placeId});

  @override
  ConsumerState<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends ConsumerState<PlaceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final places = ref.watch(placesProvider);
    final place = places.where((p) => p.id == widget.placeId).firstOrNull;
    final oc = context.oc;

    if (place == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Место не найдено')),
      );
    }

    final visits = ref
        .watch(visitsProvider)
        .where((v) => v.placeId == widget.placeId)
        .toList();

    final cat = place.category;
    final bestMood = _bestMood(visits);

    return Scaffold(
      backgroundColor: oc.bgPrimary,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [cat.bgColor, oc.bgDeep],
                    ),
                  ),
                  child: place.photoPath != null
                      ? Image.file(
                          File(place.photoPath!),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => Center(
                            child: Text(
                              cat.emoji,
                              style: TextStyle(
                                fontSize: 64,
                                color: Colors.black.withValues(alpha: 0.4),
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            cat.emoji,
                            style: TextStyle(
                              fontSize: 64,
                              color: Colors.black.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _CircleButton(
                          icon: Icons.chevron_left,
                          onTap: () => context.pop(),
                        ),
                        Row(
                          children: [
                            _CircleButton(
                              icon: place.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              iconColor: place.isFavorite
                                  ? AppColors.accent
                                  : oc.textSub,
                              onTap: () => ref
                                  .read(placesProvider.notifier)
                                  .toggleFavorite(place.id),
                            ),
                            const SizedBox(width: 8),
                            _CircleButton(
                              icon: Icons.share_outlined,
                              onTap: () => _share(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(place.name, style: context.ts.h2),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: cat.bgColor,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(cat.emoji,
                                style: const TextStyle(fontSize: 13)),
                            const SizedBox(width: 4),
                            Text(
                              cat.label,
                              style: context.ts.micro
                                  .copyWith(color: cat.color),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 13, color: oc.textMuted),
                      const SizedBox(width: 4),
                      Text(place.city, style: context.ts.caption),
                    ],
                  ),

                  if (place.description.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      '«${place.description}»',
                      style: context.ts.quote,
                    ),
                  ],

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      _StatCard(
                        label: 'Визитов',
                        value: '${visits.length}',
                      ),
                      const SizedBox(width: 10),
                      _StatCard(
                        label: 'Настроение',
                        value: bestMood?.emoji ?? '—',
                      ),
                      const SizedBox(width: 10),
                      _StatCard(
                        label: 'Избранное',
                        value: place.isFavorite ? '❤️' : '—',
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () => _showAddVisitSheet(context),
                    child: Text('+ Добавить визит',
                        style: AppTextStyles.button),
                  ),

                  const SizedBox(height: 24),

                  Text('История визитов', style: context.ts.h4),
                  const SizedBox(height: 12),

                  if (visits.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Пока нет визитов',
                          style: context.ts.caption,
                        ),
                      ),
                    )
                  else
                    ...visits.map((v) => VisitCard(visit: v)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _share(BuildContext context) {
    final place =
        ref.read(placesProvider).where((p) => p.id == widget.placeId).firstOrNull;
    if (place == null) return;

    final visits = ref
        .read(visitsProvider)
        .where((v) => v.placeId == widget.placeId)
        .toList();

    final lines = [
      '${place.category.emoji} ${place.name}',
      '📍 ${place.city}  •  ${place.category.label}',
      if (place.description.isNotEmpty) '«${place.description}»',
      '',
      '🚶 Визитов: ${visits.length}',
      if (place.isFavorite) '❤️ В избранном',
      '',
      'Сохранено в Ownly — личном дневнике мест',
    ];

    final box = context.findRenderObject() as RenderBox?;
    Share.share(
      lines.join('\n'),
      subject: place.name,
      sharePositionOrigin: box != null
          ? box.localToGlobal(Offset.zero) & box.size
          : null,
    );
  }

  MoodType? _bestMood(List<Visit> visits) {
    if (visits.isEmpty) return null;
    final counts = <MoodType, int>{};
    for (final v in visits) {
      counts[v.mood] = (counts[v.mood] ?? 0) + 1;
    }
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  void _showAddVisitSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddVisitSheet(placeId: widget.placeId),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: context.oc.bgCard.withValues(alpha: 0.85),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20,
          color: iconColor ?? context.oc.textSub,
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final oc = context.oc;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: oc.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: oc.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: context.ts.micro),
            const SizedBox(height: 4),
            Text(
              value,
              style: context.ts.label.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddVisitSheet extends StatefulWidget {
  final String placeId;

  const _AddVisitSheet({required this.placeId});

  @override
  State<_AddVisitSheet> createState() => _AddVisitSheetState();
}

class _AddVisitSheetState extends State<_AddVisitSheet> {
  MoodType _mood = MoodType.good;
  final WeatherType _weather = WeatherType.sunny;
  final CompanionType _companion = CompanionType.alone;
  final _noteCtrl = TextEditingController();

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final oc = context.oc;
    return Consumer(
      builder: (context, ref, _) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: oc.bgPrimary,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: oc.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Добавить визит', style: context.ts.h3),
                const SizedBox(height: 20),

                Text('Настроение', style: context.ts.micro),
                const SizedBox(height: 8),
                Row(
                  children: MoodType.values
                      .map((m) => Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _mood = m),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10),
                                decoration: BoxDecoration(
                                  color: _mood == m
                                      ? oc.accentBg
                                      : oc.bgCard,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _mood == m
                                        ? AppColors.accent
                                        : oc.border,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(m.emoji,
                                        style: const TextStyle(
                                            fontSize: 20)),
                                    const SizedBox(height: 2),
                                    Text(
                                      m.label,
                                      style: context.ts.micro
                                          .copyWith(fontSize: 10),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: _noteCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Заметка к визиту...',
                    hintStyle: context.ts.quote,
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () async {
                    await ref.read(visitsProvider.notifier).addVisit(
                          placeId: widget.placeId,
                          mood: _mood,
                          weather: _weather,
                          companion: _companion,
                          note: _noteCtrl.text.isEmpty
                              ? null
                              : _noteCtrl.text,
                        );
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: Text('Сохранить ✓', style: AppTextStyles.button),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
