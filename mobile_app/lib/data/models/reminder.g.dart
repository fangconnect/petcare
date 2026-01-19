// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReminderImpl _$$ReminderImplFromJson(Map<String, dynamic> json) =>
    _$ReminderImpl(
      id: json['id'] as String,
      petId: json['pet_id'] as String,
      petDiseaseId: json['pet_disease_id'] as String?,
      reminderType: json['reminder_type'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      scheduledTime: json['scheduled_time'] as String,
      frequency: json['frequency'] as String? ?? 'daily',
      frequencyConfig: json['frequency_config'] as Map<String, dynamic>?,
      isActive: json['is_active'] as bool? ?? true,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ReminderImplToJson(_$ReminderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pet_id': instance.petId,
      'pet_disease_id': instance.petDiseaseId,
      'reminder_type': instance.reminderType,
      'title': instance.title,
      'description': instance.description,
      'scheduled_time': instance.scheduledTime,
      'frequency': instance.frequency,
      'frequency_config': instance.frequencyConfig,
      'is_active': instance.isActive,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$ReminderLogImpl _$$ReminderLogImplFromJson(Map<String, dynamic> json) =>
    _$ReminderLogImpl(
      id: json['id'] as String,
      reminderId: json['reminder_id'] as String,
      scheduledFor: DateTime.parse(json['scheduled_for'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      status: json['status'] as String? ?? 'pending',
      completedBy: json['completed_by'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$ReminderLogImplToJson(_$ReminderLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reminder_id': instance.reminderId,
      'scheduled_for': instance.scheduledFor.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
      'status': instance.status,
      'completed_by': instance.completedBy,
      'notes': instance.notes,
      'created_at': instance.createdAt?.toIso8601String(),
    };
