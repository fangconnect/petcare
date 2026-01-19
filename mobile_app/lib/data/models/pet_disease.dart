import 'package:freezed_annotation/freezed_annotation.dart';
import 'disease.dart';

part 'pet_disease.freezed.dart';
part 'pet_disease.g.dart';

@freezed
class PetDisease with _$PetDisease {
  const factory PetDisease({
    required String id,
    @JsonKey(name: 'pet_id') required String petId,
    @JsonKey(name: 'disease_id') required String diseaseId,
    @JsonKey(name: 'diagnosed_date') DateTime? diagnosedDate,
    String? severity, // mild, moderate, severe
    String? notes,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'recovery_date') DateTime? recoveryDate,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    Disease? disease,
  }) = _PetDisease;

  factory PetDisease.fromJson(Map<String, dynamic> json) => _$PetDiseaseFromJson(json);
}
