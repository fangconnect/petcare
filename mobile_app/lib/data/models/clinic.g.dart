// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClinicImpl _$$ClinicImplFromJson(Map<String, dynamic> json) => _$ClinicImpl(
  id: json['id'] as String,
  clinicName: json['clinic_name'] as String,
  licenseNumber: json['license_number'] as String?,
  address: json['address'] as String?,
  phone: json['phone'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$$ClinicImplToJson(_$ClinicImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clinic_name': instance.clinicName,
      'license_number': instance.licenseNumber,
      'address': instance.address,
      'phone': instance.phone,
      'created_at': instance.createdAt?.toIso8601String(),
    };

_$AppointmentImpl _$$AppointmentImplFromJson(Map<String, dynamic> json) =>
    _$AppointmentImpl(
      id: json['id'] as String,
      clinicId: json['clinic_id'] as String,
      petId: json['pet_id'] as String,
      vetId: json['vet_id'] as String?,
      appointmentTime: DateTime.parse(json['appointment_time'] as String),
      purpose: json['purpose'] as String?,
      status: json['status'] as String? ?? 'scheduled',
      notes: json['notes'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      clinic: json['clinic'] == null
          ? null
          : Clinic.fromJson(json['clinic'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AppointmentImplToJson(_$AppointmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clinic_id': instance.clinicId,
      'pet_id': instance.petId,
      'vet_id': instance.vetId,
      'appointment_time': instance.appointmentTime.toIso8601String(),
      'purpose': instance.purpose,
      'status': instance.status,
      'notes': instance.notes,
      'created_at': instance.createdAt?.toIso8601String(),
      'clinic': instance.clinic,
    };
