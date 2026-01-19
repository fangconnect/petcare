// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  id: json['id'] as String,
  email: json['email'] as String,
  fullName: json['full_name'] as String?,
  phone: json['phone'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  isActive: json['is_active'] as bool? ?? true,
  role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ?? UserRole.user,
  subscriptionTier:
      $enumDecodeNullable(
        _$SubscriptionTierEnumMap,
        json['subscription_tier'],
      ) ??
      SubscriptionTier.free,
  subscriptionExpiresAt: json['subscription_expires_at'] == null
      ? null
      : DateTime.parse(json['subscription_expires_at'] as String),
  isTrialUsed: json['is_trial_used'] as bool? ?? false,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$UserImplToJson(
  _$UserImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'full_name': instance.fullName,
  'phone': instance.phone,
  'avatar_url': instance.avatarUrl,
  'is_active': instance.isActive,
  'role': _$UserRoleEnumMap[instance.role]!,
  'subscription_tier': _$SubscriptionTierEnumMap[instance.subscriptionTier]!,
  'subscription_expires_at': instance.subscriptionExpiresAt?.toIso8601String(),
  'is_trial_used': instance.isTrialUsed,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

const _$UserRoleEnumMap = {
  UserRole.user: 'user',
  UserRole.admin: 'admin',
  UserRole.clinicStaff: 'clinic_staff',
};

const _$SubscriptionTierEnumMap = {
  SubscriptionTier.free: 'free',
  SubscriptionTier.premium: 'premium',
};
