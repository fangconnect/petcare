package repository

import (
	"pet-care-backend/internal/models"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

// ActivityTypeRepository defines activity type database operations
type ActivityTypeRepository interface {
	Create(activityType *models.ActivityType) error
	GetAll() ([]models.ActivityType, error)
	GetByID(id uuid.UUID) (*models.ActivityType, error)
	GetActiveTypes() ([]models.ActivityType, error)
	Update(activityType *models.ActivityType) error
	Delete(id uuid.UUID) error
	SetUnits(activityTypeID uuid.UUID, unitIDs []uuid.UUID) error
}

type activityTypeRepository struct {
	db *gorm.DB
}

// NewActivityTypeRepository creates a new activity type repository
func NewActivityTypeRepository(db *gorm.DB) ActivityTypeRepository {
	return &activityTypeRepository{db: db}
}

// Create creates a new activity type
func (r *activityTypeRepository) Create(activityType *models.ActivityType) error {
	return r.db.Create(activityType).Error
}

// GetAll retrieves all activity types with their units
func (r *activityTypeRepository) GetAll() ([]models.ActivityType, error) {
	var types []models.ActivityType
	err := r.db.
		Preload("ActivityTypeUnits", func(db *gorm.DB) *gorm.DB {
			return db.Order("sort_order ASC")
		}).
		Preload("ActivityTypeUnits.Unit").
		Order("sort_order ASC, name ASC").
		Find(&types).Error
	return types, err
}

// GetByID retrieves an activity type by ID with its units
func (r *activityTypeRepository) GetByID(id uuid.UUID) (*models.ActivityType, error) {
	var activityType models.ActivityType
	err := r.db.
		Preload("ActivityTypeUnits", func(db *gorm.DB) *gorm.DB {
			return db.Order("sort_order ASC")
		}).
		Preload("ActivityTypeUnits.Unit").
		Where("id = ?", id).
		First(&activityType).Error
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return nil, nil
		}
		return nil, err
	}
	return &activityType, nil
}

// GetActiveTypes retrieves only active activity types with their units
func (r *activityTypeRepository) GetActiveTypes() ([]models.ActivityType, error) {
	var types []models.ActivityType
	err := r.db.
		Preload("ActivityTypeUnits", func(db *gorm.DB) *gorm.DB {
			return db.Order("sort_order ASC")
		}).
		Preload("ActivityTypeUnits.Unit").
		Where("is_active = ?", true).
		Order("sort_order ASC, name ASC").
		Find(&types).Error
	return types, err
}

// Update updates an activity type
func (r *activityTypeRepository) Update(activityType *models.ActivityType) error {
	return r.db.Save(activityType).Error
}

// Delete deletes an activity type
func (r *activityTypeRepository) Delete(id uuid.UUID) error {
	return r.db.Delete(&models.ActivityType{}, id).Error
}

// SetUnits sets the units for an activity type (replaces all existing associations)
func (r *activityTypeRepository) SetUnits(activityTypeID uuid.UUID, unitIDs []uuid.UUID) error {
	// Delete existing associations
	if err := r.db.Where("activity_type_id = ?", activityTypeID).Delete(&models.ActivityTypeUnit{}).Error; err != nil {
		return err
	}

	// Create new associations
	for i, unitID := range unitIDs {
		atu := models.ActivityTypeUnit{
			ActivityTypeID: activityTypeID,
			UnitID:         unitID,
			IsDefault:      i == 0, // First unit is default
			SortOrder:      i,
		}
		if err := r.db.Create(&atu).Error; err != nil {
			return err
		}
	}

	return nil
}
