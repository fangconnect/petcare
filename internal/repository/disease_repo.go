package repository

import (
	"pet-care-backend/internal/models"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

// DiseaseRepository defines disease database operations
type DiseaseRepository interface {
	GetAll() ([]models.Disease, error)
	GetByID(id uuid.UUID) (*models.Disease, error)
	Create(disease *models.Disease) error
	Update(disease *models.Disease) error
	Delete(id uuid.UUID) error
	GetWithTemplates(id uuid.UUID) (*models.Disease, error)
}

type diseaseRepository struct {
	db *gorm.DB
}

// NewDiseaseRepository creates a new disease repository
func NewDiseaseRepository(db *gorm.DB) DiseaseRepository {
	return &diseaseRepository{db: db}
}

// GetAll retrieves all diseases
func (r *diseaseRepository) GetAll() ([]models.Disease, error) {
	var diseases []models.Disease
	err := r.db.Where("is_active = ?", true).Order("name").Find(&diseases).Error
	return diseases, err
}

// GetByID retrieves a disease by ID
func (r *diseaseRepository) GetByID(id uuid.UUID) (*models.Disease, error) {
	var disease models.Disease
	err := r.db.Where("id = ?", id).First(&disease).Error
	if err != nil {
		return nil, err
	}
	return &disease, nil
}

// Create creates a new disease
func (r *diseaseRepository) Create(disease *models.Disease) error {
	return r.db.Create(disease).Error
}

// Update updates an existing disease
func (r *diseaseRepository) Update(disease *models.Disease) error {
	return r.db.Save(disease).Error
}

// Delete soft deletes a disease by setting is_active to false
func (r *diseaseRepository) Delete(id uuid.UUID) error {
	return r.db.Model(&models.Disease{}).Where("id = ?", id).Update("is_active", false).Error
}

// GetWithTemplates retrieves a disease with its templates
func (r *diseaseRepository) GetWithTemplates(id uuid.UUID) (*models.Disease, error) {
	var disease models.Disease
	err := r.db.Preload("DiseaseTemplates").Where("id = ?", id).First(&disease).Error
	if err != nil {
		return nil, err
	}
	return &disease, nil
}
