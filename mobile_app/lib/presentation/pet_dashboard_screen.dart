import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../data/models/pet.dart';
import '../data/models/activity_log.dart';
import '../data/repository/log_repository.dart';
import '../core/network/api_client.dart';
import '../presentation/widgets/vet_summary_modal.dart';

// Provider for LogRepository
final logRepositoryProvider = Provider<LogRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return LogRepository(dio);
});

// Provider for pet logs
final petLogsProvider = FutureProvider.family<List<ActivityLog>, String>((ref, petId) async {
  final repository = ref.watch(logRepositoryProvider);
  return repository.getLogsByPetID(petId);
});

// Provider for template activity types
final templateActivityTypesProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, petId) async {
  final repository = ref.watch(logRepositoryProvider);
  return repository.getTemplateActivityTypes(petId);
});

// Date range model for filtering logs
class DateRange {
  final DateTime start;
  final DateTime end;
  DateRange({required this.start, required this.end});
}

// Activity type option for dropdown
class ActivityTypeOption {
  final String type;
  final String displayName;
  final IconData icon;
  final String inputType; // 'number', 'text', 'medication'
  final String? unit;
  final List<String>? unitOptions; // Available unit choices
  final bool hasMedicationName; // For medication type

  const ActivityTypeOption({
    required this.type,
    required this.displayName,
    required this.icon,
    required this.inputType,
    this.unit,
    this.unitOptions,
    this.hasMedicationName = false,
  });
  
  // Override == and hashCode to compare by type
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ActivityTypeOption && other.type == type;
  }
  
  @override
  int get hashCode => type.hashCode;
}

// Available activity types with UI metadata
const List<ActivityTypeOption> activityTypeOptions = [
  // Intake
  ActivityTypeOption(
    type: 'water_intake', 
    displayName: 'Water Intake', 
    icon: Icons.water_drop, 
    inputType: 'number', 
    unit: 'ml',
    unitOptions: ['ml', 'times'],
  ),
  ActivityTypeOption(
    type: 'food_intake', 
    displayName: 'Food Intake', 
    icon: Icons.restaurant, 
    inputType: 'number', 
    unit: 'g',
    unitOptions: ['g', 'ml', 'portion'],
  ),
  ActivityTypeOption(
    type: 'saline', 
    displayName: 'Saline (น้ำเกลือ)', 
    icon: Icons.water, 
    inputType: 'number', 
    unit: 'ml',
    unitOptions: ['ml', 'bag'],
  ),
  
  // Elimination
  ActivityTypeOption(type: 'urination', displayName: 'Urination', icon: Icons.wc, inputType: 'number', unit: 'times'),
  ActivityTypeOption(type: 'defecation', displayName: 'Defecation', icon: Icons.wc, inputType: 'number', unit: 'times'),
  ActivityTypeOption(type: 'vomiting', displayName: 'Vomiting', icon: Icons.sick, inputType: 'number', unit: 'times'),
  
  // Medical
  ActivityTypeOption(type: 'weight', displayName: 'Weight', icon: Icons.monitor_weight, inputType: 'number', unit: 'kg'),
  ActivityTypeOption(
    type: 'medication', 
    displayName: 'Medication', 
    icon: Icons.medication, 
    inputType: 'medication',
    unit: 'tabs',
    unitOptions: ['tabs', 'ml', 'IM', 'SC', 'IV', 'drops'],
    hasMedicationName: true,
  ),
  ActivityTypeOption(type: 'symptom', displayName: 'Symptom', icon: Icons.healing, inputType: 'text'),
  
  // Activity
  ActivityTypeOption(type: 'exercise', displayName: 'Exercise', icon: Icons.directions_run, inputType: 'number', unit: 'min'),
  ActivityTypeOption(type: 'sleep', displayName: 'Sleep', icon: Icons.bedtime, inputType: 'number', unit: 'hrs'),
  
  // Behavioral Assessment
  ActivityTypeOption(type: 'appetite', displayName: 'Appetite Level', icon: Icons.dining, inputType: 'number', unit: '/10'),
  ActivityTypeOption(type: 'mood', displayName: 'Mood', icon: Icons.mood, inputType: 'number', unit: '/10'),
  ActivityTypeOption(type: 'energy_level', displayName: 'Energy Level', icon: Icons.bolt, inputType: 'number', unit: '/10'),
  ActivityTypeOption(type: 'pain_level', displayName: 'Pain Level', icon: Icons.personal_injury, inputType: 'number', unit: '/10'),
  ActivityTypeOption(type: 'anxiety', displayName: 'Anxiety', icon: Icons.psychology_alt, inputType: 'number', unit: '/10'),
  ActivityTypeOption(type: 'breathing', displayName: 'Breathing Rate', icon: Icons.air, inputType: 'number', unit: 'bpm'),
  ActivityTypeOption(type: 'behavior', displayName: 'Behavior Note', icon: Icons.psychology, inputType: 'text'),
  
  // Other - note with optional photo
  ActivityTypeOption(type: 'other', displayName: 'Other', icon: Icons.note_add, inputType: 'photo'),
];

// Helper class for daily summary calculations
class _DailySummaryItem {
  final String type;
  final String displayName;
  final IconData icon;
  // Map of unit -> total value
  final Map<String, double> unitBreakdown = {};
  // For medications: Map of medication name -> (value, unit)
  final Map<String, _MedInfo> medications = {};
  // For photos: List of (title, base64)
  final List<_PhotoInfo> photos = [];
  int count = 0;

  _DailySummaryItem({
    required this.type,
    required this.displayName,
    required this.icon,
  });
}

class _PhotoInfo {
  final String title;
  final String imageBase64;
  _PhotoInfo({required this.title, required this.imageBase64});
}

class _MedInfo {
  double total = 0;
  String unit = '';
  int count = 0;
}

class PetDashboardScreen extends ConsumerStatefulWidget {
  final Pet pet;

  const PetDashboardScreen({super.key, required this.pet});

  @override
  ConsumerState<PetDashboardScreen> createState() => _PetDashboardScreenState();
}

class _PetDashboardScreenState extends ConsumerState<PetDashboardScreen> {
  DateRange? _selectedRange;
  
  // Form state
  ActivityTypeOption? _selectedActivityType;
  String? _selectedUnit; // Selected unit from unitOptions
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _medicationNameController = TextEditingController(); // For medication name
  final TextEditingController _photoTitleController = TextEditingController(); // For photo title
  DateTime _selectedDateTime = DateTime.now();
  bool _isSaving = false;
  
  // Photo upload
  final ImagePicker _imagePicker = ImagePicker();
  Uint8List? _selectedImageBytes;  // Web-compatible image storage
  String? _imageBase64;
  
  // Medication name suggestions (from previous logs)
  List<String> _medicationSuggestions = [];

  @override
  void initState() {
    super.initState();
    _loadMedicationSuggestions();
  }
  
  Future<void> _loadMedicationSuggestions() async {
    try {
      final logs = await ref.read(petLogsProvider(widget.pet.id).future);
      // Check for medication_name in activityData (works with any activity type: 'medication', 'ยา', etc.)
      final medications = logs
        .where((log) => log.activityData.containsKey('medication_name'))
        .map((log) => log.activityData['medication_name'] as String?)
        .where((name) => name != null && name.isNotEmpty)
        .cast<String>()
        .toSet()
        .toList();
      if (mounted) {
        setState(() {
          _medicationSuggestions = medications;
        });
      }
    } catch (e) {
      // Ignore errors - suggestions are optional
      debugPrint('Error loading medication suggestions: $e');
    }
  }
  
  // Convert template activity types from API to ActivityTypeOption objects
  List<ActivityTypeOption> _buildActivityTypeOptionsFromTemplate(List templateTypes) {
    return templateTypes.map<ActivityTypeOption>((at) {
      final name = at['name'] ?? at['name_en'] ?? '';
      final inputType = at['input_type'] ?? 'number';
      final category = at['category'] ?? '';
      
      // Get icon based on name or category
      IconData icon = _getIconForActivityType(name, category);
      
      // Get unit from API response
      String? unit;
      List<String>? unitOptions;
      if (at['units'] != null && (at['units'] as List).isNotEmpty) {
        final units = at['units'] as List;
        // Find default unit
        final defaultUnit = units.firstWhere((u) => u['is_default'] == true, orElse: () => units.first);
        unit = defaultUnit['symbol'] ?? defaultUnit['name'] ?? '';
        unitOptions = units.map<String>((u) => (u['symbol'] ?? u['name'] ?? '') as String).toList();
      }
      
      return ActivityTypeOption(
        type: name, // Use name as type since backend uses name as identifier
        displayName: at['name'] ?? at['name_en'] ?? '',
        icon: icon,
        inputType: inputType == 'checkbox' ? 'number' : inputType,
        unit: unit,
        unitOptions: unitOptions,
        hasMedicationName: name.toLowerCase().contains('medication') || name.toLowerCase().contains('ยา'),
      );
    }).toList();
  }
  
  // Get icon based on activity type name or category
  IconData _getIconForActivityType(String name, String category) {
    final nameLower = name.toLowerCase();
    
    // Match by name
    if (nameLower.contains('water') || nameLower.contains('น้ำ')) return Icons.water_drop;
    if (nameLower.contains('food') || nameLower.contains('อาหาร')) return Icons.restaurant;
    if (nameLower.contains('saline') || nameLower.contains('น้ำเกลือ')) return Icons.water;
    if (nameLower.contains('weight') || nameLower.contains('น้ำหนัก')) return Icons.monitor_weight;
    if (nameLower.contains('medication') || nameLower.contains('ยา')) return Icons.medication;
    if (nameLower.contains('urin') || nameLower.contains('ปัสสาวะ')) return Icons.wc;
    if (nameLower.contains('defec') || nameLower.contains('อุจจาระ')) return Icons.wc;
    if (nameLower.contains('vomit') || nameLower.contains('อาเจียน')) return Icons.sick;
    if (nameLower.contains('exercise') || nameLower.contains('ออกกำลัง')) return Icons.directions_run;
    if (nameLower.contains('sleep') || nameLower.contains('นอน')) return Icons.bedtime;
    if (nameLower.contains('symptom') || nameLower.contains('อาการ')) return Icons.healing;
    if (nameLower.contains('appetite') || nameLower.contains('กิน')) return Icons.dining;
    if (nameLower.contains('mood') || nameLower.contains('อารมณ์')) return Icons.mood;
    if (nameLower.contains('energy') || nameLower.contains('พลังงาน')) return Icons.bolt;
    if (nameLower.contains('pain') || nameLower.contains('เจ็บ')) return Icons.personal_injury;
    if (nameLower.contains('breathing') || nameLower.contains('หายใจ')) return Icons.air;
    if (nameLower.contains('behavior') || nameLower.contains('พฤติกรรม')) return Icons.psychology;
    
    // Match by category
    if (category == 'intake') return Icons.restaurant;
    if (category == 'elimination') return Icons.wc;
    if (category == 'medical') return Icons.medical_services;
    if (category == 'activity') return Icons.directions_run;
    if (category == 'vital') return Icons.favorite;
    if (category == 'behavior') return Icons.psychology;
    
    return Icons.note_add; // Default
  }

  @override
  void dispose() {
    _valueController.dispose();
    _notesController.dispose();
    _medicationNameController.dispose();
    _photoTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logsAsync = ref.watch(petLogsProvider(widget.pet.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet.name),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPetInfoSection(context),
            _buildActivityFormSection(context),
            _buildRecentHistorySection(context, logsAsync),
          ],
        ),
      ),
    );
  }

  Widget _buildPetInfoSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.blue.shade50,
      child: Column(
        children: [
          if (widget.pet.photoUrl != null && widget.pet.photoUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.pet.photoUrl!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
              ),
            )
          else
            _buildPlaceholderImage(),
          const SizedBox(height: 16),
          Text(
            widget.pet.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (widget.pet.petDiseases != null && widget.pet.petDiseases!.isNotEmpty)
            Wrap(
              spacing: 8,
              children: widget.pet.petDiseases!.map((pd) {
                return Chip(
                  label: Text(pd.disease?.name ?? 'Unknown'),
                  backgroundColor: Colors.blue.shade100,
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.pets, size: 50),
    );
  }

  Widget _buildActivityFormSection(BuildContext context) {
    // Watch template activity types for this pet
    final templateActivityTypesAsync = ref.watch(templateActivityTypesProvider(widget.pet.id));
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add New Log',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Activity Type Dropdown - use template types if available
                  templateActivityTypesAsync.when(
                    data: (data) {
                      final templateTypes = data['activity_types'] as List? ?? [];
                      
                      // Build activity type options from template
                      final options = _buildActivityTypeOptionsFromTemplate(templateTypes);
                      
                      // Use template options if available, otherwise fallback to hardcoded
                      final availableOptions = options.isNotEmpty ? options : activityTypeOptions;
                      
                      // Find matching selected value in available options (or null if not found)
                      ActivityTypeOption? currentValue;
                      if (_selectedActivityType != null) {
                        try {
                          currentValue = availableOptions.firstWhere(
                            (opt) => opt.type == _selectedActivityType!.type,
                          );
                        } catch (_) {
                          currentValue = null; // Not found in list
                        }
                      }
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Show template info if available
                          if (data['template'] != null) 
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                '📋 Template: ${data['template']['template_name'] ?? 'Unknown'}',
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                              ),
                            ),
                          DropdownButtonFormField<ActivityTypeOption>(
                            value: currentValue,
                            decoration: InputDecoration(
                              labelText: 'Activity Type',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              prefixIcon: Icon(_selectedActivityType?.icon ?? Icons.list),
                            ),
                            isExpanded: true,
                            items: availableOptions.map((option) {
                              return DropdownMenuItem<ActivityTypeOption>(
                                value: option,
                                child: Row(
                                  children: [
                                    Icon(option.icon, size: 20, color: Colors.blue),
                                    SizedBox(width: 12),
                                    Expanded(child: Text(option.displayName, overflow: TextOverflow.ellipsis)),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedActivityType = value;
                                _selectedUnit = value?.unit; // Reset to default unit
                                _valueController.clear();
                                _notesController.clear();
                                _medicationNameController.clear();
                              });
                            },
                          ),
                        ],
                      );
                    },
                    loading: () => DropdownButtonFormField<ActivityTypeOption>(
                      value: _selectedActivityType,
                      decoration: InputDecoration(
                        labelText: 'Activity Type',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: Icon(_selectedActivityType?.icon ?? Icons.list),
                        suffixIcon: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                      isExpanded: true,
                      items: activityTypeOptions.map((option) {
                        return DropdownMenuItem<ActivityTypeOption>(
                          value: option,
                          child: Row(
                            children: [
                              Icon(option.icon, size: 20, color: Colors.blue),
                              SizedBox(width: 12),
                              Expanded(child: Text(option.displayName, overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedActivityType = value;
                          _selectedUnit = value?.unit;
                          _valueController.clear();
                          _notesController.clear();
                          _medicationNameController.clear();
                        });
                      },
                    ),
                    error: (_, __) => DropdownButtonFormField<ActivityTypeOption>(
                      value: _selectedActivityType,
                      decoration: InputDecoration(
                        labelText: 'Activity Type',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: Icon(_selectedActivityType?.icon ?? Icons.list),
                      ),
                      isExpanded: true,
                      items: activityTypeOptions.map((option) {
                        return DropdownMenuItem<ActivityTypeOption>(
                          value: option,
                          child: Row(
                            children: [
                              Icon(option.icon, size: 20, color: Colors.blue),
                              SizedBox(width: 12),
                              Expanded(child: Text(option.displayName, overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedActivityType = value;
                          _selectedUnit = value?.unit;
                          _valueController.clear();
                          _notesController.clear();
                          _medicationNameController.clear();
                        });
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Dynamic input field based on selected type
                  if (_selectedActivityType != null) ...[
                    // Unit dropdown for types with unitOptions
                    if (_selectedActivityType!.unitOptions != null && _selectedActivityType!.unitOptions!.isNotEmpty)
                      Column(
                        children: [
                          DropdownButtonFormField<String>(
                            value: _selectedUnit ?? _selectedActivityType!.unit,
                            decoration: InputDecoration(
                              labelText: 'Unit',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              prefixIcon: Icon(Icons.straighten),
                            ),
                            items: _selectedActivityType!.unitOptions!.map((unit) {
                              return DropdownMenuItem(
                                value: unit,
                                child: Text(unit),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedUnit = value;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    
                    // Medication name field with simple text input and suggestions
                    if (_selectedActivityType!.inputType == 'medication' || _selectedActivityType!.hasMedicationName) ...[
                      TextField(
                        controller: _medicationNameController,
                        decoration: InputDecoration(
                          labelText: 'Medication Name *',
                          hintText: 'Enter medication name...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          prefixIcon: Icon(Icons.medication),
                        ),
                      ),
                      // Show medication suggestions if available
                      if (_medicationSuggestions.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: _medicationSuggestions.map((med) {
                            return ActionChip(
                              label: Text(med, style: TextStyle(fontSize: 12)),
                              avatar: Icon(Icons.medication, size: 16),
                              onPressed: () {
                                setState(() {
                                  _medicationNameController.text = med;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                      const SizedBox(height: 12),
                    ],
                    
                    // Value input field
                    if (_selectedActivityType!.inputType == 'number')
                      TextField(
                        controller: _valueController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Value',
                          suffixText: _selectedUnit ?? _selectedActivityType!.unit,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      )
                    else if (_selectedActivityType!.inputType == 'medication') ...[
                      TextField(
                        controller: _valueController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Quantity',
                          hintText: 'e.g. 1, 1/2, 1/4, 0.5',
                          suffixText: _selectedUnit ?? _selectedActivityType!.unit,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      SizedBox(height: 8),
                      // Quick fraction selection chips
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: ['1/4', '1/2', '3/4', '1', '1.5', '2'].map((fraction) {
                          return ActionChip(
                            label: Text(fraction, style: TextStyle(fontSize: 12)),
                            backgroundColor: _valueController.text == fraction 
                                ? Colors.blue.shade100 
                                : null,
                            onPressed: () {
                              setState(() {
                                _valueController.text = fraction;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ]
                    else if (_selectedActivityType!.inputType == 'text')
                      TextField(
                        controller: _valueController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'Enter details...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      )
                    else if (_selectedActivityType!.inputType == 'photo') ...[
                      // Photo title/description
                      TextField(
                        controller: _photoTitleController,
                        decoration: InputDecoration(
                          labelText: 'Title/Description *',
                          hintText: 'e.g. ผื่น, แผล, สังเกตุอาการ...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          prefixIcon: Icon(Icons.title),
                        ),
                      ),
                      SizedBox(height: 12),
                      // Photo picker buttons (optional)
                      Text(
                        '📷 Photo (Optional)',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          // Only show camera button on non-web platforms
                          if (!kIsWeb) ...[
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _pickImage(ImageSource.camera),
                                icon: Icon(Icons.camera_alt),
                                label: Text('Camera'),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                          ],
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _pickImage(ImageSource.gallery),
                              icon: Icon(Icons.photo_library),
                              label: Text(kIsWeb ? 'Select Photo' : 'Gallery'),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Image preview
                      if (_selectedImageBytes != null) ...[
                        SizedBox(height: 12),
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                _selectedImageBytes!,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.red,
                                child: IconButton(
                                  icon: Icon(Icons.close, size: 16, color: Colors.white),
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    setState(() {
                                      _selectedImageBytes = null;
                                      _imageBase64 = null;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                    
                    const SizedBox(height: 12),
                    
                    // Notes field
                    TextField(
                      controller: _notesController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Notes (Optional)',
                        hintText: 'Additional notes...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Date/Time Picker - Editable text field with picker buttons
                    Row(
                      children: [
                        // Editable date/time text field
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(text: _formatDateTime(_selectedDateTime)),
                            decoration: InputDecoration(
                              labelText: 'Date & Time',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              prefixIcon: Icon(Icons.access_time, color: Colors.blue),
                              hintText: 'dd/MM/yyyy HH:mm',
                            ),
                            onSubmitted: (value) => _parseAndSetDateTime(value),
                            onChanged: (value) {
                              // Try to parse on change for immediate feedback
                              if (value.length >= 16) {
                                _parseAndSetDateTime(value);
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        // Calendar button
                        IconButton(
                          icon: Icon(Icons.calendar_today, color: Colors.blue),
                          tooltip: 'Select Date',
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _selectedDateTime,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now().add(Duration(days: 1)),
                            );
                            if (date != null) {
                              setState(() {
                                _selectedDateTime = DateTime(
                                  date.year, date.month, date.day,
                                  _selectedDateTime.hour, _selectedDateTime.minute,
                                );
                              });
                            }
                          },
                        ),
                        // Clock button
                        IconButton(
                          icon: Icon(Icons.schedule, color: Colors.blue),
                          tooltip: 'Select Time',
                          onPressed: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
                            );
                            if (time != null) {
                              setState(() {
                                _selectedDateTime = DateTime(
                                  _selectedDateTime.year, _selectedDateTime.month, _selectedDateTime.day,
                                  time.hour, time.minute,
                                );
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Save Button
                    ElevatedButton.icon(
                      onPressed: _isSaving ? null : _saveLog,
                      icon: _isSaving
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Icon(Icons.save),
                      label: Text(_isSaving ? 'Saving...' : 'Save Log'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year, date.month, date.day, time.hour, time.minute,
      );
    });
  }

  String _formatDateTime(DateTime dt) {
    // Use consistent format that can be parsed back
    return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }

  // Parse fraction string (e.g., "1/4", "1/2", "3/4") to double
  double? _parseFraction(String text) {
    text = text.trim();
    if (text.isEmpty) return null;
    
    // Try direct parse first (handles "1", "1.5", "0.5" etc.)
    final direct = double.tryParse(text);
    if (direct != null) return direct;
    
    // Handle fraction format "a/b"
    if (text.contains('/')) {
      final parts = text.split('/');
      if (parts.length == 2) {
        final numerator = double.tryParse(parts[0].trim());
        final denominator = double.tryParse(parts[1].trim());
        if (numerator != null && denominator != null && denominator != 0) {
          return numerator / denominator;
        }
      }
    }
    
    return null;
  }

  void _parseAndSetDateTime(String value) {
    // Try multiple formats
    final formats = [
      DateFormat('dd/MM/yyyy HH:mm'),
      DateFormat('d/M/yyyy HH:mm'),
      DateFormat('dd/MM/yyyy H:mm'),
      DateFormat('yyyy-MM-dd HH:mm'),
    ];
    
    for (var format in formats) {
      try {
        final parsed = format.parseStrict(value.trim());
        if (parsed.isBefore(DateTime.now().add(Duration(days: 1)))) {
          setState(() {
            _selectedDateTime = parsed;
          });
          return;
        }
      } catch (_) {
        // Try next format
      }
    }
    // If none worked, don't change the value
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      
      if (pickedFile != null) {
        // Use readAsBytes() which works on web and mobile
        final bytes = await pickedFile.readAsBytes();
        final base64Image = base64Encode(bytes);
        
        setState(() {
          _selectedImageBytes = bytes;
          _imageBase64 = base64Image;
        });
      }
    } catch (e) {
      _showSnackBar('Failed to pick image: $e', isError: true);
    }
  }

  Future<void> _saveLog() async {
    debugPrint('=== _saveLog CALLED (NEW CODE v2) ===');
    debugPrint('Activity type: ${_selectedActivityType?.type}');
    debugPrint('Input type: ${_selectedActivityType?.inputType}');
    debugPrint('Medication controller text: "${_medicationNameController.text}"');
    
    if (_selectedActivityType == null) {
      _showSnackBar('Please select an activity type', isError: true);
      return;
    }
    
    final valueText = _valueController.text.trim();
    
    // Validate medication name for medication type
    if (_selectedActivityType!.inputType == 'medication' && _medicationNameController.text.trim().isEmpty) {
      _showSnackBar('Please enter medication name', isError: true);
      return;
    }
    
    // Value is required for number/medication types, but not for text or photo
    if (valueText.isEmpty && 
        _selectedActivityType!.inputType != 'text' && 
        _selectedActivityType!.inputType != 'photo') {
      _showSnackBar('Please enter a value', isError: true);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final repository = ref.read(logRepositoryProvider);
      
      // Get the actual unit to use
      final unit = _selectedUnit ?? _selectedActivityType!.unit;
      
      // Build activityData based on type
      Map<String, dynamic> activityData = {};
      if (_selectedActivityType!.inputType == 'number') {
        final value = double.tryParse(valueText);
        if (value == null) {
          _showSnackBar('Please enter a valid number', isError: true);
          setState(() => _isSaving = false);
          return;
        }
        activityData = {
          'value': value,
          'unit': unit,
          'input_type': 'number',
        };
      } else if (_selectedActivityType!.inputType == 'medication') {
        final value = _parseFraction(valueText);
        if (value == null) {
          _showSnackBar('Please enter a valid quantity (e.g. 1, 1/2, 0.5)', isError: true);
          setState(() => _isSaving = false);
          return;
        }
        final medName = _medicationNameController.text.trim();
        debugPrint('SAVE LOG: Medication name from controller: "$medName"');
        activityData = {
          'medication_name': medName,
          'value': value,
          'unit': unit,
          'input_type': 'medication',
        };
        debugPrint('SAVE LOG: activityData = $activityData');
      } else if (_selectedActivityType!.inputType == 'photo') {
        final title = _photoTitleController.text.trim();
        if (title.isEmpty) {
          _showSnackBar('Please enter a title/description', isError: true);
          setState(() => _isSaving = false);
          return;
        }
        // Photo is optional - can save with just title/description
        activityData = {
          'title': title,
          'input_type': 'photo',
        };
        // Only include image if one was selected
        if (_imageBase64 != null) {
          activityData['image_base64'] = _imageBase64;
        }
      } else {
        activityData = {
          'text': valueText,
          'input_type': 'text',
        };
      }

      await repository.createLog(
        petId: widget.pet.id,
        activityType: _selectedActivityType!.type,
        activityData: activityData,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        loggedAt: _selectedDateTime,
      );

      _showSnackBar('Log saved successfully!');
      
      // Clear form
      setState(() {
        _valueController.clear();
        _notesController.clear();
        _medicationNameController.clear();
        _photoTitleController.clear();
        _selectedImageBytes = null;
        _imageBase64 = null;
        _selectedDateTime = DateTime.now();
      });
      
      // Refresh logs
      ref.invalidate(petLogsProvider(widget.pet.id));

    } catch (e) {
      _showSnackBar('Error: ${e.toString()}', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Widget _buildRecentHistorySection(BuildContext context, AsyncValue<List<ActivityLog>> logsAsync) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Recent History',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: Icon(Icons.summarize, color: Colors.blue),
                tooltip: 'Health Summary',
                onPressed: () {
                  logsAsync.whenData((logs) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => VetSummaryModal(petName: widget.pet.name, logs: logs),
                    );
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          _buildWeekRangeSelector(logsAsync),
          const SizedBox(height: 16),
          
          logsAsync.when(
            data: (logs) {
              final filtered = _filterLogsByRange(logs);
              if (filtered.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('No logs for this period', style: TextStyle(color: Colors.grey)),
                  ),
                );
              }
              return Column(children: _buildLogsByDate(filtered));
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekRangeSelector(AsyncValue<List<ActivityLog>> logsAsync) {
    return logsAsync.when(
      data: (logs) {
        final ranges = _generateWeekRangesFromLogs(logs);
        if (ranges.isEmpty) return SizedBox.shrink();
        
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ranges.asMap().entries.map((entry) {
              final index = entry.key;
              final range = entry.value;
              final isSelected = _selectedRange?.start == range.start;
              final weekNum = ranges.length - index; // Week 1 is earliest
              return Padding(
                padding: EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(_formatWeekLabel(range, weekNum)),
                  selected: isSelected,
                  onSelected: (sel) => setState(() => _selectedRange = sel ? range : null),
                ),
              );
            }).toList(),
          ),
        );
      },
      loading: () => SizedBox.shrink(),
      error: (_, __) => SizedBox.shrink(),
    );
  }

  /// Generate week ranges starting from the first log entry date
  List<DateRange> _generateWeekRangesFromLogs(List<ActivityLog> logs) {
    if (logs.isEmpty) return [];
    
    // Find the earliest log date
    final sortedDates = logs.map((log) => log.loggedAt).toList()..sort();
    final firstLogDate = DateTime(sortedDates.first.year, sortedDates.first.month, sortedDates.first.day);
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    
    // Calculate how many weeks from first log to today
    final daysSinceFirst = todayOnly.difference(firstLogDate).inDays;
    final totalWeeks = (daysSinceFirst / 7).ceil().clamp(1, 12); // Cap at 12 weeks
    
    final ranges = <DateRange>[];
    
    // Generate weeks from most recent to oldest
    for (int i = 0; i < totalWeeks; i++) {
      // Calculate week start from first log date
      final weekNumber = totalWeeks - i; // Current week index from first entry
      final weekStartDays = (weekNumber - 1) * 7;
      final weekStart = firstLogDate.add(Duration(days: weekStartDays));
      final weekEnd = weekStart.add(Duration(days: 6));
      
      // Only add if the week has started
      if (!weekStart.isAfter(todayOnly)) {
        ranges.add(DateRange(start: weekStart, end: weekEnd));
      }
    }
    
    // Reverse to show most recent first
    ranges.sort((a, b) => b.start.compareTo(a.start));
    
    // Auto-select first (most recent) week
    if (_selectedRange == null && ranges.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _selectedRange = ranges.first);
      });
    }
    
    return ranges;
  }

  String _formatWeekLabel(DateRange range, int weekNum) {
    final fmt = DateFormat('d/M');
    return 'Week $weekNum (${fmt.format(range.start)}-${fmt.format(range.end)})';
  }

  List<ActivityLog> _filterLogsByRange(List<ActivityLog> logs) {
    if (_selectedRange == null) return logs;
    return logs.where((log) {
      final logDate = DateTime(log.loggedAt.year, log.loggedAt.month, log.loggedAt.day);
      return !logDate.isBefore(_selectedRange!.start) && !logDate.isAfter(_selectedRange!.end);
    }).toList();
  }

  List<Widget> _buildLogsByDate(List<ActivityLog> logs) {
    final grouped = <String, List<ActivityLog>>{};
    for (var log in logs) {
      final key = DateFormat('yyyy-MM-dd').format(log.loggedAt);
      grouped.putIfAbsent(key, () => []).add(log);
    }
    
    final sortedDates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    
    return sortedDates.map((dateKey) {
      final dateLogs = grouped[dateKey]!;
      final date = DateTime.parse(dateKey);
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              DateFormat('EEEE, MMMM d').format(date),
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade700),
            ),
          ),
          ...dateLogs.map((log) => _buildLogItem(log)),
          // Daily Summary Card
          _buildDailySummary(dateLogs, date),
          SizedBox(height: 16),
        ],
      );
    }).toList();
  }

  /// Build daily summary card showing totals for the day - grouped by activity type
  Widget _buildDailySummary(List<ActivityLog> logs, DateTime date) {
    // Group by activity type (not by unit)
    final summaryItems = <String, _DailySummaryItem>{};
    
    for (var log in logs) {
      // Try to find matching option from hardcoded list first, or create fallback
      late final ActivityTypeOption option;
      try {
        option = activityTypeOptions.firstWhere((o) => o.type == log.activityType);
      } catch (_) {
        // Not found in hardcoded list, create a smart fallback based on log data
        final inputType = log.activityData['input_type'] as String? ?? 
                          (log.value != null ? 'number' : 'text');
        final displayName = log.activityType.replaceAll('_', ' ').split(' ').map((w) => 
          w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : w
        ).join(' ');
        
        option = ActivityTypeOption(
          type: log.activityType, 
          displayName: displayName, 
          icon: _getIconForActivityType(log.activityType, ''), 
          inputType: inputType,
          unit: log.unit,
          hasMedicationName: log.activityType.toLowerCase().contains('medication') || 
                             log.activityData.containsKey('medication_name'),
        );
      }
      
      if (option.inputType == 'medication') {
        // Handle medication separately - group by medication name
        summaryItems.putIfAbsent(log.activityType, () => _DailySummaryItem(
          type: log.activityType,
          displayName: option.displayName,
          icon: option.icon,
        ));
        
        final medName = log.activityData['medication_name'] as String? ?? 'Unknown';
        final actualUnit = log.unit ?? option.unit ?? 'tabs';
        
        summaryItems[log.activityType]!.medications.putIfAbsent(medName, () => _MedInfo());
        summaryItems[log.activityType]!.medications[medName]!.total += log.value ?? 0;
        summaryItems[log.activityType]!.medications[medName]!.unit = actualUnit;
        summaryItems[log.activityType]!.medications[medName]!.count++;
        summaryItems[log.activityType]!.count++;
      } else if (option.inputType == 'number' && log.value != null) {
        // Regular numeric activity - group by type, breakdown by unit
        summaryItems.putIfAbsent(log.activityType, () => _DailySummaryItem(
          type: log.activityType,
          displayName: option.displayName,
          icon: option.icon,
        ));
        
        final actualUnit = log.unit ?? option.unit ?? '';
        summaryItems[log.activityType]!.unitBreakdown.update(
          actualUnit, 
          (val) => val + log.value!, 
          ifAbsent: () => log.value!,
        );
        summaryItems[log.activityType]!.count++;
      } else if (option.inputType == 'photo') {
        // Photo activity - store photo info
        final photoTitle = log.activityData['title'] as String? ?? 'Photo';
        final imageBase64 = log.activityData['image_base64'] as String?;
        
        summaryItems.putIfAbsent(log.activityType, () => _DailySummaryItem(
          type: log.activityType,
          displayName: option.displayName,
          icon: option.icon,
        ));
        
        if (imageBase64 != null) {
          summaryItems[log.activityType]!.photos.add(_PhotoInfo(
            title: photoTitle,
            imageBase64: imageBase64,
          ));
        }
        summaryItems[log.activityType]!.count++;
      }
    }
    
    if (summaryItems.isEmpty) {
      return SizedBox.shrink();
    }
    
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.summarize, size: 16, color: Colors.green.shade700),
              SizedBox(width: 6),
              Text(
                'Daily Summary',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: summaryItems.values.map((item) {
              return _buildSummaryChip(item);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryChip(_DailySummaryItem item) {
    // Special handling for photos
    if (item.photos.isNotEmpty) {
      return GestureDetector(
        onTap: () => _showPhotoGallery(item.photos),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.purple.shade300),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.photo_library, size: 14, color: Colors.purple.shade600),
              SizedBox(width: 6),
              Text(
                '📷 ${item.photos.length} photo${item.photos.length > 1 ? 's' : ''}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.purple.shade800,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios, size: 10, color: Colors.purple.shade400),
            ],
          ),
        ),
      );
    }
    
    // Build display text based on type
    String displayText;
    
    if (item.medications.isNotEmpty) {
      // For medications, show each medication name and value
      final medStrings = item.medications.entries.map((e) {
        final name = e.key;
        final info = e.value;
        String valueStr = info.total == info.total.roundToDouble() 
            ? info.total.toInt().toString() 
            : info.total.toStringAsFixed(1);
        return '$name: $valueStr${info.unit}';
      }).toList();
      displayText = medStrings.join(', ');
    } else {
      // For regular activities, show unit breakdown
      final unitStrings = item.unitBreakdown.entries.map((e) {
        final unit = e.key;
        final total = e.value;
        String valueStr = total == total.roundToDouble() 
            ? total.toInt().toString() 
            : total.toStringAsFixed(1);
        return '$valueStr$unit';
      }).toList();
      displayText = unitStrings.join(' + ');
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item.icon, size: 14, color: Colors.green.shade600),
          SizedBox(width: 6),
          Flexible(
            child: Text(
              displayText,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade800,
              ),
            ),
          ),
          if (item.count > 1) ...[
            SizedBox(width: 4),
            Text(
              '(${item.count}x)',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLogItem(ActivityLog log) {
    final option = activityTypeOptions.firstWhere(
      (o) => o.type == log.activityType,
      orElse: () => ActivityTypeOption(type: log.activityType, displayName: log.activityType, icon: Icons.note, inputType: 'text'),
    );
    
    // Check if this is a photo log
    final isPhoto = log.activityData['input_type'] == 'photo';
    final imageBase64 = log.activityData['image_base64'] as String?;
    final photoTitle = log.activityData['title'] as String?;
    
    // Debug log for photo data
    if (log.activityType == 'other') {
      debugPrint('LOG ITEM: type=${log.activityType}, isPhoto=$isPhoto');
      debugPrint('LOG ITEM: input_type=${log.activityData['input_type']}');
      debugPrint('LOG ITEM: activityData keys=${log.activityData.keys.toList()}');
      debugPrint('LOG ITEM: title=${log.activityData['title']}');
      debugPrint('LOG ITEM: has image_base64=${log.activityData.containsKey('image_base64')}');
    }
    
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: isPhoto && imageBase64 != null
            ? GestureDetector(
                onTap: () => _showImagePopup(imageBase64, photoTitle ?? 'Photo'),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    base64Decode(imageBase64),
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => CircleAvatar(
                      backgroundColor: Colors.grey.shade300,
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
              )
            : CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Icon(option.icon, color: Colors.blue.shade700, size: 20),
              ),
        title: Text(
          isPhoto && photoTitle != null ? photoTitle : option.displayName, 
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: isPhoto 
            ? (imageBase64 != null 
                ? Text('📷 Tap to view${log.notes != null && log.notes!.isNotEmpty ? " • ${log.notes}" : ""}', 
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                : Text(log.notes != null && log.notes!.isNotEmpty ? log.notes! : 'Note', 
                    style: TextStyle(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ))
            : Text(_formatLogValue(log)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(DateFormat('HH:mm').format(log.loggedAt), style: TextStyle(color: Colors.grey, fontSize: 12)),
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'delete') await _deleteLog(log);
                if (value == 'view' && isPhoto && imageBase64 != null) {
                  _showImagePopup(imageBase64, photoTitle ?? 'Photo');
                }
              },
              itemBuilder: (_) => [
                if (isPhoto && imageBase64 != null)
                  PopupMenuItem(value: 'view', child: Row(children: [Icon(Icons.visibility, color: Colors.blue, size: 20), SizedBox(width: 8), Text('View Photo')])),
                PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, color: Colors.red, size: 20), SizedBox(width: 8), Text('Delete')])),
              ],
            ),
          ],
        ),
        onTap: isPhoto && imageBase64 != null 
            ? () => _showImagePopup(imageBase64, photoTitle ?? 'Photo')
            : null,
      ),
    );
  }

  void _showImagePopup(String imageBase64, String title) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              AppBar(
                title: Text(title),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Expanded(
                child: InteractiveViewer(
                  child: Image.memory(
                    base64Decode(imageBase64),
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Center(child: Text('Failed to load image')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPhotoGallery(List<_PhotoInfo> photos) {
    int currentIndex = 0;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                title: Text('Photos (${currentIndex + 1}/${photos.length})'),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Container(
                height: 350,
                child: Stack(
                  children: [
                    // Photo content
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            photos[currentIndex].title,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Expanded(
                          child: InteractiveViewer(
                            child: Image.memory(
                              base64Decode(photos[currentIndex].imageBase64),
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Center(
                                child: Text('Failed to load image'),
                              ),
                            ),
                          ),
                        ),
                        // Page indicator
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(photos.length, (i) => Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: i == currentIndex ? Colors.blue : Colors.grey.shade300,
                              ),
                            )),
                          ),
                        ),
                      ],
                    ),
                    // Navigation arrows
                    if (photos.length > 1) ...[
                      // Left arrow
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: IconButton(
                            icon: Icon(Icons.chevron_left, size: 32),
                            color: currentIndex > 0 ? Colors.blue : Colors.grey.shade300,
                            onPressed: currentIndex > 0 ? () {
                              setDialogState(() {
                                currentIndex--;
                              });
                            } : null,
                          ),
                        ),
                      ),
                      // Right arrow
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: IconButton(
                            icon: Icon(Icons.chevron_right, size: 32),
                            color: currentIndex < photos.length - 1 ? Colors.blue : Colors.grey.shade300,
                            onPressed: currentIndex < photos.length - 1 ? () {
                              setDialogState(() {
                                currentIndex++;
                              });
                            } : null,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatLogValue(ActivityLog log) {
    final parts = <String>[];
    // For medication type, show medication name first
    final medicationName = log.activityData['medication_name'] as String?;
    if (medicationName != null && medicationName.isNotEmpty) {
      parts.add(medicationName);
    }
    
    if (log.value != null) {
      parts.add('${log.value}${log.unit ?? ''}');
    }
    final text = log.activityData['text'] as String?;
    if (text != null && text.isNotEmpty) {
      parts.add(text);
    }
    if (log.notes != null && log.notes!.isNotEmpty) {
      parts.add(log.notes!);
    }
    return parts.isEmpty ? 'No details' : parts.join(' - ');
  }

  Future<void> _deleteLog(ActivityLog log) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Log'),
        content: Text('Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), style: TextButton.styleFrom(foregroundColor: Colors.red), child: Text('Delete')),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(logRepositoryProvider).deleteLog(log.id);
        ref.invalidate(petLogsProvider(widget.pet.id));
        _showSnackBar('Log deleted');
      } catch (e) {
        _showSnackBar('Error: $e', isError: true);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: isError ? Colors.red : Colors.green),
      );
    }
  }
}
