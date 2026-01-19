package repository

import (
	"pet-care-backend/internal/models"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

// SpeciesStandardRepository defines species standard database operations
type SpeciesStandardRepository interface {
	Create(standard *models.SpeciesStandard) error
	GetAll() ([]models.SpeciesStandard, error)
	GetByID(id uuid.UUID) (*models.SpeciesStandard, error)
	GetBySpecies(species string) (*models.SpeciesStandard, error)
	GetBySpeciesAndBreed(species, breed string) (*models.SpeciesStandard, error)
	Update(standard *models.SpeciesStandard) error
	Delete(id uuid.UUID) error
}

type speciesStandardRepository struct {
	db *gorm.DB
}

// NewSpeciesStandardRepository creates a new species standard repository
func NewSpeciesStandardRepository(db *gorm.DB) SpeciesStandardRepository {
	return &speciesStandardRepository{db: db}
}

// Create creates a new species standard
func (r *speciesStandardRepository) Create(standard *models.SpeciesStandard) error {
	return r.db.Create(standard).Error
}

// GetAll retrieves all species standards
func (r *speciesStandardRepository) GetAll() ([]models.SpeciesStandard, error) {
	var standards []models.SpeciesStandard
	err := r.db.Order("species ASC, breed ASC").Find(&standards).Error
	return standards, err
}

// GetByID retrieves a species standard by ID
func (r *speciesStandardRepository) GetByID(id uuid.UUID) (*models.SpeciesStandard, error) {
	var standard models.SpeciesStandard
	err := r.db.Where("id = ?", id).First(&standard).Error
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return nil, nil
		}
		return nil, err
	}
	return &standard, nil
}

// GetBySpecies retrieves a species standard by species name
func (r *speciesStandardRepository) GetBySpecies(species string) (*models.SpeciesStandard, error) {
	var standard models.SpeciesStandard
	err := r.db.Where("species = ? AND (breed = '' OR breed IS NULL)", species).First(&standard).Error
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return nil, nil
		}
		return nil, err
	}
	return &standard, nil
}

// GetBySpeciesAndBreed retrieves a species standard by species and breed
func (r *speciesStandardRepository) GetBySpeciesAndBreed(species, breed string) (*models.SpeciesStandard, error) {
	var standard models.SpeciesStandard
	err := r.db.Where("species = ? AND breed = ?", species, breed).First(&standard).Error
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return nil, nil
		}
		return nil, err
	}
	return &standard, nil
}

// Update updates a species standard
func (r *speciesStandardRepository) Update(standard *models.SpeciesStandard) error {
	return r.db.Save(standard).Error
}

// Delete deletes a species standard
func (r *speciesStandardRepository) Delete(id uuid.UUID) error {
	return r.db.Delete(&models.SpeciesStandard{}, id).Error
}
