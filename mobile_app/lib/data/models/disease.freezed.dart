// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'disease.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Disease _$DiseaseFromJson(Map<String, dynamic> json) {
  return _Disease.fromJson(json);
}

/// @nodoc
mixin _$Disease {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'name_en')
  String? get nameEn => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String> get symptoms => throw _privateConstructorUsedError;
  @JsonKey(name: 'recommended_monitoring')
  Map<String, dynamic>? get recommendedMonitoring =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'disease_templates')
  List<DiseaseTemplate>? get diseaseTemplates =>
      throw _privateConstructorUsedError;

  /// Serializes this Disease to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Disease
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiseaseCopyWith<Disease> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiseaseCopyWith<$Res> {
  factory $DiseaseCopyWith(Disease value, $Res Function(Disease) then) =
      _$DiseaseCopyWithImpl<$Res, Disease>;
  @useResult
  $Res call({
    String id,
    String name,
    @JsonKey(name: 'name_en') String? nameEn,
    String? category,
    String? description,
    List<String> symptoms,
    @JsonKey(name: 'recommended_monitoring')
    Map<String, dynamic>? recommendedMonitoring,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'disease_templates') List<DiseaseTemplate>? diseaseTemplates,
  });
}

/// @nodoc
class _$DiseaseCopyWithImpl<$Res, $Val extends Disease>
    implements $DiseaseCopyWith<$Res> {
  _$DiseaseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Disease
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nameEn = freezed,
    Object? category = freezed,
    Object? description = freezed,
    Object? symptoms = null,
    Object? recommendedMonitoring = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? diseaseTemplates = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            nameEn: freezed == nameEn
                ? _value.nameEn
                : nameEn // ignore: cast_nullable_to_non_nullable
                      as String?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            symptoms: null == symptoms
                ? _value.symptoms
                : symptoms // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            recommendedMonitoring: freezed == recommendedMonitoring
                ? _value.recommendedMonitoring
                : recommendedMonitoring // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            diseaseTemplates: freezed == diseaseTemplates
                ? _value.diseaseTemplates
                : diseaseTemplates // ignore: cast_nullable_to_non_nullable
                      as List<DiseaseTemplate>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DiseaseImplCopyWith<$Res> implements $DiseaseCopyWith<$Res> {
  factory _$$DiseaseImplCopyWith(
    _$DiseaseImpl value,
    $Res Function(_$DiseaseImpl) then,
  ) = __$$DiseaseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    @JsonKey(name: 'name_en') String? nameEn,
    String? category,
    String? description,
    List<String> symptoms,
    @JsonKey(name: 'recommended_monitoring')
    Map<String, dynamic>? recommendedMonitoring,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'disease_templates') List<DiseaseTemplate>? diseaseTemplates,
  });
}

/// @nodoc
class __$$DiseaseImplCopyWithImpl<$Res>
    extends _$DiseaseCopyWithImpl<$Res, _$DiseaseImpl>
    implements _$$DiseaseImplCopyWith<$Res> {
  __$$DiseaseImplCopyWithImpl(
    _$DiseaseImpl _value,
    $Res Function(_$DiseaseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Disease
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nameEn = freezed,
    Object? category = freezed,
    Object? description = freezed,
    Object? symptoms = null,
    Object? recommendedMonitoring = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? diseaseTemplates = freezed,
  }) {
    return _then(
      _$DiseaseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        nameEn: freezed == nameEn
            ? _value.nameEn
            : nameEn // ignore: cast_nullable_to_non_nullable
                  as String?,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        symptoms: null == symptoms
            ? _value._symptoms
            : symptoms // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        recommendedMonitoring: freezed == recommendedMonitoring
            ? _value._recommendedMonitoring
            : recommendedMonitoring // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        diseaseTemplates: freezed == diseaseTemplates
            ? _value._diseaseTemplates
            : diseaseTemplates // ignore: cast_nullable_to_non_nullable
                  as List<DiseaseTemplate>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DiseaseImpl implements _Disease {
  const _$DiseaseImpl({
    required this.id,
    required this.name,
    @JsonKey(name: 'name_en') this.nameEn,
    this.category,
    this.description,
    final List<String> symptoms = const [],
    @JsonKey(name: 'recommended_monitoring')
    final Map<String, dynamic>? recommendedMonitoring,
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
    @JsonKey(name: 'disease_templates')
    final List<DiseaseTemplate>? diseaseTemplates,
  }) : _symptoms = symptoms,
       _recommendedMonitoring = recommendedMonitoring,
       _diseaseTemplates = diseaseTemplates;

  factory _$DiseaseImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiseaseImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey(name: 'name_en')
  final String? nameEn;
  @override
  final String? category;
  @override
  final String? description;
  final List<String> _symptoms;
  @override
  @JsonKey()
  List<String> get symptoms {
    if (_symptoms is EqualUnmodifiableListView) return _symptoms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_symptoms);
  }

  final Map<String, dynamic>? _recommendedMonitoring;
  @override
  @JsonKey(name: 'recommended_monitoring')
  Map<String, dynamic>? get recommendedMonitoring {
    final value = _recommendedMonitoring;
    if (value == null) return null;
    if (_recommendedMonitoring is EqualUnmodifiableMapView)
      return _recommendedMonitoring;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  final List<DiseaseTemplate>? _diseaseTemplates;
  @override
  @JsonKey(name: 'disease_templates')
  List<DiseaseTemplate>? get diseaseTemplates {
    final value = _diseaseTemplates;
    if (value == null) return null;
    if (_diseaseTemplates is EqualUnmodifiableListView)
      return _diseaseTemplates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Disease(id: $id, name: $name, nameEn: $nameEn, category: $category, description: $description, symptoms: $symptoms, recommendedMonitoring: $recommendedMonitoring, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, diseaseTemplates: $diseaseTemplates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiseaseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._symptoms, _symptoms) &&
            const DeepCollectionEquality().equals(
              other._recommendedMonitoring,
              _recommendedMonitoring,
            ) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(
              other._diseaseTemplates,
              _diseaseTemplates,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    nameEn,
    category,
    description,
    const DeepCollectionEquality().hash(_symptoms),
    const DeepCollectionEquality().hash(_recommendedMonitoring),
    isActive,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(_diseaseTemplates),
  );

  /// Create a copy of Disease
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiseaseImplCopyWith<_$DiseaseImpl> get copyWith =>
      __$$DiseaseImplCopyWithImpl<_$DiseaseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DiseaseImplToJson(this);
  }
}

abstract class _Disease implements Disease {
  const factory _Disease({
    required final String id,
    required final String name,
    @JsonKey(name: 'name_en') final String? nameEn,
    final String? category,
    final String? description,
    final List<String> symptoms,
    @JsonKey(name: 'recommended_monitoring')
    final Map<String, dynamic>? recommendedMonitoring,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
    @JsonKey(name: 'disease_templates')
    final List<DiseaseTemplate>? diseaseTemplates,
  }) = _$DiseaseImpl;

  factory _Disease.fromJson(Map<String, dynamic> json) = _$DiseaseImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'name_en')
  String? get nameEn;
  @override
  String? get category;
  @override
  String? get description;
  @override
  List<String> get symptoms;
  @override
  @JsonKey(name: 'recommended_monitoring')
  Map<String, dynamic>? get recommendedMonitoring;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'disease_templates')
  List<DiseaseTemplate>? get diseaseTemplates;

  /// Create a copy of Disease
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiseaseImplCopyWith<_$DiseaseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
