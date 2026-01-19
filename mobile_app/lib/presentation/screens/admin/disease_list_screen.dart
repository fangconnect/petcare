import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/disease.dart';
import '../../providers/admin_provider.dart';
import 'disease_form_screen.dart';
import 'template_list_screen.dart';

class DiseaseListScreen extends ConsumerWidget {
  const DiseaseListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diseasesAsync = ref.watch(diseasesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('จัดการโรค'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showDiseaseForm(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('เพิ่มโรค'),
        backgroundColor: Colors.blue,
      ),
      body: diseasesAsync.when(
        data: (diseases) => diseases.isEmpty
            ? const Center(child: Text('ยังไม่มีโรคในระบบ'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: diseases.length,
                itemBuilder: (context, index) {
                  final disease = diseases[index];
                  return _DiseaseCard(
                    disease: disease,
                    onEdit: () => _showDiseaseForm(context, ref, disease: disease),
                    onDelete: () => _confirmDelete(context, ref, disease),
                    onManageTemplates: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TemplateListScreen(disease: disease),
                        ),
                      );
                    },
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showDiseaseForm(BuildContext context, WidgetRef ref, {Disease? disease}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DiseaseFormScreen(disease: disease),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Disease disease) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: Text('ต้องการลบ "${disease.name}" หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(adminNotifierProvider.notifier).deleteDisease(disease.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ลบโรคเรียบร้อย')),
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

class _DiseaseCard extends StatelessWidget {
  final Disease disease;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onManageTemplates;

  const _DiseaseCard({
    required this.disease,
    required this.onEdit,
    required this.onDelete,
    required this.onManageTemplates,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Icon(Icons.medical_information, color: Colors.blue),
            ),
            title: Text(
              disease.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (disease.nameEn != null)
                  Text(disease.nameEn!, style: TextStyle(color: Colors.grey)),
                if (disease.category != null)
                  Chip(
                    label: Text(disease.category!, style: TextStyle(fontSize: 12)),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
              ],
            ),
            isThreeLine: disease.nameEn != null || disease.category != null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onManageTemplates,
                  icon: const Icon(Icons.article, size: 18),
                  label: const Text('Templates'),
                ),
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
          ),
        ],
      ),
    );
  }
}
