import 'package:dio/dio.dart';
import '../models/models.dart';

class ConfigRepository {
  final Dio _dio;

  ConfigRepository(this._dio);

  /// Fetches all diseases with their activities from the API
  Future<List<Disease>> getAllDiseases() async {
    try {
      final response = await _dio.get('/api/configs/diseases');
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        
        // Debug: Print first item to see the structure
        if (data.isNotEmpty) {
          print('Sample disease JSON: ${data[0]}');
        }
        
        return data.map((json) {
          try {
            return Disease.fromJson(json as Map<String, dynamic>);
          } catch (e, stackTrace) {
            print('Error parsing disease: $e');
            print('JSON: $json');
            print('Stack: $stackTrace');
            rethrow;
          }
        }).toList();
      } else {
        throw Exception('Failed to fetch diseases: ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Fetches templates for a specific disease
  Future<List<DiseaseTemplate>> getTemplatesByDiseaseId(String diseaseId) async {
    try {
      final response = await _dio.get('/api/admin/diseases/$diseaseId/templates');
      
      if (response.statusCode == 200) {
        final templatesList = response.data['templates'] as List<dynamic>? ?? [];
        
        return templatesList.map((json) {
          return DiseaseTemplate.fromJson(json as Map<String, dynamic>);
        }).toList();
      } else {
        throw Exception('Failed to fetch templates: ${response.data}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return []; // No templates found
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}

