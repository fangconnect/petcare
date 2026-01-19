// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_disease.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PetDiseaseImpl _$$PetDiseaseImplFromJson(Map<String, dynamic> json) =>
    _$PetDiseaseImpl(
      id: json['id'] as String,
      petId: json['pet_id'] as String,
      diseaseId: json['disease_id'] as String,
      diagnosedDate: json['diagnosed_date'] == null
          ? null
          : DateTime.parse(json['diagnosed_date'] as String),
      severity: json['severity'] as String?,
      notes: json['notes'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      recoveryDate: json['recovery_date'] == null
          ? null
          : DateTime.parse(json['recovery_date'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      disease: json['disease'] == null
          ? null
          : Disease.fromJson(json['disease'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PetDiseaseImplToJson(_$PetDiseaseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pet_id': instance.petId,
      'disease_id': instance.diseaseId,
      'diagnosed_date': instance.diagnosedDate?.toIso8601String(),
      'severity': instance.severity,
      'notes': instance.notes,
      'is_active': instance.isActive,
      'recovery_date': instance.recoveryDate?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'disease': instance.disease,
    };
