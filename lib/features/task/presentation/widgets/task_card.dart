import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/task_entity.dart';
import 'category_chip.dart';
import 'priority_badge.dart';

class TaskCard extends StatelessWidget {

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
  });
  final TaskEntity task;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Styling properties based on selection / completion
    final backgroundColor = task.isCompleted 
        ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
        : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.24);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.borderRadiusMd,
        border: Border.all(
          color: theme.brightness == Brightness.dark
              ? theme.colorScheme.outline.withValues(alpha: 0.2)
              : Colors.grey.shade300,
        ),
        boxShadow: task.isCompleted
            ? null
            : [
                BoxShadow(
                  color: theme.brightness == Brightness.dark 
                      ? Colors.black.withValues(alpha: 0.2) 
                      : const Color(0xFF2C3437).withValues(alpha: 0.04),
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
                  activeColor: theme.colorScheme.primary,
                  side: BorderSide(
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
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
                          color: task.isCompleted 
                              ? theme.colorScheme.onSurface.withValues(alpha: 0.4) 
                              : theme.colorScheme.onSurface,
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
                            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
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
                            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontFamily: 'Inter',
                              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
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
