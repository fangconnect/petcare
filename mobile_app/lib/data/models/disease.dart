import 'package:freezed_annotation/freezed_annotation.dart';
import 'disease_template.dart';

part 'disease.freezed.dart';
part 'disease.g.dart';

@freezed
class Disease with _$Disease {
  const factory Disease({
    required String id,
    required String name,
    @JsonKey(name: 'name_en') String? nameEn,
    String? category,
    String? description,
    @Default([]) List<String> symptoms,
    @JsonKey(name: 'recommended_monitoring') Map<String, dynamic>? recommendedMonitoring,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'disease_templates') List<DiseaseTemplate>? diseaseTemplates,
  }) = _Disease;

  factory Disease.fromJson(Map<String, dynamic> json) => _$DiseaseFromJson(json);
}
