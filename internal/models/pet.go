package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/datatypes"
)

// Pet represents a pet in the system
type Pet struct {
	ID             uuid.UUID      `gorm:"type:uuid;primary_key;default:gen_random_uuid()" json:"id"`
	OwnerID        uuid.UUID      `gorm:"type:uuid;not null;index" json:"owner_id"`
	Name           string         `gorm:"not null;size:255" json:"name"`
	Species        string         `gorm:"size:100" json:"species,omitempty"`
	Breed          string         `gorm:"size:100" json:"breed,omitempty"`
	BirthDate      *time.Time     `gorm:"column:birth_date;type:date" json:"birth_date,omitempty"`
	CurrentWeight  *float64       `gorm:"column:current_weight;type:decimal(10,2)" json:"current_weight,omitempty"`
	Gender         string         `gorm:"size:20" json:"gender,omitempty"`
	PhotoURL       string         `gorm:"column:photo_url;type:text" json:"photo_url,omitempty"`
	MicrochipID    string         `gorm:"column:microchip_id;size:100" json:"microchip_id,omitempty"`
	MedicalHistory datatypes.JSON `gorm:"column:medical_history;type:jsonb;default:'{}'" json:"medical_history,omitempty"`
	IsActive       bool           `gorm:"column:is_active;default:true" json:"is_active"`
	CreatedAt      time.Time      `gorm:"autoCreateTime" json:"created_at"`
	UpdatedAt      time.Time      `gorm:"autoUpdateTime" json:"updated_at"`

	// Relations
	Owner        User          `gorm:"foreignKey:OwnerID" json:"owner,omitempty"`
	PetDiseases  []PetDisease  `gorm:"foreignKey:PetID" json:"pet_diseases,omitempty"`
	ActivityLogs []ActivityLog `gorm:"foreignKey:PetID" json:"activity_logs,omitempty"`
	Reminders    []Reminder    `gorm:"foreignKey:PetID" json:"reminders,omitempty"`
}

func (Pet) TableName() string {
	return "pets"
}

// GetAge returns pet's age in years and months
func (p *Pet) GetAge() (years int, months int) {
	if p.BirthDate == nil {
		return 0, 0
	}
	now := time.Now()
	years = now.Year() - p.BirthDate.Year()
	months = int(now.Month() - p.BirthDate.Month())
	if months < 0 {
		years--
		months += 12
	}
	return years, months
}

// GetActiveDiseases returns only active diagnosed diseases
func (p *Pet) GetActiveDiseases() []PetDisease {
	var active []PetDisease
	for _, pd := range p.PetDiseases {
		if pd.IsActive {
			active = append(active, pd)
		}
	}
	return active
}
