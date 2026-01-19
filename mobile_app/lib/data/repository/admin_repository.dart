import 'package:dio/dio.dart';
import '../models/disease.dart';
import '../models/disease_template.dart';
import '../models/activity_type.dart';
import '../../core/config/app_config.dart';
import '../../core/services/token_storage.dart';

/// Repository for admin API calls (Disease & Template management)
class AdminRepository {
  final Dio _dio;

  AdminRepository({Dio? dio}) : _dio = dio ?? Dio() {
    _setupDio();
  }

  void _setupDio() {
    _dio.options.baseUrl = AppConfig().apiBaseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  // ==================== Disease ====================

  Future<List<Disease>> getAllDiseases() async {
    final response = await _dio.get('/api/admin/diseases');
    final List<dynamic> data = response.data['diseases'] ?? [];
    return data.map((json) => Disease.fromJson(json)).toList();
  }

  Future<Disease> getDiseaseById(String id) async {
    final response = await _dio.get('/api/admin/diseases/$id');
    return Disease.fromJson(response.data);
  }

  Future<Disease> createDisease(Disease disease) async {
    final response = await _dio.post('/api/admin/diseases', data: {
      'name': disease.name,
      'name_en': disease.nameEn,
      'category': disease.category,
      'description': disease.description,
    });
    return Disease.fromJson(response.data);
  }

  Future<Disease> updateDisease(String id, Disease disease) async {
    final response = await _dio.put('/api/admin/diseases/$id', data: {
      'name': disease.name,
      'name_en': disease.nameEn,
      'category': disease.category,
      'description': disease.description,
    });
    return Disease.fromJson(response.data);
  }

  Future<void> deleteDisease(String id) async {
    await _dio.delete('/api/admin/diseases/$id');
  }

  // ==================== Template ====================

  Future<List<DiseaseTemplate>> getTemplatesByDiseaseId(String diseaseId) async {
    final response = await _dio.get('/api/admin/diseases/$diseaseId/templates');
    final List<dynamic> data = response.data['templates'] ?? [];
    return data.map((json) => DiseaseTemplate.fromJson(json)).toList();
  }

  Future<DiseaseTemplate> getTemplateById(String id) async {
    final response = await _dio.get('/api/admin/templates/$id');
    return DiseaseTemplate.fromJson(response.data);
  }

  Future<DiseaseTemplate> createTemplate(DiseaseTemplate template) async {
    final response = await _dio.post('/api/admin/templates', data: {
      'disease_id': template.diseaseId,
      'template_name': template.templateName,
      'description': template.description,
      'is_default': template.isDefault,
      'activity_types': template.activityTypes.map((at) => {
        'activity_type_id': at.activityTypeId,
        'is_required': at.isRequired,
        'sort_order': at.sortOrder,
      }).toList(),
    });
    return DiseaseTemplate.fromJson(response.data);
  }

  Future<DiseaseTemplate> updateTemplate(String id, DiseaseTemplate template) async {
    final response = await _dio.put('/api/admin/templates/$id', data: {
      'template_name': template.templateName,
      'description': template.description,
      'activity_types': template.activityTypes.map((at) => {
        'activity_type_id': at.activityTypeId,
        'is_required': at.isRequired,
        'sort_order': at.sortOrder,
      }).toList(),
    });
    return DiseaseTemplate.fromJson(response.data);
  }

  Future<void> deleteTemplate(String id) async {
    await _dio.delete('/api/admin/templates/$id');
  }

  Future<void> setDefaultTemplate(String id) async {
    await _dio.post('/api/admin/templates/$id/set-default');
  }

  // ==================== User Management ====================

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final response = await _dio.get('/api/admin/users');
    final List<dynamic> data = response.data['users'] ?? [];
    return data.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> createUser({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) async {
    final response = await _dio.post('/api/admin/users', data: {
      'email': email,
      'password': password,
      'full_name': fullName,
      'role': role,
    });
    return response.data['user'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateUser(String id, {
    String? email,
    String? fullName,
    String? phone,
    String? role,
  }) async {
    final data = <String, dynamic>{};
    if (email != null) data['email'] = email;
    if (fullName != null) data['full_name'] = fullName;
    if (phone != null) data['phone'] = phone;
    if (role != null) data['role'] = role;
    
    final response = await _dio.put('/api/admin/users/$id', data: data);
    return response.data['user'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> toggleUserActive(String id) async {
    final response = await _dio.put('/api/admin/users/$id/toggle-active');
    return response.data['user'] as Map<String, dynamic>;
  }

  // ==================== Activity Type ====================

  Future<List<ActivityType>> getAllActivityTypes() async {
    final response = await _dio.get('/api/admin/activity-types');
    final List<dynamic> data = response.data['activity_types'] ?? [];
    return data.map((json) => ActivityType.fromJson(json)).toList();
  }

  Future<ActivityType> createActivityType(ActivityType type) async {
    final response = await _dio.post('/api/admin/activity-types', data: {
      'name': type.name,
      'name_en': type.nameEn,
      'input_type': type.inputType,
      'category': type.category,
      'units': type.units.map((u) => {'name': u.name, 'name_en': u.nameEn}).toList(),
    });
    return ActivityType.fromJson(response.data['activity_type'] ?? response.data);
  }

  Future<ActivityType> updateActivityType(String id, ActivityType type) async {
    final response = await _dio.put('/api/admin/activity-types/$id', data: {
      'name': type.name,
      'name_en': type.nameEn,
      'input_type': type.inputType,
      'category': type.category,
      'is_active': type.isActive,
      'units': type.units.map((u) => {'name': u.name, 'name_en': u.nameEn}).toList(),
    });
    return ActivityType.fromJson(response.data['activity_type'] ?? response.data);
  }

  Future<void> deleteActivityType(String id) async {
    await _dio.delete('/api/admin/activity-types/$id');
  }

  // ==================== Species Standard ====================

  Future<List<Map<String, dynamic>>> getAllSpeciesStandards() async {
    final response = await _dio.get('/api/admin/species-standards');
    final List<dynamic> data = response.data['species_standards'] ?? [];
    return data.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> createSpeciesStandard({
    required String species,
    String? breed,
    Map<String, dynamic>? normalRanges,
  }) async {
    final response = await _dio.post('/api/admin/species-standards', data: {
      'species': species,
      'breed': breed,
      'normal_ranges': normalRanges ?? {},
    });
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateSpeciesStandard(String id, {
    String? species,
    String? breed,
    Map<String, dynamic>? normalRanges,
  }) async {
    final data = <String, dynamic>{};
    if (species != null) data['species'] = species;
    if (breed != null) data['breed'] = breed;
    if (normalRanges != null) data['normal_ranges'] = normalRanges;
    
    final response = await _dio.put('/api/admin/species-standards/$id', data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<void> deleteSpeciesStandard(String id) async {
    await _dio.delete('/api/admin/species-standards/$id');
  }

  // ==================== Unit Management ====================

  Future<List<Map<String, dynamic>>> getAllUnits() async {
    final response = await _dio.get('/api/admin/units');
    final List<dynamic> data = response.data['units'] ?? [];
    return data.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> createUnit({
    required String name,
    String? nameEn,
    String? symbol,
    String? category,
  }) async {
    final response = await _dio.post('/api/admin/units', data: {
      'name': name,
      'name_en': nameEn,
      'symbol': symbol,
      'category': category,
    });
    return response.data['unit'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateUnit(String id, {
    String? name,
    String? nameEn,
    String? symbol,
    String? category,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (nameEn != null) data['name_en'] = nameEn;
    if (symbol != null) data['symbol'] = symbol;
    if (category != null) data['category'] = category;

    final response = await _dio.put('/api/admin/units/$id', data: data);
    return response.data['unit'] as Map<String, dynamic>;
  }

  Future<void> deleteUnit(String id) async {
    await _dio.delete('/api/admin/units/$id');
  }

  // ==================== Activity Type Unit Linking ====================

  Future<ActivityType> updateActivityTypeWithUnits(String id, ActivityType type, List<String> unitIds) async {
    final response = await _dio.put('/api/admin/activity-types/$id', data: {
      'name': type.name,
      'name_en': type.nameEn,
      'input_type': type.inputType,
      'category': type.category,
      'is_active': type.isActive,
      'unit_ids': unitIds,
    });
    return ActivityType.fromJson(response.data['activity_type'] ?? response.data);
  }

  Future<ActivityType> createActivityTypeWithUnits(ActivityType type, List<String> unitIds) async {
    final response = await _dio.post('/api/admin/activity-types', data: {
      'name': type.name,
      'name_en': type.nameEn,
      'input_type': type.inputType,
      'category': type.category,
      'unit_ids': unitIds,
    });
    return ActivityType.fromJson(response.data['activity_type'] ?? response.data);
  }

  // ==================== Summary Config ====================

  /// Get summary config for a template
  Future<Map<String, dynamic>> getSummaryConfig(String templateId) async {
    final response = await _dio.get('/api/admin/templates/$templateId/summary-config');
    return response.data['data'] as Map<String, dynamic>;
  }

  /// Create a new summary section
  Future<Map<String, dynamic>> createSummarySection(String templateId, {
    required String name,
    String? nameTH,
    String? icon,
    String? color,
    int displayOrder = 0,
    bool isVisible = true,
  }) async {
    final response = await _dio.post('/api/admin/templates/$templateId/summary-sections', data: {
      'name': name,
      'name_th': nameTH,
      'icon': icon,
      'color': color,
      'display_order': displayOrder,
      'is_visible': isVisible,
    });
    return response.data['data'] as Map<String, dynamic>;
  }

  /// Update a summary section
  Future<Map<String, dynamic>> updateSummarySection(String sectionId, {
    String? name,
    String? nameTH,
    String? icon,
    String? color,
    int? displayOrder,
    bool? isVisible,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (nameTH != null) data['name_th'] = nameTH;
    if (icon != null) data['icon'] = icon;
    if (color != null) data['color'] = color;
    if (displayOrder != null) data['display_order'] = displayOrder;
    if (isVisible != null) data['is_visible'] = isVisible;
    
    final response = await _dio.put('/api/admin/summary-sections/$sectionId', data: data);
    return response.data['data'] as Map<String, dynamic>;
  }

  /// Delete a summary section
  Future<void> deleteSummarySection(String sectionId) async {
    await _dio.delete('/api/admin/summary-sections/$sectionId');
  }

  /// Create a section item
  Future<Map<String, dynamic>> createSectionItem(String sectionId, {
    required String label,
    String? labelTH,
    required List<String> activityTypes,
    String formula = 'SUM',
    String? unit,
    bool groupByUnit = false,
    int displayOrder = 0,
    bool isVisible = true,
  }) async {
    final response = await _dio.post('/api/admin/summary-sections/$sectionId/items', data: {
      'label': label,
      'label_th': labelTH,
      'activity_types': activityTypes,
      'formula': formula,
      'unit': unit,
      'group_by_unit': groupByUnit,
      'display_order': displayOrder,
      'is_visible': isVisible,
    });
    return response.data['data'] as Map<String, dynamic>;
  }

  /// Update a section item
  Future<Map<String, dynamic>> updateSectionItem(String itemId, {
    String? label,
    String? labelTH,
    List<String>? activityTypes,
    String? formula,
    String? unit,
    bool? groupByUnit,
    int? displayOrder,
    bool? isVisible,
  }) async {
    final data = <String, dynamic>{};
    if (label != null) data['label'] = label;
    if (labelTH != null) data['label_th'] = labelTH;
    if (activityTypes != null) data['activity_types'] = activityTypes;
    if (formula != null) data['formula'] = formula;
    if (unit != null) data['unit'] = unit;
    if (groupByUnit != null) data['group_by_unit'] = groupByUnit;
    if (displayOrder != null) data['display_order'] = displayOrder;
    if (isVisible != null) data['is_visible'] = isVisible;
    
    final response = await _dio.put('/api/admin/summary-section-items/$itemId', data: data);
    return response.data['data'] as Map<String, dynamic>;
  }

  /// Delete a section item
  Future<void> deleteSectionItem(String itemId) async {
    await _dio.delete('/api/admin/summary-section-items/$itemId');
  }

  /// Create a summary chart
  Future<Map<String, dynamic>> createSummaryChart(String templateId, {
    required String title,
    String? titleTH,
    String chartType = 'bar',
    required List<String> activityTypes,
    String xAxis = 'date',
    String yAxis = 'value',
    String? groupBy,
    int displayOrder = 0,
    bool isVisible = true,
  }) async {
    final response = await _dio.post('/api/admin/templates/$templateId/summary-charts', data: {
      'title': title,
      'title_th': titleTH,
      'chart_type': chartType,
      'activity_types': activityTypes,
      'x_axis': xAxis,
      'y_axis': yAxis,
      'group_by': groupBy,
      'display_order': displayOrder,
      'is_visible': isVisible,
    });
    return response.data['data'] as Map<String, dynamic>;
  }

  /// Update a chart
  Future<Map<String, dynamic>> updateSummaryChart(String chartId, {
    String? title,
    String? titleTH,
    String? chartType,
    List<String>? activityTypes,
    String? xAxis,
    String? yAxis,
    String? groupBy,
    int? displayOrder,
    bool? isVisible,
  }) async {
    final data = <String, dynamic>{};
    if (title != null) data['title'] = title;
    if (titleTH != null) data['title_th'] = titleTH;
    if (chartType != null) data['chart_type'] = chartType;
    if (activityTypes != null) data['activity_types'] = activityTypes;
    if (xAxis != null) data['x_axis'] = xAxis;
    if (yAxis != null) data['y_axis'] = yAxis;
    if (groupBy != null) data['group_by'] = groupBy;
    if (displayOrder != null) data['display_order'] = displayOrder;
    if (isVisible != null) data['is_visible'] = isVisible;
    
    final response = await _dio.put('/api/admin/summary-charts/$chartId', data: data);
    return response.data['data'] as Map<String, dynamic>;
  }

  /// Delete a chart
  Future<void> deleteSummaryChart(String chartId) async {
    await _dio.delete('/api/admin/summary-charts/$chartId');
  }
}
