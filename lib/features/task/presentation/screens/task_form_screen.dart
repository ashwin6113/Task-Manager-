import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Create Task' : 'Edit Task'),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingMd,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _titleController,
                label: 'Title',
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
                enabled: state.status != TaskStatus.submitting,
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                initialValue: _priority,
                decoration: InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.borderRadiusMd,
                  ),
                ),
                items: _priorities.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
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
                initialValue: _category,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.borderRadiusMd,
                  ),
                ),
                items: _categories.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
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
                  decoration: InputDecoration(
                    labelText: 'Due Date',
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.borderRadiusMd,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${_dueDate.day}/${_dueDate.month}/${_dueDate.year}'),
                      Icon(Icons.calendar_today, color: theme.colorScheme.primary),
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
      ),
    );
  }
}
