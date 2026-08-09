import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/theme/app_colors.dart';
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        title: Text(
          profile != null ? '${profile.name}\'s Flow' : 'Daily Flow',
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined, color: Colors.black87),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.borderRadiusMd,
                  ),
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await ref.read(logoutUseCaseProvider).call(const NoParams());
                        await SecureStorageService.clearTokens();
                        ref.read(userProfileProvider.notifier).state = null;
                        if (context.mounted) {
                          context.goNamed(RouteNames.login);
                        }
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
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
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Search tasks by title...',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    prefixIcon: Icon(Icons.search_outlined, color: Colors.grey.shade500, size: 20),
                    filled: true,
                    fillColor: AppColors.surfaceLowest,
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
                      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
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
                                color: isSelected ? Colors.white : Colors.grey.shade700,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                fontSize: 13,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (_) {
                              controller.setFilter(filter);
                            },
                            selectedColor: AppColors.primary,
                            backgroundColor: AppColors.surfaceLowest,
                            checkmarkColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xs),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadius.borderRadiusFull,
                              side: BorderSide(
                                color: isSelected ? Colors.transparent : Colors.grey.shade200,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    // Sorting Menu
                    PopupMenuButton<String>(
                      icon: Icon(Icons.tune_outlined, color: Colors.grey.shade700),
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
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
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
                style: const TextStyle(color: Colors.redAccent),
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No tasks found',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
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
