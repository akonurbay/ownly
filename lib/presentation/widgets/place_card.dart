import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/entities/place.dart';
import '../providers/places_provider.dart';

class PlaceCard extends ConsumerWidget {
  final Place place;
  final int visitCount;

  const PlaceCard({super.key, required this.place, required this.visitCount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cat = place.category;
    final oc = context.oc;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => context.push('/place/${place.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: oc.bgCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: oc.border),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.2)
                  : const Color(0x0F2C2416),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 120,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [cat.bgColor, oc.bgDeep],
                      ),
                    ),
                  ),
                  if (place.photoPath != null)
                    Positioned.fill(
                      child: Image.file(
                        File(place.photoPath!),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox(),
                      ),
                    )
                  else
                    Center(
                      child: Text(cat.emoji,
                          style: const TextStyle(fontSize: 40)),
                    ),
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(cat.emoji,
                              style: const TextStyle(fontSize: 11)),
                          const SizedBox(width: 4),
                          Text(
                            cat.label,
                            style: context.ts.micro
                                .copyWith(color: cat.color),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (place.isFavorite)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () => ref
                            .read(placesProvider.notifier)
                            .toggleFavorite(place.id),
                        child: const Icon(
                          Icons.favorite,
                          color: AppColors.accent,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: context.ts.cardTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 12, color: oc.textMuted),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          '${place.city} · $visitCount ${_visitWord(visitCount)}',
                          style: context.ts.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _visitWord(int n) {
    if (n % 10 == 1 && n % 100 != 11) return 'визит';
    if (n % 10 >= 2 && n % 10 <= 4 && (n % 100 < 10 || n % 100 >= 20)) {
      return 'визита';
    }
    return 'визитов';
  }
}
