package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/datatypes"
)

// ActivityLog represents a logged activity for a pet
type ActivityLog struct {
	ID           uuid.UUID      `gorm:"type:uuid;primary_key;default:gen_random_uuid()" json:"id"`
	PetID        uuid.UUID      `gorm:"type:uuid;not null;index" json:"pet_id"`
	PetDiseaseID *uuid.UUID     `gorm:"type:uuid;index" json:"pet_disease_id,omitempty"`
	ActivityType string         `gorm:"column:activity_type;not null;size:100;index" json:"activity_type"`
	LoggedAt     time.Time      `gorm:"column:logged_at;not null;index" json:"logged_at"`
	ActivityData datatypes.JSON `gorm:"column:activity_data;type:jsonb;not null;default:'{}'" json:"activity_data"`
	Notes        string         `gorm:"type:text" json:"notes,omitempty"`
	LoggedBy     *uuid.UUID     `gorm:"type:uuid;index" json:"logged_by,omitempty"`
	CreatedAt    time.Time      `gorm:"autoCreateTime" json:"created_at"`
	UpdatedAt    time.Time      `gorm:"autoUpdateTime" json:"updated_at"`

	// Relations
	Pet        Pet             `gorm:"foreignKey:PetID" json:"pet,omitempty"`
	PetDisease *PetDisease     `gorm:"foreignKey:PetDiseaseID" json:"pet_disease,omitempty"`
	Logger     *User           `gorm:"foreignKey:LoggedBy" json:"logger,omitempty"`
	Photos     []ActivityPhoto `gorm:"foreignKey:ActivityLogID" json:"photos,omitempty"`
}

func (ActivityLog) TableName() string {
	return "activity_logs"
}

// ActivityPhoto stores photos attached to activity logs
type ActivityPhoto struct {
	ID            uuid.UUID `gorm:"type:uuid;primary_key;default:gen_random_uuid()" json:"id"`
	ActivityLogID uuid.UUID `gorm:"type:uuid;not null;index" json:"activity_log_id"`
	PhotoURL      string    `gorm:"column:photo_url;type:text;not null" json:"photo_url"`
	ThumbnailURL  string    `gorm:"column:thumbnail_url;type:text" json:"thumbnail_url,omitempty"`
	Caption       string    `gorm:"type:text" json:"caption,omitempty"`
	FileSize      int       `gorm:"column:file_size" json:"file_size,omitempty"`
	CreatedAt     time.Time `gorm:"autoCreateTime" json:"created_at"`

	// Relations
	ActivityLog ActivityLog `gorm:"foreignKey:ActivityLogID" json:"activity_log,omitempty"`
}

func (ActivityPhoto) TableName() string {
	return "activity_photos"
}

// Common activity types
const (
	ActivityTypeWaterIntake  = "water_intake"
	ActivityTypeFoodIntake   = "food_intake"
	ActivityTypeWeight       = "weight"
	ActivityTypeMedication   = "medication"
	ActivityTypeUrination    = "urination"
	ActivityTypeDefecation   = "defecation"
	ActivityTypeVomiting     = "vomiting"
	ActivityTypeExercise     = "exercise"
	ActivityTypeSleep        = "sleep"
	ActivityTypeSymptom      = "symptom"
	ActivityTypeBehavior     = "behavior"
	ActivityTypeVitalSigns   = "vital_signs"
	ActivityTypeBloodGlucose = "blood_glucose"
	ActivityTypeAppetite     = "appetite"
	ActivityTypeMood         = "mood"
)
