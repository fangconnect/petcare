package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/datatypes"
)

// UserPreference holds user-specific settings
type UserPreference struct {
	ID                   uuid.UUID      `gorm:"type:uuid;primary_key;default:gen_random_uuid()" json:"id"`
	UserID               uuid.UUID      `gorm:"type:uuid;not null;uniqueIndex" json:"user_id"`
	NotificationSettings datatypes.JSON `gorm:"type:jsonb;default:'{}'" json:"notification_settings"`
	DisplayPreferences   datatypes.JSON `gorm:"type:jsonb;default:'{}'" json:"display_preferences"`
	Language             string         `gorm:"size:10;default:'th'" json:"language"`
	Timezone             string         `gorm:"size:50;default:'Asia/Bangkok'" json:"timezone"`
	CreatedAt            time.Time      `gorm:"autoCreateTime" json:"created_at"`
	UpdatedAt            time.Time      `gorm:"autoUpdateTime" json:"updated_at"`

	// Relations
	User User `gorm:"foreignKey:UserID" json:"user,omitempty"`
}

func (UserPreference) TableName() string {
	return "user_preferences"
}

// PaymentTransaction records subscription payments
type PaymentTransaction struct {
	ID            uuid.UUID `gorm:"type:uuid;primary_key;default:gen_random_uuid()" json:"id"`
	UserID        uuid.UUID `gorm:"type:uuid;not null;index" json:"user_id"`
	Provider      string    `gorm:"size:50;not null" json:"provider"` // apple, google, stripe
	TransactionID string    `gorm:"column:transaction_id;size:255;not null" json:"transaction_id"`
	Amount        float64   `gorm:"type:decimal(10,2);not null" json:"amount"`
	Currency      string    `gorm:"size:10;default:'THB'" json:"currency"`
	Status        string    `gorm:"size:50;default:'pending'" json:"status"` // success, pending, failed
	CreatedAt     time.Time `gorm:"autoCreateTime" json:"created_at"`

	// Relations
	User User `gorm:"foreignKey:UserID" json:"user,omitempty"`
}

func (PaymentTransaction) TableName() string {
	return "payment_transactions"
}
