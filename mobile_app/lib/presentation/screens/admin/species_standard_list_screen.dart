import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repository/admin_repository.dart';

/// Provider for species standards list
final speciesStandardsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = AdminRepository();
  return repo.getAllSpeciesStandards();
});

class SpeciesStandardListScreen extends ConsumerStatefulWidget {
  const SpeciesStandardListScreen({super.key});

  @override
  ConsumerState<SpeciesStandardListScreen> createState() => _SpeciesStandardListScreenState();
}

class _SpeciesStandardListScreenState extends ConsumerState<SpeciesStandardListScreen> {
  final _repo = AdminRepository();

  Future<void> _deleteSpeciesStandard(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: const Text('คุณต้องการลบค่ามาตรฐานนี้?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('ลบ'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _repo.deleteSpeciesStandard(id);
        ref.invalidate(speciesStandardsProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ลบสำเร็จ'), backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('เกิดข้อผิดพลาด: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  void _showAddEditDialog({Map<String, dynamic>? standard}) {
    final isEdit = standard != null;
    final speciesController = TextEditingController(text: standard?['species'] ?? '');
    final breedController = TextEditingController(text: standard?['breed'] ?? '');
    
    // Parse normal ranges
    Map<String, dynamic> normalRanges = {};
    if (standard?['normal_ranges'] != null) {
      if (standard!['normal_ranges'] is String) {
        normalRanges = jsonDecode(standard['normal_ranges']);
      } else if (standard['normal_ranges'] is Map) {
        normalRanges = Map<String, dynamic>.from(standard['normal_ranges']);
      }
    }
    
    final normalRangesController = TextEditingController(
      text: const JsonEncoder.withIndent('  ').convert(normalRanges),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'แก้ไขค่ามาตรฐาน' : 'เพิ่มค่ามาตรฐาน'),
        content: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: speciesController,
                  decoration: const InputDecoration(
                    labelText: 'สายพันธุ์ *',
                    hintText: 'dog, cat, rabbit',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: breedController,
                  decoration: const InputDecoration(
                    labelText: 'พันธุ์ (ถ้ามี)',
                    hintText: 'Siamese, Persian, Labrador',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: normalRangesController,
                  decoration: const InputDecoration(
                    labelText: 'ค่ามาตรฐาน (JSON)',
                    hintText: '{"weight_range": {"min": 2, "max": 10}}',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 8,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (speciesController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('กรุณากรอกสายพันธุ์')),
                );
                return;
              }

              Map<String, dynamic>? parsedRanges;
              try {
                if (normalRangesController.text.isNotEmpty) {
                  parsedRanges = jsonDecode(normalRangesController.text);
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('รูปแบบ JSON ไม่ถูกต้อง'), backgroundColor: Colors.red),
                );
                return;
              }

              try {
                if (isEdit) {
                  await _repo.updateSpeciesStandard(
                    standard['id'],
                    species: speciesController.text,
                    breed: breedController.text,
                    normalRanges: parsedRanges,
                  );
                } else {
                  await _repo.createSpeciesStandard(
                    species: speciesController.text,
                    breed: breedController.text,
                    normalRanges: parsedRanges,
                  );
                }
                ref.invalidate(speciesStandardsProvider);
                if (mounted) Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('เกิดข้อผิดพลาด: $e'), backgroundColor: Colors.red),
                );
              }
            },
            child: Text(isEdit ? 'บันทึก' : 'เพิ่ม'),
          ),
        ],
      ),
    );
  }

  String _getSpeciesLabel(String species) {
    switch (species.toLowerCase()) {
      case 'dog': return '🐕 สุนัข';
      case 'cat': return '🐈 แมว';
      case 'rabbit': return '🐇 กระต่าย';
      case 'bird': return '🐦 นก';
      case 'fish': return '🐟 ปลา';
      default: return species;
    }
  }

  @override
  Widget build(BuildContext context) {
    final standardsAsync = ref.watch(speciesStandardsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('จัดการค่ามาตรฐานสัตว์'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: standardsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(speciesStandardsProvider),
                child: const Text('ลองใหม่'),
              ),
            ],
          ),
        ),
        data: (standards) => standards.isEmpty
            ? const Center(child: Text('ยังไม่มีค่ามาตรฐาน'))
            : ListView.builder(
                itemCount: standards.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final std = standards[index];
                  final species = std['species'] as String? ?? '';
                  final breed = std['breed'] as String? ?? '';
                  
                  // Parse normal ranges for display
                  Map<String, dynamic> normalRanges = {};
                  if (std['normal_ranges'] != null) {
                    if (std['normal_ranges'] is String) {
                      try {
                        normalRanges = jsonDecode(std['normal_ranges']);
                      } catch (_) {}
                    } else if (std['normal_ranges'] is Map) {
                      normalRanges = Map<String, dynamic>.from(std['normal_ranges']);
                    }
                  }
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal.withValues(alpha: 0.2),
                        child: const Icon(Icons.pets, color: Colors.teal),
                      ),
                      title: Text(_getSpeciesLabel(species)),
                      subtitle: breed.isNotEmpty ? Text('พันธุ์: $breed') : null,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showAddEditDialog(standard: std),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteSpeciesStandard(std['id']),
                          ),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('ค่ามาตรฐาน:', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              ...normalRanges.entries.map((entry) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    children: [
                                      Text('• ${entry.key}: ', style: const TextStyle(fontWeight: FontWeight.w500)),
                                      Expanded(child: Text(entry.value.toString())),
                                    ],
                                  ),
                                );
                              }),
                              if (normalRanges.isEmpty)
                                const Text('(ยังไม่มีข้อมูล)', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
