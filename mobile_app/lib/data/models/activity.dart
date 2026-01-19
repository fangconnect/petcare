import 'package:freezed_annotation/freezed_annotation.dart';
import 'activity_input_type.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

@freezed
class Activity with _$Activity {
  const factory Activity({
    @JsonKey(fromJson: _intFromJson) required int id,
    required String name,
    String? unit,
    @JsonKey(name: 'input_type', fromJson: _activityInputTypeFromJson) required ActivityInputType inputType,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt,
  }) = _Activity;

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
}

int _intFromJson(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return 0;
}

DateTime? _dateTimeFromJson(dynamic value) {
  if (value == null) return null;
  if (value is String) {
    try {
      return DateTime.parse(value);
    } catch (e) {
      return null;
    }
  }
  return null;
}

ActivityInputType _activityInputTypeFromJson(dynamic value) {
  if (value == null) return ActivityInputType.number;
  if (value is String) {
    switch (value.toLowerCase()) {
      case 'number':
        return ActivityInputType.number;
      case 'text':
        return ActivityInputType.text;
      case 'checkbox':
        return ActivityInputType.checkbox;
      default:
        return ActivityInputType.number;
    }
  }
  return ActivityInputType.number;
}
