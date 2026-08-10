import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/empty_states/empty_state_view.dart';
import '../../../../shared/widgets/error_states/error_state_view.dart';
import '../../../../shared/widgets/loading/shimmer_loading.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../controllers/task_controller.dart';
import '../providers/connectivity_provider.dart';
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
    // Instantiate/listen to SyncManager
    ref.watch(syncManagerProvider);

    final connectionStatus = ref.watch(connectivityStatusProvider);
    final isOffline = connectionStatus == ConnectivityStatus.offline;

    final state = ref.watch(taskControllerProvider);
    final controller = ref.read(taskControllerProvider.notifier);
    final profile = ref.watch(userProfileProvider);

    ref.listen<TaskState>(taskControllerProvider, (previous, next) {
      if (next.status == TaskStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.borderRadiusMd,
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: GestureDetector(
            onTap: () => context.pushNamed(RouteNames.profile),
            child: Hero(
              tag: 'profile_avatar',
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  profile != null && profile.name.isNotEmpty
                      ? profile.name[0].toUpperCase()
                      : 'U',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          profile != null ? '${profile.name}\'s Flow' : 'Daily Flow',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: Column(
        children: [
          if (isOffline)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.redAccent.shade400,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off_outlined, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'No Internet Connection — Operating Offline',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          // ── SEARCH & FILTERS ──
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Column(
              children: [
                // Custom Search bar with Fluid Architect properties
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: 'Search tasks by title...',
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
                    prefixIcon: Icon(Icons.search_outlined, color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6), size: 20),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.borderRadiusMd,
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppRadius.borderRadiusMd,
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppRadius.borderRadiusMd,
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Filter Chips (Editorial Chips)
                    Row(
                      children: ['All', 'Completed', 'Pending'].map((filter) {
                        final isSelected = state.filter.toLowerCase() == filter.toLowerCase();
                        return Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: ChoiceChip(
                            label: Text(
                              filter,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: isSelected 
                                    ? Theme.of(context).colorScheme.onPrimary 
                                    : Theme.of(context).colorScheme.onSurfaceVariant,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                fontSize: 13,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (_) {
                              controller.setFilter(filter);
                            },
                            selectedColor: Theme.of(context).colorScheme.primary,
                            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                            checkmarkColor: Theme.of(context).colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xs),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadius.borderRadiusFull,
                              side: BorderSide(
                                color: isSelected ? Colors.transparent : Theme.of(context).colorScheme.outline.withValues(alpha: 0.12),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    // Sorting Menu
                    PopupMenuButton<String>(
                      icon: Icon(Icons.tune_outlined, color: Theme.of(context).colorScheme.onSurface),
                      tooltip: 'Sort tasks',
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.borderRadiusMd,
                      ),
                      onSelected: (value) {
                        final parts = value.split(':');
                        controller.setSorting(parts[0], parts[1] == 'asc');
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'created_at:desc',
                          child: Row(
                            children: [
                              Icon(Icons.date_range_outlined, color: AppColors.primary, size: 18),
                              SizedBox(width: 8),
                              Text('Created Date (Newest)'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'due_date:asc',
                          child: Row(
                            children: [
                              Icon(Icons.event_outlined, color: AppColors.primary, size: 18),
                              SizedBox(width: 8),
                              Text('Due Date (Earliest)'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'priority:desc',
                          child: Row(
                            children: [
                              Icon(Icons.priority_high_outlined, color: AppColors.primary, size: 18),
                              SizedBox(width: 8),
                              Text('Priority (Highest)'),
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
              color: AppColors.primary,
              onRefresh: () => controller.fetchTasks(isRefresh: true),
              child: _buildListContent(state, controller),
            ),
          ),
        ],
      ),
      floatingActionButton: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: AppRadius.borderRadiusFull,
          gradient: const LinearGradient(
            colors: [
              AppColors.primaryGradientStart,
              AppColors.primaryGradientEnd,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGradientStart.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TaskFormScreen(),
              ),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildListContent(TaskState state, TaskController controller) {
    if (state.status == TaskStatus.loading && state.tasks.isEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        itemCount: 5,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: ShimmerLoading(
            width: double.infinity,
            height: 96,
            borderRadius: AppRadius.borderRadiusMd.topLeft.x,
          ),
        ),
      );
    }

    if (state.status == TaskStatus.error && state.tasks.isEmpty) {
      return ErrorStateView(
        errorMessage: state.errorMessage ?? 'An error occurred while loading tasks.',
        onRetry: () => controller.fetchTasks(),
      );
    }

    if (state.displayTasks.isEmpty) {
      return EmptyStateView(
        title: 'Your Flow is Clear',
        description: 'You do not have any tasks matching your filters.',
        icon: Icons.assignment_turned_in_outlined,
        actionLabel: 'Refresh',
        onActionPressed: () => controller.fetchTasks(),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: state.displayTasks.length + 1,
      itemBuilder: (context, index) {
        if (index == state.displayTasks.length) {
          if (!state.hasReachedMax) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
            );
          } else {
            return const SizedBox(height: 80);
          }
        }

        final task = state.displayTasks[index];
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 200 + (index.clamp(0, 5) * 50)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 16 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: TaskCard(
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
            ),
          ),
        );
      },
    );
  }
}
