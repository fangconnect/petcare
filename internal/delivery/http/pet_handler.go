package http

import (
	"pet-care-backend/internal/usecase"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
)

type PetHandler struct {
	petUsecase usecase.PetUsecase
}

// NewPetHandler creates a new pet handler
func NewPetHandler(petUsecase usecase.PetUsecase) *PetHandler {
	return &PetHandler{
		petUsecase: petUsecase,
	}
}

// CreatePet handles POST /api/pets
func (h *PetHandler) CreatePet(c *fiber.Ctx) error {
	var req usecase.CreatePetRequest

	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"success": false,
			"error":   "Invalid request body",
			"message": err.Error(),
		})
	}

	// Validate required fields
	if req.OwnerID == uuid.Nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"success": false,
			"error":   "owner_id is required",
		})
	}

	if req.Name == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"success": false,
			"error":   "name is required",
		})
	}

	pet, err := h.petUsecase.CreatePet(&req)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"success": false,
			"error":   "Failed to create pet",
			"message": err.Error(),
		})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"success": true,
		"data":    pet,
	})
}

// GetPetsByUserID handles GET /api/users/:id/pets
func (h *PetHandler) GetPetsByUserID(c *fiber.Ctx) error {
	userIDStr := c.Params("id")

	userID, err := uuid.Parse(userIDStr)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"success": false,
			"error":   "Invalid user ID format",
			"message": err.Error(),
		})
	}

	pets, err := h.petUsecase.GetPetsByUserID(userID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"success": false,
			"error":   "Failed to fetch pets",
			"message": err.Error(),
		})
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"success": true,
		"data":    pets,
	})
}
