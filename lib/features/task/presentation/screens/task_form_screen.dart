import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/buttons/custom_button.dart';
import '../../../../shared/widgets/text_fields/custom_text_field.dart';
import '../../domain/entities/task_entity.dart';
import '../providers/task_provider.dart';
import '../state/task_state.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  const TaskFormScreen({super.key, this.task});
  final TaskEntity? task;

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late String _priority;
  late String _category;
  late DateTime _dueDate;

  final List<String> _priorities = ['Low', 'Medium', 'High'];
  final List<String> _categories = ['Work', 'Personal', 'Shopping', 'Others'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descController = TextEditingController(text: widget.task?.description ?? '');
    _priority = widget.task?.priority ?? 'Medium';
    _category = widget.task?.category ?? 'Work';
    _dueDate = widget.task?.dueDate ?? DateTime.now().add(const Duration(days: 1));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final taskController = ref.read(taskControllerProvider.notifier);

      final taskToSave = widget.task?.copyWith(
            title: _titleController.text.trim(),
            description: _descController.text.trim(),
            priority: _priority,
            category: _category,
            dueDate: _dueDate,
          ) ??
          TaskEntity(
            title: _titleController.text.trim(),
            description: _descController.text.trim(),
            priority: _priority,
            category: _category,
            dueDate: _dueDate,
          );

      final success = widget.task == null
          ? await taskController.createTask(taskToSave)
          : await taskController.updateTask(taskToSave);

      if (success && mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taskControllerProvider);

    // Common minimalist decoration for input fields in this form
    InputDecoration inputDecoration(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 14,
        ),
        floatingLabelStyle: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: AppColors.surfaceLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
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
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(
          widget.task == null ? 'Create Task' : 'Edit Task',
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── EDITORIAL WORKSPACE CARD ──
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLowest,
                  borderRadius: AppRadius.borderRadiusLg,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2C3437).withOpacity(0.04),
                      blurRadius: 32,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextField(
                      controller: _titleController,
                      label: 'Task Title',
                      enabled: state.status != TaskStatus.submitting,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    CustomTextField(
                      controller: _descController,
                      label: 'Description',
                      maxLines: 3,
                      enabled: state.status != TaskStatus.submitting,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DropdownButtonFormField<String>(
                      value: _priority,
                      decoration: inputDecoration('Priority'),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      dropdownColor: AppColors.surfaceLowest,
                      items: _priorities.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(fontSize: 15, color: Colors.black87)),
                        );
                      }).toList(),
                      onChanged: state.status == TaskStatus.submitting
                          ? null
                          : (newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _priority = newValue;
                                });
                              }
                            },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DropdownButtonFormField<String>(
                      value: _category,
                      decoration: inputDecoration('Category'),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      dropdownColor: AppColors.surfaceLowest,
                      items: _categories.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(fontSize: 15, color: Colors.black87)),
                        );
                      }).toList(),
                      onChanged: state.status == TaskStatus.submitting
                          ? null
                          : (newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _category = newValue;
                                });
                              }
                            },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    InkWell(
                      onTap: state.status == TaskStatus.submitting ? null : () => _selectDueDate(context),
                      borderRadius: AppRadius.borderRadiusMd,
                      child: InputDecorator(
                        decoration: inputDecoration('Due Date'),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                              style: const TextStyle(fontSize: 15, color: Colors.black87),
                            ),
                            const Icon(Icons.calendar_month_outlined, color: AppColors.primary, size: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    CustomButton(
                      text: widget.task == null ? 'Create Task' : 'Save Changes',
                      isLoading: state.status == TaskStatus.submitting,
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
