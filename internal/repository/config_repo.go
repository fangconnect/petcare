package repository

import (
	"pet-care-backend/internal/models"

	"gorm.io/gorm"
)

type ConfigRepository interface {
	GetAllDiseases() ([]models.Disease, error)
}

type configRepository struct {
	db *gorm.DB
}

// NewConfigRepository creates a new config repository
func NewConfigRepository(db *gorm.DB) ConfigRepository {
	return &configRepository{db: db}
}

// GetAllDiseases retrieves all diseases with their associated templates
func (r *configRepository) GetAllDiseases() ([]models.Disease, error) {
	var diseases []models.Disease

	err := r.db.
		Where("is_active = ?", true).
		Preload("DiseaseTemplates").
		Find(&diseases).Error

	if err != nil {
		return nil, err
	}

	return diseases, nil
}
