// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'disease_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DiseaseTemplate _$DiseaseTemplateFromJson(Map<String, dynamic> json) {
  return _DiseaseTemplate.fromJson(json);
}

/// @nodoc
mixin _$DiseaseTemplate {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'disease_id')
  String get diseaseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'template_name')
  String get templateName => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_default')
  bool get isDefault => throw _privateConstructorUsedError;
  @JsonKey(name: 'activity_types')
  List<TemplateActivityType> get activityTypes =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this DiseaseTemplate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DiseaseTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiseaseTemplateCopyWith<DiseaseTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiseaseTemplateCopyWith<$Res> {
  factory $DiseaseTemplateCopyWith(
    DiseaseTemplate value,
    $Res Function(DiseaseTemplate) then,
  ) = _$DiseaseTemplateCopyWithImpl<$Res, DiseaseTemplate>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'disease_id') String diseaseId,
    @JsonKey(name: 'template_name') String templateName,
    String? description,
    int version,
    @JsonKey(name: 'is_default') bool isDefault,
    @JsonKey(name: 'activity_types') List<TemplateActivityType> activityTypes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class _$DiseaseTemplateCopyWithImpl<$Res, $Val extends DiseaseTemplate>
    implements $DiseaseTemplateCopyWith<$Res> {
  _$DiseaseTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiseaseTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? diseaseId = null,
    Object? templateName = null,
    Object? description = freezed,
    Object? version = null,
    Object? isDefault = null,
    Object? activityTypes = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            diseaseId: null == diseaseId
                ? _value.diseaseId
                : diseaseId // ignore: cast_nullable_to_non_nullable
                      as String,
            templateName: null == templateName
                ? _value.templateName
                : templateName // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as int,
            isDefault: null == isDefault
                ? _value.isDefault
                : isDefault // ignore: cast_nullable_to_non_nullable
                      as bool,
            activityTypes: null == activityTypes
                ? _value.activityTypes
                : activityTypes // ignore: cast_nullable_to_non_nullable
                      as List<TemplateActivityType>,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DiseaseTemplateImplCopyWith<$Res>
    implements $DiseaseTemplateCopyWith<$Res> {
  factory _$$DiseaseTemplateImplCopyWith(
    _$DiseaseTemplateImpl value,
    $Res Function(_$DiseaseTemplateImpl) then,
  ) = __$$DiseaseTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'disease_id') String diseaseId,
    @JsonKey(name: 'template_name') String templateName,
    String? description,
    int version,
    @JsonKey(name: 'is_default') bool isDefault,
    @JsonKey(name: 'activity_types') List<TemplateActivityType> activityTypes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class __$$DiseaseTemplateImplCopyWithImpl<$Res>
    extends _$DiseaseTemplateCopyWithImpl<$Res, _$DiseaseTemplateImpl>
    implements _$$DiseaseTemplateImplCopyWith<$Res> {
  __$$DiseaseTemplateImplCopyWithImpl(
    _$DiseaseTemplateImpl _value,
    $Res Function(_$DiseaseTemplateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DiseaseTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? diseaseId = null,
    Object? templateName = null,
    Object? description = freezed,
    Object? version = null,
    Object? isDefault = null,
    Object? activityTypes = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$DiseaseTemplateImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        diseaseId: null == diseaseId
            ? _value.diseaseId
            : diseaseId // ignore: cast_nullable_to_non_nullable
                  as String,
        templateName: null == templateName
            ? _value.templateName
            : templateName // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as int,
        isDefault: null == isDefault
            ? _value.isDefault
            : isDefault // ignore: cast_nullable_to_non_nullable
                  as bool,
        activityTypes: null == activityTypes
            ? _value._activityTypes
            : activityTypes // ignore: cast_nullable_to_non_nullable
                  as List<TemplateActivityType>,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DiseaseTemplateImpl implements _DiseaseTemplate {
  const _$DiseaseTemplateImpl({
    required this.id,
    @JsonKey(name: 'disease_id') required this.diseaseId,
    @JsonKey(name: 'template_name') required this.templateName,
    this.description,
    this.version = 1,
    @JsonKey(name: 'is_default') this.isDefault = false,
    @JsonKey(name: 'activity_types')
    final List<TemplateActivityType> activityTypes = const [],
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : _activityTypes = activityTypes;

  factory _$DiseaseTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiseaseTemplateImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'disease_id')
  final String diseaseId;
  @override
  @JsonKey(name: 'template_name')
  final String templateName;
  @override
  final String? description;
  @override
  @JsonKey()
  final int version;
  @override
  @JsonKey(name: 'is_default')
  final bool isDefault;
  final List<TemplateActivityType> _activityTypes;
  @override
  @JsonKey(name: 'activity_types')
  List<TemplateActivityType> get activityTypes {
    if (_activityTypes is EqualUnmodifiableListView) return _activityTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activityTypes);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'DiseaseTemplate(id: $id, diseaseId: $diseaseId, templateName: $templateName, description: $description, version: $version, isDefault: $isDefault, activityTypes: $activityTypes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiseaseTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.diseaseId, diseaseId) ||
                other.diseaseId == diseaseId) &&
            (identical(other.templateName, templateName) ||
                other.templateName == templateName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            const DeepCollectionEquality().equals(
              other._activityTypes,
              _activityTypes,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    diseaseId,
    templateName,
    description,
    version,
    isDefault,
    const DeepCollectionEquality().hash(_activityTypes),
    createdAt,
    updatedAt,
  );

  /// Create a copy of DiseaseTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiseaseTemplateImplCopyWith<_$DiseaseTemplateImpl> get copyWith =>
      __$$DiseaseTemplateImplCopyWithImpl<_$DiseaseTemplateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DiseaseTemplateImplToJson(this);
  }
}

abstract class _DiseaseTemplate implements DiseaseTemplate {
  const factory _DiseaseTemplate({
    required final String id,
    @JsonKey(name: 'disease_id') required final String diseaseId,
    @JsonKey(name: 'template_name') required final String templateName,
    final String? description,
    final int version,
    @JsonKey(name: 'is_default') final bool isDefault,
    @JsonKey(name: 'activity_types')
    final List<TemplateActivityType> activityTypes,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$DiseaseTemplateImpl;

  factory _DiseaseTemplate.fromJson(Map<String, dynamic> json) =
      _$DiseaseTemplateImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'disease_id')
  String get diseaseId;
  @override
  @JsonKey(name: 'template_name')
  String get templateName;
  @override
  String? get description;
  @override
  int get version;
  @override
  @JsonKey(name: 'is_default')
  bool get isDefault;
  @override
  @JsonKey(name: 'activity_types')
  List<TemplateActivityType> get activityTypes;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of DiseaseTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiseaseTemplateImplCopyWith<_$DiseaseTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TemplateActivityType _$TemplateActivityTypeFromJson(Map<String, dynamic> json) {
  return _TemplateActivityType.fromJson(json);
}

/// @nodoc
mixin _$TemplateActivityType {
  @JsonKey(name: 'activity_type_id')
  String get activityTypeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'activity_type')
  ActivityType? get activityType => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_required')
  bool get isRequired => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;

  /// Serializes this TemplateActivityType to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TemplateActivityType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemplateActivityTypeCopyWith<TemplateActivityType> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateActivityTypeCopyWith<$Res> {
  factory $TemplateActivityTypeCopyWith(
    TemplateActivityType value,
    $Res Function(TemplateActivityType) then,
  ) = _$TemplateActivityTypeCopyWithImpl<$Res, TemplateActivityType>;
  @useResult
  $Res call({
    @JsonKey(name: 'activity_type_id') String activityTypeId,
    @JsonKey(name: 'activity_type') ActivityType? activityType,
    @JsonKey(name: 'is_required') bool isRequired,
    @JsonKey(name: 'sort_order') int sortOrder,
  });

  $ActivityTypeCopyWith<$Res>? get activityType;
}

/// @nodoc
class _$TemplateActivityTypeCopyWithImpl<
  $Res,
  $Val extends TemplateActivityType
>
    implements $TemplateActivityTypeCopyWith<$Res> {
  _$TemplateActivityTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemplateActivityType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityTypeId = null,
    Object? activityType = freezed,
    Object? isRequired = null,
    Object? sortOrder = null,
  }) {
    return _then(
      _value.copyWith(
            activityTypeId: null == activityTypeId
                ? _value.activityTypeId
                : activityTypeId // ignore: cast_nullable_to_non_nullable
                      as String,
            activityType: freezed == activityType
                ? _value.activityType
                : activityType // ignore: cast_nullable_to_non_nullable
                      as ActivityType?,
            isRequired: null == isRequired
                ? _value.isRequired
                : isRequired // ignore: cast_nullable_to_non_nullable
                      as bool,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of TemplateActivityType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ActivityTypeCopyWith<$Res>? get activityType {
    if (_value.activityType == null) {
      return null;
    }

    return $ActivityTypeCopyWith<$Res>(_value.activityType!, (value) {
      return _then(_value.copyWith(activityType: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TemplateActivityTypeImplCopyWith<$Res>
    implements $TemplateActivityTypeCopyWith<$Res> {
  factory _$$TemplateActivityTypeImplCopyWith(
    _$TemplateActivityTypeImpl value,
    $Res Function(_$TemplateActivityTypeImpl) then,
  ) = __$$TemplateActivityTypeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'activity_type_id') String activityTypeId,
    @JsonKey(name: 'activity_type') ActivityType? activityType,
    @JsonKey(name: 'is_required') bool isRequired,
    @JsonKey(name: 'sort_order') int sortOrder,
  });

  @override
  $ActivityTypeCopyWith<$Res>? get activityType;
}

/// @nodoc
class __$$TemplateActivityTypeImplCopyWithImpl<$Res>
    extends _$TemplateActivityTypeCopyWithImpl<$Res, _$TemplateActivityTypeImpl>
    implements _$$TemplateActivityTypeImplCopyWith<$Res> {
  __$$TemplateActivityTypeImplCopyWithImpl(
    _$TemplateActivityTypeImpl _value,
    $Res Function(_$TemplateActivityTypeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TemplateActivityType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityTypeId = null,
    Object? activityType = freezed,
    Object? isRequired = null,
    Object? sortOrder = null,
  }) {
    return _then(
      _$TemplateActivityTypeImpl(
        activityTypeId: null == activityTypeId
            ? _value.activityTypeId
            : activityTypeId // ignore: cast_nullable_to_non_nullable
                  as String,
        activityType: freezed == activityType
            ? _value.activityType
            : activityType // ignore: cast_nullable_to_non_nullable
                  as ActivityType?,
        isRequired: null == isRequired
            ? _value.isRequired
            : isRequired // ignore: cast_nullable_to_non_nullable
                  as bool,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TemplateActivityTypeImpl implements _TemplateActivityType {
  const _$TemplateActivityTypeImpl({
    @JsonKey(name: 'activity_type_id') required this.activityTypeId,
    @JsonKey(name: 'activity_type') this.activityType,
    @JsonKey(name: 'is_required') this.isRequired = false,
    @JsonKey(name: 'sort_order') this.sortOrder = 0,
  });

  factory _$TemplateActivityTypeImpl.fromJson(Map<String, dynamic> json) =>
      _$$TemplateActivityTypeImplFromJson(json);

  @override
  @JsonKey(name: 'activity_type_id')
  final String activityTypeId;
  @override
  @JsonKey(name: 'activity_type')
  final ActivityType? activityType;
  @override
  @JsonKey(name: 'is_required')
  final bool isRequired;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;

  @override
  String toString() {
    return 'TemplateActivityType(activityTypeId: $activityTypeId, activityType: $activityType, isRequired: $isRequired, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateActivityTypeImpl &&
            (identical(other.activityTypeId, activityTypeId) ||
                other.activityTypeId == activityTypeId) &&
            (identical(other.activityType, activityType) ||
                other.activityType == activityType) &&
            (identical(other.isRequired, isRequired) ||
                other.isRequired == isRequired) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    activityTypeId,
    activityType,
    isRequired,
    sortOrder,
  );

  /// Create a copy of TemplateActivityType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateActivityTypeImplCopyWith<_$TemplateActivityTypeImpl>
  get copyWith =>
      __$$TemplateActivityTypeImplCopyWithImpl<_$TemplateActivityTypeImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TemplateActivityTypeImplToJson(this);
  }
}

abstract class _TemplateActivityType implements TemplateActivityType {
  const factory _TemplateActivityType({
    @JsonKey(name: 'activity_type_id') required final String activityTypeId,
    @JsonKey(name: 'activity_type') final ActivityType? activityType,
    @JsonKey(name: 'is_required') final bool isRequired,
    @JsonKey(name: 'sort_order') final int sortOrder,
  }) = _$TemplateActivityTypeImpl;

  factory _TemplateActivityType.fromJson(Map<String, dynamic> json) =
      _$TemplateActivityTypeImpl.fromJson;

  @override
  @JsonKey(name: 'activity_type_id')
  String get activityTypeId;
  @override
  @JsonKey(name: 'activity_type')
  ActivityType? get activityType;
  @override
  @JsonKey(name: 'is_required')
  bool get isRequired;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;

  /// Create a copy of TemplateActivityType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateActivityTypeImplCopyWith<_$TemplateActivityTypeImpl>
  get copyWith => throw _privateConstructorUsedError;
}
