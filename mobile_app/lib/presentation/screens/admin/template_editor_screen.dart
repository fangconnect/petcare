import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/disease_template.dart';
import '../../../data/models/activity_type.dart';
import '../../providers/admin_provider.dart';

class TemplateEditorScreen extends ConsumerStatefulWidget {
  final String diseaseId;
  final DiseaseTemplate? template;

  const TemplateEditorScreen({
    super.key,
    required this.diseaseId,
    this.template,
  });

  @override
  ConsumerState<TemplateEditorScreen> createState() => _TemplateEditorScreenState();
}

class _TemplateEditorScreenState extends ConsumerState<TemplateEditorScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descController;
  final Map<String, bool> _selectedTypes = {};
  final Map<String, bool> _requiredTypes = {};

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.template?.templateName ?? '');
    _descController = TextEditingController(text: widget.template?.description ?? '');

    // Pre-select activity types from existing template
    if (widget.template != null) {
      for (final at in widget.template!.activityTypes) {
        _selectedTypes[at.activityTypeId] = true;
        _requiredTypes[at.activityTypeId] = at.isRequired;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activityTypesAsync = ref.watch(activityTypesProvider);
    final isEditing = widget.template != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'แก้ไข Template' : 'สร้าง Template ใหม่'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _save,
          ),
        ],
      ),
      body: activityTypesAsync.when(
        data: (activityTypes) => _buildForm(activityTypes),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildForm(List<ActivityType> activityTypes) {
    // Group by category
    final Map<String, List<ActivityType>> grouped = {};
    for (final at in activityTypes) {
      grouped.putIfAbsent(at.category, () => []).add(at);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Template Name
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'ชื่อ Template *',
              border: OutlineInputBorder(),
              hintText: 'เช่น Default CKD Tracking',
            ),
          ),
          const SizedBox(height: 16),

          // Description
          TextField(
            controller: _descController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'คำอธิบาย',
              border: OutlineInputBorder(),
              hintText: 'รายละเอียดเพิ่มเติม',
            ),
          ),
          const SizedBox(height: 24),

          // Activity Types Selection
          const Text(
            'เลือกประเภทกิจกรรมที่ต้องติดตาม:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Build sections by category
          ...grouped.entries.map((entry) => _buildCategorySection(entry.key, entry.value)),

          const SizedBox(height: 32),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('บันทึก Template'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String category, List<ActivityType> types) {
    final categoryLabels = {
      'intake': 'การรับเข้า (Intake)',
      'excretion': 'การขับถ่าย (Excretion)',
      'vital': 'สัญญาณชีพ (Vital Signs)',
      'medical': 'การรักษา (Medical)',
      'behavior': 'พฤติกรรม (Behavior)',
      'other': 'อื่นๆ (Other)',
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Text(
              categoryLabels[category] ?? category,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ...types.map((type) => _buildTypeCheckbox(type)),
        ],
      ),
    );
  }

  Widget _buildTypeCheckbox(ActivityType type) {
    final isSelected = _selectedTypes[type.id] ?? false;
    final isRequired = _requiredTypes[type.id] ?? false;

    return CheckboxListTile(
      value: isSelected,
      onChanged: (val) {
        setState(() {
          _selectedTypes[type.id] = val ?? false;
          if (!(val ?? false)) {
            _requiredTypes.remove(type.id);
          }
        });
      },
      title: Text(type.name),
      subtitle: Text(
        '${type.nameEn ?? ''}${type.units.isNotEmpty ? ' • ${type.units.map((u) => u.name).join(", ")}' : ''}',
        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
      ),
      secondary: isSelected
          ? IconButton(
              icon: Icon(
                isRequired ? Icons.star : Icons.star_border,
                color: isRequired ? Colors.orange : Colors.grey,
              ),
              tooltip: isRequired ? 'จำเป็น' : 'ไม่จำเป็น',
              onPressed: () {
                setState(() {
                  _requiredTypes[type.id] = !isRequired;
                });
              },
            )
          : null,
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกชื่อ Template')),
      );
      return;
    }

    // Build activity types list
    final selectedActivityTypes = _selectedTypes.entries
        .where((e) => e.value)
        .toList();

    if (selectedActivityTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาเลือกอย่างน้อย 1 ประเภทกิจกรรม')),
      );
      return;
    }

    final List<TemplateActivityType> activityTypes = [];
    for (int i = 0; i < selectedActivityTypes.length; i++) {
      final typeId = selectedActivityTypes[i].key;
      activityTypes.add(TemplateActivityType(
        activityTypeId: typeId,
        isRequired: _requiredTypes[typeId] ?? false,
        sortOrder: i,
      ));
    }

    final template = DiseaseTemplate(
      id: widget.template?.id ?? '',
      diseaseId: widget.diseaseId,
      templateName: name,
      description: _descController.text.trim(),
      activityTypes: activityTypes,
    );

    bool success;
    if (widget.template != null) {
      success = await ref.read(adminNotifierProvider.notifier).updateTemplate(widget.template!.id, template);
    } else {
      success = await ref.read(adminNotifierProvider.notifier).createTemplate(template);
    }

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('บันทึกเรียบร้อย')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('เกิดข้อผิดพลาดในการบันทึก')),
        );
      }
    }
  }
}
