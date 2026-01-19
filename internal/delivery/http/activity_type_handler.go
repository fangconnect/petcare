package http

import (
	"errors"

	"pet-care-backend/internal/models"
	"pet-care-backend/internal/usecase"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
)

// ActivityTypeHandler handles activity type HTTP requests
type ActivityTypeHandler struct {
	usecase usecase.ActivityTypeUsecase
}

// NewActivityTypeHandler creates a new activity type handler
func NewActivityTypeHandler(usecase usecase.ActivityTypeUsecase) *ActivityTypeHandler {
	return &ActivityTypeHandler{usecase: usecase}
}

// GetAll returns all activity types
// GET /api/admin/activity-types
func (h *ActivityTypeHandler) GetAll(c *fiber.Ctx) error {
	types, err := h.usecase.GetAll()
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to get activity types",
		})
	}

	// Transform to include flat units array
	result := make([]fiber.Map, len(types))
	for i, t := range types {
		units := make([]fiber.Map, 0)
		for _, atu := range t.ActivityTypeUnits {
			units = append(units, fiber.Map{
				"id":         atu.Unit.ID,
				"name":       atu.Unit.Name,
				"name_en":    atu.Unit.NameEN,
				"symbol":     atu.Unit.Symbol,
				"is_default": atu.IsDefault,
			})
		}
		result[i] = fiber.Map{
			"id":         t.ID,
			"name":       t.Name,
			"name_en":    t.NameEN,
			"input_type": t.InputType,
			"category":   t.Category,
			"icon":       t.Icon,
			"is_active":  t.IsActive,
			"sort_order": t.SortOrder,
			"units":      units,
		}
	}

	return c.JSON(fiber.Map{
		"activity_types": result,
	})
}

// GetByID returns an activity type by ID
// GET /api/admin/activity-types/:id
func (h *ActivityTypeHandler) GetByID(c *fiber.Ctx) error {
	idStr := c.Params("id")
	id, err := uuid.Parse(idStr)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "invalid_id",
			"message": "Invalid activity type ID",
		})
	}

	activityType, err := h.usecase.GetByID(id)
	if err != nil {
		if errors.Is(err, usecase.ErrActivityTypeNotFound) {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
				"error":   "not_found",
				"message": "Activity type not found",
			})
		}
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to get activity type",
		})
	}

	return c.JSON(activityType)
}

// Create creates a new activity type
// POST /api/admin/activity-types
func (h *ActivityTypeHandler) Create(c *fiber.Ctx) error {
	var req models.ActivityTypeRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "bad_request",
			"message": "Invalid request body",
		})
	}

	if req.Name == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "validation_error",
			"message": "Name is required",
		})
	}

	activityType, err := h.usecase.Create(&req)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to create activity type",
		})
	}

	return c.Status(fiber.StatusCreated).JSON(activityType)
}

// Update updates an activity type
// PUT /api/admin/activity-types/:id
func (h *ActivityTypeHandler) Update(c *fiber.Ctx) error {
	idStr := c.Params("id")
	id, err := uuid.Parse(idStr)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "invalid_id",
			"message": "Invalid activity type ID",
		})
	}

	var req models.ActivityTypeRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "bad_request",
			"message": "Invalid request body",
		})
	}

	activityType, err := h.usecase.Update(id, &req)
	if err != nil {
		if errors.Is(err, usecase.ErrActivityTypeNotFound) {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
				"error":   "not_found",
				"message": "Activity type not found",
			})
		}
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to update activity type",
		})
	}

	return c.JSON(activityType)
}

// Delete deletes an activity type
// DELETE /api/admin/activity-types/:id
func (h *ActivityTypeHandler) Delete(c *fiber.Ctx) error {
	idStr := c.Params("id")
	id, err := uuid.Parse(idStr)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "invalid_id",
			"message": "Invalid activity type ID",
		})
	}

	err = h.usecase.Delete(id)
	if err != nil {
		if errors.Is(err, usecase.ErrActivityTypeNotFound) {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
				"error":   "not_found",
				"message": "Activity type not found",
			})
		}
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to delete activity type",
		})
	}

	return c.SendStatus(fiber.StatusNoContent)
}
