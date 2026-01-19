import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_summary.freezed.dart';
part 'health_summary.g.dart';

@freezed
class HealthSummary with _$HealthSummary {
  const factory HealthSummary({
    required String id,
    @JsonKey(name: 'pet_id') required String petId,
    @JsonKey(name: 'summary_date') required DateTime summaryDate,
    @JsonKey(name: 'period_start') required DateTime periodStart,
    @JsonKey(name: 'period_end') required DateTime periodEnd,
    @Default({}) Map<String, dynamic> metrics,
    @JsonKey(name: 'health_score') double? healthScore,
    @JsonKey(name: 'score_breakdown') Map<String, dynamic>? scoreBreakdown,
    String? assessment,
    @Default([]) List<String> recommendations,
    @JsonKey(name: 'generated_at') DateTime? generatedAt,
    @JsonKey(name: 'generated_by') String? generatedBy,
  }) = _HealthSummary;

  factory HealthSummary.fromJson(Map<String, dynamic> json) => _$HealthSummaryFromJson(json);
}
