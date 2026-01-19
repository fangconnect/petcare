import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/disease.dart';
import '../../../data/models/disease_template.dart';
import '../../providers/admin_provider.dart';
import 'template_editor_screen.dart';
import 'summary_config_screen.dart';

class TemplateListScreen extends ConsumerWidget {
  final Disease disease;

  const TemplateListScreen({super.key, required this.disease});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(templatesProvider(disease.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('Templates: ${disease.name}'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createTemplate(context),
        icon: const Icon(Icons.add),
        label: const Text('เพิ่ม Template'),
        backgroundColor: Colors.green,
      ),
      body: templatesAsync.when(
        data: (templates) => templates.isEmpty
            ? _buildEmptyState(context)
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: templates.length,
                itemBuilder: (context, index) {
                  final template = templates[index];
                  return _TemplateCard(
                    template: template,
                    diseaseId: disease.id,
                    onEdit: () => _editTemplate(context, template),
                    onDelete: () => _confirmDelete(context, ref, template),
                    onSetDefault: () => _setDefault(context, ref, template),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.article_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('ยังไม่มี Template', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => _createTemplate(context),
            icon: const Icon(Icons.add),
            label: const Text('สร้าง Template แรก'),
          ),
        ],
      ),
    );
  }

  void _createTemplate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TemplateEditorScreen(diseaseId: disease.id),
      ),
    );
  }

  void _editTemplate(BuildContext context, DiseaseTemplate template) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TemplateEditorScreen(
          diseaseId: disease.id,
          template: template,
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, DiseaseTemplate template) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: Text('ต้องการลบ Template "${template.templateName}" หรือไม่?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('ยกเลิก')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(adminNotifierProvider.notifier).deleteTemplate(template.id, disease.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ลบ Template เรียบร้อย')));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('ลบ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _setDefault(BuildContext context, WidgetRef ref, DiseaseTemplate template) async {
    await ref.read(adminNotifierProvider.notifier).setDefaultTemplate(template.id, disease.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ตั้ง "${template.templateName}" เป็นค่าเริ่มต้น')),
      );
    }
  }
}

class _TemplateCard extends StatelessWidget {
  final DiseaseTemplate template;
  final String diseaseId;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const _TemplateCard({
    required this.template,
    required this.diseaseId,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    final activityTypes = template.activityTypes;
    final fieldCount = activityTypes.length;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: template.isDefault ? Colors.green.shade100 : Colors.grey.shade100,
              child: Icon(
                Icons.article,
                color: template.isDefault ? Colors.green : Colors.grey,
              ),
            ),
            title: Row(
              children: [
                Expanded(child: Text(template.templateName, style: const TextStyle(fontWeight: FontWeight.bold))),
                if (template.isDefault)
                  Chip(
                    label: const Text('Default', style: TextStyle(fontSize: 10)),
                    backgroundColor: Colors.green.shade100,
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
              ],
            ),
            subtitle: Text('$fieldCount fields • Version ${template.version}'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!template.isDefault)
                  TextButton.icon(
                    onPressed: onSetDefault,
                    icon: const Icon(Icons.star_border, size: 18),
                    label: const Text('ตั้งเป็นค่าเริ่มต้น'),
                  ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SummaryConfigScreen(
                          templateId: template.id,
                          templateName: template.templateName,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.summarize, size: 18, color: Colors.purple),
                  label: const Text('Summary', style: TextStyle(color: Colors.purple)),
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
