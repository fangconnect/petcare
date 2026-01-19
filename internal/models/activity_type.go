package models

import (
	"time"

	"github.com/google/uuid"
)

// InputType represents the type of input for an activity
type InputType string

const (
	InputTypeNumber     InputType = "number"
	InputTypeText       InputType = "text"
	InputTypeCheckbox   InputType = "checkbox"
	InputTypeSelect     InputType = "select"
	InputTypePhoto      InputType = "photo"
	InputTypeRange      InputType = "range"
	InputTypeMedication InputType = "medication"
)

// ActivityCategory represents the category of an activity
type ActivityCategory string

const (
	CategoryVital     ActivityCategory = "vital"
	CategoryIntake    ActivityCategory = "intake"
	CategoryExcretion ActivityCategory = "excretion"
	CategoryBehavior  ActivityCategory = "behavior"
	CategoryMedical   ActivityCategory = "medical"
	CategoryOther     ActivityCategory = "other"
)

// ActivityType represents a configurable activity type in the system
type ActivityType struct {
	ID        uuid.UUID        `gorm:"type:uuid;primary_key;default:gen_random_uuid()" json:"id"`
	Name      string           `gorm:"not null;size:100" json:"name"`
	NameEN    string           `gorm:"column:name_en;size:100" json:"name_en,omitempty"`
	InputType InputType        `gorm:"size:50;not null;default:'number'" json:"input_type"`
	Category  ActivityCategory `gorm:"size:50;not null;default:'other'" json:"category"`
	Icon      string           `gorm:"size:50" json:"icon,omitempty"`
	IsActive  bool             `gorm:"not null;default:true" json:"is_active"`
	SortOrder int              `gorm:"default:0" json:"sort_order"`
	CreatedAt time.Time        `gorm:"autoCreateTime" json:"created_at"`
	UpdatedAt time.Time        `gorm:"autoUpdateTime" json:"updated_at"`

	// Relations - Units available for this activity type
	ActivityTypeUnits []ActivityTypeUnit `gorm:"foreignKey:ActivityTypeID" json:"activity_type_units,omitempty"`
}

// TableName returns the table name for ActivityType
func (ActivityType) TableName() string {
	return "activity_types"
}

// ActivityTypeRequest represents the request body for creating/updating an activity type
type ActivityTypeRequest struct {
	Name      string   `json:"name" validate:"required"`
	NameEN    string   `json:"name_en,omitempty"`
	InputType string   `json:"input_type,omitempty"`
	Category  string   `json:"category,omitempty"`
	Icon      string   `json:"icon,omitempty"`
	IsActive  *bool    `json:"is_active,omitempty"`
	SortOrder *int     `json:"sort_order,omitempty"`
	UnitIDs   []string `json:"unit_ids,omitempty"` // Unit IDs to link
}

// ActivityTypeResponse includes units for API response
type ActivityTypeResponse struct {
	ID        uuid.UUID `json:"id"`
	Name      string    `json:"name"`
	NameEN    string    `json:"name_en,omitempty"`
	InputType string    `json:"input_type"`
	Category  string    `json:"category"`
	Icon      string    `json:"icon,omitempty"`
	IsActive  bool      `json:"is_active"`
	SortOrder int       `json:"sort_order"`
	Units     []Unit    `json:"units,omitempty"`
}
