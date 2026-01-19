package models

import (
	"time"

	"github.com/google/uuid"
)

// SubscriptionTier represents the user's subscription level
type SubscriptionTier string

const (
	SubscriptionFree    SubscriptionTier = "free"
	SubscriptionPremium SubscriptionTier = "premium"
)

// UserRole represents the user's role in the system
type UserRole string

const (
	RoleUser        UserRole = "user"
	RoleAdmin       UserRole = "admin"
	RoleClinicStaff UserRole = "clinic_staff"
)

// User represents a user in the system
type User struct {
	ID                    uuid.UUID        `gorm:"type:uuid;primary_key;default:gen_random_uuid()" json:"id"`
	Email                 string           `gorm:"uniqueIndex;not null;size:255" json:"email"`
	PasswordHash          string           `gorm:"column:password_hash;not null;size:255" json:"-"`
	FullName              string           `gorm:"size:255" json:"full_name,omitempty"`
	Phone                 string           `gorm:"size:50" json:"phone,omitempty"`
	AvatarURL             string           `gorm:"column:avatar_url;type:text" json:"avatar_url,omitempty"`
	IsActive              bool             `gorm:"default:true" json:"is_active"`
	Role                  UserRole         `gorm:"type:user_role;default:'user'" json:"role"`
	SubscriptionTier      SubscriptionTier `gorm:"type:subscription_tier;default:'free'" json:"subscription_tier"`
	SubscriptionExpiresAt *time.Time       `gorm:"column:subscription_expires_at" json:"subscription_expires_at,omitempty"`
	IsTrialUsed           bool             `gorm:"column:is_trial_used;default:false" json:"is_trial_used"`
	CreatedAt             time.Time        `gorm:"autoCreateTime" json:"created_at"`
	UpdatedAt             time.Time        `gorm:"autoUpdateTime" json:"updated_at"`

	// Relations
	Pets         []Pet                `gorm:"foreignKey:OwnerID" json:"pets,omitempty"`
	Preferences  *UserPreference      `gorm:"foreignKey:UserID" json:"preferences,omitempty"`
	Transactions []PaymentTransaction `gorm:"foreignKey:UserID" json:"transactions,omitempty"`
}

func (User) TableName() string {
	return "users"
}

// IsPremium checks if user has active premium subscription
func (u *User) IsPremium() bool {
	if u.SubscriptionTier != SubscriptionPremium {
		return false
	}
	if u.SubscriptionExpiresAt == nil {
		return false
	}
	return u.SubscriptionExpiresAt.After(time.Now())
}

// CanAddPet checks if user can add more pets based on subscription
func (u *User) CanAddPet(currentPetCount int) bool {
	if u.IsPremium() {
		return true // Unlimited pets for premium
	}
	return currentPetCount < 1 // Free tier: 1 pet limit
}

// GetHistoryDaysLimit returns the number of days of history user can view
func (u *User) GetHistoryDaysLimit() int {
	if u.IsPremium() {
		return 0 // 0 = unlimited
	}
	return 14 // Free tier: last 14 days only
}
