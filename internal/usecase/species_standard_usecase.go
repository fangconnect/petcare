package usecase

import (
	"encoding/json"
	"errors"

	"pet-care-backend/internal/models"
	"pet-care-backend/internal/repository"

	"github.com/google/uuid"
	"gorm.io/datatypes"
)

// Species standard errors
var (
	ErrSpeciesStandardNotFound = errors.New("species standard not found")
)

// SpeciesStandardRequest represents the request body for creating/updating a species standard
type SpeciesStandardRequest struct {
	Species      string                 `json:"species" validate:"required"`
	Breed        string                 `json:"breed,omitempty"`
	NormalRanges map[string]interface{} `json:"normal_ranges"`
}

// SpeciesStandardUsecase defines species standard business logic
type SpeciesStandardUsecase interface {
	Create(req *SpeciesStandardRequest) (*models.SpeciesStandard, error)
	GetAll() ([]models.SpeciesStandard, error)
	GetByID(id uuid.UUID) (*models.SpeciesStandard, error)
	GetBySpecies(species string) (*models.SpeciesStandard, error)
	Update(id uuid.UUID, req *SpeciesStandardRequest) (*models.SpeciesStandard, error)
	Delete(id uuid.UUID) error
}

type speciesStandardUsecase struct {
	repo repository.SpeciesStandardRepository
}

// NewSpeciesStandardUsecase creates a new species standard usecase
func NewSpeciesStandardUsecase(repo repository.SpeciesStandardRepository) SpeciesStandardUsecase {
	return &speciesStandardUsecase{repo: repo}
}

// Create creates a new species standard
func (u *speciesStandardUsecase) Create(req *SpeciesStandardRequest) (*models.SpeciesStandard, error) {
	// Convert normal ranges to JSON
	normalRangesJSON, err := marshalNormalRanges(req.NormalRanges)
	if err != nil {
		return nil, err
	}

	standard := &models.SpeciesStandard{
		Species:      req.Species,
		Breed:        req.Breed,
		NormalRanges: normalRangesJSON,
	}

	if err := u.repo.Create(standard); err != nil {
		return nil, err
	}

	return standard, nil
}

// GetAll retrieves all species standards
func (u *speciesStandardUsecase) GetAll() ([]models.SpeciesStandard, error) {
	return u.repo.GetAll()
}

// GetByID retrieves a species standard by ID
func (u *speciesStandardUsecase) GetByID(id uuid.UUID) (*models.SpeciesStandard, error) {
	standard, err := u.repo.GetByID(id)
	if err != nil {
		return nil, err
	}
	if standard == nil {
		return nil, ErrSpeciesStandardNotFound
	}
	return standard, nil
}

// GetBySpecies retrieves a species standard by species name
func (u *speciesStandardUsecase) GetBySpecies(species string) (*models.SpeciesStandard, error) {
	standard, err := u.repo.GetBySpecies(species)
	if err != nil {
		return nil, err
	}
	if standard == nil {
		return nil, ErrSpeciesStandardNotFound
	}
	return standard, nil
}

// Update updates a species standard
func (u *speciesStandardUsecase) Update(id uuid.UUID, req *SpeciesStandardRequest) (*models.SpeciesStandard, error) {
	standard, err := u.repo.GetByID(id)
	if err != nil {
		return nil, err
	}
	if standard == nil {
		return nil, ErrSpeciesStandardNotFound
	}

	// Update fields
	if req.Species != "" {
		standard.Species = req.Species
	}
	if req.Breed != "" {
		standard.Breed = req.Breed
	}
	if req.NormalRanges != nil {
		normalRangesJSON, err := marshalNormalRanges(req.NormalRanges)
		if err != nil {
			return nil, err
		}
		standard.NormalRanges = normalRangesJSON
	}

	if err := u.repo.Update(standard); err != nil {
		return nil, err
	}

	return standard, nil
}

// Delete deletes a species standard
func (u *speciesStandardUsecase) Delete(id uuid.UUID) error {
	standard, err := u.repo.GetByID(id)
	if err != nil {
		return err
	}
	if standard == nil {
		return ErrSpeciesStandardNotFound
	}
	return u.repo.Delete(id)
}

// marshalNormalRanges converts a map to datatypes.JSON
func marshalNormalRanges(data map[string]interface{}) (datatypes.JSON, error) {
	if data == nil {
		return datatypes.JSON([]byte("{}")), nil
	}
	bytes, err := json.Marshal(data)
	if err != nil {
		return nil, err
	}
	return datatypes.JSON(bytes), nil
}
