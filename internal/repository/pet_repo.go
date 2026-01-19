package repository

import (
	"pet-care-backend/internal/models"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type PetRepository interface {
	CreatePet(pet *models.Pet) error
	CreatePetDisease(petDisease *models.PetDisease) error
	GetPetsByUserID(userID uuid.UUID) ([]models.Pet, error)
	GetPetByID(petID uuid.UUID) (*models.Pet, error)
	UpdatePet(pet *models.Pet) error
	DeletePet(petID uuid.UUID) error
}

type petRepository struct {
	db *gorm.DB
}

// NewPetRepository creates a new pet repository
func NewPetRepository(db *gorm.DB) PetRepository {
	return &petRepository{db: db}
}

// CreatePet creates a new pet
func (r *petRepository) CreatePet(pet *models.Pet) error {
	return r.db.Create(pet).Error
}

// CreatePetDisease creates a new pet disease record
func (r *petRepository) CreatePetDisease(petDisease *models.PetDisease) error {
	return r.db.Create(petDisease).Error
}

// GetPetsByUserID retrieves all pets for a specific user (owner_id)
func (r *petRepository) GetPetsByUserID(userID uuid.UUID) ([]models.Pet, error) {
	var pets []models.Pet

	err := r.db.
		Where("owner_id = ? AND is_active = ?", userID, true).
		Preload("PetDiseases", "is_active = ?", true).
		Preload("PetDiseases.Disease").
		Preload("PetDiseases.TrackingConfig").
		Preload("PetDiseases.TrackingConfig.Template").
		Order("created_at DESC").
		Find(&pets).Error

	if err != nil {
		return nil, err
	}

	return pets, nil
}

// GetPetByID retrieves a pet by its ID
func (r *petRepository) GetPetByID(petID uuid.UUID) (*models.Pet, error) {
	var pet models.Pet

	err := r.db.
		Where("id = ?", petID).
		Preload("PetDiseases", "is_active = ?", true).
		Preload("PetDiseases.Disease").
		Preload("PetDiseases.TrackingConfig").
		Preload("PetDiseases.TrackingConfig.Template").
		Preload("Owner").
		First(&pet).Error

	if err != nil {
		return nil, err
	}

	return &pet, nil
}

// UpdatePet updates an existing pet
func (r *petRepository) UpdatePet(pet *models.Pet) error {
	return r.db.Model(&models.Pet{}).Where("id = ?", pet.ID).Updates(pet).Error
}

// DeletePet soft-deletes a pet by setting is_active to false
func (r *petRepository) DeletePet(petID uuid.UUID) error {
	return r.db.Model(&models.Pet{}).Where("id = ?", petID).Update("is_active", false).Error
}
