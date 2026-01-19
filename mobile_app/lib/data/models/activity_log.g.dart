// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityLogImpl _$$ActivityLogImplFromJson(Map<String, dynamic> json) =>
    _$ActivityLogImpl(
      id: json['id'] as String,
      petId: json['pet_id'] as String,
      petDiseaseId: json['pet_disease_id'] as String?,
      activityType: json['activity_type'] as String,
      loggedAt: DateTime.parse(json['logged_at'] as String),
      activityData: json['activity_data'] as Map<String, dynamic>? ?? const {},
      notes: json['notes'] as String?,
      loggedBy: json['logged_by'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => ActivityPhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ActivityLogImplToJson(_$ActivityLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pet_id': instance.petId,
      'pet_disease_id': instance.petDiseaseId,
      'activity_type': instance.activityType,
      'logged_at': instance.loggedAt.toIso8601String(),
      'activity_data': instance.activityData,
      'notes': instance.notes,
      'logged_by': instance.loggedBy,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'photos': instance.photos,
    };

_$ActivityPhotoImpl _$$ActivityPhotoImplFromJson(Map<String, dynamic> json) =>
    _$ActivityPhotoImpl(
      id: json['id'] as String,
      activityLogId: json['activity_log_id'] as String,
      photoUrl: json['photo_url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String?,
      caption: json['caption'] as String?,
      fileSize: (json['file_size'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$ActivityPhotoImplToJson(_$ActivityPhotoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'activity_log_id': instance.activityLogId,
      'photo_url': instance.photoUrl,
      'thumbnail_url': instance.thumbnailUrl,
      'caption': instance.caption,
      'file_size': instance.fileSize,
      'created_at': instance.createdAt?.toIso8601String(),
    };
