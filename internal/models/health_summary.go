package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/datatypes"
)

// HealthSummary represents a generated health report for a pet
type HealthSummary struct {
	ID              uuid.UUID      `gorm:"type:uuid;primary_key;default:gen_random_uuid()" json:"id"`
	PetID           uuid.UUID      `gorm:"type:uuid;not null;index" json:"pet_id"`
	SummaryDate     time.Time      `gorm:"column:summary_date;type:date;not null;index" json:"summary_date"`
	PeriodStart     time.Time      `gorm:"column:period_start;type:date;not null" json:"period_start"`
	PeriodEnd       time.Time      `gorm:"column:period_end;type:date;not null" json:"period_end"`
	Metrics         datatypes.JSON `gorm:"type:jsonb;not null;default:'{}'" json:"metrics"`
	HealthScore     *float64       `gorm:"column:health_score;type:decimal(5,2)" json:"health_score,omitempty"`
	ScoreBreakdown  datatypes.JSON `gorm:"column:score_breakdown;type:jsonb;default:'{}'" json:"score_breakdown,omitempty"`
	Assessment      string         `gorm:"type:text" json:"assessment,omitempty"`
	Recommendations datatypes.JSON `gorm:"type:jsonb;default:'[]'" json:"recommendations,omitempty"`
	GeneratedAt     time.Time      `gorm:"column:generated_at;autoCreateTime" json:"generated_at"`
	GeneratedBy     *uuid.UUID     `gorm:"type:uuid" json:"generated_by,omitempty"`

	// Relations
	Pet  Pet   `gorm:"foreignKey:PetID" json:"pet,omitempty"`
	User *User `gorm:"foreignKey:GeneratedBy" json:"user,omitempty"`
}

func (HealthSummary) TableName() string {
	return "health_summaries"
}

// CalculationRule defines formulas for health score calculations
type CalculationRule struct {
	ID         uuid.UUID      `gorm:"type:uuid;primary_key;default:gen_random_uuid()" json:"id"`
	RuleName   string         `gorm:"column:rule_name;not null;size:255" json:"rule_name"`
	RuleType   string         `gorm:"column:rule_type;not null;size:100;index" json:"rule_type"`
	Conditions datatypes.JSON `gorm:"type:jsonb;default:'{}'" json:"conditions,omitempty"`
	Formula    string         `gorm:"type:text" json:"formula,omitempty"`
	Parameters datatypes.JSON `gorm:"type:jsonb;default:'{}'" json:"parameters,omitempty"`
	IsActive   bool           `gorm:"column:is_active;default:true" json:"is_active"`
	CreatedAt  time.Time      `gorm:"autoCreateTime" json:"created_at"`
}

func (CalculationRule) TableName() string {
	return "calculation_rules"
}

// SpeciesStandard defines normal ranges for health metrics by species/breed
type SpeciesStandard struct {
	ID           uuid.UUID      `gorm:"type:uuid;primary_key;default:gen_random_uuid()" json:"id"`
	Species      string         `gorm:"not null;size:100;index" json:"species"`
	Breed        string         `gorm:"size:100" json:"breed,omitempty"`
	NormalRanges datatypes.JSON `gorm:"column:normal_ranges;type:jsonb;not null;default:'{}'" json:"normal_ranges"`
	CreatedAt    time.Time      `gorm:"autoCreateTime" json:"created_at"`
}

func (SpeciesStandard) TableName() string {
	return "species_standards"
}
