import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/enums.dart';
import '../../providers/places_provider.dart';
import '../../widgets/place_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _search = '';
  PlaceCategory? _activeCategory;

  @override
  Widget build(BuildContext context) {
    final places = ref.watch(placesProvider);
    final visits = ref.watch(visitsProvider);

    final filtered = places.where((p) {
      final matchesSearch = _search.isEmpty ||
          p.name.toLowerCase().contains(_search.toLowerCase()) ||
          p.city.toLowerCase().contains(_search.toLowerCase());
      final matchesCategory =
          _activeCategory == null || p.category == _activeCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    final totalVisits = visits.length;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Мои места', style: AppTextStyles.h2),
                          const SizedBox(height: 2),
                          Text(
                            '${places.length} ${_placeWord(places.length)} · $totalVisits ${_visitWord(totalVisits)}',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                    // FAB
                    GestureDetector(
                      onTap: () => context.push('/add-place'),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.add,
                            color: Colors.white, size: 22),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    onChanged: (v) => setState(() => _search = v),
                    style: AppTextStyles.body.copyWith(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Поиск по названию или городу...',
                      hintStyle: AppTextStyles.body.copyWith(
                          color: AppColors.textMuted, fontSize: 14),
                      prefixIcon: const Icon(Icons.search,
                          size: 15, color: AppColors.textMuted),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 10),
                      isDense: true,
                    ),
                  ),
                ),
              ),
            ),

            // Category filters
            SliverToBoxAdapter(
              child: SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  children: [
                    _FilterChip(
                      label: 'Все',
                      active: _activeCategory == null,
                      onTap: () => setState(() => _activeCategory = null),
                    ),
                    ...PlaceCategory.values.map(
                      (cat) => _FilterChip(
                        label: '${cat.emoji} ${cat.label}',
                        active: _activeCategory == cat,
                        onTap: () => setState(() => _activeCategory =
                            _activeCategory == cat ? null : cat),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Grid
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            if (filtered.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      const Text('🗺', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 16),
                      Text(
                        _search.isNotEmpty || _activeCategory != null
                            ? 'Ничего не найдено'
                            : 'Пока нет мест',
                        style: AppTextStyles.h4,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Нажмите + чтобы добавить первое место',
                        style: AppTextStyles.caption,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final place = filtered[i];
                      final count = visits
                          .where((v) => v.placeId == place.id)
                          .length;
                      return PlaceCard(place: place, visitCount: count);
                    },
                    childCount: filtered.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _placeWord(int n) {
    if (n % 10 == 1 && n % 100 != 11) return 'место';
    if (n % 10 >= 2 && n % 10 <= 4 && (n % 100 < 10 || n % 100 >= 20)) {
      return 'места';
    }
    return 'мест';
  }

  String _visitWord(int n) {
    if (n % 10 == 1 && n % 100 != 11) return 'визит';
    if (n % 10 >= 2 && n % 10 <= 4 && (n % 100 < 10 || n % 100 >= 20)) {
      return 'визита';
    }
    return 'визитов';
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.accent : AppColors.bgCard,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: active ? AppColors.accent : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: active ? Colors.white : AppColors.textSub,
          ),
        ),
      ),
    );
  }
}
