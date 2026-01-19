package http

import (
	"errors"

	"pet-care-backend/internal/usecase"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
)

// UnitHandler handles unit HTTP requests
type UnitHandler struct {
	usecase usecase.UnitUsecase
}

// NewUnitHandler creates a new unit handler
func NewUnitHandler(usecase usecase.UnitUsecase) *UnitHandler {
	return &UnitHandler{usecase: usecase}
}

// GetAll returns all units
// GET /api/admin/units
func (h *UnitHandler) GetAll(c *fiber.Ctx) error {
	units, err := h.usecase.GetAll()
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to get units",
		})
	}

	return c.JSON(fiber.Map{
		"units": units,
	})
}

// GetByID returns a unit by ID
// GET /api/admin/units/:id
func (h *UnitHandler) GetByID(c *fiber.Ctx) error {
	idStr := c.Params("id")
	id, err := uuid.Parse(idStr)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "invalid_id",
			"message": "Invalid unit ID",
		})
	}

	unit, err := h.usecase.GetByID(id)
	if err != nil {
		if errors.Is(err, usecase.ErrUnitNotFound) {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
				"error":   "not_found",
				"message": "Unit not found",
			})
		}
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to get unit",
		})
	}

	return c.JSON(unit)
}

// Create creates a new unit
// POST /api/admin/units
func (h *UnitHandler) Create(c *fiber.Ctx) error {
	var req usecase.UnitRequest
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

	unit, err := h.usecase.Create(&req)
	if err != nil {
		if errors.Is(err, usecase.ErrUnitExists) {
			return c.Status(fiber.StatusConflict).JSON(fiber.Map{
				"error":   "conflict",
				"message": "Unit with this name already exists",
			})
		}
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to create unit",
		})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"unit": unit,
	})
}

// Update updates a unit
// PUT /api/admin/units/:id
func (h *UnitHandler) Update(c *fiber.Ctx) error {
	idStr := c.Params("id")
	id, err := uuid.Parse(idStr)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "invalid_id",
			"message": "Invalid unit ID",
		})
	}

	var req usecase.UnitRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "bad_request",
			"message": "Invalid request body",
		})
	}

	unit, err := h.usecase.Update(id, &req)
	if err != nil {
		if errors.Is(err, usecase.ErrUnitNotFound) {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
				"error":   "not_found",
				"message": "Unit not found",
			})
		}
		if errors.Is(err, usecase.ErrUnitExists) {
			return c.Status(fiber.StatusConflict).JSON(fiber.Map{
				"error":   "conflict",
				"message": "Unit with this name already exists",
			})
		}
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to update unit",
		})
	}

	return c.JSON(fiber.Map{
		"unit": unit,
	})
}

// Delete deletes a unit
// DELETE /api/admin/units/:id
func (h *UnitHandler) Delete(c *fiber.Ctx) error {
	idStr := c.Params("id")
	id, err := uuid.Parse(idStr)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "invalid_id",
			"message": "Invalid unit ID",
		})
	}

	err = h.usecase.Delete(id)
	if err != nil {
		if errors.Is(err, usecase.ErrUnitNotFound) {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
				"error":   "not_found",
				"message": "Unit not found",
			})
		}
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to delete unit",
		})
	}

	return c.SendStatus(fiber.StatusNoContent)
}
