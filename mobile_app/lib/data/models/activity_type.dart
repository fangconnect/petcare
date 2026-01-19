import 'package:freezed_annotation/freezed_annotation.dart';
import 'unit.dart';

part 'activity_type.freezed.dart';
part 'activity_type.g.dart';

@freezed
class ActivityType with _$ActivityType {
  const factory ActivityType({
    required String id,
    required String name,
    @JsonKey(name: 'name_en') String? nameEn,
    @JsonKey(name: 'input_type') @Default('number') String inputType,
    @Default('other') String category,
    String? icon,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @Default([]) List<Unit> units, // Available units for this type
  }) = _ActivityType;

  factory ActivityType.fromJson(Map<String, dynamic> json) => _$ActivityTypeFromJson(json);
}
