package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/datatypes"
)

// Reminder represents a scheduled reminder for pet care
type Reminder struct {
	ID              uuid.UUID      `gorm:"type:uuid;primary_key;default:gen_random_uuid()" json:"id"`
	PetID           uuid.UUID      `gorm:"type:uuid;not null;index" json:"pet_id"`
	PetDiseaseID    *uuid.UUID     `gorm:"type:uuid;index" json:"pet_disease_id,omitempty"`
	ReminderType    string         `gorm:"column:reminder_type;not null;size:100" json:"reminder_type"`
	Title           string         `gorm:"not null;size:255" json:"title"`
	Description     string         `gorm:"type:text" json:"description,omitempty"`
	ScheduledTime   string         `gorm:"column:scheduled_time;type:time;not null" json:"scheduled_time"`
	Frequency       string         `gorm:"not null;size:50;default:'daily'" json:"frequency"` // daily, weekly, monthly, custom
	FrequencyConfig datatypes.JSON `gorm:"column:frequency_config;type:jsonb;default:'{}'" json:"frequency_config,omitempty"`
	IsActive        bool           `gorm:"column:is_active;default:true" json:"is_active"`
	StartDate       time.Time      `gorm:"column:start_date;type:date;not null" json:"start_date"`
	EndDate         *time.Time     `gorm:"column:end_date;type:date" json:"end_date,omitempty"`
	CreatedAt       time.Time      `gorm:"autoCreateTime" json:"created_at"`
	UpdatedAt       time.Time      `gorm:"autoUpdateTime" json:"updated_at"`

	// Relations
	Pet        Pet           `gorm:"foreignKey:PetID" json:"pet,omitempty"`
	PetDisease *PetDisease   `gorm:"foreignKey:PetDiseaseID" json:"pet_disease,omitempty"`
	Logs       []ReminderLog `gorm:"foreignKey:ReminderID" json:"logs,omitempty"`
}

func (Reminder) TableName() string {
	return "reminders"
}

// ReminderLog tracks reminder completion
type ReminderLog struct {
	ID           uuid.UUID  `gorm:"type:uuid;primary_key;default:gen_random_uuid()" json:"id"`
	ReminderID   uuid.UUID  `gorm:"type:uuid;not null;index" json:"reminder_id"`
	ScheduledFor time.Time  `gorm:"column:scheduled_for;not null" json:"scheduled_for"`
	CompletedAt  *time.Time `gorm:"column:completed_at" json:"completed_at,omitempty"`
	Status       string     `gorm:"size:50;default:'pending'" json:"status"` // pending, completed, skipped, missed
	CompletedBy  *uuid.UUID `gorm:"type:uuid" json:"completed_by,omitempty"`
	Notes        string     `gorm:"type:text" json:"notes,omitempty"`
	CreatedAt    time.Time  `gorm:"autoCreateTime" json:"created_at"`

	// Relations
	Reminder Reminder `gorm:"foreignKey:ReminderID" json:"reminder,omitempty"`
	User     *User    `gorm:"foreignKey:CompletedBy" json:"user,omitempty"`
}

func (ReminderLog) TableName() string {
	return "reminder_logs"
}

// Reminder frequencies
const (
	FrequencyDaily   = "daily"
	FrequencyWeekly  = "weekly"
	FrequencyMonthly = "monthly"
	FrequencyCustom  = "custom"
)

// Reminder types
const (
	ReminderTypeMedication = "medication"
	ReminderTypeFeeding    = "feeding"
	ReminderTypeExercise   = "exercise"
	ReminderTypeVetVisit   = "vet_visit"
	ReminderTypeGrooming   = "grooming"
	ReminderTypeTracking   = "tracking"
)
