import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/place.dart';
import '../../../domain/entities/visit.dart';
import '../../providers/places_provider.dart';

class TimeMachineScreen extends ConsumerWidget {
  const TimeMachineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final places = ref.watch(placesProvider);
    final visits = ref.watch(visitsProvider);

    final now = DateTime.now();

    final yearAgo = _findVisitsAround(visits, now.subtract(const Duration(days: 365)), 30);
    final monthAgo = _findVisitsAround(visits, now.subtract(const Duration(days: 30)), 7);
    final weekAgo = _findVisitsAround(visits, now.subtract(const Duration(days: 7)), 3);

    final allMemories = [
      if (yearAgo.isNotEmpty) ('Год назад', yearAgo),
      if (monthAgo.isNotEmpty) ('Месяц назад', monthAgo),
      if (weekAgo.isNotEmpty) ('Неделю назад', weekAgo),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Машина времени', style: AppTextStyles.h2),
              const SizedBox(height: 4),
              Text('Воспоминания о ваших местах', style: AppTextStyles.caption),
              const SizedBox(height: 20),

              // Surprise me card
              GestureDetector(
                onTap: () {
                  if (places.isNotEmpty) {
                    final random = places[DateTime.now().millisecond % places.length];
                    context.push('/place/${random.id}');
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2C2416), Color(0xFF4A3728)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x332C2416),
                        blurRadius: 24,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Text('✨', style: TextStyle(fontSize: 40)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Удиви меня',
                              style: AppTextStyles.h3.copyWith(
                                color: const Color(0xFFF7F2EA),
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Случайное воспоминание из вашей коллекции',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        color: AppColors.accent,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              if (allMemories.isEmpty)
                _EmptyState()
              else
                _Timeline(
                  memories: allMemories,
                  places: places,
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Visit> _findVisitsAround(
      List<Visit> visits, DateTime target, int radiusDays) {
    return visits.where((v) {
      final diff = (v.visitedAt.difference(target).inDays).abs();
      return diff <= radiusDays;
    }).toList();
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            const Text('⏳', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text('Пока нет воспоминаний', style: AppTextStyles.h4),
            const SizedBox(height: 8),
            Text(
              'Добавляйте места и возвращайтесь сюда через год',
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  final List<(String, List<Visit>)> memories;
  final List<Place> places;

  const _Timeline({required this.memories, required this.places});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Vertical line
        Positioned(
          left: 20,
          top: 0,
          bottom: 0,
          child: Container(
            width: 2,
            color: AppColors.border,
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: memories.expand((period) {
            final (label, visits) = period;
            return [
              _PeriodHeader(label: label),
              ...visits.take(3).map((v) {
                final place = places.cast<Place?>().firstWhere(
                      (p) => p?.id == v.placeId,
                      orElse: () => null,
                    );
                if (place == null) return const SizedBox.shrink();
                return _TimelineCard(visit: v, place: place);
              }),
            ];
          }).toList(),
        ),
      ],
    );
  }
}

class _PeriodHeader extends StatelessWidget {
  final String label;

  const _PeriodHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 52, bottom: 12, top: 4),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.micro.copyWith(
          color: AppColors.accent,
          letterSpacing: 0.05 * 11,
        ),
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  final Visit visit;
  final Place place;

  const _TimelineCard({required this.visit, required this.place});

  @override
  Widget build(BuildContext context) {
    final cat = place.category;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline dot
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentBg,
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Text('⏳', style: TextStyle(fontSize: 20)),
          ),

          const SizedBox(width: 10),

          // Card
          Expanded(
            child: GestureDetector(
              onTap: () => context.push('/place/${place.id}'),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mini hero
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [cat.bgColor, AppColors.bgDeep],
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        cat.emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(place.name, style: AppTextStyles.cardTitleSm),
                          const SizedBox(height: 4),
                          if (visit.note != null && visit.note!.isNotEmpty)
                            Text(
                              visit.note!,
                              style: AppTextStyles.quote
                                  .copyWith(fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(visit.visitedAt),
                            style: AppTextStyles.micro,
                          ),
                        ],
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

  String _formatDate(DateTime dt) {
    const months = [
      'янв', 'фев', 'мар', 'апр', 'май', 'июн',
      'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }
}
