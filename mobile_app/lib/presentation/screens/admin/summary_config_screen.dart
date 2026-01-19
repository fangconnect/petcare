import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repository/admin_repository.dart';

/// Admin screen for managing Health Summary configuration per template
class SummaryConfigScreen extends ConsumerStatefulWidget {
  final String templateId;
  final String templateName;

  const SummaryConfigScreen({
    super.key,
    required this.templateId,
    required this.templateName,
  });

  @override
  ConsumerState<SummaryConfigScreen> createState() => _SummaryConfigScreenState();
}

class _SummaryConfigScreenState extends ConsumerState<SummaryConfigScreen> {
  final _adminRepo = AdminRepository();
  Map<String, dynamic>? _config;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final config = await _adminRepo.getSummaryConfig(widget.templateId);
      setState(() {
        _config = config;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Summary Config: ${widget.templateName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.preview),
            tooltip: 'Preview Report',
            onPressed: _showPreviewDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadConfig,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'addSection',
            onPressed: _showAddSectionDialog,
            icon: const Icon(Icons.add),
            label: const Text('เพิ่ม Section'),
            backgroundColor: Colors.blue,
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'addChart',
            onPressed: _showAddChartDialog,
            icon: const Icon(Icons.bar_chart),
            label: const Text('เพิ่มกราฟ'),
            backgroundColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadConfig, child: const Text('Retry')),
          ],
        ),
      );
    }

    final sections = (_config?['sections'] as List?) ?? [];
    final charts = (_config?['charts'] as List?) ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sections
          _buildSectionHeader('📋 Sections (${sections.length})', 'กำหนด sections ที่แสดงใน Health Summary'),
          if (sections.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: Text('ยังไม่มี sections - กด "เพิ่ม Section" ด้านล่าง')),
              ),
            )
          else
            ...sections.map((s) => _buildSectionCard(s)),
          
          const SizedBox(height: 32),
          
          // Charts
          _buildSectionHeader('📊 Charts (${charts.length})', 'กำหนดกราฟที่แสดงใน Health Summary'),
          if (charts.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: Text('ยังไม่มีกราฟ - กด "เพิ่มกราฟ" ด้านล่าง')),
              ),
            )
          else
            ...charts.map((c) => _buildChartCard(c)),
          
          const SizedBox(height: 100), // FAB space
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildSectionCard(Map<String, dynamic> section) {
    final items = (section['items'] as List?) ?? [];
    final color = _parseColor(section['color']);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(_getIconData(section['icon']), color: color),
        ),
        title: Text(section['name'] ?? 'Untitled'),
        subtitle: Text('${section['name_th'] ?? ''} • ${items.length} items'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (section['is_visible'] != true)
              const Icon(Icons.visibility_off, color: Colors.grey, size: 18),
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () => _showEditSectionDialog(section),
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
              onPressed: () => _deleteSection(section['id']),
            ),
          ],
        ),
        children: [
          // Items list
          ...items.map((item) => _buildItemTile(item, section['id'])),
          // Add item button
          ListTile(
            leading: const Icon(Icons.add_circle_outline, color: Colors.blue),
            title: const Text('เพิ่ม Item', style: TextStyle(color: Colors.blue)),
            onTap: () => _showAddItemDialog(section['id']),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTile(Map<String, dynamic> item, String sectionId) {
    final activityTypes = (item['activity_types'] as List?)?.cast<String>() ?? [];
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      leading: _buildFormulaChip(item['formula'] ?? 'SUM'),
      title: Text(item['label'] ?? 'Untitled'),
      subtitle: Text(
        'Activity Types: ${activityTypes.join(", ")}\nUnit: ${item['unit'] ?? "-"}',
        style: const TextStyle(fontSize: 12),
      ),
      isThreeLine: true,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, size: 18),
            onPressed: () => _showEditItemDialog(item),
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 18, color: Colors.red),
            onPressed: () => _deleteItem(item['id']),
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaChip(String formula) {
    Color color;
    switch (formula) {
      case 'AVG':
        color = Colors.blue;
        break;
      case 'SUM':
        color = Colors.green;
        break;
      case 'COUNT':
        color = Colors.orange;
        break;
      case 'LATEST':
        color = Colors.purple;
        break;
      case 'TREND':
        color = Colors.teal;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(formula, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  Widget _buildChartCard(Map<String, dynamic> chart) {
    final activityTypes = (chart['activity_types'] as List?)?.cast<String>() ?? [];
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: _getChartIcon(chart['chart_type']),
        title: Text(chart['title'] ?? 'Untitled'),
        subtitle: Text('${chart['title_th'] ?? ''}\nTypes: ${activityTypes.join(", ")}'),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (chart['is_visible'] != true)
              const Icon(Icons.visibility_off, color: Colors.grey, size: 18),
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () => _showEditChartDialog(chart),
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
              onPressed: () => _deleteChart(chart['id']),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getChartIcon(String? type) {
    switch (type) {
      case 'line':
        return CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: const Icon(Icons.show_chart, color: Colors.blue),
        );
      case 'area':
        return CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: const Icon(Icons.area_chart, color: Colors.green),
        );
      case 'bar':
      default:
        return CircleAvatar(
          backgroundColor: Colors.orange.shade100,
          child: const Icon(Icons.bar_chart, color: Colors.orange),
        );
    }
  }

  Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return Colors.blue;
    try {
      return Color(int.parse(hex.replaceFirst('#', 'FF'), radix: 16));
    } catch (_) {
      return Colors.blue;
    }
  }

  IconData _getIconData(String? iconName) {
    const iconMap = {
      'restaurant_menu': Icons.restaurant_menu,
      'water_drop': Icons.water_drop,
      'wc': Icons.wc,
      'medication': Icons.medication,
      'monitor_weight': Icons.monitor_weight,
      'psychology': Icons.psychology,
      'favorite': Icons.favorite,
      'pets': Icons.pets,
    };
    return iconMap[iconName] ?? Icons.category;
  }

  // ==================== Dialogs ====================

  void _showAddSectionDialog() {
    final nameController = TextEditingController();
    final nameTHController = TextEditingController();
    String selectedIcon = 'restaurant_menu';
    String selectedColor = '#2196F3';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('เพิ่ม Section ใหม่'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'ชื่อ (English)'),
                ),
                TextField(
                  controller: nameTHController,
                  decoration: const InputDecoration(labelText: 'ชื่อ (ภาษาไทย)'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Icon'),
                  value: selectedIcon,
                  items: const [
                    DropdownMenuItem(value: 'restaurant_menu', child: Text('🍽️ Restaurant')),
                    DropdownMenuItem(value: 'water_drop', child: Text('💧 Water')),
                    DropdownMenuItem(value: 'wc', child: Text('🚽 WC')),
                    DropdownMenuItem(value: 'medication', child: Text('💊 Medication')),
                    DropdownMenuItem(value: 'monitor_weight', child: Text('⚖️ Weight')),
                    DropdownMenuItem(value: 'psychology', child: Text('🧠 Psychology')),
                    DropdownMenuItem(value: 'favorite', child: Text('❤️ Heart')),
                    DropdownMenuItem(value: 'pets', child: Text('🐾 Pets')),
                    DropdownMenuItem(value: 'category', child: Text('📁 Category')),
                  ],
                  onChanged: (v) => setDialogState(() => selectedIcon = v ?? 'restaurant_menu'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('ยกเลิก')),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await _adminRepo.createSummarySection(
                    widget.templateId,
                    name: nameController.text,
                    nameTH: nameTHController.text,
                    icon: selectedIcon,
                    color: selectedColor,
                  );
                  _loadConfig();
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                }
              },
              child: const Text('บันทึก'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditSectionDialog(Map<String, dynamic> section) {
    final nameController = TextEditingController(text: section['name']);
    final nameTHController = TextEditingController(text: section['name_th']);
    bool isVisible = section['is_visible'] ?? true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('แก้ไข Section'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'ชื่อ (English)'),
                ),
                TextField(
                  controller: nameTHController,
                  decoration: const InputDecoration(labelText: 'ชื่อ (ภาษาไทย)'),
                ),
                SwitchListTile(
                  title: const Text('แสดงผล'),
                  value: isVisible,
                  onChanged: (v) => setDialogState(() => isVisible = v),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('ยกเลิก')),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await _adminRepo.updateSummarySection(
                    section['id'],
                    name: nameController.text,
                    nameTH: nameTHController.text,
                    isVisible: isVisible,
                  );
                  _loadConfig();
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                }
              },
              child: const Text('บันทึก'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddItemDialog(String sectionId) {
    final labelController = TextEditingController();
    final labelTHController = TextEditingController();
    final activityTypesController = TextEditingController();
    final unitController = TextEditingController();
    String formula = 'SUM';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('เพิ่ม Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: labelController,
                decoration: const InputDecoration(labelText: 'Label (English)'),
              ),
              TextField(
                controller: labelTHController,
                decoration: const InputDecoration(labelText: 'Label (ภาษาไทย)'),
              ),
              TextField(
                controller: activityTypesController,
                decoration: const InputDecoration(
                  labelText: 'Activity Types',
                  helperText: 'คั่นด้วย comma เช่น food_intake,อาหาร',
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Formula'),
                value: formula,
                items: const [
                  DropdownMenuItem(value: 'SUM', child: Text('SUM - รวมทั้งหมด')),
                  DropdownMenuItem(value: 'AVG', child: Text('AVG - ค่าเฉลี่ยต่อวัน')),
                  DropdownMenuItem(value: 'COUNT', child: Text('COUNT - นับจำนวน')),
                  DropdownMenuItem(value: 'LATEST', child: Text('LATEST - ค่าล่าสุด')),
                  DropdownMenuItem(value: 'MIN', child: Text('MIN - ค่าต่ำสุด')),
                  DropdownMenuItem(value: 'MAX', child: Text('MAX - ค่าสูงสุด')),
                  DropdownMenuItem(value: 'TREND', child: Text('TREND - แนวโน้มเปลี่ยนแปลง')),
                ],
                onChanged: (v) => formula = v ?? 'SUM',
              ),
              TextField(
                controller: unitController,
                decoration: const InputDecoration(labelText: 'Unit (เช่น ml, g, kg)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ยกเลิก')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final types = activityTypesController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
              try {
                await _adminRepo.createSectionItem(
                  sectionId,
                  label: labelController.text,
                  labelTH: labelTHController.text,
                  activityTypes: types,
                  formula: formula,
                  unit: unitController.text.isEmpty ? null : unitController.text,
                );
                _loadConfig();
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: const Text('บันทึก'),
          ),
        ],
      ),
    );
  }

  void _showEditItemDialog(Map<String, dynamic> item) {
    final labelController = TextEditingController(text: item['label']);
    final activityTypes = (item['activity_types'] as List?)?.cast<String>() ?? [];
    final activityTypesController = TextEditingController(text: activityTypes.join(', '));
    final unitController = TextEditingController(text: item['unit']);
    String formula = item['formula'] ?? 'SUM';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('แก้ไข Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: labelController,
                decoration: const InputDecoration(labelText: 'Label'),
              ),
              TextField(
                controller: activityTypesController,
                decoration: const InputDecoration(
                  labelText: 'Activity Types',
                  helperText: 'คั่นด้วย comma',
                ),
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Formula'),
                value: formula,
                items: const [
                  DropdownMenuItem(value: 'SUM', child: Text('SUM')),
                  DropdownMenuItem(value: 'AVG', child: Text('AVG')),
                  DropdownMenuItem(value: 'COUNT', child: Text('COUNT')),
                  DropdownMenuItem(value: 'LATEST', child: Text('LATEST')),
                  DropdownMenuItem(value: 'MIN', child: Text('MIN')),
                  DropdownMenuItem(value: 'MAX', child: Text('MAX')),
                  DropdownMenuItem(value: 'TREND', child: Text('TREND')),
                ],
                onChanged: (v) => formula = v ?? 'SUM',
              ),
              TextField(
                controller: unitController,
                decoration: const InputDecoration(labelText: 'Unit'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ยกเลิก')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final types = activityTypesController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
              try {
                await _adminRepo.updateSectionItem(
                  item['id'],
                  label: labelController.text,
                  activityTypes: types,
                  formula: formula,
                  unit: unitController.text.isEmpty ? null : unitController.text,
                );
                _loadConfig();
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: const Text('บันทึก'),
          ),
        ],
      ),
    );
  }

  void _showAddChartDialog() {
    final titleController = TextEditingController();
    final titleTHController = TextEditingController();
    final activityTypesController = TextEditingController();
    String chartType = 'bar';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('เพิ่มกราฟ'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'ชื่อกราฟ (English)'),
              ),
              TextField(
                controller: titleTHController,
                decoration: const InputDecoration(labelText: 'ชื่อกราฟ (ภาษาไทย)'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'ประเภทกราฟ'),
                value: chartType,
                items: const [
                  DropdownMenuItem(value: 'bar', child: Text('📊 Bar Chart')),
                  DropdownMenuItem(value: 'line', child: Text('📈 Line Chart')),
                  DropdownMenuItem(value: 'area', child: Text('📉 Area Chart')),
                ],
                onChanged: (v) => chartType = v ?? 'bar',
              ),
              TextField(
                controller: activityTypesController,
                decoration: const InputDecoration(
                  labelText: 'Activity Types',
                  helperText: 'คั่นด้วย comma',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ยกเลิก')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final types = activityTypesController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
              try {
                await _adminRepo.createSummaryChart(
                  widget.templateId,
                  title: titleController.text,
                  titleTH: titleTHController.text,
                  chartType: chartType,
                  activityTypes: types,
                );
                _loadConfig();
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: const Text('บันทึก'),
          ),
        ],
      ),
    );
  }

  void _showEditChartDialog(Map<String, dynamic> chart) {
    final titleController = TextEditingController(text: chart['title']);
    final activityTypes = (chart['activity_types'] as List?)?.cast<String>() ?? [];
    final activityTypesController = TextEditingController(text: activityTypes.join(', '));
    String chartType = chart['chart_type'] ?? 'bar';
    bool isVisible = chart['is_visible'] ?? true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('แก้ไขกราฟ'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'ชื่อกราฟ'),
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'ประเภทกราฟ'),
                  value: chartType,
                  items: const [
                    DropdownMenuItem(value: 'bar', child: Text('Bar')),
                    DropdownMenuItem(value: 'line', child: Text('Line')),
                    DropdownMenuItem(value: 'area', child: Text('Area')),
                  ],
                  onChanged: (v) => setDialogState(() => chartType = v ?? 'bar'),
                ),
                TextField(
                  controller: activityTypesController,
                  decoration: const InputDecoration(labelText: 'Activity Types'),
                ),
                SwitchListTile(
                  title: const Text('แสดงผล'),
                  value: isVisible,
                  onChanged: (v) => setDialogState(() => isVisible = v),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('ยกเลิก')),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                final types = activityTypesController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
                try {
                  await _adminRepo.updateSummaryChart(
                    chart['id'],
                    title: titleController.text,
                    chartType: chartType,
                    activityTypes: types,
                    isVisible: isVisible,
                  );
                  _loadConfig();
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                }
              },
              child: const Text('บันทึก'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteSection(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: const Text('Section และ items ทั้งหมดจะถูกลบ ต้องการดำเนินการต่อหรือไม่?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('ยกเลิก')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('ลบ'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await _adminRepo.deleteSummarySection(id);
        _loadConfig();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  Future<void> _deleteItem(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: const Text('Item นี้จะถูกลบ'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('ยกเลิก')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('ลบ'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await _adminRepo.deleteSectionItem(id);
        _loadConfig();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  Future<void> _deleteChart(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: const Text('กราฟนี้จะถูกลบ'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('ยกเลิก')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('ลบ'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await _adminRepo.deleteSummaryChart(id);
        _loadConfig();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  // ==================== Preview ====================

  void _showPreviewDialog() {
    final sections = (_config?['sections'] as List?) ?? [];
    final charts = (_config?['charts'] as List?) ?? [];

    if (sections.isEmpty && charts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาเพิ่ม Section หรือ Chart ก่อน Preview')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '📊 Preview: Health Summary Report',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const Text(
                '(ใช้ข้อมูลจำลองเพื่อแสดงตัวอย่าง)',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 16),
              
              // Preview Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date Range
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.calendar_month, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('📅 สัปดาห์ที่ 1: 13 - 19 ม.ค. 2026', 
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Sections Preview
                      ...sections.map((section) => _buildPreviewSection(section)),
                      
                      // Charts Preview
                      if (charts.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Text('📈 กราฟ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ...charts.map((chart) => _buildPreviewChart(chart)),
                      ],
                    ],
                  ),
                ),
              ),
              
              // Footer
              const Divider(),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.check),
                  label: const Text('ปิด Preview'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewSection(Map<String, dynamic> section) {
    final items = (section['items'] as List?) ?? [];
    final color = _parseColor(section['color']);
    final name = section['name_th'] ?? section['name'] ?? 'Section';
    
    if (items.isEmpty) return const SizedBox.shrink();
    
    // Match exact styling from VetSummaryModal._buildSectionCard
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header - match VetSummaryModal style
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              children: [
                Icon(_getIconData(section['icon']), color: color, size: 18),
                const SizedBox(width: 8),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          // Section items
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: items.map((item) => _buildPreviewItem(item)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewItem(Map<String, dynamic> item) {
    final label = item['label_th'] ?? item['label'] ?? 'Item';
    final formula = item['formula'] ?? 'SUM';
    final unit = item['unit'] ?? '';
    
    // Generate mock value based on formula
    String mockValue;
    String? detail;
    switch (formula) {
      case 'AVG':
        mockValue = '152.5 $unit'.trim();
        detail = '(Avg/day)';
        break;
      case 'SUM':
        mockValue = '1,280.0 $unit total'.trim();
        detail = '(Avg: 182.9 $unit/day, 7 entries)'.trim();
        break;
      case 'COUNT':
        mockValue = '7 times';
        detail = '(Avg: 1.0/day)';
        break;
      case 'LATEST':
        mockValue = '3.2 $unit'.trim();
        break;
      case 'TREND':
        mockValue = '+0.2 $unit'.trim();
        detail = '(Increasing)';
        break;
      case 'MIN':
        mockValue = '120 $unit'.trim();
        break;
      case 'MAX':
        mockValue = '180 $unit'.trim();
        break;
      default:
        mockValue = '125 $unit'.trim();
    }
    
    // Match exact styling from VetSummaryModal._buildReportItem
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    mockValue,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                if (detail != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    detail,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewChart(Map<String, dynamic> chart) {
    final title = chart['title_th'] ?? chart['title'] ?? 'Chart';
    final chartType = chart['chart_type'] ?? 'bar';
    
    IconData chartIcon;
    Color chartColor;
    switch (chartType) {
      case 'line':
        chartIcon = Icons.show_chart;
        chartColor = Colors.blue;
        break;
      case 'area':
        chartIcon = Icons.area_chart;
        chartColor = Colors.green;
        break;
      case 'bar':
      default:
        chartIcon = Icons.bar_chart;
        chartColor = Colors.orange;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: chartColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(chartIcon, color: chartColor, size: 20),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: chartColor)),
            ],
          ),
          const SizedBox(height: 12),
          // Mock chart visualization
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: chartColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMockBar(0.6, chartColor),
                  _buildMockBar(0.8, chartColor),
                  _buildMockBar(0.5, chartColor),
                  _buildMockBar(0.9, chartColor),
                  _buildMockBar(0.7, chartColor),
                  _buildMockBar(0.4, chartColor),
                  _buildMockBar(0.85, chartColor),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Center(
            child: Text('จ. อ. พ. พฤ. ศ. ส. อา.', 
              style: TextStyle(fontSize: 10, color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildMockBar(double height, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 20,
          height: 80 * height,
          decoration: BoxDecoration(
            color: color.withOpacity(0.6),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
      ],
    );
  }
}
