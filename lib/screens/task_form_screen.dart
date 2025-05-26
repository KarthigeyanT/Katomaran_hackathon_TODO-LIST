import 'package:flutter/material.dart';
import 'package:katomaran_hackathon/theme/app_theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:katomaran_hackathon/models/task.dart';
import 'package:katomaran_hackathon/providers/task_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? taskToEdit;
  
  const TaskFormScreen({super.key, this.taskToEdit});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String _selectedList = 'Personal';
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  final List<PlatformFile> _attachments = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.taskToEdit?.title ?? '');
    _descriptionController = TextEditingController(text: widget.taskToEdit?.description ?? '');
    if (widget.taskToEdit != null) {
      _dueDate = widget.taskToEdit!.dueDate;
      // Set other fields from taskToEdit if needed
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result != null) {
      setState(() {
        _attachments.addAll(result.files);
      });
    }
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      try {
        final taskProvider = Provider.of<TaskProvider>(context, listen: false);
        
        if (widget.taskToEdit != null) {
          // Update existing task
          final updatedTask = Task(
            id: widget.taskToEdit!.id,
            title: _titleController.text,
            description: _descriptionController.text,
            dueDate: _dueDate,
            isCompleted: widget.taskToEdit!.isCompleted,
          );
          taskProvider.updateTask(updatedTask);
          
          if (mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Task updated successfully!')),
            );
          }
        } else {
          // Create new task
          final task = Task(
            id: const Uuid().v4(),
            title: _titleController.text,
            description: _descriptionController.text,
            dueDate: _dueDate,
            isCompleted: false,
          );
          
          taskProvider.addTask(task);
          
          if (mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Task created successfully!')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Material(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 32),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Create Task',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Task name',
                      border: InputBorder.none,
                      filled: true,
                      fillColor: AppTheme.backgroundColor,
                    ),
                    style: theme.textTheme.titleMedium,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a task name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedList,
                    decoration: InputDecoration(
                      hintText: 'List',
                      border: InputBorder.none,
                      filled: true,
                      fillColor: AppTheme.backgroundColor,
                    ),
                    items: ['Personal', 'Work', 'Shopping', 'Others']
                        .map((list) => DropdownMenuItem(
                              value: list,
                              child: Text(list),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedList = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'Description',
                      border: InputBorder.none,
                      filled: true,
                      fillColor: AppTheme.backgroundColor,
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Add to task'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildAddButton(
                        icon: Icons.add,
                        label: 'Subtask',
                        onTap: () {
                          // TODO: Implement subtask functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Subtask functionality coming soon!')),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildAddButton(
                        icon: Icons.checklist,
                        label: 'Checklist',
                        onTap: () {
                          // TODO: Implement checklist functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Checklist functionality coming soon!')),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildAddButton(
                        icon: Icons.calendar_today,
                        label: 'Due Date',
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _dueDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            setState(() {
                              _dueDate = date;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildFileUploadButton(),
                  if (_attachments.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildSectionTitle('Attachments'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _attachments
                          .map((file) => _buildAttachmentItem(file))
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveTask,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Create Task'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppTheme.textSecondary,
      ),
    );
  }

  Widget _buildAddButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18, color: AppTheme.primaryColor),
        label: Text(
          label,
          style: const TextStyle(color: AppTheme.primaryColor),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
  
  Widget _buildFileUploadButton() {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: _pickFiles,
        icon: const Icon(Icons.attach_file, size: 18, color: AppTheme.primaryColor),
        label: const Text(
          'Add File',
          style: TextStyle(color: AppTheme.primaryColor),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentItem(PlatformFile file) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.insert_drive_file, color: AppTheme.primaryColor),
          const SizedBox(width: 8),
          Text(
            file.name,
            style: const TextStyle(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _attachments.remove(file);
              });
            },
            child: const Icon(Icons.close, size: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
