package usecase

import (
	"encoding/json"
	"pet-care-backend/internal/models"
	"pet-care-backend/internal/repository"
	"time"

	"github.com/google/uuid"
	"gorm.io/datatypes"
)

type LogUsecase interface {
	CreateLog(req *CreateLogRequest) (*models.ActivityLog, error)
	GetLogsByPetID(petID uuid.UUID) ([]models.ActivityLog, error)
	UpdateLog(logID uuid.UUID, req *UpdateLogRequest) (*models.ActivityLog, error)
	DeleteLog(logID uuid.UUID) error
}

type logUsecase struct {
	logRepo repository.LogRepository
}

// ActivityDataPayload represents the flexible activity data
type ActivityDataPayload struct {
	Value          *float64    `json:"value,omitempty"`
	Unit           string      `json:"unit,omitempty"`
	InputType      string      `json:"input_type,omitempty"`
	Checked        *bool       `json:"checked,omitempty"`
	MedicationName string      `json:"medication_name,omitempty"`
	Text           string      `json:"text,omitempty"`
	Title          string      `json:"title,omitempty"`        // For photo type
	ImageBase64    string      `json:"image_base64,omitempty"` // For photo type
	Extra          interface{} `json:"extra,omitempty"`
}

// CreateLogRequest represents the request to create an activity log
type CreateLogRequest struct {
	PetID        string               `json:"pet_id" validate:"required"`
	PetDiseaseID *string              `json:"pet_disease_id"`
	ActivityType string               `json:"activity_type" validate:"required"`
	ActivityData *ActivityDataPayload `json:"activity_data"`
	Notes        string               `json:"notes"`
	LoggedAt     string               `json:"logged_at" validate:"required"` // ISO 8601 format
	LoggedBy     *string              `json:"logged_by"`
}

// UpdateLogRequest represents the request to update an activity log
type UpdateLogRequest struct {
	ActivityType *string              `json:"activity_type"`
	ActivityData *ActivityDataPayload `json:"activity_data"`
	Notes        *string              `json:"notes"`
	LoggedAt     *string              `json:"logged_at"`
}

// NewLogUsecase creates a new log usecase
func NewLogUsecase(logRepo repository.LogRepository) LogUsecase {
	return &logUsecase{
		logRepo: logRepo,
	}
}

// CreateLog creates a new activity log
func (u *logUsecase) CreateLog(req *CreateLogRequest) (*models.ActivityLog, error) {
	// Parse pet_id
	petID, err := parseUUID(req.PetID)
	if err != nil {
		return nil, err
	}

	// Parse logged_at
	loggedAt, err := parseDateTime(req.LoggedAt)
	if err != nil {
		return nil, err
	}

	// Build activity data JSON
	activityDataJSON, err := json.Marshal(req.ActivityData)
	if err != nil {
		return nil, err
	}

	log := &models.ActivityLog{
		PetID:        petID,
		ActivityType: req.ActivityType,
		LoggedAt:     loggedAt,
		ActivityData: datatypes.JSON(activityDataJSON),
		Notes:        req.Notes,
	}

	// Parse optional pet_disease_id
	if req.PetDiseaseID != nil && *req.PetDiseaseID != "" {
		diseaseID, err := parseUUID(*req.PetDiseaseID)
		if err != nil {
			return nil, err
		}
		log.PetDiseaseID = &diseaseID
	}

	// Parse optional logged_by
	if req.LoggedBy != nil && *req.LoggedBy != "" {
		loggedBy, err := parseUUID(*req.LoggedBy)
		if err != nil {
			return nil, err
		}
		log.LoggedBy = &loggedBy
	}

	if err := u.logRepo.CreateLog(log); err != nil {
		return nil, err
	}

	return log, nil
}

// GetLogsByPetID retrieves all logs for a specific pet
func (u *logUsecase) GetLogsByPetID(petID uuid.UUID) ([]models.ActivityLog, error) {
	return u.logRepo.GetLogsByPetID(petID)
}

// UpdateLog updates an existing activity log
func (u *logUsecase) UpdateLog(logID uuid.UUID, req *UpdateLogRequest) (*models.ActivityLog, error) {
	log := &models.ActivityLog{
		ID: logID,
	}

	if req.ActivityType != nil {
		log.ActivityType = *req.ActivityType
	}
	if req.ActivityData != nil {
		activityDataJSON, err := json.Marshal(req.ActivityData)
		if err != nil {
			return nil, err
		}
		log.ActivityData = datatypes.JSON(activityDataJSON)
	}
	if req.Notes != nil {
		log.Notes = *req.Notes
	}
	if req.LoggedAt != nil {
		loggedAt, err := parseDateTime(*req.LoggedAt)
		if err != nil {
			return nil, err
		}
		log.LoggedAt = loggedAt
	}

	if err := u.logRepo.UpdateLog(log); err != nil {
		return nil, err
	}

	return log, nil
}

// DeleteLog deletes an activity log by ID
func (u *logUsecase) DeleteLog(logID uuid.UUID) error {
	return u.logRepo.DeleteLog(logID)
}

// parseUUID parses a UUID string
func parseUUID(uuidStr string) (uuid.UUID, error) {
	return uuid.Parse(uuidStr)
}

// parseDateTime parses a datetime string in ISO 8601 format
func parseDateTime(dateTimeStr string) (time.Time, error) {
	parsedTime, err := time.Parse(time.RFC3339, dateTimeStr)
	if err != nil {
		parsedTime, err = time.Parse("2006-01-02T15:04:05", dateTimeStr)
		if err != nil {
			parsedTime, err = time.Parse("2006-01-02", dateTimeStr)
			if err != nil {
				return time.Time{}, err
			}
		}
	}
	return parsedTime, nil
}
