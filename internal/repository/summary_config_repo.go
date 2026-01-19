package repository

import (
	"pet-care-backend/internal/models"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type SummaryConfigRepository interface {
	// Sections
	GetSectionsByTemplateID(templateID uuid.UUID) ([]models.SummarySection, error)
	CreateSection(section *models.SummarySection) error
	UpdateSection(section *models.SummarySection) error
	DeleteSection(id uuid.UUID) error

	// Section Items
	CreateSectionItem(item *models.SummarySectionItem) error
	UpdateSectionItem(item *models.SummarySectionItem) error
	DeleteSectionItem(id uuid.UUID) error

	// Charts
	GetChartsByTemplateID(templateID uuid.UUID) ([]models.SummaryChart, error)
	CreateChart(chart *models.SummaryChart) error
	UpdateChart(chart *models.SummaryChart) error
	DeleteChart(id uuid.UUID) error

	// Full Config
	GetConfigByTemplateID(templateID uuid.UUID) (*models.SummaryConfig, error)
}

type summaryConfigRepository struct {
	db *gorm.DB
}

func NewSummaryConfigRepository(db *gorm.DB) SummaryConfigRepository {
	return &summaryConfigRepository{db: db}
}

// Sections
func (r *summaryConfigRepository) GetSectionsByTemplateID(templateID uuid.UUID) ([]models.SummarySection, error) {
	var sections []models.SummarySection
	err := r.db.Where("template_id = ?", templateID).
		Order("display_order ASC").
		Preload("Items", func(db *gorm.DB) *gorm.DB {
			return db.Order("display_order ASC")
		}).
		Find(&sections).Error
	return sections, err
}

func (r *summaryConfigRepository) CreateSection(section *models.SummarySection) error {
	return r.db.Create(section).Error
}

func (r *summaryConfigRepository) UpdateSection(section *models.SummarySection) error {
	return r.db.Save(section).Error
}

func (r *summaryConfigRepository) DeleteSection(id uuid.UUID) error {
	// Delete items first
	if err := r.db.Where("section_id = ?", id).Delete(&models.SummarySectionItem{}).Error; err != nil {
		return err
	}
	return r.db.Delete(&models.SummarySection{}, "id = ?", id).Error
}

// Section Items
func (r *summaryConfigRepository) CreateSectionItem(item *models.SummarySectionItem) error {
	return r.db.Create(item).Error
}

func (r *summaryConfigRepository) UpdateSectionItem(item *models.SummarySectionItem) error {
	return r.db.Save(item).Error
}

func (r *summaryConfigRepository) DeleteSectionItem(id uuid.UUID) error {
	return r.db.Delete(&models.SummarySectionItem{}, "id = ?", id).Error
}

// Charts
func (r *summaryConfigRepository) GetChartsByTemplateID(templateID uuid.UUID) ([]models.SummaryChart, error) {
	var charts []models.SummaryChart
	err := r.db.Where("template_id = ?", templateID).
		Order("display_order ASC").
		Find(&charts).Error
	return charts, err
}

func (r *summaryConfigRepository) CreateChart(chart *models.SummaryChart) error {
	return r.db.Create(chart).Error
}

func (r *summaryConfigRepository) UpdateChart(chart *models.SummaryChart) error {
	return r.db.Save(chart).Error
}

func (r *summaryConfigRepository) DeleteChart(id uuid.UUID) error {
	return r.db.Delete(&models.SummaryChart{}, "id = ?", id).Error
}

// Full Config
func (r *summaryConfigRepository) GetConfigByTemplateID(templateID uuid.UUID) (*models.SummaryConfig, error) {
	sections, err := r.GetSectionsByTemplateID(templateID)
	if err != nil {
		return nil, err
	}

	charts, err := r.GetChartsByTemplateID(templateID)
	if err != nil {
		return nil, err
	}

	return &models.SummaryConfig{
		TemplateID: templateID,
		Sections:   sections,
		Charts:     charts,
	}, nil
}
