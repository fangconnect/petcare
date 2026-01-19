import 'package:freezed_annotation/freezed_annotation.dart';
import 'pet_disease.dart';

part 'pet.freezed.dart';
part 'pet.g.dart';

@freezed
class Pet with _$Pet {
  const Pet._();

  const factory Pet({
    required String id,
    @JsonKey(name: 'owner_id') required String ownerId,
    required String name,
    String? species,
    String? breed,
    @JsonKey(name: 'birth_date') DateTime? birthDate,
    @JsonKey(name: 'current_weight') double? currentWeight,
    String? gender,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'microchip_id') String? microchipId,
    @JsonKey(name: 'medical_history') Map<String, dynamic>? medicalHistory,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'pet_diseases') List<PetDisease>? petDiseases,
  }) = _Pet;

  factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);

  /// Get pet's age in years and months
  (int years, int months) get age {
    if (birthDate == null) return (0, 0);
    final now = DateTime.now();
    int years = now.year - birthDate!.year;
    int months = now.month - birthDate!.month;
    if (months < 0) {
      years--;
      months += 12;
    }
    return (years, months);
  }

  /// Get age as formatted string
  String get ageString {
    final (years, months) = age;
    if (years == 0 && months == 0) return 'Unknown';
    if (years == 0) return '$months months';
    if (months == 0) return '$years years';
    return '$years years, $months months';
  }

  /// Get active diseases only
  List<PetDisease> get activeDiseases {
    return petDiseases?.where((pd) => pd.isActive).toList() ?? [];
  }
}
