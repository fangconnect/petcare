package http

import (
	"pet-care-backend/internal/usecase"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
)

type LogHandler struct {
	logUsecase usecase.LogUsecase
}

// NewLogHandler creates a new log handler
func NewLogHandler(logUsecase usecase.LogUsecase) *LogHandler {
	return &LogHandler{
		logUsecase: logUsecase,
	}
}

// CreateLog handles POST /api/logs
// Accepts JSON payload matching the ActivityLog struct
func (h *LogHandler) CreateLog(c *fiber.Ctx) error {
	var req usecase.CreateLogRequest

	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"success": false,
			"error":   "Invalid request body",
			"message": err.Error(),
		})
	}

	// Validate required fields
	if req.PetID == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"success": false,
			"error":   "pet_id is required",
		})
	}

	// Validate pet_id is a valid UUID
	if _, err := uuid.Parse(req.PetID); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"success": false,
			"error":   "Invalid pet_id format (must be UUID)",
			"message": err.Error(),
		})
	}

	if req.ActivityType == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"success": false,
			"error":   "activity_type is required",
		})
	}

	if req.LoggedAt == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"success": false,
			"error":   "logged_at is required",
		})
	}

	log, err := h.logUsecase.CreateLog(&req)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"success": false,
			"error":   "Failed to create log",
			"message": err.Error(),
		})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"success": true,
		"data":    log,
	})
}

// GetLogsByPetID handles GET /api/pets/:id/logs
func (h *LogHandler) GetLogsByPetID(c *fiber.Ctx) error {
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

	// Get logs from usecase
	logs, err := h.logUsecase.GetLogsByPetID(petID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"success": false,
			"error":   "Failed to fetch logs",
			"message": err.Error(),
		})
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"success": true,
		"data":    logs,
	})
}

// UpdateLog handles PUT /api/logs/:id
func (h *LogHandler) UpdateLog(c *fiber.Ctx) error {
	// Get log ID from URL parameter
	logIDStr := c.Params("id")
	if logIDStr == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"success": false,
			"error":   "log_id is required",
		})
	}

	// Validate and parse log_id as UUID
	logID, err := uuid.Parse(logIDStr)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"success": false,
			"error":   "Invalid log_id format (must be UUID)",
			"message": err.Error(),
		})
	}

	var req usecase.UpdateLogRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"success": false,
			"error":   "Invalid request body",
			"message": err.Error(),
		})
	}

	log, err := h.logUsecase.UpdateLog(logID, &req)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"success": false,
			"error":   "Failed to update log",
			"message": err.Error(),
		})
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"success": true,
		"data":    log,
	})
}

// DeleteLog handles DELETE /api/logs/:id
func (h *LogHandler) DeleteLog(c *fiber.Ctx) error {
	// Get log ID from URL parameter
	logIDStr := c.Params("id")
	if logIDStr == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"success": false,
			"error":   "log_id is required",
		})
	}

	// Validate and parse log_id as UUID
	logID, err := uuid.Parse(logIDStr)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"success": false,
			"error":   "Invalid log_id format (must be UUID)",
			"message": err.Error(),
		})
	}

	if err := h.logUsecase.DeleteLog(logID); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"success": false,
			"error":   "Failed to delete log",
			"message": err.Error(),
		})
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"success": true,
		"message": "Log deleted successfully",
	})
}
