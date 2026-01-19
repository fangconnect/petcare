// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Reminder _$ReminderFromJson(Map<String, dynamic> json) {
  return _Reminder.fromJson(json);
}

/// @nodoc
mixin _$Reminder {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'pet_id')
  String get petId => throw _privateConstructorUsedError;
  @JsonKey(name: 'pet_disease_id')
  String? get petDiseaseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'reminder_type')
  String get reminderType => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'scheduled_time')
  String get scheduledTime => throw _privateConstructorUsedError; // HH:mm format
  String get frequency => throw _privateConstructorUsedError;
  @JsonKey(name: 'frequency_config')
  Map<String, dynamic>? get frequencyConfig =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_date')
  DateTime get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date')
  DateTime? get endDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Reminder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Reminder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReminderCopyWith<Reminder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReminderCopyWith<$Res> {
  factory $ReminderCopyWith(Reminder value, $Res Function(Reminder) then) =
      _$ReminderCopyWithImpl<$Res, Reminder>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'pet_id') String petId,
    @JsonKey(name: 'pet_disease_id') String? petDiseaseId,
    @JsonKey(name: 'reminder_type') String reminderType,
    String title,
    String? description,
    @JsonKey(name: 'scheduled_time') String scheduledTime,
    String frequency,
    @JsonKey(name: 'frequency_config') Map<String, dynamic>? frequencyConfig,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'start_date') DateTime startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class _$ReminderCopyWithImpl<$Res, $Val extends Reminder>
    implements $ReminderCopyWith<$Res> {
  _$ReminderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Reminder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? petId = null,
    Object? petDiseaseId = freezed,
    Object? reminderType = null,
    Object? title = null,
    Object? description = freezed,
    Object? scheduledTime = null,
    Object? frequency = null,
    Object? frequencyConfig = freezed,
    Object? isActive = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
            petDiseaseId: freezed == petDiseaseId
                ? _value.petDiseaseId
                : petDiseaseId // ignore: cast_nullable_to_non_nullable
                      as String?,
            reminderType: null == reminderType
                ? _value.reminderType
                : reminderType // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            scheduledTime: null == scheduledTime
                ? _value.scheduledTime
                : scheduledTime // ignore: cast_nullable_to_non_nullable
                      as String,
            frequency: null == frequency
                ? _value.frequency
                : frequency // ignore: cast_nullable_to_non_nullable
                      as String,
            frequencyConfig: freezed == frequencyConfig
                ? _value.frequencyConfig
                : frequencyConfig // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
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
abstract class _$$ReminderImplCopyWith<$Res>
    implements $ReminderCopyWith<$Res> {
  factory _$$ReminderImplCopyWith(
    _$ReminderImpl value,
    $Res Function(_$ReminderImpl) then,
  ) = __$$ReminderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'pet_id') String petId,
    @JsonKey(name: 'pet_disease_id') String? petDiseaseId,
    @JsonKey(name: 'reminder_type') String reminderType,
    String title,
    String? description,
    @JsonKey(name: 'scheduled_time') String scheduledTime,
    String frequency,
    @JsonKey(name: 'frequency_config') Map<String, dynamic>? frequencyConfig,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'start_date') DateTime startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class __$$ReminderImplCopyWithImpl<$Res>
    extends _$ReminderCopyWithImpl<$Res, _$ReminderImpl>
    implements _$$ReminderImplCopyWith<$Res> {
  __$$ReminderImplCopyWithImpl(
    _$ReminderImpl _value,
    $Res Function(_$ReminderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Reminder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? petId = null,
    Object? petDiseaseId = freezed,
    Object? reminderType = null,
    Object? title = null,
    Object? description = freezed,
    Object? scheduledTime = null,
    Object? frequency = null,
    Object? frequencyConfig = freezed,
    Object? isActive = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ReminderImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        petId: null == petId
            ? _value.petId
            : petId // ignore: cast_nullable_to_non_nullable
                  as String,
        petDiseaseId: freezed == petDiseaseId
            ? _value.petDiseaseId
            : petDiseaseId // ignore: cast_nullable_to_non_nullable
                  as String?,
        reminderType: null == reminderType
            ? _value.reminderType
            : reminderType // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        scheduledTime: null == scheduledTime
            ? _value.scheduledTime
            : scheduledTime // ignore: cast_nullable_to_non_nullable
                  as String,
        frequency: null == frequency
            ? _value.frequency
            : frequency // ignore: cast_nullable_to_non_nullable
                  as String,
        frequencyConfig: freezed == frequencyConfig
            ? _value._frequencyConfig
            : frequencyConfig // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
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
class _$ReminderImpl implements _Reminder {
  const _$ReminderImpl({
    required this.id,
    @JsonKey(name: 'pet_id') required this.petId,
    @JsonKey(name: 'pet_disease_id') this.petDiseaseId,
    @JsonKey(name: 'reminder_type') required this.reminderType,
    required this.title,
    this.description,
    @JsonKey(name: 'scheduled_time') required this.scheduledTime,
    this.frequency = 'daily',
    @JsonKey(name: 'frequency_config')
    final Map<String, dynamic>? frequencyConfig,
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'start_date') required this.startDate,
    @JsonKey(name: 'end_date') this.endDate,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : _frequencyConfig = frequencyConfig;

  factory _$ReminderImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReminderImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'pet_id')
  final String petId;
  @override
  @JsonKey(name: 'pet_disease_id')
  final String? petDiseaseId;
  @override
  @JsonKey(name: 'reminder_type')
  final String reminderType;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'scheduled_time')
  final String scheduledTime;
  // HH:mm format
  @override
  @JsonKey()
  final String frequency;
  final Map<String, dynamic>? _frequencyConfig;
  @override
  @JsonKey(name: 'frequency_config')
  Map<String, dynamic>? get frequencyConfig {
    final value = _frequencyConfig;
    if (value == null) return null;
    if (_frequencyConfig is EqualUnmodifiableMapView) return _frequencyConfig;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'start_date')
  final DateTime startDate;
  @override
  @JsonKey(name: 'end_date')
  final DateTime? endDate;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Reminder(id: $id, petId: $petId, petDiseaseId: $petDiseaseId, reminderType: $reminderType, title: $title, description: $description, scheduledTime: $scheduledTime, frequency: $frequency, frequencyConfig: $frequencyConfig, isActive: $isActive, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReminderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.petId, petId) || other.petId == petId) &&
            (identical(other.petDiseaseId, petDiseaseId) ||
                other.petDiseaseId == petDiseaseId) &&
            (identical(other.reminderType, reminderType) ||
                other.reminderType == reminderType) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.scheduledTime, scheduledTime) ||
                other.scheduledTime == scheduledTime) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            const DeepCollectionEquality().equals(
              other._frequencyConfig,
              _frequencyConfig,
            ) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
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
    petId,
    petDiseaseId,
    reminderType,
    title,
    description,
    scheduledTime,
    frequency,
    const DeepCollectionEquality().hash(_frequencyConfig),
    isActive,
    startDate,
    endDate,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Reminder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReminderImplCopyWith<_$ReminderImpl> get copyWith =>
      __$$ReminderImplCopyWithImpl<_$ReminderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReminderImplToJson(this);
  }
}

abstract class _Reminder implements Reminder {
  const factory _Reminder({
    required final String id,
    @JsonKey(name: 'pet_id') required final String petId,
    @JsonKey(name: 'pet_disease_id') final String? petDiseaseId,
    @JsonKey(name: 'reminder_type') required final String reminderType,
    required final String title,
    final String? description,
    @JsonKey(name: 'scheduled_time') required final String scheduledTime,
    final String frequency,
    @JsonKey(name: 'frequency_config')
    final Map<String, dynamic>? frequencyConfig,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'start_date') required final DateTime startDate,
    @JsonKey(name: 'end_date') final DateTime? endDate,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$ReminderImpl;

  factory _Reminder.fromJson(Map<String, dynamic> json) =
      _$ReminderImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'pet_id')
  String get petId;
  @override
  @JsonKey(name: 'pet_disease_id')
  String? get petDiseaseId;
  @override
  @JsonKey(name: 'reminder_type')
  String get reminderType;
  @override
  String get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'scheduled_time')
  String get scheduledTime; // HH:mm format
  @override
  String get frequency;
  @override
  @JsonKey(name: 'frequency_config')
  Map<String, dynamic>? get frequencyConfig;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'start_date')
  DateTime get startDate;
  @override
  @JsonKey(name: 'end_date')
  DateTime? get endDate;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of Reminder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReminderImplCopyWith<_$ReminderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReminderLog _$ReminderLogFromJson(Map<String, dynamic> json) {
  return _ReminderLog.fromJson(json);
}

/// @nodoc
mixin _$ReminderLog {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'reminder_id')
  String get reminderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'scheduled_for')
  DateTime get scheduledFor => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // pending, completed, skipped, missed
  @JsonKey(name: 'completed_by')
  String? get completedBy => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ReminderLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReminderLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReminderLogCopyWith<ReminderLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReminderLogCopyWith<$Res> {
  factory $ReminderLogCopyWith(
    ReminderLog value,
    $Res Function(ReminderLog) then,
  ) = _$ReminderLogCopyWithImpl<$Res, ReminderLog>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'reminder_id') String reminderId,
    @JsonKey(name: 'scheduled_for') DateTime scheduledFor,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    String status,
    @JsonKey(name: 'completed_by') String? completedBy,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class _$ReminderLogCopyWithImpl<$Res, $Val extends ReminderLog>
    implements $ReminderLogCopyWith<$Res> {
  _$ReminderLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReminderLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reminderId = null,
    Object? scheduledFor = null,
    Object? completedAt = freezed,
    Object? status = null,
    Object? completedBy = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            reminderId: null == reminderId
                ? _value.reminderId
                : reminderId // ignore: cast_nullable_to_non_nullable
                      as String,
            scheduledFor: null == scheduledFor
                ? _value.scheduledFor
                : scheduledFor // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            completedBy: freezed == completedBy
                ? _value.completedBy
                : completedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReminderLogImplCopyWith<$Res>
    implements $ReminderLogCopyWith<$Res> {
  factory _$$ReminderLogImplCopyWith(
    _$ReminderLogImpl value,
    $Res Function(_$ReminderLogImpl) then,
  ) = __$$ReminderLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'reminder_id') String reminderId,
    @JsonKey(name: 'scheduled_for') DateTime scheduledFor,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    String status,
    @JsonKey(name: 'completed_by') String? completedBy,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class __$$ReminderLogImplCopyWithImpl<$Res>
    extends _$ReminderLogCopyWithImpl<$Res, _$ReminderLogImpl>
    implements _$$ReminderLogImplCopyWith<$Res> {
  __$$ReminderLogImplCopyWithImpl(
    _$ReminderLogImpl _value,
    $Res Function(_$ReminderLogImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReminderLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reminderId = null,
    Object? scheduledFor = null,
    Object? completedAt = freezed,
    Object? status = null,
    Object? completedBy = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$ReminderLogImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        reminderId: null == reminderId
            ? _value.reminderId
            : reminderId // ignore: cast_nullable_to_non_nullable
                  as String,
        scheduledFor: null == scheduledFor
            ? _value.scheduledFor
            : scheduledFor // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        completedBy: freezed == completedBy
            ? _value.completedBy
            : completedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReminderLogImpl implements _ReminderLog {
  const _$ReminderLogImpl({
    required this.id,
    @JsonKey(name: 'reminder_id') required this.reminderId,
    @JsonKey(name: 'scheduled_for') required this.scheduledFor,
    @JsonKey(name: 'completed_at') this.completedAt,
    this.status = 'pending',
    @JsonKey(name: 'completed_by') this.completedBy,
    this.notes,
    @JsonKey(name: 'created_at') this.createdAt,
  });

  factory _$ReminderLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReminderLogImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'reminder_id')
  final String reminderId;
  @override
  @JsonKey(name: 'scheduled_for')
  final DateTime scheduledFor;
  @override
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;
  @override
  @JsonKey()
  final String status;
  // pending, completed, skipped, missed
  @override
  @JsonKey(name: 'completed_by')
  final String? completedBy;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'ReminderLog(id: $id, reminderId: $reminderId, scheduledFor: $scheduledFor, completedAt: $completedAt, status: $status, completedBy: $completedBy, notes: $notes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReminderLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reminderId, reminderId) ||
                other.reminderId == reminderId) &&
            (identical(other.scheduledFor, scheduledFor) ||
                other.scheduledFor == scheduledFor) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.completedBy, completedBy) ||
                other.completedBy == completedBy) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    reminderId,
    scheduledFor,
    completedAt,
    status,
    completedBy,
    notes,
    createdAt,
  );

  /// Create a copy of ReminderLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReminderLogImplCopyWith<_$ReminderLogImpl> get copyWith =>
      __$$ReminderLogImplCopyWithImpl<_$ReminderLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReminderLogImplToJson(this);
  }
}

abstract class _ReminderLog implements ReminderLog {
  const factory _ReminderLog({
    required final String id,
    @JsonKey(name: 'reminder_id') required final String reminderId,
    @JsonKey(name: 'scheduled_for') required final DateTime scheduledFor,
    @JsonKey(name: 'completed_at') final DateTime? completedAt,
    final String status,
    @JsonKey(name: 'completed_by') final String? completedBy,
    final String? notes,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
  }) = _$ReminderLogImpl;

  factory _ReminderLog.fromJson(Map<String, dynamic> json) =
      _$ReminderLogImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'reminder_id')
  String get reminderId;
  @override
  @JsonKey(name: 'scheduled_for')
  DateTime get scheduledFor;
  @override
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt;
  @override
  String get status; // pending, completed, skipped, missed
  @override
  @JsonKey(name: 'completed_by')
  String? get completedBy;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of ReminderLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReminderLogImplCopyWith<_$ReminderLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
