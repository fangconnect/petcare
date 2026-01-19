package usecase

import (
	"pet-care-backend/internal/models"
	"pet-care-backend/internal/repository"
	"time"

	"github.com/google/uuid"
	"gorm.io/datatypes"
)

type PetUsecase interface {
	CreatePet(req *CreatePetRequest) (*models.Pet, error)
	GetPetsByUserID(userID uuid.UUID) ([]models.Pet, error)
}

type petUsecase struct {
	petRepo      repository.PetRepository
	trackingRepo repository.TrackingConfigRepository
}

// CreatePetRequest represents the request to create a pet
type CreatePetRequest struct {
	OwnerID    uuid.UUID `json:"owner_id" validate:"required"`
	Name       string    `json:"name" validate:"required"`
	Species    string    `json:"species"`
	Breed      string    `json:"breed"`
	PhotoURL   string    `json:"photo_url"`
	BirthDate  *string   `json:"birth_date"` // ISO 8601 format string
	Gender     string    `json:"gender"`
	DiseaseID  string    `json:"disease_id,omitempty"`  // Optional disease ID
	TemplateID string    `json:"template_id,omitempty"` // Optional template ID
}

// NewPetUsecase creates a new pet usecase
func NewPetUsecase(petRepo repository.PetRepository, trackingRepo repository.TrackingConfigRepository) PetUsecase {
	return &petUsecase{
		petRepo:      petRepo,
		trackingRepo: trackingRepo,
	}
}

// CreatePet creates a new pet and optionally links disease and template
func (u *petUsecase) CreatePet(req *CreatePetRequest) (*models.Pet, error) {
	pet := &models.Pet{
		OwnerID:  req.OwnerID,
		Name:     req.Name,
		Species:  req.Species,
		Breed:    req.Breed,
		PhotoURL: req.PhotoURL,
		Gender:   req.Gender,
		IsActive: true,
	}

	// Parse birthdate if provided
	if req.BirthDate != nil && *req.BirthDate != "" {
		birthDate, err := parseDate(*req.BirthDate)
		if err != nil {
			return nil, err
		}
		pet.BirthDate = birthDate
	}

	// Create pet
	if err := u.petRepo.CreatePet(pet); err != nil {
		return nil, err
	}

	// If disease is provided, create PetDisease and optionally TrackingConfig
	if req.DiseaseID != "" {
		diseaseID, err := uuid.Parse(req.DiseaseID)
		if err == nil {
			now := time.Now()
			petDisease := &models.PetDisease{
				PetID:         pet.ID,
				DiseaseID:     diseaseID,
				DiagnosedDate: &now,
				IsActive:      true,
			}

			if err := u.petRepo.CreatePetDisease(petDisease); err != nil {
				// Log error but don't fail pet creation
				// TODO: handle error properly
			} else if req.TemplateID != "" {
				// Set tracking config with template
				templateID, err := uuid.Parse(req.TemplateID)
				if err == nil {
					config := &models.DiseaseTrackingConfig{
						PetDiseaseID:     petDisease.ID,
						TemplateID:       &templateID,
						CustomFields:     datatypes.JSON([]byte("{}")),
						TrackingSchedule: datatypes.JSON([]byte("{}")),
						IsActive:         true,
					}
					u.trackingRepo.Upsert(config)
				}
			}
		}
	}

	return pet, nil
}

// GetPetsByUserID retrieves all pets for a specific user
func (u *petUsecase) GetPetsByUserID(userID uuid.UUID) ([]models.Pet, error) {
	return u.petRepo.GetPetsByUserID(userID)
}

// parseDate parses a date string in ISO 8601 format
func parseDate(dateStr string) (*time.Time, error) {
	parsedTime, err := time.Parse("2006-01-02", dateStr)
	if err != nil {
		return nil, err
	}
	return &parsedTime, nil
}
