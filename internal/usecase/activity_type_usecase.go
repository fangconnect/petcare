package usecase

import (
	"errors"

	"pet-care-backend/internal/models"
	"pet-care-backend/internal/repository"

	"github.com/google/uuid"
)

// Activity type errors
var (
	ErrActivityTypeNotFound = errors.New("activity type not found")
	ErrActivityTypeExists   = errors.New("activity type already exists")
)

// ActivityTypeUsecase defines activity type business logic
type ActivityTypeUsecase interface {
	Create(req *models.ActivityTypeRequest) (*models.ActivityType, error)
	GetAll() ([]models.ActivityType, error)
	GetByID(id uuid.UUID) (*models.ActivityType, error)
	GetActiveTypes() ([]models.ActivityType, error)
	Update(id uuid.UUID, req *models.ActivityTypeRequest) (*models.ActivityType, error)
	Delete(id uuid.UUID) error
	SetUnits(activityTypeID uuid.UUID, unitIDs []string) error
}

type activityTypeUsecase struct {
	repo     repository.ActivityTypeRepository
	unitRepo repository.UnitRepository
}

// NewActivityTypeUsecase creates a new activity type usecase
func NewActivityTypeUsecase(repo repository.ActivityTypeRepository, unitRepo repository.UnitRepository) ActivityTypeUsecase {
	return &activityTypeUsecase{repo: repo, unitRepo: unitRepo}
}

// Create creates a new activity type
func (u *activityTypeUsecase) Create(req *models.ActivityTypeRequest) (*models.ActivityType, error) {
	activityType := &models.ActivityType{
		Name:      req.Name,
		NameEN:    req.NameEN,
		Icon:      req.Icon,
		InputType: models.InputTypeNumber, // default
		Category:  models.CategoryOther,   // default
		IsActive:  true,
	}

	// Set input type if provided
	if req.InputType != "" {
		activityType.InputType = models.InputType(req.InputType)
	}

	// Set category if provided
	if req.Category != "" {
		activityType.Category = models.ActivityCategory(req.Category)
	}

	// Set is_active if provided
	if req.IsActive != nil {
		activityType.IsActive = *req.IsActive
	}

	// Set sort_order if provided
	if req.SortOrder != nil {
		activityType.SortOrder = *req.SortOrder
	}

	if err := u.repo.Create(activityType); err != nil {
		return nil, err
	}

	// Link units if provided
	if len(req.UnitIDs) > 0 {
		if err := u.SetUnits(activityType.ID, req.UnitIDs); err != nil {
			return nil, err
		}
		// Reload to get units
		return u.repo.GetByID(activityType.ID)
	}

	return activityType, nil
}

// GetAll retrieves all activity types
func (u *activityTypeUsecase) GetAll() ([]models.ActivityType, error) {
	return u.repo.GetAll()
}

// GetByID retrieves an activity type by ID
func (u *activityTypeUsecase) GetByID(id uuid.UUID) (*models.ActivityType, error) {
	activityType, err := u.repo.GetByID(id)
	if err != nil {
		return nil, err
	}
	if activityType == nil {
		return nil, ErrActivityTypeNotFound
	}
	return activityType, nil
}

// GetActiveTypes retrieves only active activity types
func (u *activityTypeUsecase) GetActiveTypes() ([]models.ActivityType, error) {
	return u.repo.GetActiveTypes()
}

// Update updates an activity type
func (u *activityTypeUsecase) Update(id uuid.UUID, req *models.ActivityTypeRequest) (*models.ActivityType, error) {
	activityType, err := u.repo.GetByID(id)
	if err != nil {
		return nil, err
	}
	if activityType == nil {
		return nil, ErrActivityTypeNotFound
	}

	// Update fields
	if req.Name != "" {
		activityType.Name = req.Name
	}
	if req.NameEN != "" {
		activityType.NameEN = req.NameEN
	}
	if req.Icon != "" {
		activityType.Icon = req.Icon
	}
	if req.InputType != "" {
		activityType.InputType = models.InputType(req.InputType)
	}
	if req.Category != "" {
		activityType.Category = models.ActivityCategory(req.Category)
	}
	if req.IsActive != nil {
		activityType.IsActive = *req.IsActive
	}
	if req.SortOrder != nil {
		activityType.SortOrder = *req.SortOrder
	}

	if err := u.repo.Update(activityType); err != nil {
		return nil, err
	}

	// Link units if provided
	if len(req.UnitIDs) > 0 {
		if err := u.SetUnits(id, req.UnitIDs); err != nil {
			return nil, err
		}
		// Reload to get updated units
		return u.repo.GetByID(id)
	}

	return activityType, nil
}

// Delete deletes an activity type
func (u *activityTypeUsecase) Delete(id uuid.UUID) error {
	activityType, err := u.repo.GetByID(id)
	if err != nil {
		return err
	}
	if activityType == nil {
		return ErrActivityTypeNotFound
	}
	return u.repo.Delete(id)
}

// SetUnits sets the units for an activity type
func (u *activityTypeUsecase) SetUnits(activityTypeID uuid.UUID, unitIDStrings []string) error {
	// Parse string IDs to UUIDs
	unitIDs := make([]uuid.UUID, 0, len(unitIDStrings))
	for _, idStr := range unitIDStrings {
		id, err := uuid.Parse(idStr)
		if err != nil {
			continue // Skip invalid UUIDs
		}
		// Verify unit exists
		unit, err := u.unitRepo.GetByID(id)
		if err != nil || unit == nil {
			continue // Skip non-existent units
		}
		unitIDs = append(unitIDs, id)
	}

	return u.repo.SetUnits(activityTypeID, unitIDs)
}
