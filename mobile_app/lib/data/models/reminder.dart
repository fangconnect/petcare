import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder.freezed.dart';
part 'reminder.g.dart';

/// Reminder frequency constants
class ReminderFrequency {
  static const String daily = 'daily';
  static const String weekly = 'weekly';
  static const String monthly = 'monthly';
  static const String custom = 'custom';
}

/// Reminder type constants
class ReminderTypes {
  static const String medication = 'medication';
  static const String feeding = 'feeding';
  static const String exercise = 'exercise';
  static const String vetVisit = 'vet_visit';
  static const String grooming = 'grooming';
  static const String tracking = 'tracking';
}

@freezed
class Reminder with _$Reminder {
  const factory Reminder({
    required String id,
    @JsonKey(name: 'pet_id') required String petId,
    @JsonKey(name: 'pet_disease_id') String? petDiseaseId,
    @JsonKey(name: 'reminder_type') required String reminderType,
    required String title,
    String? description,
    @JsonKey(name: 'scheduled_time') required String scheduledTime, // HH:mm format
    @Default('daily') String frequency,
    @JsonKey(name: 'frequency_config') Map<String, dynamic>? frequencyConfig,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'start_date') required DateTime startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Reminder;

  factory Reminder.fromJson(Map<String, dynamic> json) => _$ReminderFromJson(json);
}

@freezed
class ReminderLog with _$ReminderLog {
  const factory ReminderLog({
    required String id,
    @JsonKey(name: 'reminder_id') required String reminderId,
    @JsonKey(name: 'scheduled_for') required DateTime scheduledFor,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @Default('pending') String status, // pending, completed, skipped, missed
    @JsonKey(name: 'completed_by') String? completedBy,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _ReminderLog;

  factory ReminderLog.fromJson(Map<String, dynamic> json) => _$ReminderLogFromJson(json);
}
