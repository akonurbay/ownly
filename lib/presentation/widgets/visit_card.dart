import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/entities/visit.dart';

class VisitCard extends StatelessWidget {
  final Visit visit;

  const VisitCard({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    final oc = context.oc;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: oc.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: oc.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _formatDate(visit.visitedAt),
                style: context.ts.label.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              Text(visit.mood.emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(visit.weather.emoji, style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 4),
          Text(visit.companion.label, style: context.ts.caption),
          if (visit.note != null && visit.note!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              '«${visit.note}»',
              style: context.ts.quote.copyWith(fontSize: 13),
            ),
          ],
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
