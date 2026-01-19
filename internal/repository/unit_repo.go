package repository

import (
	"pet-care-backend/internal/models"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

// UnitRepository defines unit database operations
type UnitRepository interface {
	Create(unit *models.Unit) error
	GetAll() ([]models.Unit, error)
	GetByID(id uuid.UUID) (*models.Unit, error)
	GetByName(name string) (*models.Unit, error)
	GetByCategory(category string) ([]models.Unit, error)
	Update(unit *models.Unit) error
	Delete(id uuid.UUID) error
}

type unitRepository struct {
	db *gorm.DB
}

// NewUnitRepository creates a new unit repository
func NewUnitRepository(db *gorm.DB) UnitRepository {
	return &unitRepository{db: db}
}

// Create creates a new unit
func (r *unitRepository) Create(unit *models.Unit) error {
	return r.db.Create(unit).Error
}

// GetAll retrieves all units
func (r *unitRepository) GetAll() ([]models.Unit, error) {
	var units []models.Unit
	err := r.db.Order("category ASC, name ASC").Find(&units).Error
	return units, err
}

// GetByID retrieves a unit by ID
func (r *unitRepository) GetByID(id uuid.UUID) (*models.Unit, error) {
	var unit models.Unit
	err := r.db.Where("id = ?", id).First(&unit).Error
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return nil, nil
		}
		return nil, err
	}
	return &unit, nil
}

// GetByName retrieves a unit by name
func (r *unitRepository) GetByName(name string) (*models.Unit, error) {
	var unit models.Unit
	err := r.db.Where("name = ?", name).First(&unit).Error
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return nil, nil
		}
		return nil, err
	}
	return &unit, nil
}

// GetByCategory retrieves units by category
func (r *unitRepository) GetByCategory(category string) ([]models.Unit, error) {
	var units []models.Unit
	err := r.db.Where("category = ?", category).Order("name ASC").Find(&units).Error
	return units, err
}

// Update updates a unit
func (r *unitRepository) Update(unit *models.Unit) error {
	return r.db.Save(unit).Error
}

// Delete deletes a unit (soft delete consideration)
func (r *unitRepository) Delete(id uuid.UUID) error {
	return r.db.Delete(&models.Unit{}, id).Error
}
