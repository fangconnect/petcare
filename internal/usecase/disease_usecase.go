package usecase

import (
	"pet-care-backend/internal/models"
	"pet-care-backend/internal/repository"

	"github.com/google/uuid"
)

// DiseaseUsecase defines disease business logic
type DiseaseUsecase interface {
	GetAll() ([]models.Disease, error)
	GetByID(id uuid.UUID) (*models.Disease, error)
	Create(disease *models.Disease) error
	Update(disease *models.Disease) error
	Delete(id uuid.UUID) error
	GetWithTemplates(id uuid.UUID) (*models.Disease, error)
}

type diseaseUsecase struct {
	diseaseRepo repository.DiseaseRepository
}

// NewDiseaseUsecase creates a new disease usecase
func NewDiseaseUsecase(diseaseRepo repository.DiseaseRepository) DiseaseUsecase {
	return &diseaseUsecase{diseaseRepo: diseaseRepo}
}

func (u *diseaseUsecase) GetAll() ([]models.Disease, error) {
	return u.diseaseRepo.GetAll()
}

func (u *diseaseUsecase) GetByID(id uuid.UUID) (*models.Disease, error) {
	return u.diseaseRepo.GetByID(id)
}

func (u *diseaseUsecase) Create(disease *models.Disease) error {
	return u.diseaseRepo.Create(disease)
}

func (u *diseaseUsecase) Update(disease *models.Disease) error {
	return u.diseaseRepo.Update(disease)
}

func (u *diseaseUsecase) Delete(id uuid.UUID) error {
	return u.diseaseRepo.Delete(id)
}

func (u *diseaseUsecase) GetWithTemplates(id uuid.UUID) (*models.Disease, error) {
	return u.diseaseRepo.GetWithTemplates(id)
}
