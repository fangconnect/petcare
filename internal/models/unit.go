package models

import (
	"time"

	"github.com/google/uuid"
)

// Unit represents a unit of measurement (ml, g, tabs, etc.)
type Unit struct {
	ID        uuid.UUID `gorm:"type:uuid;primary_key;default:gen_random_uuid()" json:"id"`
	Name      string    `gorm:"not null;size:50;uniqueIndex" json:"name"`
	NameEN    string    `gorm:"size:50" json:"name_en,omitempty"`
	Symbol    string    `gorm:"size:20" json:"symbol,omitempty"`
	Category  string    `gorm:"size:50" json:"category,omitempty"` // volume, weight, count, scale, time
	CreatedAt time.Time `gorm:"autoCreateTime" json:"created_at"`
	UpdatedAt time.Time `gorm:"autoUpdateTime" json:"updated_at"`
}

func (Unit) TableName() string {
	return "units"
}

// ActivityTypeUnit is a junction table linking activity types to their allowed units
type ActivityTypeUnit struct {
	ActivityTypeID uuid.UUID `gorm:"type:uuid;primaryKey" json:"activity_type_id"`
	UnitID         uuid.UUID `gorm:"type:uuid;primaryKey" json:"unit_id"`
	IsDefault      bool      `gorm:"default:false" json:"is_default"`
	SortOrder      int       `gorm:"default:0" json:"sort_order"`
	CreatedAt      time.Time `gorm:"autoCreateTime" json:"created_at"`

	// Relations
	ActivityType ActivityType `gorm:"foreignKey:ActivityTypeID" json:"activity_type,omitempty"`
	Unit         Unit         `gorm:"foreignKey:UnitID" json:"unit,omitempty"`
}

func (ActivityTypeUnit) TableName() string {
	return "activity_type_units"
}
