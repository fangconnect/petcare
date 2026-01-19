import 'package:dio/dio.dart';
import '../models/models.dart';

class LogRepository {
  final Dio _dio;

  LogRepository(this._dio);

  /// Creates a new activity log using new schema
  Future<ActivityLog> createLog({
    required String petId,
    required String activityType,
    Map<String, dynamic>? activityData,
    String? notes,
    required DateTime loggedAt,
    String? petDiseaseId,
  }) async {
    try {
      final response = await _dio.post(
        '/api/logs',
        data: {
          'pet_id': petId,
          'activity_type': activityType,
          if (activityData != null) 'activity_data': activityData,
          if (notes != null && notes.isNotEmpty) 'notes': notes,
          'logged_at': loggedAt.toIso8601String(),
          if (petDiseaseId != null) 'pet_disease_id': petDiseaseId,
        },
      );

      if (response.statusCode == 201 && response.data['success'] == true) {
        final data = response.data['data'];
        
        if (data is! Map<String, dynamic>) {
          throw Exception('Invalid response format: data is not a Map');
        }
        
        final Map<String, dynamic> logData = Map<String, dynamic>.from(data);
        if (logData['id'] != null && logData['id'] is! String) {
          logData['id'] = logData['id'].toString();
        }
        if (logData['pet_id'] != null && logData['pet_id'] is! String) {
          logData['pet_id'] = logData['pet_id'].toString();
        }
        
        // Ensure required DateTime fields
        logData['logged_at'] ??= DateTime.now().toIso8601String();
        logData['created_at'] ??= DateTime.now().toIso8601String();
        logData['updated_at'] ??= DateTime.now().toIso8601String();
        
        return ActivityLog.fromJson(logData);
      } else {
        throw Exception('Failed to create log: ${response.data}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to create log: ${e.response?.data}');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Gets all logs for a specific pet
  Future<List<ActivityLog>> getLogsByPetID(String petId) async {
    try {
      final response = await _dio.get('/api/pets/$petId/logs');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) {
          final Map<String, dynamic> logData = Map<String, dynamic>.from(json);
          if (logData['id'] != null && logData['id'] is! String) {
            logData['id'] = logData['id'].toString();
          }
          if (logData['pet_id'] != null && logData['pet_id'] is! String) {
            logData['pet_id'] = logData['pet_id'].toString();
          }
          
          logData['logged_at'] ??= DateTime.now().toIso8601String();
          logData['created_at'] ??= DateTime.now().toIso8601String();
          logData['updated_at'] ??= DateTime.now().toIso8601String();
          
          return ActivityLog.fromJson(logData);
        }).toList();
      } else {
        throw Exception('Failed to fetch logs: ${response.data}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to fetch logs: ${e.response?.data}');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Updates an existing activity log
  Future<ActivityLog> updateLog({
    required String logId,
    String? activityType,
    Map<String, dynamic>? activityData,
    String? notes,
    DateTime? loggedAt,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      
      if (activityType != null) data['activity_type'] = activityType;
      if (activityData != null) data['activity_data'] = activityData;
      if (notes != null) data['notes'] = notes;
      if (loggedAt != null) data['logged_at'] = loggedAt.toIso8601String();

      final response = await _dio.put(
        '/api/logs/$logId',
        data: data,
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final logData = Map<String, dynamic>.from(response.data['data']);
        
        if (logData['id'] != null && logData['id'] is! String) {
          logData['id'] = logData['id'].toString();
        }
        if (logData['pet_id'] != null && logData['pet_id'] is! String) {
          logData['pet_id'] = logData['pet_id'].toString();
        }
        
        return ActivityLog.fromJson(logData);
      } else {
        throw Exception('Failed to update log: ${response.data}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to update log: ${e.response?.data}');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Deletes an activity log by ID
  Future<void> deleteLog(String logId) async {
    try {
      final response = await _dio.delete('/api/logs/$logId');

      if (response.statusCode != 200 || response.data['success'] != true) {
        throw Exception('Failed to delete log: ${response.data}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to delete log: ${e.response?.data}');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Gets template activity types for a pet based on their active disease template
  Future<Map<String, dynamic>> getTemplateActivityTypes(String petId) async {
    try {
      final response = await _dio.get('/api/pets/$petId/template-activity-types');

      if (response.statusCode == 200) {
        return {
          'activity_types': response.data['activity_types'] ?? [],
          'disease': response.data['disease'],
          'template': response.data['template'],
        };
      } else {
        throw Exception('Failed to fetch template activity types: ${response.data}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to fetch template activity types: ${e.response?.data}');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Sets the tracking config (template) for a pet disease
  Future<void> setTrackingConfig({
    required String petId,
    required String petDiseaseId,
    required String templateId,
  }) async {
    try {
      final response = await _dio.put(
        '/api/pets/$petId/diseases/$petDiseaseId/tracking-config',
        data: {'template_id': templateId},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to set tracking config: ${response.data}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to set tracking config: ${e.response?.data}');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Gets summary config for a pet based on their template
  /// Returns null if no template is configured
  Future<Map<String, dynamic>?> getSummaryConfig(String petId) async {
    try {
      // First get template info
      final templateData = await getTemplateActivityTypes(petId);
      final template = templateData['template'];
      
      if (template == null || template['id'] == null) {
        return null; // No template configured
      }
      
      final templateId = template['id'].toString();
      
      // Fetch summary config from admin endpoint (will work with valid token)
      final response = await _dio.get('/api/admin/templates/$templateId/summary-config');
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      }
      return null;
    } on DioException catch (_) {
      // Return null if failed (user may not have permission or no config)
      return null;
    } catch (_) {
      return null;
    }
  }
}
