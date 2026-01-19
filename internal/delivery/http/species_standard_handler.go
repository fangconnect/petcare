package http

import (
	"errors"

	"pet-care-backend/internal/usecase"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
)

// SpeciesStandardHandler handles species standard HTTP requests
type SpeciesStandardHandler struct {
	usecase usecase.SpeciesStandardUsecase
}

// NewSpeciesStandardHandler creates a new species standard handler
func NewSpeciesStandardHandler(usecase usecase.SpeciesStandardUsecase) *SpeciesStandardHandler {
	return &SpeciesStandardHandler{usecase: usecase}
}

// GetAll returns all species standards
// GET /api/admin/species-standards
func (h *SpeciesStandardHandler) GetAll(c *fiber.Ctx) error {
	standards, err := h.usecase.GetAll()
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to get species standards",
		})
	}

	return c.JSON(fiber.Map{
		"species_standards": standards,
	})
}

// GetByID returns a species standard by ID
// GET /api/admin/species-standards/:id
func (h *SpeciesStandardHandler) GetByID(c *fiber.Ctx) error {
	idStr := c.Params("id")
	id, err := uuid.Parse(idStr)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "invalid_id",
			"message": "Invalid species standard ID",
		})
	}

	standard, err := h.usecase.GetByID(id)
	if err != nil {
		if errors.Is(err, usecase.ErrSpeciesStandardNotFound) {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
				"error":   "not_found",
				"message": "Species standard not found",
			})
		}
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to get species standard",
		})
	}

	return c.JSON(standard)
}

// Create creates a new species standard
// POST /api/admin/species-standards
func (h *SpeciesStandardHandler) Create(c *fiber.Ctx) error {
	var req usecase.SpeciesStandardRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "bad_request",
			"message": "Invalid request body",
		})
	}

	if req.Species == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "validation_error",
			"message": "Species is required",
		})
	}

	standard, err := h.usecase.Create(&req)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to create species standard",
		})
	}

	return c.Status(fiber.StatusCreated).JSON(standard)
}

// Update updates a species standard
// PUT /api/admin/species-standards/:id
func (h *SpeciesStandardHandler) Update(c *fiber.Ctx) error {
	idStr := c.Params("id")
	id, err := uuid.Parse(idStr)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "invalid_id",
			"message": "Invalid species standard ID",
		})
	}

	var req usecase.SpeciesStandardRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "bad_request",
			"message": "Invalid request body",
		})
	}

	standard, err := h.usecase.Update(id, &req)
	if err != nil {
		if errors.Is(err, usecase.ErrSpeciesStandardNotFound) {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
				"error":   "not_found",
				"message": "Species standard not found",
			})
		}
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to update species standard",
		})
	}

	return c.JSON(standard)
}

// Delete deletes a species standard
// DELETE /api/admin/species-standards/:id
func (h *SpeciesStandardHandler) Delete(c *fiber.Ctx) error {
	idStr := c.Params("id")
	id, err := uuid.Parse(idStr)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "invalid_id",
			"message": "Invalid species standard ID",
		})
	}

	err = h.usecase.Delete(id)
	if err != nil {
		if errors.Is(err, usecase.ErrSpeciesStandardNotFound) {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
				"error":   "not_found",
				"message": "Species standard not found",
			})
		}
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to delete species standard",
		})
	}

	return c.SendStatus(fiber.StatusNoContent)
}
