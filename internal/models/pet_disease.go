package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/datatypes"
)

// PetDisease tracks a diagnosed disease for a specific pet
type PetDisease struct {
	ID            uuid.UUID  `gorm:"type:uuid;primary_key;default:gen_random_uuid()" json:"id"`
	PetID         uuid.UUID  `gorm:"type:uuid;not null;index" json:"pet_id"`
	DiseaseID     uuid.UUID  `gorm:"type:uuid;not null;index" json:"disease_id"`
	DiagnosedDate *time.Time `gorm:"column:diagnosed_date;type:date" json:"diagnosed_date,omitempty"`
	Severity      string     `gorm:"size:50" json:"severity,omitempty"` // mild, moderate, severe
	Notes         string     `gorm:"type:text" json:"notes,omitempty"`
	IsActive      bool       `gorm:"column:is_active;default:true" json:"is_active"`
	RecoveryDate  *time.Time `gorm:"column:recovery_date;type:date" json:"recovery_date,omitempty"`
	CreatedAt     time.Time  `gorm:"autoCreateTime" json:"created_at"`
	UpdatedAt     time.Time  `gorm:"autoUpdateTime" json:"updated_at"`

	// Relations
	Pet            Pet                    `gorm:"foreignKey:PetID" json:"pet,omitempty"`
	Disease        Disease                `gorm:"foreignKey:DiseaseID" json:"disease,omitempty"`
	ActivityLogs   []ActivityLog          `gorm:"foreignKey:PetDiseaseID" json:"activity_logs,omitempty"`
	TrackingConfig *DiseaseTrackingConfig `gorm:"foreignKey:PetDiseaseID" json:"tracking_config,omitempty"`
}

func (PetDisease) TableName() string {
	return "pet_diseases"
}

// DiseaseTrackingConfig holds custom tracking configuration for a pet's disease
type DiseaseTrackingConfig struct {
	ID               uuid.UUID      `gorm:"type:uuid;primary_key;default:gen_random_uuid()" json:"id"`
	PetDiseaseID     uuid.UUID      `gorm:"type:uuid;not null;uniqueIndex" json:"pet_disease_id"`
	TemplateID       *uuid.UUID     `gorm:"type:uuid;index" json:"template_id,omitempty"`
	CustomFields     datatypes.JSON `gorm:"column:custom_fields;type:jsonb;default:'{}'" json:"custom_fields,omitempty"`
	TrackingSchedule datatypes.JSON `gorm:"column:tracking_schedule;type:jsonb;default:'{}'" json:"tracking_schedule,omitempty"`
	IsActive         bool           `gorm:"column:is_active;default:true" json:"is_active"`
	CreatedAt        time.Time      `gorm:"autoCreateTime" json:"created_at"`
	UpdatedAt        time.Time      `gorm:"autoUpdateTime" json:"updated_at"`

	// Relations
	PetDisease PetDisease       `gorm:"foreignKey:PetDiseaseID" json:"pet_disease,omitempty"`
	Template   *DiseaseTemplate `gorm:"foreignKey:TemplateID" json:"template,omitempty"`
}

func (DiseaseTrackingConfig) TableName() string {
	return "disease_tracking_config"
}
