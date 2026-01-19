import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/disease.dart';
import '../../providers/admin_provider.dart';

class DiseaseFormScreen extends ConsumerStatefulWidget {
  final Disease? disease;

  const DiseaseFormScreen({super.key, this.disease});

  @override
  ConsumerState<DiseaseFormScreen> createState() => _DiseaseFormScreenState();
}

class _DiseaseFormScreenState extends ConsumerState<DiseaseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _nameEnController;
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;
  bool _isLoading = false;

  bool get isEditing => widget.disease != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.disease?.name ?? '');
    _nameEnController = TextEditingController(text: widget.disease?.nameEn ?? '');
    _categoryController = TextEditingController(text: widget.disease?.category ?? '');
    _descriptionController = TextEditingController(text: widget.disease?.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameEnController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final disease = Disease(
      id: widget.disease?.id ?? '',
      name: _nameController.text.trim(),
      nameEn: _nameEnController.text.trim().isEmpty ? null : _nameEnController.text.trim(),
      category: _categoryController.text.trim().isEmpty ? null : _categoryController.text.trim(),
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
    );

    bool success;
    if (isEditing) {
      success = await ref.read(adminNotifierProvider.notifier).updateDisease(widget.disease!.id, disease);
    } else {
      success = await ref.read(adminNotifierProvider.notifier).createDisease(disease);
    }

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEditing ? 'อัปเดตโรคเรียบร้อย' : 'เพิ่มโรคเรียบร้อย')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'แก้ไขโรค' : 'เพิ่มโรคใหม่'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'ชื่อโรค (ภาษาไทย) *',
                  prefixIcon: Icon(Icons.medical_information),
                ),
                validator: (v) => v?.isEmpty == true ? 'กรุณากรอกชื่อโรค' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameEnController,
                decoration: const InputDecoration(
                  labelText: 'ชื่อโรค (ภาษาอังกฤษ)',
                  prefixIcon: Icon(Icons.translate),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'หมวดหมู่',
                  prefixIcon: Icon(Icons.category),
                  hintText: 'เช่น chronic, acute, infectious',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'รายละเอียด',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(isEditing ? 'บันทึกการแก้ไข' : 'เพิ่มโรค'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
