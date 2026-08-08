import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/usecase.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../controllers/task_controller.dart';
import '../providers/task_provider.dart';
import '../state/task_state.dart';
import '../widgets/task_card.dart';
import 'task_form_screen.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(taskControllerProvider.notifier).fetchTasks();
    }
  }

  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      ref.read(taskControllerProvider.notifier).setSearch(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taskControllerProvider);
    final controller = ref.read(taskControllerProvider.notifier);
    final theme = Theme.of(context);
    final profile = ref.watch(userProfileProvider);

    // Listen for error messages
    ref.listen<TaskState>(taskControllerProvider, (previous, next) {
      if (next.status == TaskStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(profile != null ? '${profile.name}\'s Tasks' : 'Smart Task Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(logoutUseCaseProvider).call(const NoParams());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ── SEARCH & FILTERS ──
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search tasks by title...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.borderRadiusMd,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Filter Chips
                    Row(
                      children: ['All', 'Completed', 'Pending'].map((filter) {
                        final isSelected = state.filter.toLowerCase() == filter.toLowerCase();
                        return Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.xs),
                          child: ChoiceChip(
                            label: Text(filter),
                            selected: isSelected,
                            onSelected: (_) {
                              controller.setFilter(filter);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    // Sorting Menu
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.sort),
                      tooltip: 'Sort tasks',
                      onSelected: (value) {
                        final parts = value.split(':');
                        controller.setSorting(parts[0], parts[1] == 'asc');
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'created_at:desc',
                          child: Row(
                            children: [
                              Icon(Icons.date_range, color: theme.colorScheme.primary, size: 18),
                              const SizedBox(width: 8),
                              const Text('Created Date (Newest)'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'due_date:asc',
                          child: Row(
                            children: [
                              Icon(Icons.event, color: theme.colorScheme.primary, size: 18),
                              const SizedBox(width: 8),
                              const Text('Due Date (Earliest)'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'priority:desc',
                          child: Row(
                            children: [
                              Icon(Icons.priority_high, color: theme.colorScheme.primary, size: 18),
                              const SizedBox(width: 8),
                              const Text('Priority (Highest)'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── TASK LIST CONTENT ──
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => controller.fetchTasks(isRefresh: true),
              child: _buildListContent(state, controller),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListContent(TaskState state, TaskController controller) {
    if (state.status == TaskStatus.loading && state.tasks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == TaskStatus.error && state.tasks.isEmpty) {
      return Center(
        child: Padding(
          padding: AppSpacing.paddingMd,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.errorMessage ?? 'An error occurred',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton(
                onPressed: () => controller.fetchTasks(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.displayTasks.isEmpty) {
      return const Center(
        child: Text('No tasks found'),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: AppSpacing.paddingHorizontalMd,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: state.displayTasks.length + 1,
      itemBuilder: (context, index) {
        if (index == state.displayTasks.length) {
          if (!state.hasReachedMax) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Center(child: CircularProgressIndicator()),
            );
          } else {
            return const SizedBox(height: 80);
          }
        }

        final task = state.displayTasks[index];
        return TaskCard(
          task: task,
          onToggle: () => controller.toggleTaskCompletion(task),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskFormScreen(task: task),
              ),
            );
          },
          onDelete: () => controller.deleteTask(task.id!),
        );
      },
    );
  }
}
