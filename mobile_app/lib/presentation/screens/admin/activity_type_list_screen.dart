import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/activity_type.dart';
import '../../../data/models/unit.dart';
import '../../providers/admin_provider.dart';

class ActivityTypeListScreen extends ConsumerWidget {
  const ActivityTypeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityTypesAsync = ref.watch(activityTypesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('จัดการประเภทกิจกรรม'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showActivityTypeForm(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('เพิ่มประเภท'),
        backgroundColor: Colors.orange,
      ),
      body: activityTypesAsync.when(
        data: (types) => types.isEmpty
            ? const Center(child: Text('ยังไม่มีประเภทกิจกรรม'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: types.length,
                itemBuilder: (context, index) {
                  final type = types[index];
                  return _ActivityTypeCard(
                    type: type,
                    onEdit: () => _showActivityTypeForm(context, ref, type: type),
                    onDelete: () => _confirmDelete(context, ref, type),
                    onManageUnits: () => _showUnitManagement(context, ref, type),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showActivityTypeForm(BuildContext context, WidgetRef ref, {ActivityType? type}) {
    final isEditing = type != null;
    final nameController = TextEditingController(text: type?.name ?? '');
    final nameEnController = TextEditingController(text: type?.nameEn ?? '');
    String selectedInputType = type?.inputType ?? 'number';
    String selectedCategory = type?.category ?? 'other';
    List<String> selectedUnitIds = type?.units.map((u) => u.id).toList() ?? [];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          final unitsAsync = ref.watch(unitsProvider);
          
          return AlertDialog(
            title: Text(isEditing ? 'แก้ไขประเภทกิจกรรม' : 'เพิ่มประเภทกิจกรรม'),
            content: SizedBox(
              width: 450,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'ชื่อ (ภาษาไทย) *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nameEnController,
                      decoration: const InputDecoration(
                        labelText: 'ชื่อ (English)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedInputType,
                      decoration: const InputDecoration(
                        labelText: 'ประเภท Input',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'number', child: Text('ตัวเลข')),
                        DropdownMenuItem(value: 'text', child: Text('ข้อความ')),
                        DropdownMenuItem(value: 'medication', child: Text('ยา')),
                        DropdownMenuItem(value: 'checkbox', child: Text('เช็คบ็อก')),
                        DropdownMenuItem(value: 'photo', child: Text('รูปภาพ')),
                      ],
                      onChanged: (v) => setState(() => selectedInputType = v ?? 'number'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'หมวดหมู่',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'intake', child: Text('Intake (รับเข้า)')),
                        DropdownMenuItem(value: 'excretion', child: Text('Excretion (ขับถ่าย)')),
                        DropdownMenuItem(value: 'vital', child: Text('Vital Signs')),
                        DropdownMenuItem(value: 'medical', child: Text('Medical')),
                        DropdownMenuItem(value: 'behavior', child: Text('Behavior')),
                        DropdownMenuItem(value: 'other', child: Text('Other')),
                      ],
                      onChanged: (v) => setState(() => selectedCategory = v ?? 'other'),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    
                    // Unit selection section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('หน่วยที่ใช้ได้:', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextButton.icon(
                          onPressed: () => _showAddUnitDialog(context, ref, setState, selectedUnitIds),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('เพิ่มหน่วย'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    unitsAsync.when(
                      data: (allUnits) {
                        final selectedUnits = allUnits.where((u) => selectedUnitIds.contains(u['id'])).toList();
                        if (selectedUnits.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text('ยังไม่ได้เลือกหน่วย', style: TextStyle(color: Colors.grey)),
                            ),
                          );
                        }
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: selectedUnits.map((unit) {
                            return Chip(
                              label: Text(unit['name'] ?? ''),
                              deleteIcon: const Icon(Icons.close, size: 16),
                              onDeleted: () {
                                setState(() => selectedUnitIds.remove(unit['id']));
                              },
                            );
                          }).toList(),
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (e, _) => Text('Error: $e'),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('ยกเลิก'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final name = nameController.text.trim();
                  if (name.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('กรุณากรอกชื่อ')),
                    );
                    return;
                  }

                  Navigator.pop(ctx);

                  final data = ActivityType(
                    id: type?.id ?? '',
                    name: name,
                    nameEn: nameEnController.text.trim().isEmpty ? null : nameEnController.text.trim(),
                    inputType: selectedInputType,
                    category: selectedCategory,
                    isActive: true,
                  );

                  bool success;
                  if (isEditing) {
                    success = await ref.read(adminNotifierProvider.notifier).updateActivityTypeWithUnits(type!.id, data, selectedUnitIds);
                  } else {
                    success = await ref.read(adminNotifierProvider.notifier).createActivityTypeWithUnits(data, selectedUnitIds);
                  }

                  if (context.mounted && success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isEditing ? 'อัปเดตเรียบร้อย' : 'เพิ่มเรียบร้อย')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: Text(isEditing ? 'บันทึก' : 'เพิ่ม', style: const TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddUnitDialog(BuildContext context, WidgetRef ref, StateSetter parentSetState, List<String> selectedUnitIds) {
    final unitsAsync = ref.read(unitsProvider);
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('เลือกหน่วย'),
            TextButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                _showCreateUnitDialog(context, ref, parentSetState, selectedUnitIds);
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('สร้างใหม่'),
            ),
          ],
        ),
        content: SizedBox(
          width: 350,
          height: 300,
          child: unitsAsync.when(
            data: (units) {
              final availableUnits = units.where((u) => !selectedUnitIds.contains(u['id'])).toList();
              if (availableUnits.isEmpty) {
                return const Center(child: Text('ไม่มีหน่วยที่เลือกได้'));
              }
              return ListView.builder(
                itemCount: availableUnits.length,
                itemBuilder: (context, index) {
                  final unit = availableUnits[index];
                  return ListTile(
                    title: Text(unit['name'] ?? ''),
                    subtitle: Text(unit['name_en'] ?? ''),
                    trailing: unit['symbol'] != null ? Chip(label: Text(unit['symbol'])) : null,
                    onTap: () {
                      parentSetState(() => selectedUnitIds.add(unit['id']));
                      Navigator.pop(ctx);
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }

  void _showCreateUnitDialog(BuildContext context, WidgetRef ref, StateSetter parentSetState, List<String> selectedUnitIds) {
    final nameController = TextEditingController();
    final nameEnController = TextEditingController();
    final symbolController = TextEditingController();
    String? selectedCategory;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('สร้างหน่วยใหม่'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'ชื่อ (ภาษาไทย) *',
                  border: OutlineInputBorder(),
                  hintText: 'เช่น มิลลิลิตร',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameEnController,
                decoration: const InputDecoration(
                  labelText: 'ชื่อ (English)',
                  border: OutlineInputBorder(),
                  hintText: 'e.g. milliliter',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: symbolController,
                decoration: const InputDecoration(
                  labelText: 'สัญลักษณ์',
                  border: OutlineInputBorder(),
                  hintText: 'เช่น ml, g, kg',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'หมวดหมู่',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'volume', child: Text('Volume (ปริมาตร)')),
                  DropdownMenuItem(value: 'weight', child: Text('Weight (น้ำหนัก)')),
                  DropdownMenuItem(value: 'count', child: Text('Count (จำนวน)')),
                  DropdownMenuItem(value: 'scale', child: Text('Scale (สเกล)')),
                  DropdownMenuItem(value: 'time', child: Text('Time (เวลา)')),
                ],
                onChanged: (v) => setState(() => selectedCategory = v),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('กรุณากรอกชื่อ')),
                  );
                  return;
                }

                Navigator.pop(ctx);
                
                final success = await ref.read(adminNotifierProvider.notifier).createUnit(
                  name: name,
                  nameEn: nameEnController.text.trim().isEmpty ? null : nameEnController.text.trim(),
                  symbol: symbolController.text.trim().isEmpty ? null : symbolController.text.trim(),
                  category: selectedCategory,
                );

                if (context.mounted && success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('สร้างหน่วยเรียบร้อย')),
                  );
                  // Refresh and re-open add unit dialog
                  ref.invalidate(unitsProvider);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('สร้าง', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showUnitManagement(BuildContext context, WidgetRef ref, ActivityType type) {
    _showActivityTypeForm(context, ref, type: type);
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, ActivityType type) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: Text('ต้องการลบ "${type.name}" หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(adminNotifierProvider.notifier).deleteActivityType(type.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ลบเรียบร้อย')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('ลบ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _ActivityTypeCard extends StatelessWidget {
  final ActivityType type;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onManageUnits;

  const _ActivityTypeCard({
    required this.type,
    required this.onEdit,
    required this.onDelete,
    required this.onManageUnits,
  });

  IconData _getIcon() {
    switch (type.category) {
      case 'intake': return Icons.restaurant;
      case 'excretion': return Icons.wc;
      case 'vital': return Icons.monitor_heart;
      case 'medical': return Icons.medication;
      case 'behavior': return Icons.psychology;
      default: return Icons.category;
    }
  }

  Color _getColor() {
    switch (type.category) {
      case 'intake': return Colors.blue;
      case 'excretion': return Colors.brown;
      case 'vital': return Colors.red;
      case 'medical': return Colors.green;
      case 'behavior': return Colors.purple;
      default: return Colors.grey;
    }
  }

  String _getUnitsText() {
    if (type.units.isEmpty) return '';
    return type.units.map((u) => u.name).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final unitsText = _getUnitsText();
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getColor().withValues(alpha: 0.15),
          child: Icon(_getIcon(), color: _getColor(), size: 20),
        ),
        title: Text(type.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (type.nameEn != null && type.nameEn!.isNotEmpty)
              Text(type.nameEn!),
            Row(
              children: [
                Chip(
                  label: Text(type.category, style: const TextStyle(fontSize: 10)),
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const SizedBox(width: 8),
                if (type.units.isNotEmpty)
                  Text('${type.units.length} units', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (type.units.isNotEmpty) ...[
                  const Text('หน่วยที่ใช้ได้:', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: type.units.map((unit) {
                      return Chip(
                        label: Text(unit.name, style: const TextStyle(fontSize: 12)),
                        avatar: unit.symbol != null ? Text(unit.symbol!, style: const TextStyle(fontSize: 10)) : null,
                        backgroundColor: Colors.orange.shade50,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                ] else ...[
                  const Text('ยังไม่มีหน่วยที่กำหนด', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 8),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('แก้ไข'),
                    ),
                    TextButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                      label: const Text('ลบ', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
