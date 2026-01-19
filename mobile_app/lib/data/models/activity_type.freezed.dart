// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_type.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ActivityType _$ActivityTypeFromJson(Map<String, dynamic> json) {
  return _ActivityType.fromJson(json);
}

/// @nodoc
mixin _$ActivityType {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'name_en')
  String? get nameEn => throw _privateConstructorUsedError;
  @JsonKey(name: 'input_type')
  String get inputType => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  List<Unit> get units => throw _privateConstructorUsedError;

  /// Serializes this ActivityType to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityTypeCopyWith<ActivityType> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityTypeCopyWith<$Res> {
  factory $ActivityTypeCopyWith(
    ActivityType value,
    $Res Function(ActivityType) then,
  ) = _$ActivityTypeCopyWithImpl<$Res, ActivityType>;
  @useResult
  $Res call({
    String id,
    String name,
    @JsonKey(name: 'name_en') String? nameEn,
    @JsonKey(name: 'input_type') String inputType,
    String category,
    String? icon,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'sort_order') int sortOrder,
    List<Unit> units,
  });
}

/// @nodoc
class _$ActivityTypeCopyWithImpl<$Res, $Val extends ActivityType>
    implements $ActivityTypeCopyWith<$Res> {
  _$ActivityTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nameEn = freezed,
    Object? inputType = null,
    Object? category = null,
    Object? icon = freezed,
    Object? isActive = null,
    Object? sortOrder = null,
    Object? units = null,
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
            inputType: null == inputType
                ? _value.inputType
                : inputType // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            icon: freezed == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            units: null == units
                ? _value.units
                : units // ignore: cast_nullable_to_non_nullable
                      as List<Unit>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActivityTypeImplCopyWith<$Res>
    implements $ActivityTypeCopyWith<$Res> {
  factory _$$ActivityTypeImplCopyWith(
    _$ActivityTypeImpl value,
    $Res Function(_$ActivityTypeImpl) then,
  ) = __$$ActivityTypeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    @JsonKey(name: 'name_en') String? nameEn,
    @JsonKey(name: 'input_type') String inputType,
    String category,
    String? icon,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'sort_order') int sortOrder,
    List<Unit> units,
  });
}

/// @nodoc
class __$$ActivityTypeImplCopyWithImpl<$Res>
    extends _$ActivityTypeCopyWithImpl<$Res, _$ActivityTypeImpl>
    implements _$$ActivityTypeImplCopyWith<$Res> {
  __$$ActivityTypeImplCopyWithImpl(
    _$ActivityTypeImpl _value,
    $Res Function(_$ActivityTypeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nameEn = freezed,
    Object? inputType = null,
    Object? category = null,
    Object? icon = freezed,
    Object? isActive = null,
    Object? sortOrder = null,
    Object? units = null,
  }) {
    return _then(
      _$ActivityTypeImpl(
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
        inputType: null == inputType
            ? _value.inputType
            : inputType // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        icon: freezed == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        units: null == units
            ? _value._units
            : units // ignore: cast_nullable_to_non_nullable
                  as List<Unit>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityTypeImpl implements _ActivityType {
  const _$ActivityTypeImpl({
    required this.id,
    required this.name,
    @JsonKey(name: 'name_en') this.nameEn,
    @JsonKey(name: 'input_type') this.inputType = 'number',
    this.category = 'other',
    this.icon,
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'sort_order') this.sortOrder = 0,
    final List<Unit> units = const [],
  }) : _units = units;

  factory _$ActivityTypeImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityTypeImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey(name: 'name_en')
  final String? nameEn;
  @override
  @JsonKey(name: 'input_type')
  final String inputType;
  @override
  @JsonKey()
  final String category;
  @override
  final String? icon;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  final List<Unit> _units;
  @override
  @JsonKey()
  List<Unit> get units {
    if (_units is EqualUnmodifiableListView) return _units;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_units);
  }

  @override
  String toString() {
    return 'ActivityType(id: $id, name: $name, nameEn: $nameEn, inputType: $inputType, category: $category, icon: $icon, isActive: $isActive, sortOrder: $sortOrder, units: $units)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityTypeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.inputType, inputType) ||
                other.inputType == inputType) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            const DeepCollectionEquality().equals(other._units, _units));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    nameEn,
    inputType,
    category,
    icon,
    isActive,
    sortOrder,
    const DeepCollectionEquality().hash(_units),
  );

  /// Create a copy of ActivityType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityTypeImplCopyWith<_$ActivityTypeImpl> get copyWith =>
      __$$ActivityTypeImplCopyWithImpl<_$ActivityTypeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityTypeImplToJson(this);
  }
}

abstract class _ActivityType implements ActivityType {
  const factory _ActivityType({
    required final String id,
    required final String name,
    @JsonKey(name: 'name_en') final String? nameEn,
    @JsonKey(name: 'input_type') final String inputType,
    final String category,
    final String? icon,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'sort_order') final int sortOrder,
    final List<Unit> units,
  }) = _$ActivityTypeImpl;

  factory _ActivityType.fromJson(Map<String, dynamic> json) =
      _$ActivityTypeImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'name_en')
  String? get nameEn;
  @override
  @JsonKey(name: 'input_type')
  String get inputType;
  @override
  String get category;
  @override
  String? get icon;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  List<Unit> get units;

  /// Create a copy of ActivityType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityTypeImplCopyWith<_$ActivityTypeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
