// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disease_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DiseaseTemplateImpl _$$DiseaseTemplateImplFromJson(
  Map<String, dynamic> json,
) => _$DiseaseTemplateImpl(
  id: json['id'] as String,
  diseaseId: json['disease_id'] as String,
  templateName: json['template_name'] as String,
  description: json['description'] as String?,
  version: (json['version'] as num?)?.toInt() ?? 1,
  isDefault: json['is_default'] as bool? ?? false,
  activityTypes:
      (json['activity_types'] as List<dynamic>?)
          ?.map((e) => TemplateActivityType.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$DiseaseTemplateImplToJson(
  _$DiseaseTemplateImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'disease_id': instance.diseaseId,
  'template_name': instance.templateName,
  'description': instance.description,
  'version': instance.version,
  'is_default': instance.isDefault,
  'activity_types': instance.activityTypes,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

_$TemplateActivityTypeImpl _$$TemplateActivityTypeImplFromJson(
  Map<String, dynamic> json,
) => _$TemplateActivityTypeImpl(
  activityTypeId: json['activity_type_id'] as String,
  activityType: json['activity_type'] == null
      ? null
      : ActivityType.fromJson(json['activity_type'] as Map<String, dynamic>),
  isRequired: json['is_required'] as bool? ?? false,
  sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$TemplateActivityTypeImplToJson(
  _$TemplateActivityTypeImpl instance,
) => <String, dynamic>{
  'activity_type_id': instance.activityTypeId,
  'activity_type': instance.activityType,
  'is_required': instance.isRequired,
  'sort_order': instance.sortOrder,
};
