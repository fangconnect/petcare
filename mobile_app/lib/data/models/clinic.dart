import 'package:freezed_annotation/freezed_annotation.dart';

part 'clinic.freezed.dart';
part 'clinic.g.dart';

@freezed
class Clinic with _$Clinic {
  const factory Clinic({
    required String id,
    @JsonKey(name: 'clinic_name') required String clinicName,
    @JsonKey(name: 'license_number') String? licenseNumber,
    String? address,
    String? phone,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Clinic;

  factory Clinic.fromJson(Map<String, dynamic> json) => _$ClinicFromJson(json);
}

@freezed
class Appointment with _$Appointment {
  const factory Appointment({
    required String id,
    @JsonKey(name: 'clinic_id') required String clinicId,
    @JsonKey(name: 'pet_id') required String petId,
    @JsonKey(name: 'vet_id') String? vetId,
    @JsonKey(name: 'appointment_time') required DateTime appointmentTime,
    String? purpose,
    @Default('scheduled') String status, // scheduled, confirmed, completed, cancelled, no_show
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    Clinic? clinic,
  }) = _Appointment;

  factory Appointment.fromJson(Map<String, dynamic> json) => _$AppointmentFromJson(json);
}
