package usecase

import (
	"pet-care-backend/internal/models"
	"pet-care-backend/internal/repository"

	"github.com/google/uuid"
)

// TemplateUsecase defines template business logic
type TemplateUsecase interface {
	GetByDiseaseID(diseaseID uuid.UUID) ([]models.DiseaseTemplate, error)
	GetByID(id uuid.UUID) (*models.DiseaseTemplate, error)
	Create(template *models.DiseaseTemplate) error
	Update(template *models.DiseaseTemplate) error
	Delete(id uuid.UUID) error
	SetDefault(diseaseID, templateID uuid.UUID) error
	SetActivityTypes(templateID uuid.UUID, activityTypes []models.DiseaseTemplateActivityType) error
}

type templateUsecase struct {
	templateRepo repository.TemplateRepository
}

// NewTemplateUsecase creates a new template usecase
func NewTemplateUsecase(templateRepo repository.TemplateRepository) TemplateUsecase {
	return &templateUsecase{templateRepo: templateRepo}
}

func (u *templateUsecase) GetByDiseaseID(diseaseID uuid.UUID) ([]models.DiseaseTemplate, error) {
	return u.templateRepo.GetByDiseaseID(diseaseID)
}

func (u *templateUsecase) GetByID(id uuid.UUID) (*models.DiseaseTemplate, error) {
	return u.templateRepo.GetByID(id)
}

func (u *templateUsecase) Create(template *models.DiseaseTemplate) error {
	return u.templateRepo.Create(template)
}

func (u *templateUsecase) Update(template *models.DiseaseTemplate) error {
	return u.templateRepo.Update(template)
}

func (u *templateUsecase) Delete(id uuid.UUID) error {
	return u.templateRepo.Delete(id)
}

func (u *templateUsecase) SetDefault(diseaseID, templateID uuid.UUID) error {
	return u.templateRepo.SetDefault(diseaseID, templateID)
}

func (u *templateUsecase) SetActivityTypes(templateID uuid.UUID, activityTypes []models.DiseaseTemplateActivityType) error {
	return u.templateRepo.SetActivityTypes(templateID, activityTypes)
}
