import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/enums.dart';
import '../../providers/places_provider.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final places = ref.watch(placesProvider);
    final visits = ref.watch(visitsProvider);

    final cities = places.map((p) => p.city).toSet().length;
    final favorites = places.where((p) => p.isFavorite).length;

    // Category counts
    final catCounts = <PlaceCategory, int>{};
    for (final p in places) {
      catCounts[p.category] = (catCounts[p.category] ?? 0) + 1;
    }

    // Monthly visits (last 6 months)
    final now = DateTime.now();
    final monthlyData = List.generate(6, (i) {
      final month = DateTime(now.year, now.month - 5 + i);
      final count = visits
          .where((v) =>
              v.visitedAt.year == month.year &&
              v.visitedAt.month == month.month)
          .length;
      return (month, count);
    });

    // Mood counts
    final moodCounts = <MoodType, int>{};
    for (final v in visits) {
      moodCounts[v.mood] = (moodCounts[v.mood] ?? 0) + 1;
    }

    final totalVisits = visits.length;
    final totalCat = places.length;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Аналитика', style: AppTextStyles.h2),
              const SizedBox(height: 4),
              Text('Статистика ваших путешествий',
                  style: AppTextStyles.caption),
              const SizedBox(height: 20),

              // Stats 2x2 grid
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.6,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _StatTile(emoji: '📍', value: '${places.length}', label: 'Мест'),
                  _StatTile(emoji: '🏙', value: '$cities', label: 'Городов'),
                  _StatTile(emoji: '🚶', value: '$totalVisits', label: 'Визитов'),
                  _StatTile(emoji: '❤️', value: '$favorites', label: 'В избранном'),
                ],
              ),

              const SizedBox(height: 20),

              // Traveler profile
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.accentBg, AppColors.goldBg],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ПРОФИЛЬ ПУТЕШЕСТВЕННИКА',
                      style: AppTextStyles.micro
                          .copyWith(color: AppColors.accentDark),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _profileTitle(catCounts),
                      style: AppTextStyles.h3,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _profileSub(places.length, totalVisits),
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Category donut
              if (places.isNotEmpty) ...[
                Text('Категории', style: AppTextStyles.h4),
                const SizedBox(height: 12),
                _CategoryChart(catCounts: catCounts, total: totalCat),
                const SizedBox(height: 20),
              ],

              // Bar chart — monthly activity
              if (visits.isNotEmpty) ...[
                Text('Активность по месяцам', style: AppTextStyles.h4),
                const SizedBox(height: 12),
                _MonthlyChart(monthlyData: monthlyData),
                const SizedBox(height: 20),
              ],

              // Mood donut
              if (visits.isNotEmpty) ...[
                Text('Настроения', style: AppTextStyles.h4),
                const SizedBox(height: 12),
                _MoodChart(moodCounts: moodCounts, total: totalVisits),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _profileTitle(Map<PlaceCategory, int> counts) {
    if (counts.isEmpty) return '🗺 Исследователь';
    final top = counts.entries.reduce((a, b) => a.value >= b.value ? a : b);
    return switch (top.key) {
      PlaceCategory.cafe => '☕ Кофейный исследователь',
      PlaceCategory.nature => '🌿 Любитель природы',
      PlaceCategory.museum => '🏛 Ценитель культуры',
      PlaceCategory.restaurant => '🍽 Гастрономический турист',
      PlaceCategory.other => '📍 Городской исследователь',
    };
  }

  String _profileSub(int places, int visits) {
    if (places == 0) return 'Начните добавлять места';
    return 'Посетили $places ${_placeWord(places)}, оставили $visits ${_visitWord(visits)}';
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

class _StatTile extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;

  const _StatTile({required this.emoji, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.h2),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _CategoryChart extends StatelessWidget {
  final Map<PlaceCategory, int> catCounts;
  final int total;

  const _CategoryChart({required this.catCounts, required this.total});

  @override
  Widget build(BuildContext context) {
    if (total == 0) return const SizedBox.shrink();

    final sections = catCounts.entries.map((e) {
      return PieChartSectionData(
        value: e.value.toDouble(),
        color: e.key.color,
        title: '',
        radius: 40,
        showTitle: false,
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 25,
                sectionsSpace: 2,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: catCounts.entries.map((e) {
                final pct = ((e.value / total) * 100).round();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: e.key.color,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(e.key.label,
                            style: AppTextStyles.caption),
                      ),
                      Text(
                        '$pct%',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSub,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthlyChart extends StatelessWidget {
  final List<(DateTime, int)> monthlyData;

  const _MonthlyChart({required this.monthlyData});

  @override
  Widget build(BuildContext context) {
    const monthLabels = ['янв', 'фев', 'мар', 'апр', 'май', 'июн',
        'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'];

    final maxVal =
        monthlyData.map((e) => e.$2).reduce((a, b) => a > b ? a : b);

    return Container(
      height: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: BarChart(
        BarChartData(
          maxY: (maxVal + 1).toDouble(),
          barGroups: monthlyData.asMap().entries.map((entry) {
            final idx = entry.key;
            final val = entry.value.$2.toDouble();
            final opacity = maxVal == 0 ? 0.3 : 0.4 + 0.6 * (val / maxVal);
            return BarChartGroupData(
              x: idx,
              barRods: [
                BarChartRodData(
                  toY: val,
                  color: AppColors.accent.withValues(alpha: opacity),
                  width: 18,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
              ],
            );
          }).toList(),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, meta) {
                  final idx = val.toInt();
                  if (idx < 0 || idx >= monthlyData.length) {
                    return const SizedBox.shrink();
                  }
                  final month = monthlyData[idx].$1;
                  return Text(
                    monthLabels[month.month - 1],
                    style: AppTextStyles.micro.copyWith(fontSize: 10),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MoodChart extends StatelessWidget {
  final Map<MoodType, int> moodCounts;
  final int total;

  const _MoodChart({required this.moodCounts, required this.total});

  @override
  Widget build(BuildContext context) {
    if (total == 0) return const SizedBox.shrink();

    final sections = moodCounts.entries.map((e) {
      return PieChartSectionData(
        value: e.value.toDouble(),
        color: e.key.color,
        title: '',
        radius: 40,
        showTitle: false,
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 25,
                sectionsSpace: 2,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: moodCounts.entries.map((e) {
                final pct = ((e.value / total) * 100).round();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: e.key.color,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(e.key.emoji,
                          style: const TextStyle(fontSize: 13)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(e.key.label,
                            style: AppTextStyles.caption),
                      ),
                      Text(
                        '$pct%',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSub,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
