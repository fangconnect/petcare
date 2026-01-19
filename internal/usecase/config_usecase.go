package usecase

import (
	"pet-care-backend/internal/repository"
)

type ConfigUsecase interface {
	GetAllDiseases() (interface{}, error)
}

type configUsecase struct {
	configRepo repository.ConfigRepository
}

// NewConfigUsecase creates a new config usecase
func NewConfigUsecase(configRepo repository.ConfigRepository) ConfigUsecase {
	return &configUsecase{
		configRepo: configRepo,
	}
}

// GetAllDiseases retrieves all diseases with activities
func (u *configUsecase) GetAllDiseases() (interface{}, error) {
	diseases, err := u.configRepo.GetAllDiseases()
	if err != nil {
		return nil, err
	}
	
	return diseases, nil
}
