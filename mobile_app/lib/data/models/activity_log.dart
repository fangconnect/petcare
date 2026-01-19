import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_log.freezed.dart';
part 'activity_log.g.dart';

/// Common activity type constants
class ActivityTypes {
  static const String waterIntake = 'water_intake';
  static const String foodIntake = 'food_intake';
  static const String weight = 'weight';
  static const String medication = 'medication';
  static const String urination = 'urination';
  static const String defecation = 'defecation';
  static const String vomiting = 'vomiting';
  static const String exercise = 'exercise';
  static const String sleep = 'sleep';
  static const String symptom = 'symptom';
  static const String behavior = 'behavior';
  static const String vitalSigns = 'vital_signs';
  static const String bloodGlucose = 'blood_glucose';
  static const String appetite = 'appetite';
  static const String mood = 'mood';
}

@freezed
class ActivityLog with _$ActivityLog {
  const ActivityLog._();

  const factory ActivityLog({
    required String id,
    @JsonKey(name: 'pet_id') required String petId,
    @JsonKey(name: 'pet_disease_id') String? petDiseaseId,
    @JsonKey(name: 'activity_type') required String activityType,
    @JsonKey(name: 'logged_at') required DateTime loggedAt,
    @JsonKey(name: 'activity_data') @Default({}) Map<String, dynamic> activityData,
    String? notes,
    @JsonKey(name: 'logged_by') String? loggedBy,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    List<ActivityPhoto>? photos,
  }) = _ActivityLog;

  factory ActivityLog.fromJson(Map<String, dynamic> json) => _$ActivityLogFromJson(json);

  /// Get numeric value from activity_data
  double? get value {
    final val = activityData['value'];
    if (val == null) return null;
    if (val is num) return val.toDouble();
    return null;
  }

  /// Get unit from activity_data
  String? get unit => activityData['unit'] as String?;

  /// Get input type from activity_data
  String? get inputType => activityData['input_type'] as String?;

  /// Check if this is a checkbox type activity
  bool get isChecked => activityData['checked'] == true;
}

@freezed
class ActivityPhoto with _$ActivityPhoto {
  const factory ActivityPhoto({
    required String id,
    @JsonKey(name: 'activity_log_id') required String activityLogId,
    @JsonKey(name: 'photo_url') required String photoUrl,
    @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
    String? caption,
    @JsonKey(name: 'file_size') int? fileSize,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _ActivityPhoto;

  factory ActivityPhoto.fromJson(Map<String, dynamic> json) => _$ActivityPhotoFromJson(json);
}
