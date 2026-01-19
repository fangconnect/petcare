import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Subscription tier enum for freemium model
enum SubscriptionTier {
  @JsonValue('free')
  free,
  @JsonValue('premium')
  premium,
}

/// User role enum
enum UserRole {
  @JsonValue('user')
  user,
  @JsonValue('admin')
  admin,
  @JsonValue('clinic_staff')
  clinicStaff,
}

@freezed
class User with _$User {
  const User._();

  const factory User({
    required String id,
    required String email,
    @JsonKey(name: 'full_name') String? fullName,
    String? phone,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @Default(UserRole.user) UserRole role,
    @JsonKey(name: 'subscription_tier') @Default(SubscriptionTier.free) SubscriptionTier subscriptionTier,
    @JsonKey(name: 'subscription_expires_at') DateTime? subscriptionExpiresAt,
    @JsonKey(name: 'is_trial_used') @Default(false) bool isTrialUsed,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Check if user has active premium subscription
  bool get isPremium {
    if (subscriptionTier != SubscriptionTier.premium) return false;
    if (subscriptionExpiresAt == null) return false;
    return subscriptionExpiresAt!.isAfter(DateTime.now());
  }

  /// Check if user can add more pets based on subscription
  bool canAddPet(int currentPetCount) {
    if (isPremium) return true;
    return currentPetCount < 1; // Free tier: 1 pet limit
  }

  /// Get history days limit based on subscription
  int get historyDaysLimit {
    if (isPremium) return 0; // 0 = unlimited
    return 14; // Free tier: last 14 days
  }
}
