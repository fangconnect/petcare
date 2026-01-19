package http

import (
	"pet-care-backend/internal/models"
	"pet-care-backend/internal/usecase"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
)

// TemplateHandler handles template HTTP requests
type TemplateHandler struct {
	templateUsecase usecase.TemplateUsecase
}

// NewTemplateHandler creates a new template handler
func NewTemplateHandler(templateUsecase usecase.TemplateUsecase) *TemplateHandler {
	return &TemplateHandler{templateUsecase: templateUsecase}
}

// CreateTemplateRequest represents the request body for creating a template
type CreateTemplateRequest struct {
	DiseaseID     string `json:"disease_id"`
	TemplateName  string `json:"template_name"`
	Description   string `json:"description,omitempty"`
	IsDefault     bool   `json:"is_default"`
	ActivityTypes []struct {
		ActivityTypeID string `json:"activity_type_id"`
		IsRequired     bool   `json:"is_required"`
		SortOrder      int    `json:"sort_order"`
	} `json:"activity_types,omitempty"`
}

// GetTemplatesByDiseaseID returns templates for a disease
// GET /api/admin/diseases/:id/templates
func (h *TemplateHandler) GetTemplatesByDiseaseID(c *fiber.Ctx) error {
	diseaseID, err := uuid.Parse(c.Params("id"))
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "invalid_id",
			"message": "Invalid disease ID",
		})
	}

	templates, err := h.templateUsecase.GetByDiseaseID(diseaseID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to get templates",
		})
	}
	return c.JSON(fiber.Map{"templates": templates})
}

// GetTemplateByID returns a template by ID
// GET /api/admin/templates/:id
func (h *TemplateHandler) GetTemplateByID(c *fiber.Ctx) error {
	id, err := uuid.Parse(c.Params("id"))
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "invalid_id",
			"message": "Invalid template ID",
		})
	}

	template, err := h.templateUsecase.GetByID(id)
	if err != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error":   "not_found",
			"message": "Template not found",
		})
	}
	return c.JSON(template)
}

// CreateTemplate creates a new template
// POST /api/admin/templates
func (h *TemplateHandler) CreateTemplate(c *fiber.Ctx) error {
	var req CreateTemplateRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "bad_request",
			"message": "Invalid request body",
		})
	}

	if req.TemplateName == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "validation_error",
			"message": "Template name is required",
		})
	}

	diseaseID, err := uuid.Parse(req.DiseaseID)
	if err != nil || diseaseID == uuid.Nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "validation_error",
			"message": "Disease ID is required",
		})
	}

	// Create template
	template := &models.DiseaseTemplate{
		DiseaseID:    diseaseID,
		TemplateName: req.TemplateName,
		Description:  req.Description,
		IsDefault:    req.IsDefault,
		Version:      1,
	}

	if err := h.templateUsecase.Create(template); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to create template",
		})
	}

	// Set activity types if provided
	if len(req.ActivityTypes) > 0 {
		activityTypes := make([]models.DiseaseTemplateActivityType, len(req.ActivityTypes))
		for i, at := range req.ActivityTypes {
			atID, err := uuid.Parse(at.ActivityTypeID)
			if err != nil {
				continue
			}
			activityTypes[i] = models.DiseaseTemplateActivityType{
				TemplateID:     template.ID,
				ActivityTypeID: atID,
				IsRequired:     at.IsRequired,
				SortOrder:      at.SortOrder,
			}
		}
		if err := h.templateUsecase.SetActivityTypes(template.ID, activityTypes); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error":   "internal_error",
				"message": "Failed to set activity types",
			})
		}
	}

	// Reload template with activity types
	result, _ := h.templateUsecase.GetByID(template.ID)
	return c.Status(fiber.StatusCreated).JSON(result)
}

// UpdateTemplate updates an existing template
// PUT /api/admin/templates/:id
func (h *TemplateHandler) UpdateTemplate(c *fiber.Ctx) error {
	id, err := uuid.Parse(c.Params("id"))
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "invalid_id",
			"message": "Invalid template ID",
		})
	}

	// Get existing template
	existing, err := h.templateUsecase.GetByID(id)
	if err != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error":   "not_found",
			"message": "Template not found",
		})
	}

	// Parse update data
	var req CreateTemplateRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "bad_request",
			"message": "Invalid request body",
		})
	}

	// Apply updates
	if req.TemplateName != "" {
		existing.TemplateName = req.TemplateName
	}
	if req.Description != "" {
		existing.Description = req.Description
	}
	existing.Version++

	if err := h.templateUsecase.Update(existing); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to update template",
		})
	}

	// Update activity types if provided
	if len(req.ActivityTypes) > 0 {
		activityTypes := make([]models.DiseaseTemplateActivityType, 0)
		for i, at := range req.ActivityTypes {
			atID, err := uuid.Parse(at.ActivityTypeID)
			if err != nil {
				continue
			}
			activityTypes = append(activityTypes, models.DiseaseTemplateActivityType{
				TemplateID:     id,
				ActivityTypeID: atID,
				IsRequired:     at.IsRequired,
				SortOrder:      i,
			})
		}
		if err := h.templateUsecase.SetActivityTypes(id, activityTypes); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error":   "internal_error",
				"message": "Failed to update activity types",
			})
		}
	}

	// Reload template with activity types
	result, _ := h.templateUsecase.GetByID(id)
	return c.JSON(result)
}

// DeleteTemplate deletes a template
// DELETE /api/admin/templates/:id
func (h *TemplateHandler) DeleteTemplate(c *fiber.Ctx) error {
	id, err := uuid.Parse(c.Params("id"))
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "invalid_id",
			"message": "Invalid template ID",
		})
	}

	if err := h.templateUsecase.Delete(id); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to delete template",
		})
	}

	return c.JSON(fiber.Map{"message": "Template deleted successfully"})
}

// SetDefaultTemplate sets a template as default
// POST /api/admin/templates/:id/set-default
func (h *TemplateHandler) SetDefaultTemplate(c *fiber.Ctx) error {
	id, err := uuid.Parse(c.Params("id"))
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error":   "invalid_id",
			"message": "Invalid template ID",
		})
	}

	// Get template to find disease ID
	template, err := h.templateUsecase.GetByID(id)
	if err != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error":   "not_found",
			"message": "Template not found",
		})
	}

	if err := h.templateUsecase.SetDefault(template.DiseaseID, id); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error":   "internal_error",
			"message": "Failed to set default template",
		})
	}

	return c.JSON(fiber.Map{"message": "Template set as default"})
}
