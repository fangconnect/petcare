package repository

import (
	"pet-care-backend/internal/models"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

// TemplateRepository defines template database operations
type TemplateRepository interface {
	GetByDiseaseID(diseaseID uuid.UUID) ([]models.DiseaseTemplate, error)
	GetByID(id uuid.UUID) (*models.DiseaseTemplate, error)
	Create(template *models.DiseaseTemplate) error
	Update(template *models.DiseaseTemplate) error
	Delete(id uuid.UUID) error
	SetDefault(diseaseID, templateID uuid.UUID) error
	SetActivityTypes(templateID uuid.UUID, activityTypes []models.DiseaseTemplateActivityType) error
}

type templateRepository struct {
	db *gorm.DB
}

// NewTemplateRepository creates a new template repository
func NewTemplateRepository(db *gorm.DB) TemplateRepository {
	return &templateRepository{db: db}
}

// GetByDiseaseID retrieves all templates for a disease with activity types
func (r *templateRepository) GetByDiseaseID(diseaseID uuid.UUID) ([]models.DiseaseTemplate, error) {
	var templates []models.DiseaseTemplate
	err := r.db.
		Preload("DiseaseTemplateActivityTypes", func(db *gorm.DB) *gorm.DB {
			return db.Order("sort_order ASC")
		}).
		Preload("DiseaseTemplateActivityTypes.ActivityType").
		Where("disease_id = ?", diseaseID).
		Order("is_default DESC, template_name").
		Find(&templates).Error
	return templates, err
}

// GetByID retrieves a template by ID with activity types
func (r *templateRepository) GetByID(id uuid.UUID) (*models.DiseaseTemplate, error) {
	var template models.DiseaseTemplate
	err := r.db.
		Preload("Disease").
		Preload("DiseaseTemplateActivityTypes", func(db *gorm.DB) *gorm.DB {
			return db.Order("sort_order ASC")
		}).
		Preload("DiseaseTemplateActivityTypes.ActivityType").
		Where("id = ?", id).
		First(&template).Error
	if err != nil {
		return nil, err
	}
	return &template, nil
}

// Create creates a new template
func (r *templateRepository) Create(template *models.DiseaseTemplate) error {
	return r.db.Create(template).Error
}

// Update updates an existing template
func (r *templateRepository) Update(template *models.DiseaseTemplate) error {
	return r.db.Save(template).Error
}

// Delete deletes a template and its activity type associations
func (r *templateRepository) Delete(id uuid.UUID) error {
	return r.db.Transaction(func(tx *gorm.DB) error {
		// Delete activity type associations first
		if err := tx.Where("template_id = ?", id).Delete(&models.DiseaseTemplateActivityType{}).Error; err != nil {
			return err
		}
		// Delete the template
		return tx.Delete(&models.DiseaseTemplate{}, "id = ?", id).Error
	})
}

// SetDefault sets a template as default and unsets others for the same disease
func (r *templateRepository) SetDefault(diseaseID, templateID uuid.UUID) error {
	return r.db.Transaction(func(tx *gorm.DB) error {
		// Unset all defaults for this disease
		if err := tx.Model(&models.DiseaseTemplate{}).
			Where("disease_id = ?", diseaseID).
			Update("is_default", false).Error; err != nil {
			return err
		}
		// Set the specified template as default
		return tx.Model(&models.DiseaseTemplate{}).
			Where("id = ?", templateID).
			Update("is_default", true).Error
	})
}

// SetActivityTypes sets the activity types for a template (replaces all existing)
func (r *templateRepository) SetActivityTypes(templateID uuid.UUID, activityTypes []models.DiseaseTemplateActivityType) error {
	return r.db.Transaction(func(tx *gorm.DB) error {
		// Delete existing associations
		if err := tx.Where("template_id = ?", templateID).Delete(&models.DiseaseTemplateActivityType{}).Error; err != nil {
			return err
		}

		// Create new associations
		for i := range activityTypes {
			activityTypes[i].TemplateID = templateID
			if err := tx.Create(&activityTypes[i]).Error; err != nil {
				return err
			}
		}

		return nil
	})
}
