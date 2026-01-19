// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityImpl _$$ActivityImplFromJson(Map<String, dynamic> json) =>
    _$ActivityImpl(
      id: _intFromJson(json['id']),
      name: json['name'] as String,
      unit: json['unit'] as String?,
      inputType: _activityInputTypeFromJson(json['input_type']),
      createdAt: _dateTimeFromJson(json['created_at']),
      updatedAt: _dateTimeFromJson(json['updated_at']),
    );

Map<String, dynamic> _$$ActivityImplToJson(_$ActivityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'unit': instance.unit,
      'input_type': _$ActivityInputTypeEnumMap[instance.inputType]!,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$ActivityInputTypeEnumMap = {
  ActivityInputType.number: 'number',
  ActivityInputType.text: 'text',
  ActivityInputType.checkbox: 'checkbox',
};
