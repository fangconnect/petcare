// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ActivityLog _$ActivityLogFromJson(Map<String, dynamic> json) {
  return _ActivityLog.fromJson(json);
}

/// @nodoc
mixin _$ActivityLog {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'pet_id')
  String get petId => throw _privateConstructorUsedError;
  @JsonKey(name: 'pet_disease_id')
  String? get petDiseaseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'activity_type')
  String get activityType => throw _privateConstructorUsedError;
  @JsonKey(name: 'logged_at')
  DateTime get loggedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'activity_data')
  Map<String, dynamic> get activityData => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'logged_by')
  String? get loggedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  List<ActivityPhoto>? get photos => throw _privateConstructorUsedError;

  /// Serializes this ActivityLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityLogCopyWith<ActivityLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityLogCopyWith<$Res> {
  factory $ActivityLogCopyWith(
    ActivityLog value,
    $Res Function(ActivityLog) then,
  ) = _$ActivityLogCopyWithImpl<$Res, ActivityLog>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'pet_id') String petId,
    @JsonKey(name: 'pet_disease_id') String? petDiseaseId,
    @JsonKey(name: 'activity_type') String activityType,
    @JsonKey(name: 'logged_at') DateTime loggedAt,
    @JsonKey(name: 'activity_data') Map<String, dynamic> activityData,
    String? notes,
    @JsonKey(name: 'logged_by') String? loggedBy,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    List<ActivityPhoto>? photos,
  });
}

/// @nodoc
class _$ActivityLogCopyWithImpl<$Res, $Val extends ActivityLog>
    implements $ActivityLogCopyWith<$Res> {
  _$ActivityLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? petId = null,
    Object? petDiseaseId = freezed,
    Object? activityType = null,
    Object? loggedAt = null,
    Object? activityData = null,
    Object? notes = freezed,
    Object? loggedBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? photos = freezed,
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
            activityType: null == activityType
                ? _value.activityType
                : activityType // ignore: cast_nullable_to_non_nullable
                      as String,
            loggedAt: null == loggedAt
                ? _value.loggedAt
                : loggedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            activityData: null == activityData
                ? _value.activityData
                : activityData // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            loggedBy: freezed == loggedBy
                ? _value.loggedBy
                : loggedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            photos: freezed == photos
                ? _value.photos
                : photos // ignore: cast_nullable_to_non_nullable
                      as List<ActivityPhoto>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActivityLogImplCopyWith<$Res>
    implements $ActivityLogCopyWith<$Res> {
  factory _$$ActivityLogImplCopyWith(
    _$ActivityLogImpl value,
    $Res Function(_$ActivityLogImpl) then,
  ) = __$$ActivityLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'pet_id') String petId,
    @JsonKey(name: 'pet_disease_id') String? petDiseaseId,
    @JsonKey(name: 'activity_type') String activityType,
    @JsonKey(name: 'logged_at') DateTime loggedAt,
    @JsonKey(name: 'activity_data') Map<String, dynamic> activityData,
    String? notes,
    @JsonKey(name: 'logged_by') String? loggedBy,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    List<ActivityPhoto>? photos,
  });
}

/// @nodoc
class __$$ActivityLogImplCopyWithImpl<$Res>
    extends _$ActivityLogCopyWithImpl<$Res, _$ActivityLogImpl>
    implements _$$ActivityLogImplCopyWith<$Res> {
  __$$ActivityLogImplCopyWithImpl(
    _$ActivityLogImpl _value,
    $Res Function(_$ActivityLogImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? petId = null,
    Object? petDiseaseId = freezed,
    Object? activityType = null,
    Object? loggedAt = null,
    Object? activityData = null,
    Object? notes = freezed,
    Object? loggedBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? photos = freezed,
  }) {
    return _then(
      _$ActivityLogImpl(
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
        activityType: null == activityType
            ? _value.activityType
            : activityType // ignore: cast_nullable_to_non_nullable
                  as String,
        loggedAt: null == loggedAt
            ? _value.loggedAt
            : loggedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        activityData: null == activityData
            ? _value._activityData
            : activityData // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        loggedBy: freezed == loggedBy
            ? _value.loggedBy
            : loggedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        photos: freezed == photos
            ? _value._photos
            : photos // ignore: cast_nullable_to_non_nullable
                  as List<ActivityPhoto>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityLogImpl extends _ActivityLog {
  const _$ActivityLogImpl({
    required this.id,
    @JsonKey(name: 'pet_id') required this.petId,
    @JsonKey(name: 'pet_disease_id') this.petDiseaseId,
    @JsonKey(name: 'activity_type') required this.activityType,
    @JsonKey(name: 'logged_at') required this.loggedAt,
    @JsonKey(name: 'activity_data')
    final Map<String, dynamic> activityData = const {},
    this.notes,
    @JsonKey(name: 'logged_by') this.loggedBy,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
    final List<ActivityPhoto>? photos,
  }) : _activityData = activityData,
       _photos = photos,
       super._();

  factory _$ActivityLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityLogImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'pet_id')
  final String petId;
  @override
  @JsonKey(name: 'pet_disease_id')
  final String? petDiseaseId;
  @override
  @JsonKey(name: 'activity_type')
  final String activityType;
  @override
  @JsonKey(name: 'logged_at')
  final DateTime loggedAt;
  final Map<String, dynamic> _activityData;
  @override
  @JsonKey(name: 'activity_data')
  Map<String, dynamic> get activityData {
    if (_activityData is EqualUnmodifiableMapView) return _activityData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_activityData);
  }

  @override
  final String? notes;
  @override
  @JsonKey(name: 'logged_by')
  final String? loggedBy;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  final List<ActivityPhoto>? _photos;
  @override
  List<ActivityPhoto>? get photos {
    final value = _photos;
    if (value == null) return null;
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ActivityLog(id: $id, petId: $petId, petDiseaseId: $petDiseaseId, activityType: $activityType, loggedAt: $loggedAt, activityData: $activityData, notes: $notes, loggedBy: $loggedBy, createdAt: $createdAt, updatedAt: $updatedAt, photos: $photos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.petId, petId) || other.petId == petId) &&
            (identical(other.petDiseaseId, petDiseaseId) ||
                other.petDiseaseId == petDiseaseId) &&
            (identical(other.activityType, activityType) ||
                other.activityType == activityType) &&
            (identical(other.loggedAt, loggedAt) ||
                other.loggedAt == loggedAt) &&
            const DeepCollectionEquality().equals(
              other._activityData,
              _activityData,
            ) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.loggedBy, loggedBy) ||
                other.loggedBy == loggedBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._photos, _photos));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    petId,
    petDiseaseId,
    activityType,
    loggedAt,
    const DeepCollectionEquality().hash(_activityData),
    notes,
    loggedBy,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(_photos),
  );

  /// Create a copy of ActivityLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityLogImplCopyWith<_$ActivityLogImpl> get copyWith =>
      __$$ActivityLogImplCopyWithImpl<_$ActivityLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityLogImplToJson(this);
  }
}

abstract class _ActivityLog extends ActivityLog {
  const factory _ActivityLog({
    required final String id,
    @JsonKey(name: 'pet_id') required final String petId,
    @JsonKey(name: 'pet_disease_id') final String? petDiseaseId,
    @JsonKey(name: 'activity_type') required final String activityType,
    @JsonKey(name: 'logged_at') required final DateTime loggedAt,
    @JsonKey(name: 'activity_data') final Map<String, dynamic> activityData,
    final String? notes,
    @JsonKey(name: 'logged_by') final String? loggedBy,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
    final List<ActivityPhoto>? photos,
  }) = _$ActivityLogImpl;
  const _ActivityLog._() : super._();

  factory _ActivityLog.fromJson(Map<String, dynamic> json) =
      _$ActivityLogImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'pet_id')
  String get petId;
  @override
  @JsonKey(name: 'pet_disease_id')
  String? get petDiseaseId;
  @override
  @JsonKey(name: 'activity_type')
  String get activityType;
  @override
  @JsonKey(name: 'logged_at')
  DateTime get loggedAt;
  @override
  @JsonKey(name: 'activity_data')
  Map<String, dynamic> get activityData;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'logged_by')
  String? get loggedBy;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  List<ActivityPhoto>? get photos;

  /// Create a copy of ActivityLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityLogImplCopyWith<_$ActivityLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActivityPhoto _$ActivityPhotoFromJson(Map<String, dynamic> json) {
  return _ActivityPhoto.fromJson(json);
}

/// @nodoc
mixin _$ActivityPhoto {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'activity_log_id')
  String get activityLogId => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_url')
  String get photoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'thumbnail_url')
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  String? get caption => throw _privateConstructorUsedError;
  @JsonKey(name: 'file_size')
  int? get fileSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ActivityPhoto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityPhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityPhotoCopyWith<ActivityPhoto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityPhotoCopyWith<$Res> {
  factory $ActivityPhotoCopyWith(
    ActivityPhoto value,
    $Res Function(ActivityPhoto) then,
  ) = _$ActivityPhotoCopyWithImpl<$Res, ActivityPhoto>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'activity_log_id') String activityLogId,
    @JsonKey(name: 'photo_url') String photoUrl,
    @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
    String? caption,
    @JsonKey(name: 'file_size') int? fileSize,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class _$ActivityPhotoCopyWithImpl<$Res, $Val extends ActivityPhoto>
    implements $ActivityPhotoCopyWith<$Res> {
  _$ActivityPhotoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityPhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? activityLogId = null,
    Object? photoUrl = null,
    Object? thumbnailUrl = freezed,
    Object? caption = freezed,
    Object? fileSize = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            activityLogId: null == activityLogId
                ? _value.activityLogId
                : activityLogId // ignore: cast_nullable_to_non_nullable
                      as String,
            photoUrl: null == photoUrl
                ? _value.photoUrl
                : photoUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            thumbnailUrl: freezed == thumbnailUrl
                ? _value.thumbnailUrl
                : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            caption: freezed == caption
                ? _value.caption
                : caption // ignore: cast_nullable_to_non_nullable
                      as String?,
            fileSize: freezed == fileSize
                ? _value.fileSize
                : fileSize // ignore: cast_nullable_to_non_nullable
                      as int?,
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
abstract class _$$ActivityPhotoImplCopyWith<$Res>
    implements $ActivityPhotoCopyWith<$Res> {
  factory _$$ActivityPhotoImplCopyWith(
    _$ActivityPhotoImpl value,
    $Res Function(_$ActivityPhotoImpl) then,
  ) = __$$ActivityPhotoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'activity_log_id') String activityLogId,
    @JsonKey(name: 'photo_url') String photoUrl,
    @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
    String? caption,
    @JsonKey(name: 'file_size') int? fileSize,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class __$$ActivityPhotoImplCopyWithImpl<$Res>
    extends _$ActivityPhotoCopyWithImpl<$Res, _$ActivityPhotoImpl>
    implements _$$ActivityPhotoImplCopyWith<$Res> {
  __$$ActivityPhotoImplCopyWithImpl(
    _$ActivityPhotoImpl _value,
    $Res Function(_$ActivityPhotoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityPhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? activityLogId = null,
    Object? photoUrl = null,
    Object? thumbnailUrl = freezed,
    Object? caption = freezed,
    Object? fileSize = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$ActivityPhotoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        activityLogId: null == activityLogId
            ? _value.activityLogId
            : activityLogId // ignore: cast_nullable_to_non_nullable
                  as String,
        photoUrl: null == photoUrl
            ? _value.photoUrl
            : photoUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        thumbnailUrl: freezed == thumbnailUrl
            ? _value.thumbnailUrl
            : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        caption: freezed == caption
            ? _value.caption
            : caption // ignore: cast_nullable_to_non_nullable
                  as String?,
        fileSize: freezed == fileSize
            ? _value.fileSize
            : fileSize // ignore: cast_nullable_to_non_nullable
                  as int?,
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
class _$ActivityPhotoImpl implements _ActivityPhoto {
  const _$ActivityPhotoImpl({
    required this.id,
    @JsonKey(name: 'activity_log_id') required this.activityLogId,
    @JsonKey(name: 'photo_url') required this.photoUrl,
    @JsonKey(name: 'thumbnail_url') this.thumbnailUrl,
    this.caption,
    @JsonKey(name: 'file_size') this.fileSize,
    @JsonKey(name: 'created_at') this.createdAt,
  });

  factory _$ActivityPhotoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityPhotoImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'activity_log_id')
  final String activityLogId;
  @override
  @JsonKey(name: 'photo_url')
  final String photoUrl;
  @override
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;
  @override
  final String? caption;
  @override
  @JsonKey(name: 'file_size')
  final int? fileSize;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'ActivityPhoto(id: $id, activityLogId: $activityLogId, photoUrl: $photoUrl, thumbnailUrl: $thumbnailUrl, caption: $caption, fileSize: $fileSize, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityPhotoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.activityLogId, activityLogId) ||
                other.activityLogId == activityLogId) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    activityLogId,
    photoUrl,
    thumbnailUrl,
    caption,
    fileSize,
    createdAt,
  );

  /// Create a copy of ActivityPhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityPhotoImplCopyWith<_$ActivityPhotoImpl> get copyWith =>
      __$$ActivityPhotoImplCopyWithImpl<_$ActivityPhotoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityPhotoImplToJson(this);
  }
}

abstract class _ActivityPhoto implements ActivityPhoto {
  const factory _ActivityPhoto({
    required final String id,
    @JsonKey(name: 'activity_log_id') required final String activityLogId,
    @JsonKey(name: 'photo_url') required final String photoUrl,
    @JsonKey(name: 'thumbnail_url') final String? thumbnailUrl,
    final String? caption,
    @JsonKey(name: 'file_size') final int? fileSize,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
  }) = _$ActivityPhotoImpl;

  factory _ActivityPhoto.fromJson(Map<String, dynamic> json) =
      _$ActivityPhotoImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'activity_log_id')
  String get activityLogId;
  @override
  @JsonKey(name: 'photo_url')
  String get photoUrl;
  @override
  @JsonKey(name: 'thumbnail_url')
  String? get thumbnailUrl;
  @override
  String? get caption;
  @override
  @JsonKey(name: 'file_size')
  int? get fileSize;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of ActivityPhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityPhotoImplCopyWith<_$ActivityPhotoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
