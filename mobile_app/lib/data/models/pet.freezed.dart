// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Pet _$PetFromJson(Map<String, dynamic> json) {
  return _Pet.fromJson(json);
}

/// @nodoc
mixin _$Pet {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id')
  String get ownerId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get species => throw _privateConstructorUsedError;
  String? get breed => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_date')
  DateTime? get birthDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_weight')
  double? get currentWeight => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_url')
  String? get photoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'microchip_id')
  String? get microchipId => throw _privateConstructorUsedError;
  @JsonKey(name: 'medical_history')
  Map<String, dynamic>? get medicalHistory =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'pet_diseases')
  List<PetDisease>? get petDiseases => throw _privateConstructorUsedError;

  /// Serializes this Pet to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Pet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PetCopyWith<Pet> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PetCopyWith<$Res> {
  factory $PetCopyWith(Pet value, $Res Function(Pet) then) =
      _$PetCopyWithImpl<$Res, Pet>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'owner_id') String ownerId,
    String name,
    String? species,
    String? breed,
    @JsonKey(name: 'birth_date') DateTime? birthDate,
    @JsonKey(name: 'current_weight') double? currentWeight,
    String? gender,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'microchip_id') String? microchipId,
    @JsonKey(name: 'medical_history') Map<String, dynamic>? medicalHistory,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'pet_diseases') List<PetDisease>? petDiseases,
  });
}

/// @nodoc
class _$PetCopyWithImpl<$Res, $Val extends Pet> implements $PetCopyWith<$Res> {
  _$PetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Pet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? name = null,
    Object? species = freezed,
    Object? breed = freezed,
    Object? birthDate = freezed,
    Object? currentWeight = freezed,
    Object? gender = freezed,
    Object? photoUrl = freezed,
    Object? microchipId = freezed,
    Object? medicalHistory = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? petDiseases = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            ownerId: null == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            species: freezed == species
                ? _value.species
                : species // ignore: cast_nullable_to_non_nullable
                      as String?,
            breed: freezed == breed
                ? _value.breed
                : breed // ignore: cast_nullable_to_non_nullable
                      as String?,
            birthDate: freezed == birthDate
                ? _value.birthDate
                : birthDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            currentWeight: freezed == currentWeight
                ? _value.currentWeight
                : currentWeight // ignore: cast_nullable_to_non_nullable
                      as double?,
            gender: freezed == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoUrl: freezed == photoUrl
                ? _value.photoUrl
                : photoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            microchipId: freezed == microchipId
                ? _value.microchipId
                : microchipId // ignore: cast_nullable_to_non_nullable
                      as String?,
            medicalHistory: freezed == medicalHistory
                ? _value.medicalHistory
                : medicalHistory // ignore: cast_nullable_to_non_nullable
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
            petDiseases: freezed == petDiseases
                ? _value.petDiseases
                : petDiseases // ignore: cast_nullable_to_non_nullable
                      as List<PetDisease>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PetImplCopyWith<$Res> implements $PetCopyWith<$Res> {
  factory _$$PetImplCopyWith(_$PetImpl value, $Res Function(_$PetImpl) then) =
      __$$PetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'owner_id') String ownerId,
    String name,
    String? species,
    String? breed,
    @JsonKey(name: 'birth_date') DateTime? birthDate,
    @JsonKey(name: 'current_weight') double? currentWeight,
    String? gender,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'microchip_id') String? microchipId,
    @JsonKey(name: 'medical_history') Map<String, dynamic>? medicalHistory,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'pet_diseases') List<PetDisease>? petDiseases,
  });
}

/// @nodoc
class __$$PetImplCopyWithImpl<$Res> extends _$PetCopyWithImpl<$Res, _$PetImpl>
    implements _$$PetImplCopyWith<$Res> {
  __$$PetImplCopyWithImpl(_$PetImpl _value, $Res Function(_$PetImpl) _then)
    : super(_value, _then);

  /// Create a copy of Pet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? name = null,
    Object? species = freezed,
    Object? breed = freezed,
    Object? birthDate = freezed,
    Object? currentWeight = freezed,
    Object? gender = freezed,
    Object? photoUrl = freezed,
    Object? microchipId = freezed,
    Object? medicalHistory = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? petDiseases = freezed,
  }) {
    return _then(
      _$PetImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerId: null == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        species: freezed == species
            ? _value.species
            : species // ignore: cast_nullable_to_non_nullable
                  as String?,
        breed: freezed == breed
            ? _value.breed
            : breed // ignore: cast_nullable_to_non_nullable
                  as String?,
        birthDate: freezed == birthDate
            ? _value.birthDate
            : birthDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        currentWeight: freezed == currentWeight
            ? _value.currentWeight
            : currentWeight // ignore: cast_nullable_to_non_nullable
                  as double?,
        gender: freezed == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoUrl: freezed == photoUrl
            ? _value.photoUrl
            : photoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        microchipId: freezed == microchipId
            ? _value.microchipId
            : microchipId // ignore: cast_nullable_to_non_nullable
                  as String?,
        medicalHistory: freezed == medicalHistory
            ? _value._medicalHistory
            : medicalHistory // ignore: cast_nullable_to_non_nullable
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
        petDiseases: freezed == petDiseases
            ? _value._petDiseases
            : petDiseases // ignore: cast_nullable_to_non_nullable
                  as List<PetDisease>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PetImpl extends _Pet {
  const _$PetImpl({
    required this.id,
    @JsonKey(name: 'owner_id') required this.ownerId,
    required this.name,
    this.species,
    this.breed,
    @JsonKey(name: 'birth_date') this.birthDate,
    @JsonKey(name: 'current_weight') this.currentWeight,
    this.gender,
    @JsonKey(name: 'photo_url') this.photoUrl,
    @JsonKey(name: 'microchip_id') this.microchipId,
    @JsonKey(name: 'medical_history')
    final Map<String, dynamic>? medicalHistory,
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
    @JsonKey(name: 'pet_diseases') final List<PetDisease>? petDiseases,
  }) : _medicalHistory = medicalHistory,
       _petDiseases = petDiseases,
       super._();

  factory _$PetImpl.fromJson(Map<String, dynamic> json) =>
      _$$PetImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'owner_id')
  final String ownerId;
  @override
  final String name;
  @override
  final String? species;
  @override
  final String? breed;
  @override
  @JsonKey(name: 'birth_date')
  final DateTime? birthDate;
  @override
  @JsonKey(name: 'current_weight')
  final double? currentWeight;
  @override
  final String? gender;
  @override
  @JsonKey(name: 'photo_url')
  final String? photoUrl;
  @override
  @JsonKey(name: 'microchip_id')
  final String? microchipId;
  final Map<String, dynamic>? _medicalHistory;
  @override
  @JsonKey(name: 'medical_history')
  Map<String, dynamic>? get medicalHistory {
    final value = _medicalHistory;
    if (value == null) return null;
    if (_medicalHistory is EqualUnmodifiableMapView) return _medicalHistory;
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
  final List<PetDisease>? _petDiseases;
  @override
  @JsonKey(name: 'pet_diseases')
  List<PetDisease>? get petDiseases {
    final value = _petDiseases;
    if (value == null) return null;
    if (_petDiseases is EqualUnmodifiableListView) return _petDiseases;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Pet(id: $id, ownerId: $ownerId, name: $name, species: $species, breed: $breed, birthDate: $birthDate, currentWeight: $currentWeight, gender: $gender, photoUrl: $photoUrl, microchipId: $microchipId, medicalHistory: $medicalHistory, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, petDiseases: $petDiseases)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.species, species) || other.species == species) &&
            (identical(other.breed, breed) || other.breed == breed) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.currentWeight, currentWeight) ||
                other.currentWeight == currentWeight) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.microchipId, microchipId) ||
                other.microchipId == microchipId) &&
            const DeepCollectionEquality().equals(
              other._medicalHistory,
              _medicalHistory,
            ) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(
              other._petDiseases,
              _petDiseases,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    ownerId,
    name,
    species,
    breed,
    birthDate,
    currentWeight,
    gender,
    photoUrl,
    microchipId,
    const DeepCollectionEquality().hash(_medicalHistory),
    isActive,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(_petDiseases),
  );

  /// Create a copy of Pet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PetImplCopyWith<_$PetImpl> get copyWith =>
      __$$PetImplCopyWithImpl<_$PetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PetImplToJson(this);
  }
}

abstract class _Pet extends Pet {
  const factory _Pet({
    required final String id,
    @JsonKey(name: 'owner_id') required final String ownerId,
    required final String name,
    final String? species,
    final String? breed,
    @JsonKey(name: 'birth_date') final DateTime? birthDate,
    @JsonKey(name: 'current_weight') final double? currentWeight,
    final String? gender,
    @JsonKey(name: 'photo_url') final String? photoUrl,
    @JsonKey(name: 'microchip_id') final String? microchipId,
    @JsonKey(name: 'medical_history')
    final Map<String, dynamic>? medicalHistory,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
    @JsonKey(name: 'pet_diseases') final List<PetDisease>? petDiseases,
  }) = _$PetImpl;
  const _Pet._() : super._();

  factory _Pet.fromJson(Map<String, dynamic> json) = _$PetImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'owner_id')
  String get ownerId;
  @override
  String get name;
  @override
  String? get species;
  @override
  String? get breed;
  @override
  @JsonKey(name: 'birth_date')
  DateTime? get birthDate;
  @override
  @JsonKey(name: 'current_weight')
  double? get currentWeight;
  @override
  String? get gender;
  @override
  @JsonKey(name: 'photo_url')
  String? get photoUrl;
  @override
  @JsonKey(name: 'microchip_id')
  String? get microchipId;
  @override
  @JsonKey(name: 'medical_history')
  Map<String, dynamic>? get medicalHistory;
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
  @JsonKey(name: 'pet_diseases')
  List<PetDisease>? get petDiseases;

  /// Create a copy of Pet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PetImplCopyWith<_$PetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
