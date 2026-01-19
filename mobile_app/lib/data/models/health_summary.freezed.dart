// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HealthSummary _$HealthSummaryFromJson(Map<String, dynamic> json) {
  return _HealthSummary.fromJson(json);
}

/// @nodoc
mixin _$HealthSummary {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'pet_id')
  String get petId => throw _privateConstructorUsedError;
  @JsonKey(name: 'summary_date')
  DateTime get summaryDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'period_start')
  DateTime get periodStart => throw _privateConstructorUsedError;
  @JsonKey(name: 'period_end')
  DateTime get periodEnd => throw _privateConstructorUsedError;
  Map<String, dynamic> get metrics => throw _privateConstructorUsedError;
  @JsonKey(name: 'health_score')
  double? get healthScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'score_breakdown')
  Map<String, dynamic>? get scoreBreakdown =>
      throw _privateConstructorUsedError;
  String? get assessment => throw _privateConstructorUsedError;
  List<String> get recommendations => throw _privateConstructorUsedError;
  @JsonKey(name: 'generated_at')
  DateTime? get generatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'generated_by')
  String? get generatedBy => throw _privateConstructorUsedError;

  /// Serializes this HealthSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HealthSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HealthSummaryCopyWith<HealthSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthSummaryCopyWith<$Res> {
  factory $HealthSummaryCopyWith(
    HealthSummary value,
    $Res Function(HealthSummary) then,
  ) = _$HealthSummaryCopyWithImpl<$Res, HealthSummary>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'pet_id') String petId,
    @JsonKey(name: 'summary_date') DateTime summaryDate,
    @JsonKey(name: 'period_start') DateTime periodStart,
    @JsonKey(name: 'period_end') DateTime periodEnd,
    Map<String, dynamic> metrics,
    @JsonKey(name: 'health_score') double? healthScore,
    @JsonKey(name: 'score_breakdown') Map<String, dynamic>? scoreBreakdown,
    String? assessment,
    List<String> recommendations,
    @JsonKey(name: 'generated_at') DateTime? generatedAt,
    @JsonKey(name: 'generated_by') String? generatedBy,
  });
}

/// @nodoc
class _$HealthSummaryCopyWithImpl<$Res, $Val extends HealthSummary>
    implements $HealthSummaryCopyWith<$Res> {
  _$HealthSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HealthSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? petId = null,
    Object? summaryDate = null,
    Object? periodStart = null,
    Object? periodEnd = null,
    Object? metrics = null,
    Object? healthScore = freezed,
    Object? scoreBreakdown = freezed,
    Object? assessment = freezed,
    Object? recommendations = null,
    Object? generatedAt = freezed,
    Object? generatedBy = freezed,
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
            summaryDate: null == summaryDate
                ? _value.summaryDate
                : summaryDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            periodStart: null == periodStart
                ? _value.periodStart
                : periodStart // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            periodEnd: null == periodEnd
                ? _value.periodEnd
                : periodEnd // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            metrics: null == metrics
                ? _value.metrics
                : metrics // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            healthScore: freezed == healthScore
                ? _value.healthScore
                : healthScore // ignore: cast_nullable_to_non_nullable
                      as double?,
            scoreBreakdown: freezed == scoreBreakdown
                ? _value.scoreBreakdown
                : scoreBreakdown // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            assessment: freezed == assessment
                ? _value.assessment
                : assessment // ignore: cast_nullable_to_non_nullable
                      as String?,
            recommendations: null == recommendations
                ? _value.recommendations
                : recommendations // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            generatedAt: freezed == generatedAt
                ? _value.generatedAt
                : generatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            generatedBy: freezed == generatedBy
                ? _value.generatedBy
                : generatedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HealthSummaryImplCopyWith<$Res>
    implements $HealthSummaryCopyWith<$Res> {
  factory _$$HealthSummaryImplCopyWith(
    _$HealthSummaryImpl value,
    $Res Function(_$HealthSummaryImpl) then,
  ) = __$$HealthSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'pet_id') String petId,
    @JsonKey(name: 'summary_date') DateTime summaryDate,
    @JsonKey(name: 'period_start') DateTime periodStart,
    @JsonKey(name: 'period_end') DateTime periodEnd,
    Map<String, dynamic> metrics,
    @JsonKey(name: 'health_score') double? healthScore,
    @JsonKey(name: 'score_breakdown') Map<String, dynamic>? scoreBreakdown,
    String? assessment,
    List<String> recommendations,
    @JsonKey(name: 'generated_at') DateTime? generatedAt,
    @JsonKey(name: 'generated_by') String? generatedBy,
  });
}

/// @nodoc
class __$$HealthSummaryImplCopyWithImpl<$Res>
    extends _$HealthSummaryCopyWithImpl<$Res, _$HealthSummaryImpl>
    implements _$$HealthSummaryImplCopyWith<$Res> {
  __$$HealthSummaryImplCopyWithImpl(
    _$HealthSummaryImpl _value,
    $Res Function(_$HealthSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HealthSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? petId = null,
    Object? summaryDate = null,
    Object? periodStart = null,
    Object? periodEnd = null,
    Object? metrics = null,
    Object? healthScore = freezed,
    Object? scoreBreakdown = freezed,
    Object? assessment = freezed,
    Object? recommendations = null,
    Object? generatedAt = freezed,
    Object? generatedBy = freezed,
  }) {
    return _then(
      _$HealthSummaryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        petId: null == petId
            ? _value.petId
            : petId // ignore: cast_nullable_to_non_nullable
                  as String,
        summaryDate: null == summaryDate
            ? _value.summaryDate
            : summaryDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        periodStart: null == periodStart
            ? _value.periodStart
            : periodStart // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        periodEnd: null == periodEnd
            ? _value.periodEnd
            : periodEnd // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        metrics: null == metrics
            ? _value._metrics
            : metrics // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        healthScore: freezed == healthScore
            ? _value.healthScore
            : healthScore // ignore: cast_nullable_to_non_nullable
                  as double?,
        scoreBreakdown: freezed == scoreBreakdown
            ? _value._scoreBreakdown
            : scoreBreakdown // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        assessment: freezed == assessment
            ? _value.assessment
            : assessment // ignore: cast_nullable_to_non_nullable
                  as String?,
        recommendations: null == recommendations
            ? _value._recommendations
            : recommendations // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        generatedAt: freezed == generatedAt
            ? _value.generatedAt
            : generatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        generatedBy: freezed == generatedBy
            ? _value.generatedBy
            : generatedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HealthSummaryImpl implements _HealthSummary {
  const _$HealthSummaryImpl({
    required this.id,
    @JsonKey(name: 'pet_id') required this.petId,
    @JsonKey(name: 'summary_date') required this.summaryDate,
    @JsonKey(name: 'period_start') required this.periodStart,
    @JsonKey(name: 'period_end') required this.periodEnd,
    final Map<String, dynamic> metrics = const {},
    @JsonKey(name: 'health_score') this.healthScore,
    @JsonKey(name: 'score_breakdown')
    final Map<String, dynamic>? scoreBreakdown,
    this.assessment,
    final List<String> recommendations = const [],
    @JsonKey(name: 'generated_at') this.generatedAt,
    @JsonKey(name: 'generated_by') this.generatedBy,
  }) : _metrics = metrics,
       _scoreBreakdown = scoreBreakdown,
       _recommendations = recommendations;

  factory _$HealthSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$HealthSummaryImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'pet_id')
  final String petId;
  @override
  @JsonKey(name: 'summary_date')
  final DateTime summaryDate;
  @override
  @JsonKey(name: 'period_start')
  final DateTime periodStart;
  @override
  @JsonKey(name: 'period_end')
  final DateTime periodEnd;
  final Map<String, dynamic> _metrics;
  @override
  @JsonKey()
  Map<String, dynamic> get metrics {
    if (_metrics is EqualUnmodifiableMapView) return _metrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metrics);
  }

  @override
  @JsonKey(name: 'health_score')
  final double? healthScore;
  final Map<String, dynamic>? _scoreBreakdown;
  @override
  @JsonKey(name: 'score_breakdown')
  Map<String, dynamic>? get scoreBreakdown {
    final value = _scoreBreakdown;
    if (value == null) return null;
    if (_scoreBreakdown is EqualUnmodifiableMapView) return _scoreBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? assessment;
  final List<String> _recommendations;
  @override
  @JsonKey()
  List<String> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

  @override
  @JsonKey(name: 'generated_at')
  final DateTime? generatedAt;
  @override
  @JsonKey(name: 'generated_by')
  final String? generatedBy;

  @override
  String toString() {
    return 'HealthSummary(id: $id, petId: $petId, summaryDate: $summaryDate, periodStart: $periodStart, periodEnd: $periodEnd, metrics: $metrics, healthScore: $healthScore, scoreBreakdown: $scoreBreakdown, assessment: $assessment, recommendations: $recommendations, generatedAt: $generatedAt, generatedBy: $generatedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.petId, petId) || other.petId == petId) &&
            (identical(other.summaryDate, summaryDate) ||
                other.summaryDate == summaryDate) &&
            (identical(other.periodStart, periodStart) ||
                other.periodStart == periodStart) &&
            (identical(other.periodEnd, periodEnd) ||
                other.periodEnd == periodEnd) &&
            const DeepCollectionEquality().equals(other._metrics, _metrics) &&
            (identical(other.healthScore, healthScore) ||
                other.healthScore == healthScore) &&
            const DeepCollectionEquality().equals(
              other._scoreBreakdown,
              _scoreBreakdown,
            ) &&
            (identical(other.assessment, assessment) ||
                other.assessment == assessment) &&
            const DeepCollectionEquality().equals(
              other._recommendations,
              _recommendations,
            ) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            (identical(other.generatedBy, generatedBy) ||
                other.generatedBy == generatedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    petId,
    summaryDate,
    periodStart,
    periodEnd,
    const DeepCollectionEquality().hash(_metrics),
    healthScore,
    const DeepCollectionEquality().hash(_scoreBreakdown),
    assessment,
    const DeepCollectionEquality().hash(_recommendations),
    generatedAt,
    generatedBy,
  );

  /// Create a copy of HealthSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthSummaryImplCopyWith<_$HealthSummaryImpl> get copyWith =>
      __$$HealthSummaryImplCopyWithImpl<_$HealthSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HealthSummaryImplToJson(this);
  }
}

abstract class _HealthSummary implements HealthSummary {
  const factory _HealthSummary({
    required final String id,
    @JsonKey(name: 'pet_id') required final String petId,
    @JsonKey(name: 'summary_date') required final DateTime summaryDate,
    @JsonKey(name: 'period_start') required final DateTime periodStart,
    @JsonKey(name: 'period_end') required final DateTime periodEnd,
    final Map<String, dynamic> metrics,
    @JsonKey(name: 'health_score') final double? healthScore,
    @JsonKey(name: 'score_breakdown')
    final Map<String, dynamic>? scoreBreakdown,
    final String? assessment,
    final List<String> recommendations,
    @JsonKey(name: 'generated_at') final DateTime? generatedAt,
    @JsonKey(name: 'generated_by') final String? generatedBy,
  }) = _$HealthSummaryImpl;

  factory _HealthSummary.fromJson(Map<String, dynamic> json) =
      _$HealthSummaryImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'pet_id')
  String get petId;
  @override
  @JsonKey(name: 'summary_date')
  DateTime get summaryDate;
  @override
  @JsonKey(name: 'period_start')
  DateTime get periodStart;
  @override
  @JsonKey(name: 'period_end')
  DateTime get periodEnd;
  @override
  Map<String, dynamic> get metrics;
  @override
  @JsonKey(name: 'health_score')
  double? get healthScore;
  @override
  @JsonKey(name: 'score_breakdown')
  Map<String, dynamic>? get scoreBreakdown;
  @override
  String? get assessment;
  @override
  List<String> get recommendations;
  @override
  @JsonKey(name: 'generated_at')
  DateTime? get generatedAt;
  @override
  @JsonKey(name: 'generated_by')
  String? get generatedBy;

  /// Create a copy of HealthSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HealthSummaryImplCopyWith<_$HealthSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
