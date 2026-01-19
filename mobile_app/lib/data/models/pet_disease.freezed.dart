// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pet_disease.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PetDisease _$PetDiseaseFromJson(Map<String, dynamic> json) {
  return _PetDisease.fromJson(json);
}

/// @nodoc
mixin _$PetDisease {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'pet_id')
  String get petId => throw _privateConstructorUsedError;
  @JsonKey(name: 'disease_id')
  String get diseaseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'diagnosed_date')
  DateTime? get diagnosedDate => throw _privateConstructorUsedError;
  String? get severity =>
      throw _privateConstructorUsedError; // mild, moderate, severe
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'recovery_date')
  DateTime? get recoveryDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  Disease? get disease => throw _privateConstructorUsedError;

  /// Serializes this PetDisease to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PetDisease
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PetDiseaseCopyWith<PetDisease> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PetDiseaseCopyWith<$Res> {
  factory $PetDiseaseCopyWith(
    PetDisease value,
    $Res Function(PetDisease) then,
  ) = _$PetDiseaseCopyWithImpl<$Res, PetDisease>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'pet_id') String petId,
    @JsonKey(name: 'disease_id') String diseaseId,
    @JsonKey(name: 'diagnosed_date') DateTime? diagnosedDate,
    String? severity,
    String? notes,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'recovery_date') DateTime? recoveryDate,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    Disease? disease,
  });

  $DiseaseCopyWith<$Res>? get disease;
}

/// @nodoc
class _$PetDiseaseCopyWithImpl<$Res, $Val extends PetDisease>
    implements $PetDiseaseCopyWith<$Res> {
  _$PetDiseaseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PetDisease
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? petId = null,
    Object? diseaseId = null,
    Object? diagnosedDate = freezed,
    Object? severity = freezed,
    Object? notes = freezed,
    Object? isActive = null,
    Object? recoveryDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? disease = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            petId: null == petId
                ? _value.petId
                : petId // ignore: cast_nullable_to_non_nullable
                      as String,
            diseaseId: null == diseaseId
                ? _value.diseaseId
                : diseaseId // ignore: cast_nullable_to_non_nullable
                      as String,
            diagnosedDate: freezed == diagnosedDate
                ? _value.diagnosedDate
                : diagnosedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            severity: freezed == severity
                ? _value.severity
                : severity // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            recoveryDate: freezed == recoveryDate
                ? _value.recoveryDate
                : recoveryDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            disease: freezed == disease
                ? _value.disease
                : disease // ignore: cast_nullable_to_non_nullable
                      as Disease?,
          )
          as $Val,
    );
  }

  /// Create a copy of PetDisease
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DiseaseCopyWith<$Res>? get disease {
    if (_value.disease == null) {
      return null;
    }

    return $DiseaseCopyWith<$Res>(_value.disease!, (value) {
      return _then(_value.copyWith(disease: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PetDiseaseImplCopyWith<$Res>
    implements $PetDiseaseCopyWith<$Res> {
  factory _$$PetDiseaseImplCopyWith(
    _$PetDiseaseImpl value,
    $Res Function(_$PetDiseaseImpl) then,
  ) = __$$PetDiseaseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'pet_id') String petId,
    @JsonKey(name: 'disease_id') String diseaseId,
    @JsonKey(name: 'diagnosed_date') DateTime? diagnosedDate,
    String? severity,
    String? notes,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'recovery_date') DateTime? recoveryDate,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    Disease? disease,
  });

  @override
  $DiseaseCopyWith<$Res>? get disease;
}

/// @nodoc
class __$$PetDiseaseImplCopyWithImpl<$Res>
    extends _$PetDiseaseCopyWithImpl<$Res, _$PetDiseaseImpl>
    implements _$$PetDiseaseImplCopyWith<$Res> {
  __$$PetDiseaseImplCopyWithImpl(
    _$PetDiseaseImpl _value,
    $Res Function(_$PetDiseaseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PetDisease
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? petId = null,
    Object? diseaseId = null,
    Object? diagnosedDate = freezed,
    Object? severity = freezed,
    Object? notes = freezed,
    Object? isActive = null,
    Object? recoveryDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? disease = freezed,
  }) {
    return _then(
      _$PetDiseaseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        petId: null == petId
            ? _value.petId
            : petId // ignore: cast_nullable_to_non_nullable
                  as String,
        diseaseId: null == diseaseId
            ? _value.diseaseId
            : diseaseId // ignore: cast_nullable_to_non_nullable
                  as String,
        diagnosedDate: freezed == diagnosedDate
            ? _value.diagnosedDate
            : diagnosedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        severity: freezed == severity
            ? _value.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        recoveryDate: freezed == recoveryDate
            ? _value.recoveryDate
            : recoveryDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        disease: freezed == disease
            ? _value.disease
            : disease // ignore: cast_nullable_to_non_nullable
                  as Disease?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PetDiseaseImpl implements _PetDisease {
  const _$PetDiseaseImpl({
    required this.id,
    @JsonKey(name: 'pet_id') required this.petId,
    @JsonKey(name: 'disease_id') required this.diseaseId,
    @JsonKey(name: 'diagnosed_date') this.diagnosedDate,
    this.severity,
    this.notes,
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'recovery_date') this.recoveryDate,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
    this.disease,
  });

  factory _$PetDiseaseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PetDiseaseImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'pet_id')
  final String petId;
  @override
  @JsonKey(name: 'disease_id')
  final String diseaseId;
  @override
  @JsonKey(name: 'diagnosed_date')
  final DateTime? diagnosedDate;
  @override
  final String? severity;
  // mild, moderate, severe
  @override
  final String? notes;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'recovery_date')
  final DateTime? recoveryDate;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  final Disease? disease;

  @override
  String toString() {
    return 'PetDisease(id: $id, petId: $petId, diseaseId: $diseaseId, diagnosedDate: $diagnosedDate, severity: $severity, notes: $notes, isActive: $isActive, recoveryDate: $recoveryDate, createdAt: $createdAt, updatedAt: $updatedAt, disease: $disease)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PetDiseaseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.petId, petId) || other.petId == petId) &&
            (identical(other.diseaseId, diseaseId) ||
                other.diseaseId == diseaseId) &&
            (identical(other.diagnosedDate, diagnosedDate) ||
                other.diagnosedDate == diagnosedDate) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.recoveryDate, recoveryDate) ||
                other.recoveryDate == recoveryDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.disease, disease) || other.disease == disease));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    petId,
    diseaseId,
    diagnosedDate,
    severity,
    notes,
    isActive,
    recoveryDate,
    createdAt,
    updatedAt,
    disease,
  );

  /// Create a copy of PetDisease
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PetDiseaseImplCopyWith<_$PetDiseaseImpl> get copyWith =>
      __$$PetDiseaseImplCopyWithImpl<_$PetDiseaseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PetDiseaseImplToJson(this);
  }
}

abstract class _PetDisease implements PetDisease {
  const factory _PetDisease({
    required final String id,
    @JsonKey(name: 'pet_id') required final String petId,
    @JsonKey(name: 'disease_id') required final String diseaseId,
    @JsonKey(name: 'diagnosed_date') final DateTime? diagnosedDate,
    final String? severity,
    final String? notes,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'recovery_date') final DateTime? recoveryDate,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
    final Disease? disease,
  }) = _$PetDiseaseImpl;

  factory _PetDisease.fromJson(Map<String, dynamic> json) =
      _$PetDiseaseImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'pet_id')
  String get petId;
  @override
  @JsonKey(name: 'disease_id')
  String get diseaseId;
  @override
  @JsonKey(name: 'diagnosed_date')
  DateTime? get diagnosedDate;
  @override
  String? get severity; // mild, moderate, severe
  @override
  String? get notes;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'recovery_date')
  DateTime? get recoveryDate;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  Disease? get disease;

  /// Create a copy of PetDisease
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PetDiseaseImplCopyWith<_$PetDiseaseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
