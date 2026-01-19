package repository

import (
	"pet-care-backend/internal/models"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

// TrackingConfigRepository defines tracking config database operations
type TrackingConfigRepository interface {
	GetByPetDiseaseID(petDiseaseID uuid.UUID) (*models.DiseaseTrackingConfig, error)
	Upsert(config *models.DiseaseTrackingConfig) error
	GetPetActiveDisease(petID uuid.UUID) (*models.PetDisease, error)
	GetTemplateActivityTypes(templateID uuid.UUID) ([]models.ActivityType, error)
}

type trackingConfigRepository struct {
	db *gorm.DB
}

// NewTrackingConfigRepository creates a new tracking config repository
func NewTrackingConfigRepository(db *gorm.DB) TrackingConfigRepository {
	return &trackingConfigRepository{db: db}
}

// GetByPetDiseaseID retrieves tracking config by pet disease ID
func (r *trackingConfigRepository) GetByPetDiseaseID(petDiseaseID uuid.UUID) (*models.DiseaseTrackingConfig, error) {
	var config models.DiseaseTrackingConfig
	err := r.db.
		Preload("Template").
		Preload("Template.DiseaseTemplateActivityTypes", func(db *gorm.DB) *gorm.DB {
			return db.Order("sort_order ASC")
		}).
		Preload("Template.DiseaseTemplateActivityTypes.ActivityType").
		Preload("Template.DiseaseTemplateActivityTypes.ActivityType.ActivityTypeUnits", func(db *gorm.DB) *gorm.DB {
			return db.Order("sort_order ASC")
		}).
		Preload("Template.DiseaseTemplateActivityTypes.ActivityType.ActivityTypeUnits.Unit").
		Where("pet_disease_id = ?", petDiseaseID).
		First(&config).Error
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return nil, nil
		}
		return nil, err
	}
	return &config, nil
}

// Upsert creates or updates a tracking config
func (r *trackingConfigRepository) Upsert(config *models.DiseaseTrackingConfig) error {
	// Check if exists
	var existing models.DiseaseTrackingConfig
	err := r.db.Where("pet_disease_id = ?", config.PetDiseaseID).First(&existing).Error
	if err == gorm.ErrRecordNotFound {
		// Create new
		return r.db.Create(config).Error
	}
	if err != nil {
		return err
	}
	// Update existing
	existing.TemplateID = config.TemplateID
	existing.CustomFields = config.CustomFields
	existing.TrackingSchedule = config.TrackingSchedule
	existing.IsActive = config.IsActive
	return r.db.Save(&existing).Error
}

// GetPetActiveDisease gets the first active disease for a pet
func (r *trackingConfigRepository) GetPetActiveDisease(petID uuid.UUID) (*models.PetDisease, error) {
	var petDisease models.PetDisease
	err := r.db.
		Preload("Disease").
		Preload("TrackingConfig").
		Preload("TrackingConfig.Template").
		Where("pet_id = ? AND is_active = ?", petID, true).
		Order("created_at DESC").
		First(&petDisease).Error
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return nil, nil
		}
		return nil, err
	}
	return &petDisease, nil
}

// GetTemplateActivityTypes retrieves all activity types for a template
func (r *trackingConfigRepository) GetTemplateActivityTypes(templateID uuid.UUID) ([]models.ActivityType, error) {
	var templateActivityTypes []models.DiseaseTemplateActivityType
	err := r.db.
		Preload("ActivityType").
		Preload("ActivityType.ActivityTypeUnits", func(db *gorm.DB) *gorm.DB {
			return db.Order("sort_order ASC")
		}).
		Preload("ActivityType.ActivityTypeUnits.Unit").
		Where("template_id = ?", templateID).
		Order("sort_order ASC").
		Find(&templateActivityTypes).Error
	if err != nil {
		return nil, err
	}

	// Extract activity types
	activityTypes := make([]models.ActivityType, len(templateActivityTypes))
	for i, tat := range templateActivityTypes {
		activityTypes[i] = tat.ActivityType
	}
	return activityTypes, nil
}
