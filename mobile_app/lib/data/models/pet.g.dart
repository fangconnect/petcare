// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PetImpl _$$PetImplFromJson(Map<String, dynamic> json) => _$PetImpl(
  id: json['id'] as String,
  ownerId: json['owner_id'] as String,
  name: json['name'] as String,
  species: json['species'] as String?,
  breed: json['breed'] as String?,
  birthDate: json['birth_date'] == null
      ? null
      : DateTime.parse(json['birth_date'] as String),
  currentWeight: (json['current_weight'] as num?)?.toDouble(),
  gender: json['gender'] as String?,
  photoUrl: json['photo_url'] as String?,
  microchipId: json['microchip_id'] as String?,
  medicalHistory: json['medical_history'] as Map<String, dynamic>?,
  isActive: json['is_active'] as bool? ?? true,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  petDiseases: (json['pet_diseases'] as List<dynamic>?)
      ?.map((e) => PetDisease.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$PetImplToJson(_$PetImpl instance) => <String, dynamic>{
  'id': instance.id,
  'owner_id': instance.ownerId,
  'name': instance.name,
  'species': instance.species,
  'breed': instance.breed,
  'birth_date': instance.birthDate?.toIso8601String(),
  'current_weight': instance.currentWeight,
  'gender': instance.gender,
  'photo_url': instance.photoUrl,
  'microchip_id': instance.microchipId,
  'medical_history': instance.medicalHistory,
  'is_active': instance.isActive,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'pet_diseases': instance.petDiseases,
};
