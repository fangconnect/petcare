// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityTypeImpl _$$ActivityTypeImplFromJson(Map<String, dynamic> json) =>
    _$ActivityTypeImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      nameEn: json['name_en'] as String?,
      inputType: json['input_type'] as String? ?? 'number',
      category: json['category'] as String? ?? 'other',
      icon: json['icon'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      units:
          (json['units'] as List<dynamic>?)
              ?.map((e) => Unit.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ActivityTypeImplToJson(_$ActivityTypeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'name_en': instance.nameEn,
      'input_type': instance.inputType,
      'category': instance.category,
      'icon': instance.icon,
      'is_active': instance.isActive,
      'sort_order': instance.sortOrder,
      'units': instance.units,
    };
