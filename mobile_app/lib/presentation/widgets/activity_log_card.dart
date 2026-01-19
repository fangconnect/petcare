import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/network/api_client.dart';
import '../../data/repository/log_repository.dart';
import '../../data/models/models.dart';

/// Provider for LogRepository
final logRepositoryProvider = Provider<LogRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return LogRepository(dio);
});

class ActivityLogCard extends ConsumerStatefulWidget {
  final DiseaseActivity diseaseActivity;
  final String petId;
  final VoidCallback? onLogSaved;

  const ActivityLogCard({
    super.key,
    required this.diseaseActivity,
    required this.petId,
    this.onLogSaved,
  });

  @override
  ConsumerState<ActivityLogCard> createState() => _ActivityLogCardState();
}

class _ActivityLogCardState extends ConsumerState<ActivityLogCard> {
  late TextEditingController? _controller;
  late bool _checkboxValue;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    final activity = widget.diseaseActivity.activity;
    if (activity != null) {
      if (activity.inputType == ActivityInputType.checkbox) {
        _checkboxValue = false;
        _controller = null;
      } else {
        _controller = TextEditingController();
        _checkboxValue = false;
      }
    } else {
      _controller = null;
      _checkboxValue = false;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );

    if (pickedTime == null) return;

    setState(() {
      _selectedDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dateStr;
    if (date == today) {
      dateStr = 'Today';
    } else if (date == today.subtract(const Duration(days: 1))) {
      dateStr = 'Yesterday';
    } else {
      dateStr = DateFormat('MMM dd, yyyy').format(dateTime);
    }

    final timeStr = DateFormat('HH:mm').format(dateTime);
    return '$dateStr, $timeStr';
  }

  Future<void> _saveLog() async {
    final activity = widget.diseaseActivity.activity;
    if (activity == null) return;

    // Get the value based on input type
    dynamic value;
    String? note;

    if (activity.inputType == ActivityInputType.checkbox) {
      value = _checkboxValue ? 1.0 : 0.0;
    } else if (activity.inputType == ActivityInputType.number) {
      final text = _controller?.text.trim() ?? '';
      if (text.isEmpty) {
        _showSnackBar('Please enter a value', isError: true);
        return;
      }
      value = double.tryParse(text);
      if (value == null) {
        _showSnackBar('Please enter a valid number', isError: true);
        return;
      }
    } else if (activity.inputType == ActivityInputType.text) {
      final text = _controller?.text.trim() ?? '';
      if (text.isEmpty) {
        _showSnackBar('Please enter a value', isError: true);
        return;
      }
      note = text;
      value = null;
    }

    try {
      final repository = ref.read(logRepositoryProvider);

      await repository.createLog(
        petId: widget.petId,
        activityId: activity.id,
        value: activity.inputType == ActivityInputType.text
            ? null
            : (value is double ? value : null),
        note: note,
        recordedAt: _selectedDate,
      );

      _showSnackBar('Log saved successfully!');

      // Clear the input after successful save
      if (activity.inputType == ActivityInputType.checkbox) {
        setState(() {
          _checkboxValue = false;
        });
      } else {
        _controller?.clear();
      }

      // Reset to current time for next log
      setState(() {
        _selectedDate = DateTime.now();
      });

      // Callback to notify parent
      widget.onLogSaved?.call();
    } catch (e) {
      _showSnackBar('Error saving log: ${e.toString()}', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
        ),
      );
    }
  }

  Widget _buildInputField(Activity activity) {
    switch (activity.inputType) {
      case ActivityInputType.number:
        return TextField(
          controller: _controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          decoration: InputDecoration(
            labelText: 'Enter value',
            hintText: '0.0',
            border: const OutlineInputBorder(),
            suffixText: activity.unit,
          ),
        );
      case ActivityInputType.text:
        return TextField(
          controller: _controller,
          keyboardType: TextInputType.text,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Enter text',
            hintText: 'Enter your note...',
            border: OutlineInputBorder(),
          ),
        );
      case ActivityInputType.checkbox:
        return CheckboxListTile(
          title: const Text('Completed'),
          value: _checkboxValue,
          onChanged: (bool? value) {
            setState(() {
              _checkboxValue = value ?? false;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final activity = widget.diseaseActivity.activity;
    if (activity == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Activity Name and Unit
            Row(
              children: [
                Expanded(
                  child: Text(
                    activity.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                if (activity.unit != null && activity.unit!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      activity.unit!,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Input Field
            _buildInputField(activity),
            const SizedBox(height: 16),
            // Date/Time Picker Row
            InkWell(
              onTap: _selectDateTime,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 20,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDateTime(_selectedDate),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Save Log Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveLog,
                icon: const Icon(Icons.save),
                label: const Text('Save Log'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
