package http

import (
	"pet-care-backend/internal/usecase"

	"github.com/gofiber/fiber/v2"
)

type ConfigHandler struct {
	configUsecase usecase.ConfigUsecase
}

// NewConfigHandler creates a new config handler
func NewConfigHandler(configUsecase usecase.ConfigUsecase) *ConfigHandler {
	return &ConfigHandler{
		configUsecase: configUsecase,
	}
}

// GetAllDiseases handles GET /api/configs/diseases
func (h *ConfigHandler) GetAllDiseases(c *fiber.Ctx) error {
	diseases, err := h.configUsecase.GetAllDiseases()
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to fetch diseases",
			"message": err.Error(),
		})
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"success": true,
		"data":    diseases,
	})
}
