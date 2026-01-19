package http

import (
	"pet-care-backend/internal/models"
	"pet-care-backend/internal/usecase"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
)

// DiseaseHandler handles disease HTTP requests
type DiseaseHandler struct {
	diseaseUsecase usecase.DiseaseUsecase
}

// NewDiseaseHandler creates a new disease handler
func NewDiseaseHandler(diseaseUsecase usecase.DiseaseUsecase) *DiseaseHandler {
	return &DiseaseHandler{diseaseUsecase: diseaseUsecase}
}

// GetAllDiseases returns all diseases
// GET /api/admin/diseases
func (h *DiseaseHandler) GetAllDiseases(c *fiber.Ctx) error {
	diseases, err := h.diseaseUsecase.GetAll()
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to get diseases",
		})
	}
	return c.JSON(fiber.Map{"diseases": diseases})
}

// GetDiseaseByID returns a disease by ID
// GET /api/admin/diseases/:id
func (h *DiseaseHandler) GetDiseaseByID(c *fiber.Ctx) error {
	id, err := uuid.Parse(c.Params("id"))
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "invalid_id",
			"message": "Invalid disease ID",
		})
	}

	disease, err := h.diseaseUsecase.GetByID(id)
	if err != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error":   "not_found",
			"message": "Disease not found",
		})
	}
	return c.JSON(disease)
}

// GetDiseaseWithTemplates returns a disease with its templates
// GET /api/admin/diseases/:id/templates
func (h *DiseaseHandler) GetDiseaseWithTemplates(c *fiber.Ctx) error {
	id, err := uuid.Parse(c.Params("id"))
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "invalid_id",
			"message": "Invalid disease ID",
		})
	}

	disease, err := h.diseaseUsecase.GetWithTemplates(id)
	if err != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error":   "not_found",
			"message": "Disease not found",
		})
	}
	return c.JSON(disease)
}

// CreateDisease creates a new disease
// POST /api/admin/diseases
func (h *DiseaseHandler) CreateDisease(c *fiber.Ctx) error {
	var disease models.Disease
	if err := c.BodyParser(&disease); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "bad_request",
			"message": "Invalid request body",
		})
	}

	if disease.Name == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "validation_error",
			"message": "Disease name is required",
		})
	}

	disease.IsActive = true
	if err := h.diseaseUsecase.Create(&disease); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to create disease",
		})
	}

	return c.Status(fiber.StatusCreated).JSON(disease)
}

// UpdateDisease updates an existing disease
// PUT /api/admin/diseases/:id
func (h *DiseaseHandler) UpdateDisease(c *fiber.Ctx) error {
	id, err := uuid.Parse(c.Params("id"))
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "invalid_id",
			"message": "Invalid disease ID",
		})
	}

	// Get existing disease
	existing, err := h.diseaseUsecase.GetByID(id)
	if err != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error":   "not_found",
			"message": "Disease not found",
		})
	}

	// Parse update data
	var updates models.Disease
	if err := c.BodyParser(&updates); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "bad_request",
			"message": "Invalid request body",
		})
	}

	// Apply updates
	if updates.Name != "" {
		existing.Name = updates.Name
	}
	if updates.NameEN != "" {
		existing.NameEN = updates.NameEN
	}
	if updates.Category != "" {
		existing.Category = updates.Category
	}
	if updates.Description != "" {
		existing.Description = updates.Description
	}

	if err := h.diseaseUsecase.Update(existing); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to update disease",
		})
	}

	return c.JSON(existing)
}

// DeleteDisease soft deletes a disease
// DELETE /api/admin/diseases/:id
func (h *DiseaseHandler) DeleteDisease(c *fiber.Ctx) error {
	id, err := uuid.Parse(c.Params("id"))
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "invalid_id",
			"message": "Invalid disease ID",
		})
	}

	if err := h.diseaseUsecase.Delete(id); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to delete disease",
		})
	}

	return c.JSON(fiber.Map{"message": "Disease deleted successfully"})
}
