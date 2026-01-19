package http

import (
	"pet-care-backend/internal/models"
	"pet-care-backend/internal/repository"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
	"gorm.io/datatypes"
)

// TrackingConfigHandler handles tracking config HTTP requests
type TrackingConfigHandler struct {
	trackingRepo repository.TrackingConfigRepository
}

// NewTrackingConfigHandler creates a new tracking config handler
func NewTrackingConfigHandler(trackingRepo repository.TrackingConfigRepository) *TrackingConfigHandler {
	return &TrackingConfigHandler{trackingRepo: trackingRepo}
}

// SetTrackingConfigRequest represents the request to set tracking config
type SetTrackingConfigRequest struct {
	TemplateID string `json:"template_id"`
}

// SetTrackingConfig sets or updates the template for a pet disease
// PUT /api/pets/:petId/diseases/:diseaseId/tracking-config
func (h *TrackingConfigHandler) SetTrackingConfig(c *fiber.Ctx) error {
	petDiseaseIDStr := c.Params("diseaseId")
	petDiseaseID, err := uuid.Parse(petDiseaseIDStr)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "invalid_id",
			"message": "Invalid pet disease ID",
		})
	}

	var req SetTrackingConfigRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "bad_request",
			"message": "Invalid request body",
		})
	}

	var templateID *uuid.UUID
	if req.TemplateID != "" {
		id, err := uuid.Parse(req.TemplateID)
		if err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"error":   "invalid_template_id",
				"message": "Invalid template ID format",
			})
		}
		templateID = &id
	}

	config := &models.DiseaseTrackingConfig{
		PetDiseaseID:     petDiseaseID,
		TemplateID:       templateID,
		CustomFields:     datatypes.JSON([]byte("{}")),
		TrackingSchedule: datatypes.JSON([]byte("{}")),
		IsActive:         true,
	}

	if err := h.trackingRepo.Upsert(config); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to update tracking config",
		})
	}

	return c.JSON(fiber.Map{
		"success": true,
		"message": "Tracking config updated",
	})
}

// GetTrackingConfig gets the tracking config for a pet disease
// GET /api/pets/:petId/diseases/:diseaseId/tracking-config
func (h *TrackingConfigHandler) GetTrackingConfig(c *fiber.Ctx) error {
	petDiseaseIDStr := c.Params("diseaseId")
	petDiseaseID, err := uuid.Parse(petDiseaseIDStr)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "invalid_id",
			"message": "Invalid pet disease ID",
		})
	}

	config, err := h.trackingRepo.GetByPetDiseaseID(petDiseaseID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to get tracking config",
		})
	}

	if config == nil {
		return c.JSON(fiber.Map{
			"tracking_config": nil,
		})
	}

	return c.JSON(fiber.Map{
		"tracking_config": config,
	})
}

// GetPetTemplateActivityTypes returns the activity types from the pet's active disease template
// GET /api/pets/:id/template-activity-types
func (h *TrackingConfigHandler) GetPetTemplateActivityTypes(c *fiber.Ctx) error {
	petIDStr := c.Params("id")
	petID, err := uuid.Parse(petIDStr)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "invalid_id",
			"message": "Invalid pet ID",
		})
	}

	// Get pet's active disease
	petDisease, err := h.trackingRepo.GetPetActiveDisease(petID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to get pet disease",
		})
	}

	if petDisease == nil {
		return c.JSON(fiber.Map{
			"activity_types": []interface{}{},
			"disease":        nil,
			"template":       nil,
		})
	}

	// Get tracking config
	config, err := h.trackingRepo.GetByPetDiseaseID(petDisease.ID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to get tracking config",
		})
	}

	if config == nil || config.TemplateID == nil {
		return c.JSON(fiber.Map{
			"activity_types": []interface{}{},
			"disease":        petDisease.Disease,
			"template":       nil,
		})
	}

	// Get activity types from template
	activityTypes, err := h.trackingRepo.GetTemplateActivityTypes(*config.TemplateID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to get activity types",
		})
	}

	// Transform to response format with units
	result := make([]fiber.Map, len(activityTypes))
	for i, at := range activityTypes {
		units := make([]fiber.Map, len(at.ActivityTypeUnits))
		for j, atu := range at.ActivityTypeUnits {
			units[j] = fiber.Map{
				"id":         atu.Unit.ID,
				"name":       atu.Unit.Name,
				"name_en":    atu.Unit.NameEN,
				"symbol":     atu.Unit.Symbol,
				"category":   atu.Unit.Category,
				"is_default": atu.IsDefault,
			}
		}

		result[i] = fiber.Map{
			"id":         at.ID,
			"name":       at.Name,
			"name_en":    at.NameEN,
			"input_type": at.InputType,
			"category":   at.Category,
			"icon":       at.Icon,
			"units":      units,
		}
	}

	return c.JSON(fiber.Map{
		"activity_types": result,
		"disease":        petDisease.Disease,
		"template":       config.Template,
	})
}
