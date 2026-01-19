package repository

import (
	"pet-care-backend/internal/models"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type LogRepository interface {
	CreateLog(log *models.ActivityLog) error
	GetLogsByPetID(petID uuid.UUID) ([]models.ActivityLog, error)
	UpdateLog(log *models.ActivityLog) error
	DeleteLog(logID uuid.UUID) error
	GetLogsByPetIDWithDateRange(petID uuid.UUID, startDate, endDate string) ([]models.ActivityLog, error)
}

type logRepository struct {
	db *gorm.DB
}

// NewLogRepository creates a new log repository
func NewLogRepository(db *gorm.DB) LogRepository {
	return &logRepository{db: db}
}

// CreateLog creates a new activity log
func (r *logRepository) CreateLog(log *models.ActivityLog) error {
	return r.db.Create(log).Error
}

// GetLogsByPetID retrieves all logs for a specific pet, ordered by logged_at DESC
func (r *logRepository) GetLogsByPetID(petID uuid.UUID) ([]models.ActivityLog, error) {
	var logs []models.ActivityLog

	err := r.db.
		Where("pet_id = ?", petID).
		Preload("PetDisease").
		Preload("PetDisease.Disease").
		Order("logged_at DESC").
		Find(&logs).Error

	if err != nil {
		return nil, err
	}

	return logs, nil
}

// GetLogsByPetIDWithDateRange retrieves logs for a pet within a date range
func (r *logRepository) GetLogsByPetIDWithDateRange(petID uuid.UUID, startDate, endDate string) ([]models.ActivityLog, error) {
	var logs []models.ActivityLog

	err := r.db.
		Where("pet_id = ? AND logged_at >= ? AND logged_at <= ?", petID, startDate, endDate).
		Preload("PetDisease").
		Order("logged_at DESC").
		Find(&logs).Error

	if err != nil {
		return nil, err
	}

	return logs, nil
}

// UpdateLog updates an existing activity log
func (r *logRepository) UpdateLog(log *models.ActivityLog) error {
	return r.db.Model(&models.ActivityLog{}).Where("id = ?", log.ID).Updates(log).Error
}

// DeleteLog deletes an activity log by ID
func (r *logRepository) DeleteLog(logID uuid.UUID) error {
	return r.db.Delete(&models.ActivityLog{}, "id = ?", logID).Error
}
