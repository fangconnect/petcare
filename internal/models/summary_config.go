package models

import (
	"database/sql/driver"
	"encoding/json"
	"time"

	"github.com/google/uuid"
)

// StringSlice is a custom type for PostgreSQL jsonb array
type StringSlice []string

// Scan implements the sql.Scanner interface
func (s *StringSlice) Scan(value interface{}) error {
	if value == nil {
		*s = nil
		return nil
	}
	bytes, ok := value.([]byte)
	if ok {
		return json.Unmarshal(bytes, s)
	}
	str, ok := value.(string)
	if ok {
		return json.Unmarshal([]byte(str), s)
	}
	return nil
}

// Value implements the driver.Valuer interface
func (s StringSlice) Value() (driver.Value, error) {
	if s == nil {
		return nil, nil
	}
	return json.Marshal(s)
}

// SummarySection represents a customizable section in the Health Summary
type SummarySection struct {
	ID           uuid.UUID `json:"id" gorm:"primaryKey;type:uuid;default:gen_random_uuid()"`
	TemplateID   uuid.UUID `json:"template_id" gorm:"type:uuid;not null"`
	Name         string    `json:"name" gorm:"not null"` // English name
	NameTH       string    `json:"name_th"`              // Thai name
	Icon         string    `json:"icon"`                 // Material icon name
	Color        string    `json:"color"`                // Hex color code
	DisplayOrder int       `json:"display_order" gorm:"default:0"`
	IsVisible    bool      `json:"is_visible" gorm:"default:true"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`

	// Relations
	Template DiseaseTemplate      `json:"template,omitempty" gorm:"foreignKey:TemplateID"`
	Items    []SummarySectionItem `json:"items,omitempty" gorm:"foreignKey:SectionID"`
}

// SummarySectionItem represents an item within a summary section
type SummarySectionItem struct {
	ID            uuid.UUID   `json:"id" gorm:"primaryKey;type:uuid;default:gen_random_uuid()"`
	SectionID     uuid.UUID   `json:"section_id" gorm:"type:uuid;not null"`
	Label         string      `json:"label" gorm:"not null"`              // Display label
	LabelTH       string      `json:"label_th"`                           // Thai label
	ActivityTypes StringSlice `json:"activity_types" gorm:"type:jsonb"`   // Activity types to aggregate
	Formula       string      `json:"formula" gorm:"default:'SUM'"`       // AVG, SUM, COUNT, LATEST, MIN, MAX, TREND
	Unit          string      `json:"unit"`                               // Display unit (ml, g, kg, etc.)
	GroupByUnit   bool        `json:"group_by_unit" gorm:"default:false"` // Group results by unit
	DisplayOrder  int         `json:"display_order" gorm:"default:0"`
	IsVisible     bool        `json:"is_visible" gorm:"default:true"`
	CreatedAt     time.Time   `json:"created_at"`
	UpdatedAt     time.Time   `json:"updated_at"`

	// Relations
	Section SummarySection `json:"-" gorm:"foreignKey:SectionID"`
}

// Formula types
const (
	FormulaAVG    = "AVG"    // Average per day
	FormulaSUM    = "SUM"    // Total sum
	FormulaCOUNT  = "COUNT"  // Count of entries
	FormulaLATEST = "LATEST" // Latest value
	FormulaMIN    = "MIN"    // Minimum value
	FormulaMAX    = "MAX"    // Maximum value
	FormulaTREND  = "TREND"  // Change from first to last
)

// SummaryChart represents a chart configuration for Health Summary
type SummaryChart struct {
	ID            uuid.UUID   `json:"id" gorm:"primaryKey;type:uuid;default:gen_random_uuid()"`
	TemplateID    uuid.UUID   `json:"template_id" gorm:"type:uuid;not null"`
	Title         string      `json:"title" gorm:"not null"`
	TitleTH       string      `json:"title_th"`
	ChartType     string      `json:"chart_type" gorm:"default:'bar'"`  // bar, line, area
	ActivityTypes StringSlice `json:"activity_types" gorm:"type:jsonb"` // Activity types to include
	XAxis         string      `json:"x_axis" gorm:"default:'date'"`     // X-axis type: date
	YAxis         string      `json:"y_axis" gorm:"default:'value'"`    // Y-axis type: value, count
	GroupBy       string      `json:"group_by"`                         // Optional grouping
	DisplayOrder  int         `json:"display_order" gorm:"default:0"`
	IsVisible     bool        `json:"is_visible" gorm:"default:true"`
	CreatedAt     time.Time   `json:"created_at"`
	UpdatedAt     time.Time   `json:"updated_at"`

	// Relations
	Template DiseaseTemplate `json:"template,omitempty" gorm:"foreignKey:TemplateID"`
}

// Chart types
const (
	ChartTypeBar  = "bar"
	ChartTypeLine = "line"
	ChartTypeArea = "area"
)

// SummaryConfig holds the complete summary configuration for a template
type SummaryConfig struct {
	TemplateID uuid.UUID        `json:"template_id"`
	Sections   []SummarySection `json:"sections"`
	Charts     []SummaryChart   `json:"charts"`
}
