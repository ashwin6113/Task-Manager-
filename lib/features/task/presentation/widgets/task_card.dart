import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/task_entity.dart';
import 'category_chip.dart';
import 'priority_badge.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Styling properties based on selection / completion
    final backgroundColor = task.isCompleted 
        ? const Color(0xFFD3E4FE) // Secondary-container / soft blue color for selection state
        : AppColors.surfaceLowest;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md), // 16px spacing instead of lines
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.borderRadiusMd,
        boxShadow: task.isCompleted
            ? null
            : [
                BoxShadow(
                  color: const Color(0xFF2C3437).withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: AppRadius.borderRadiusMd,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: AppSpacing.paddingMd,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: task.isCompleted,
                  onChanged: (_) => onToggle(),
                  activeColor: AppColors.primary,
                  side: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.5,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          color: task.isCompleted ? Colors.grey.shade600 : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (task.description.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          task.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontFamily: 'Inter',
                            color: Colors.grey.shade600,
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          PriorityBadge(priority: task.priority),
                          const SizedBox(width: AppSpacing.sm),
                          CategoryChip(category: task.category),
                          const Spacer(),
                          Icon(
                            Icons.calendar_month_outlined,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontFamily: 'Inter',
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline, 
                    size: 20, 
                    color: Colors.red.shade400,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.borderRadiusMd,
                        ),
                        title: const Text('Delete Task'),
                        content: const Text('Are you sure you want to delete this task?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              onDelete();
                            },
                            child: Text(
                              'Delete',
                              style: TextStyle(color: Colors.red.shade400),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
