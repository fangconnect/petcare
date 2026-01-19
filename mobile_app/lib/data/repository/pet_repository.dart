import 'package:dio/dio.dart';
import '../models/models.dart';

class PetRepository {
  final Dio _dio;

  PetRepository(this._dio);

  /// Creates a new pet
  Future<Pet> createPet({
    required String ownerId,
    required String diseaseId,
    required String name,
    String? species,
    String? breed,
    String? imageUrl,
    String? birthdate,
    String? templateId,
  }) async {
    try {
      final response = await _dio.post(
        '/api/pets',
        data: {
          'owner_id': ownerId,
          'disease_id': diseaseId,
          'name': name,
          if (species != null && species.isNotEmpty) 'species': species,
          if (breed != null && breed.isNotEmpty) 'breed': breed,
          if (imageUrl != null && imageUrl.isNotEmpty) 'photo_url': imageUrl,
          if (birthdate != null && birthdate.isNotEmpty) 'birth_date': birthdate,
          if (templateId != null && templateId.isNotEmpty) 'template_id': templateId,
        },
      );

      if (response.statusCode == 201 && response.data['success'] == true) {
        final data = response.data['data'];
        
        // Debug: Print response to see structure
        print('Pet creation response data: $data');
        print('Pet creation response data type: ${data.runtimeType}');
        
        // Ensure data is a Map
        if (data is! Map<String, dynamic>) {
          print('Error: data is not a Map, it is: ${data.runtimeType}');
          throw Exception('Invalid response format: data is not a Map');
        }
        
        // Convert UUID objects to strings if needed
        final Map<String, dynamic> petData = Map<String, dynamic>.from(data);
        if (petData['id'] != null && petData['id'] is! String) {
          petData['id'] = petData['id'].toString();
        }
        if (petData['user_id'] != null && petData['user_id'] is! String) {
          petData['user_id'] = petData['user_id'].toString();
        }
        
        try {
          return Pet.fromJson(petData);
        } catch (e, stackTrace) {
          print('Error parsing Pet from JSON: $e');
          print('Stack trace: $stackTrace');
          print('Data being parsed: $petData');
          rethrow;
        }
      } else {
        throw Exception('Failed to create pet: ${response.data}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to create pet: ${e.response?.data}');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Gets all pets for a specific user
  Future<List<Pet>> getPetsByUserID(String userId) async {
    try {
      final response = await _dio.get('/api/users/$userId/pets');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) {
          // Convert UUID objects to strings if needed
          final Map<String, dynamic> petData = Map<String, dynamic>.from(json);
          if (petData['id'] != null && petData['id'] is! String) {
            petData['id'] = petData['id'].toString();
          }
          if (petData['user_id'] != null && petData['user_id'] is! String) {
            petData['user_id'] = petData['user_id'].toString();
          }
          return Pet.fromJson(petData);
        }).toList();
      } else {
        throw Exception('Failed to fetch pets: ${response.data}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to fetch pets: ${e.response?.data}');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
