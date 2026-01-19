import 'package:freezed_annotation/freezed_annotation.dart';
import 'activity_type.dart';

part 'disease_template.freezed.dart';
part 'disease_template.g.dart';

@freezed
class DiseaseTemplate with _$DiseaseTemplate {
  const factory DiseaseTemplate({
    required String id,
    @JsonKey(name: 'disease_id') required String diseaseId,
    @JsonKey(name: 'template_name') required String templateName,
    String? description,
    @Default(1) int version,
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
    @JsonKey(name: 'activity_types') @Default([]) List<TemplateActivityType> activityTypes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _DiseaseTemplate;

  factory DiseaseTemplate.fromJson(Map<String, dynamic> json) => _$DiseaseTemplateFromJson(json);
}

/// Represents an activity type linked to a template
@freezed
class TemplateActivityType with _$TemplateActivityType {
  const factory TemplateActivityType({
    @JsonKey(name: 'activity_type_id') required String activityTypeId,
    @JsonKey(name: 'activity_type') ActivityType? activityType,
    @JsonKey(name: 'is_required') @Default(false) bool isRequired,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
  }) = _TemplateActivityType;

  factory TemplateActivityType.fromJson(Map<String, dynamic> json) => _$TemplateActivityTypeFromJson(json);
}
