// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HealthSummaryImpl _$$HealthSummaryImplFromJson(Map<String, dynamic> json) =>
    _$HealthSummaryImpl(
      id: json['id'] as String,
      petId: json['pet_id'] as String,
      summaryDate: DateTime.parse(json['summary_date'] as String),
      periodStart: DateTime.parse(json['period_start'] as String),
      periodEnd: DateTime.parse(json['period_end'] as String),
      metrics: json['metrics'] as Map<String, dynamic>? ?? const {},
      healthScore: (json['health_score'] as num?)?.toDouble(),
      scoreBreakdown: json['score_breakdown'] as Map<String, dynamic>?,
      assessment: json['assessment'] as String?,
      recommendations:
          (json['recommendations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      generatedAt: json['generated_at'] == null
          ? null
          : DateTime.parse(json['generated_at'] as String),
      generatedBy: json['generated_by'] as String?,
    );

Map<String, dynamic> _$$HealthSummaryImplToJson(_$HealthSummaryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pet_id': instance.petId,
      'summary_date': instance.summaryDate.toIso8601String(),
      'period_start': instance.periodStart.toIso8601String(),
      'period_end': instance.periodEnd.toIso8601String(),
      'metrics': instance.metrics,
      'health_score': instance.healthScore,
      'score_breakdown': instance.scoreBreakdown,
      'assessment': instance.assessment,
      'recommendations': instance.recommendations,
      'generated_at': instance.generatedAt?.toIso8601String(),
      'generated_by': instance.generatedBy,
    };
