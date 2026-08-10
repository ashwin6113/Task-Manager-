import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';

class PriorityBadge extends StatelessWidget {

  const PriorityBadge({super.key, required this.priority});
  final String priority;

  Color _getPriorityColor(BuildContext context) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red.shade700;
      case 'medium':
        return Colors.orange.shade800;
      case 'low':
      default:
        return Colors.green.shade700;
    }
  }

  Color _getPriorityBgColor(BuildContext context) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red.shade50;
      case 'medium':
        return Colors.orange.shade50;
      case 'low':
      default:
        return Colors.green.shade50;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getPriorityColor(context);
    final bgColor = _getPriorityBgColor(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.borderRadiusSm,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        priority,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
