package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/datatypes"
)

// Disease represents a medical condition that can be diagnosed
type Disease struct {
	ID                    uuid.UUID      `gorm:"type:uuid;primary_key;default:gen_random_uuid()" json:"id"`
	Name                  string         `gorm:"not null;size:255" json:"name"`
	NameEN                string         `gorm:"column:name_en;size:255" json:"name_en,omitempty"`
	Category              string         `gorm:"size:100" json:"category,omitempty"`
	Description           string         `gorm:"type:text" json:"description,omitempty"`
	Symptoms              datatypes.JSON `gorm:"type:jsonb;default:'[]'" json:"symptoms,omitempty"`
	RecommendedMonitoring datatypes.JSON `gorm:"column:recommended_monitoring;type:jsonb;default:'{}'" json:"recommended_monitoring,omitempty"`
	IsActive              bool           `gorm:"column:is_active;default:true" json:"is_active"`
	CreatedAt             time.Time      `gorm:"autoCreateTime" json:"created_at"`
	UpdatedAt             time.Time      `gorm:"autoUpdateTime" json:"updated_at"`

	// Relations
	PetDiseases      []PetDisease      `gorm:"foreignKey:DiseaseID" json:"pet_diseases,omitempty"`
	DiseaseTemplates []DiseaseTemplate `gorm:"foreignKey:DiseaseID" json:"disease_templates,omitempty"`
}

func (Disease) TableName() string {
	return "diseases"
}

// DiseaseTemplate defines which activity types to track for a disease
type DiseaseTemplate struct {
	ID           uuid.UUID `gorm:"type:uuid;primary_key;default:gen_random_uuid()" json:"id"`
	DiseaseID    uuid.UUID `gorm:"type:uuid;not null;index" json:"disease_id"`
	TemplateName string    `gorm:"column:template_name;not null;size:255" json:"template_name"`
	Description  string    `gorm:"type:text" json:"description,omitempty"`
	Version      int       `gorm:"default:1" json:"version"`
	IsDefault    bool      `gorm:"column:is_default;default:false" json:"is_default"`
	CreatedAt    time.Time `gorm:"autoCreateTime" json:"created_at"`
	UpdatedAt    time.Time `gorm:"autoUpdateTime" json:"updated_at"`

	// Relations
	Disease                      Disease                       `gorm:"foreignKey:DiseaseID" json:"disease,omitempty"`
	DiseaseTemplateActivityTypes []DiseaseTemplateActivityType `gorm:"foreignKey:TemplateID" json:"activity_types,omitempty"`
}

func (DiseaseTemplate) TableName() string {
	return "disease_templates"
}

// DiseaseTemplateActivityType links templates to activity types
type DiseaseTemplateActivityType struct {
	TemplateID     uuid.UUID `gorm:"type:uuid;primaryKey" json:"template_id"`
	ActivityTypeID uuid.UUID `gorm:"type:uuid;primaryKey" json:"activity_type_id"`
	IsRequired     bool      `gorm:"default:false" json:"is_required"`
	SortOrder      int       `gorm:"default:0" json:"sort_order"`
	CreatedAt      time.Time `gorm:"autoCreateTime" json:"created_at"`

	// Relations
	Template     DiseaseTemplate `gorm:"foreignKey:TemplateID" json:"template,omitempty"`
	ActivityType ActivityType    `gorm:"foreignKey:ActivityTypeID" json:"activity_type,omitempty"`
}

func (DiseaseTemplateActivityType) TableName() string {
	return "disease_template_activity_types"
}
