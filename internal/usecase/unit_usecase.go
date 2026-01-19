package usecase

import (
	"errors"

	"pet-care-backend/internal/models"
	"pet-care-backend/internal/repository"

	"github.com/google/uuid"
)

// Unit errors
var (
	ErrUnitNotFound = errors.New("unit not found")
	ErrUnitExists   = errors.New("unit with this name already exists")
)

// UnitRequest represents the request body for creating/updating a unit
type UnitRequest struct {
	Name     string `json:"name" validate:"required"`
	NameEN   string `json:"name_en,omitempty"`
	Symbol   string `json:"symbol,omitempty"`
	Category string `json:"category,omitempty"` // volume, weight, count, scale, time
}

// UnitUsecase defines unit business logic
type UnitUsecase interface {
	Create(req *UnitRequest) (*models.Unit, error)
	GetAll() ([]models.Unit, error)
	GetByID(id uuid.UUID) (*models.Unit, error)
	GetByCategory(category string) ([]models.Unit, error)
	Update(id uuid.UUID, req *UnitRequest) (*models.Unit, error)
	Delete(id uuid.UUID) error
}

type unitUsecase struct {
	repo repository.UnitRepository
}

// NewUnitUsecase creates a new unit usecase
func NewUnitUsecase(repo repository.UnitRepository) UnitUsecase {
	return &unitUsecase{repo: repo}
}

// Create creates a new unit
func (u *unitUsecase) Create(req *UnitRequest) (*models.Unit, error) {
	// Check if unit with same name already exists
	existing, err := u.repo.GetByName(req.Name)
	if err != nil {
		return nil, err
	}
	if existing != nil {
		return nil, ErrUnitExists
	}

	unit := &models.Unit{
		Name:     req.Name,
		NameEN:   req.NameEN,
		Symbol:   req.Symbol,
		Category: req.Category,
	}

	if err := u.repo.Create(unit); err != nil {
		return nil, err
	}

	return unit, nil
}

// GetAll retrieves all units
func (u *unitUsecase) GetAll() ([]models.Unit, error) {
	return u.repo.GetAll()
}

// GetByID retrieves a unit by ID
func (u *unitUsecase) GetByID(id uuid.UUID) (*models.Unit, error) {
	unit, err := u.repo.GetByID(id)
	if err != nil {
		return nil, err
	}
	if unit == nil {
		return nil, ErrUnitNotFound
	}
	return unit, nil
}

// GetByCategory retrieves units by category
func (u *unitUsecase) GetByCategory(category string) ([]models.Unit, error) {
	return u.repo.GetByCategory(category)
}

// Update updates a unit
func (u *unitUsecase) Update(id uuid.UUID, req *UnitRequest) (*models.Unit, error) {
	unit, err := u.repo.GetByID(id)
	if err != nil {
		return nil, err
	}
	if unit == nil {
		return nil, ErrUnitNotFound
	}

	// Check if another unit with the same name exists
	if req.Name != "" && req.Name != unit.Name {
		existing, err := u.repo.GetByName(req.Name)
		if err != nil {
			return nil, err
		}
		if existing != nil && existing.ID != unit.ID {
			return nil, ErrUnitExists
		}
		unit.Name = req.Name
	}

	if req.NameEN != "" {
		unit.NameEN = req.NameEN
	}
	if req.Symbol != "" {
		unit.Symbol = req.Symbol
	}
	if req.Category != "" {
		unit.Category = req.Category
	}

	if err := u.repo.Update(unit); err != nil {
		return nil, err
	}

	return unit, nil
}

// Delete deletes a unit
func (u *unitUsecase) Delete(id uuid.UUID) error {
	unit, err := u.repo.GetByID(id)
	if err != nil {
		return err
	}
	if unit == nil {
		return ErrUnitNotFound
	}
	return u.repo.Delete(id)
}
