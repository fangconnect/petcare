package http

import (
	"strconv"

	"pet-care-backend/internal/usecase"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
)

// SummaryHandler handles summary-related HTTP requests
type SummaryHandler struct {
	summaryUsecase usecase.SummaryUsecase
}

// NewSummaryHandler creates a new summary handler
func NewSummaryHandler(summaryUsecase usecase.SummaryUsecase) *SummaryHandler {
	return &SummaryHandler{
		summaryUsecase: summaryUsecase,
	}
}

// GetPetSummary handles GET /api/pets/:id/summary
func (h *SummaryHandler) GetPetSummary(c *fiber.Ctx) error {
	// Get pet ID from URL parameter
	petIDStr := c.Params("id")
	if petIDStr == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"success": false,
			"error":   "pet_id is required",
		})
	}

	// Validate and parse pet_id as UUID
	petID, err := uuid.Parse(petIDStr)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"success": false,
			"error":   "Invalid pet_id format (must be UUID)",
			"message": err.Error(),
		})
	}

	// Get days parameter (default to 7)
	daysStr := c.Query("days", "7")
	days, err := strconv.Atoi(daysStr)
	if err != nil || days < 1 {
		days = 7
	}

	// Get summary from usecase
	summary, err := h.summaryUsecase.GetPetSummary(petID, days)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"success": false,
			"error":   "Failed to generate summary",
			"message": err.Error(),
		})
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"success": true,
		"data":    summary,
	})
}
