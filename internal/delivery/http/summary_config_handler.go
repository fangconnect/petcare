package http

import (
	"pet-care-backend/internal/models"
	"pet-care-backend/internal/repository"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
)

type SummaryConfigHandler struct {
	repo repository.SummaryConfigRepository
}

func NewSummaryConfigHandler(repo repository.SummaryConfigRepository) *SummaryConfigHandler {
	return &SummaryConfigHandler{repo: repo}
}

// GetConfig returns the full summary config for a template
func (h *SummaryConfigHandler) GetConfig(c *fiber.Ctx) error {
	templateID, err := uuid.Parse(c.Params("templateId"))
	if err != nil {
		return c.Status(400).JSON(fiber.Map{"success": false, "error": "Invalid template ID"})
	}

	config, err := h.repo.GetConfigByTemplateID(templateID)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"success": false, "error": err.Error()})
	}

	return c.JSON(fiber.Map{"success": true, "data": config})
}

// CreateSection creates a new summary section
func (h *SummaryConfigHandler) CreateSection(c *fiber.Ctx) error {
	templateID, err := uuid.Parse(c.Params("templateId"))
	if err != nil {
		return c.Status(400).JSON(fiber.Map{"success": false, "error": "Invalid template ID"})
	}

	var section models.SummarySection
	if err := c.BodyParser(&section); err != nil {
		return c.Status(400).JSON(fiber.Map{"success": false, "error": err.Error()})
	}

	section.TemplateID = templateID
	if err := h.repo.CreateSection(&section); err != nil {
		return c.Status(500).JSON(fiber.Map{"success": false, "error": err.Error()})
	}

	return c.Status(201).JSON(fiber.Map{"success": true, "data": section})
}

// UpdateSection updates an existing summary section
func (h *SummaryConfigHandler) UpdateSection(c *fiber.Ctx) error {
	sectionID, err := uuid.Parse(c.Params("sectionId"))
	if err != nil {
		return c.Status(400).JSON(fiber.Map{"success": false, "error": "Invalid section ID"})
	}

	var section models.SummarySection
	if err := c.BodyParser(&section); err != nil {
		return c.Status(400).JSON(fiber.Map{"success": false, "error": err.Error()})
	}

	section.ID = sectionID
	if err := h.repo.UpdateSection(&section); err != nil {
		return c.Status(500).JSON(fiber.Map{"success": false, "error": err.Error()})
	}

	return c.JSON(fiber.Map{"success": true, "data": section})
}

// DeleteSection deletes a summary section and its items
func (h *SummaryConfigHandler) DeleteSection(c *fiber.Ctx) error {
	sectionID, err := uuid.Parse(c.Params("sectionId"))
	if err != nil {
		return c.Status(400).JSON(fiber.Map{"success": false, "error": "Invalid section ID"})
	}

	if err := h.repo.DeleteSection(sectionID); err != nil {
		return c.Status(500).JSON(fiber.Map{"success": false, "error": err.Error()})
	}

	return c.JSON(fiber.Map{"success": true, "message": "Section deleted"})
}

// CreateSectionItem creates a new item within a section
func (h *SummaryConfigHandler) CreateSectionItem(c *fiber.Ctx) error {
	sectionID, err := uuid.Parse(c.Params("sectionId"))
	if err != nil {
		return c.Status(400).JSON(fiber.Map{"success": false, "error": "Invalid section ID"})
	}

	var item models.SummarySectionItem
	if err := c.BodyParser(&item); err != nil {
		return c.Status(400).JSON(fiber.Map{"success": false, "error": err.Error()})
	}

	item.SectionID = sectionID
	if err := h.repo.CreateSectionItem(&item); err != nil {
		return c.Status(500).JSON(fiber.Map{"success": false, "error": err.Error()})
	}

	return c.Status(201).JSON(fiber.Map{"success": true, "data": item})
}

// UpdateSectionItem updates an existing section item
func (h *SummaryConfigHandler) UpdateSectionItem(c *fiber.Ctx) error {
	itemID, err := uuid.Parse(c.Params("itemId"))
	if err != nil {
		return c.Status(400).JSON(fiber.Map{"success": false, "error": "Invalid item ID"})
	}

	var item models.SummarySectionItem
	if err := c.BodyParser(&item); err != nil {
		return c.Status(400).JSON(fiber.Map{"success": false, "error": err.Error()})
	}

	item.ID = itemID
	if err := h.repo.UpdateSectionItem(&item); err != nil {
		return c.Status(500).JSON(fiber.Map{"success": false, "error": err.Error()})
	}

	return c.JSON(fiber.Map{"success": true, "data": item})
}

// DeleteSectionItem deletes a section item
func (h *SummaryConfigHandler) DeleteSectionItem(c *fiber.Ctx) error {
	itemID, err := uuid.Parse(c.Params("itemId"))
	if err != nil {
		return c.Status(400).JSON(fiber.Map{"success": false, "error": "Invalid item ID"})
	}

	if err := h.repo.DeleteSectionItem(itemID); err != nil {
		return c.Status(500).JSON(fiber.Map{"success": false, "error": err.Error()})
	}

	return c.JSON(fiber.Map{"success": true, "message": "Item deleted"})
}

// CreateChart creates a new summary chart
func (h *SummaryConfigHandler) CreateChart(c *fiber.Ctx) error {
	templateID, err := uuid.Parse(c.Params("templateId"))
	if err != nil {
		return c.Status(400).JSON(fiber.Map{"success": false, "error": "Invalid template ID"})
	}

	var chart models.SummaryChart
	if err := c.BodyParser(&chart); err != nil {
		return c.Status(400).JSON(fiber.Map{"success": false, "error": err.Error()})
	}

	chart.TemplateID = templateID
	if err := h.repo.CreateChart(&chart); err != nil {
		return c.Status(500).JSON(fiber.Map{"success": false, "error": err.Error()})
	}

	return c.Status(201).JSON(fiber.Map{"success": true, "data": chart})
}

// UpdateChart updates an existing chart
func (h *SummaryConfigHandler) UpdateChart(c *fiber.Ctx) error {
	chartID, err := uuid.Parse(c.Params("chartId"))
	if err != nil {
		return c.Status(400).JSON(fiber.Map{"success": false, "error": "Invalid chart ID"})
	}

	var chart models.SummaryChart
	if err := c.BodyParser(&chart); err != nil {
		return c.Status(400).JSON(fiber.Map{"success": false, "error": err.Error()})
	}

	chart.ID = chartID
	if err := h.repo.UpdateChart(&chart); err != nil {
		return c.Status(500).JSON(fiber.Map{"success": false, "error": err.Error()})
	}

	return c.JSON(fiber.Map{"success": true, "data": chart})
}

// DeleteChart deletes a chart
func (h *SummaryConfigHandler) DeleteChart(c *fiber.Ctx) error {
	chartID, err := uuid.Parse(c.Params("chartId"))
	if err != nil {
		return c.Status(400).JSON(fiber.Map{"success": false, "error": "Invalid chart ID"})
	}

	if err := h.repo.DeleteChart(chartID); err != nil {
		return c.Status(500).JSON(fiber.Map{"success": false, "error": err.Error()})
	}

	return c.JSON(fiber.Map{"success": true, "message": "Chart deleted"})
}
