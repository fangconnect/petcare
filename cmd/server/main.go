package main

import (
	"log"

	"pet-care-backend/internal/config"
	"pet-care-backend/internal/delivery/http"
	"pet-care-backend/internal/models"
	"pet-care-backend/internal/repository"
	"pet-care-backend/internal/usecase"
	"pet-care-backend/pkg/database"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
)

func main() {
	// Load configuration
	cfg, err := config.Load()
	if err != nil {
		log.Fatalf("Failed to load configuration: %v", err)
	}
	log.Printf("Environment: %s", cfg.Environment)

	// Load JWT configuration
	jwtConfig := config.LoadJWTConfig()
	log.Println("JWT configuration loaded")

	// Connect to database
	db, err := database.Connect()
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}
	log.Println("Database connected successfully")

	// AutoMigrate all entities (21 tables)
	if err := db.AutoMigrate(
		// User-related
		&models.User{},
		&models.UserPreference{},
		&models.PaymentTransaction{},
		// Pet-related
		&models.Pet{},
		// Disease-related
		&models.Disease{},
		&models.DiseaseTemplate{},
		&models.PetDisease{},
		&models.DiseaseTrackingConfig{},
		// Activity tracking
		&models.ActivityLog{},
		&models.ActivityPhoto{},
		// Reminders
		&models.Reminder{},
		&models.ReminderLog{},
		// Health & Analytics
		&models.HealthSummary{},
		&models.CalculationRule{},
		&models.SpeciesStandard{},
		// Clinic management
		&models.Clinic{},
		&models.ClinicStaff{},
		&models.ClinicPet{},
		&models.Appointment{},
		// Activity Type management
		&models.Unit{},
		&models.ActivityType{},
		&models.ActivityTypeUnit{},
		// Template Activity Type linking
		&models.DiseaseTemplateActivityType{},
		// Summary Config (customizable health summary)
		&models.SummarySection{},
		&models.SummarySectionItem{},
		&models.SummaryChart{},
	); err != nil {
		log.Fatalf("Failed to migrate database: %v", err)
	}
	log.Println("Database migration completed (25 tables)")

	// Seed master data if database is empty
	if err := database.SeedMasterData(db); err != nil {
		log.Fatalf("Failed to seed master data: %v", err)
	}
	log.Println("Master data seeding completed")

	// Initialize Clean Architecture layers
	// Repository layer
	authRepo := repository.NewAuthRepository(db)
	configRepo := repository.NewConfigRepository(db)
	petRepo := repository.NewPetRepository(db)
	logRepo := repository.NewLogRepository(db)
	diseaseRepo := repository.NewDiseaseRepository(db)
	templateRepo := repository.NewTemplateRepository(db)
	activityTypeRepo := repository.NewActivityTypeRepository(db)
	speciesStandardRepo := repository.NewSpeciesStandardRepository(db)
	unitRepo := repository.NewUnitRepository(db)
	trackingConfigRepo := repository.NewTrackingConfigRepository(db)
	summaryConfigRepo := repository.NewSummaryConfigRepository(db)

	// Usecase layer
	authUsecase := usecase.NewAuthUsecase(authRepo, jwtConfig)
	configUsecase := usecase.NewConfigUsecase(configRepo)
	petUsecase := usecase.NewPetUsecase(petRepo, trackingConfigRepo)
	logUsecase := usecase.NewLogUsecase(logRepo)
	summaryUsecase := usecase.NewSummaryUsecase(logRepo, trackingConfigRepo)
	diseaseUsecase := usecase.NewDiseaseUsecase(diseaseRepo)
	templateUsecase := usecase.NewTemplateUsecase(templateRepo)
	activityTypeUsecase := usecase.NewActivityTypeUsecase(activityTypeRepo, unitRepo)
	speciesStandardUsecase := usecase.NewSpeciesStandardUsecase(speciesStandardRepo)
	unitUsecase := usecase.NewUnitUsecase(unitRepo)

	// Handler layer
	authHandler := http.NewAuthHandler(authUsecase)
	configHandler := http.NewConfigHandler(configUsecase)
	petHandler := http.NewPetHandler(petUsecase)
	logHandler := http.NewLogHandler(logUsecase)
	summaryHandler := http.NewSummaryHandler(summaryUsecase)
	diseaseHandler := http.NewDiseaseHandler(diseaseUsecase)
	templateHandler := http.NewTemplateHandler(templateUsecase)
	activityTypeHandler := http.NewActivityTypeHandler(activityTypeUsecase)
	speciesStandardHandler := http.NewSpeciesStandardHandler(speciesStandardUsecase)
	unitHandler := http.NewUnitHandler(unitUsecase)
	trackingConfigHandler := http.NewTrackingConfigHandler(trackingConfigRepo)
	summaryConfigHandler := http.NewSummaryConfigHandler(summaryConfigRepo)

	// Initialize Fiber app
	app := fiber.New()

	// CORS middleware
	app.Use(cors.New(cors.Config{
		AllowOrigins: "*",
		AllowHeaders: "Origin, Content-Type, Accept, Authorization",
		AllowMethods: "GET, POST, PUT, DELETE, OPTIONS",
	}))

	// API routes
	api := app.Group("/api")

	// ==========================================
	// Public Auth routes (no authentication required)
	// ==========================================
	auth := api.Group("/auth")
	auth.Post("/register", authHandler.Register)
	auth.Post("/login", authHandler.Login)
	auth.Post("/refresh", authHandler.RefreshToken)

	// ==========================================
	// Protected routes (requires authentication)
	// ==========================================

	// Auth - Get current user (protected)
	authProtected := api.Group("/auth")
	authProtected.Use(http.JWTProtected(authUsecase))
	authProtected.Get("/me", authHandler.GetCurrentUser)

	// Config routes (public for now - diseases list)
	configs := api.Group("/configs")
	configs.Get("/diseases", configHandler.GetAllDiseases)

	// Pet routes (protected)
	pets := api.Group("/pets")
	pets.Use(http.JWTProtected(authUsecase))
	pets.Post("/", petHandler.CreatePet)
	pets.Get("/:id/logs", logHandler.GetLogsByPetID)
	pets.Get("/:id/summary", summaryHandler.GetPetSummary)
	pets.Get("/:id/template-activity-types", trackingConfigHandler.GetPetTemplateActivityTypes)
	pets.Get("/:id/diseases/:diseaseId/tracking-config", trackingConfigHandler.GetTrackingConfig)
	pets.Put("/:id/diseases/:diseaseId/tracking-config", trackingConfigHandler.SetTrackingConfig)

	// User routes (protected)
	users := api.Group("/users")
	users.Use(http.JWTProtected(authUsecase))
	users.Get("/:id/pets", petHandler.GetPetsByUserID)

	// Log routes (protected)
	logs := api.Group("/logs")
	logs.Use(http.JWTProtected(authUsecase))
	logs.Post("/", logHandler.CreateLog)
	logs.Put("/:id", logHandler.UpdateLog)
	logs.Delete("/:id", logHandler.DeleteLog)

	// ==========================================
	// Admin routes (requires admin role)
	// ==========================================
	admin := api.Group("/admin")
	admin.Use(http.JWTProtected(authUsecase))
	admin.Use(http.RequireRole("admin"))

	// Disease management
	admin.Get("/diseases", diseaseHandler.GetAllDiseases)
	admin.Get("/diseases/:id", diseaseHandler.GetDiseaseByID)
	admin.Post("/diseases", diseaseHandler.CreateDisease)
	admin.Put("/diseases/:id", diseaseHandler.UpdateDisease)
	admin.Delete("/diseases/:id", diseaseHandler.DeleteDisease)

	// Template management
	admin.Get("/diseases/:id/templates", templateHandler.GetTemplatesByDiseaseID)
	admin.Get("/templates/:id", templateHandler.GetTemplateByID)
	admin.Post("/templates", templateHandler.CreateTemplate)
	admin.Put("/templates/:id", templateHandler.UpdateTemplate)
	admin.Delete("/templates/:id", templateHandler.DeleteTemplate)
	admin.Post("/templates/:id/set-default", templateHandler.SetDefaultTemplate)

	// User management (admin-only)
	admin.Get("/users", authHandler.GetAllUsers)
	admin.Post("/users", authHandler.CreateUser)
	admin.Put("/users/:id", authHandler.UpdateUser)
	admin.Put("/users/:id/toggle-active", authHandler.ToggleUserActive)

	// Activity Type management
	admin.Get("/activity-types", activityTypeHandler.GetAll)
	admin.Get("/activity-types/:id", activityTypeHandler.GetByID)
	admin.Post("/activity-types", activityTypeHandler.Create)
	admin.Put("/activity-types/:id", activityTypeHandler.Update)
	admin.Delete("/activity-types/:id", activityTypeHandler.Delete)

	// Species Standards management
	admin.Get("/species-standards", speciesStandardHandler.GetAll)
	admin.Get("/species-standards/:id", speciesStandardHandler.GetByID)
	admin.Post("/species-standards", speciesStandardHandler.Create)
	admin.Put("/species-standards/:id", speciesStandardHandler.Update)
	admin.Delete("/species-standards/:id", speciesStandardHandler.Delete)

	// Unit management
	admin.Get("/units", unitHandler.GetAll)
	admin.Get("/units/:id", unitHandler.GetByID)
	admin.Post("/units", unitHandler.Create)
	admin.Put("/units/:id", unitHandler.Update)
	admin.Delete("/units/:id", unitHandler.Delete)

	// Summary Config management (customizable health summary per template)
	admin.Get("/templates/:templateId/summary-config", summaryConfigHandler.GetConfig)
	admin.Post("/templates/:templateId/summary-sections", summaryConfigHandler.CreateSection)
	admin.Put("/summary-sections/:sectionId", summaryConfigHandler.UpdateSection)
	admin.Delete("/summary-sections/:sectionId", summaryConfigHandler.DeleteSection)
	admin.Post("/summary-sections/:sectionId/items", summaryConfigHandler.CreateSectionItem)
	admin.Put("/summary-section-items/:itemId", summaryConfigHandler.UpdateSectionItem)
	admin.Delete("/summary-section-items/:itemId", summaryConfigHandler.DeleteSectionItem)
	admin.Post("/templates/:templateId/summary-charts", summaryConfigHandler.CreateChart)
	admin.Put("/summary-charts/:chartId", summaryConfigHandler.UpdateChart)
	admin.Delete("/summary-charts/:chartId", summaryConfigHandler.DeleteChart)

	// Hello World route (public)
	app.Get("/", func(c *fiber.Ctx) error {
		return c.JSON(fiber.Map{
			"message": "Pet Care API - v1.0",
			"status":  "running",
		})
	})

	// Start server on port 3000
	log.Println("Server starting on :3000")
	log.Println("Auth endpoints: /api/auth/register, /api/auth/login, /api/auth/refresh, /api/auth/me")
	if err := app.Listen(":3000"); err != nil {
		log.Fatal(err)
	}
}
