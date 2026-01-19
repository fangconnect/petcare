package database

import (
	"encoding/json"
	"log"

	"pet-care-backend/internal/models"

	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/datatypes"
	"gorm.io/gorm"
)

// SeedMasterData inserts initial master data if the database is empty
func SeedMasterData(db *gorm.DB) error {
	// Seed activity types first (they are referenced by templates)
	if err := seedActivityTypes(db); err != nil {
		return err
	}

	// Check if diseases table is empty
	var diseaseCount int64
	if err := db.Model(&models.Disease{}).Count(&diseaseCount).Error; err != nil {
		return err
	}

	// Seed diseases if empty
	if diseaseCount == 0 {
		diseases := []models.Disease{
			{
				Name:        "โรคไตเรื้อรัง",
				NameEN:      "Kidney Disease (CKD)",
				Category:    "kidney",
				Description: "Chronic Kidney Disease management for pets",
				Symptoms:    datatypes.JSON(mustMarshalJSON([]string{"ดื่มน้ำมาก", "ปัสสาวะบ่อย", "น้ำหนักลด"})),
				RecommendedMonitoring: datatypes.JSON(mustMarshalJSON(map[string]interface{}{
					"daily":   []string{"water_intake", "food_intake"},
					"weekly":  []string{"weight"},
					"monthly": []string{"blood_test"},
				})),
				IsActive: true,
			},
			{
				Name:        "เบาหวาน",
				NameEN:      "Diabetes Mellitus",
				Category:    "endocrine",
				Description: "ร่างกายไม่สามารถควบคุมระดับน้ำตาลในเลือดได้",
				Symptoms:    datatypes.JSON(mustMarshalJSON([]string{"ดื่มน้ำมาก", "ปัสสาวะบ่อย", "น้ำหนักลด"})),
				IsActive:    true,
			},
		}

		for _, disease := range diseases {
			if err := db.Create(&disease).Error; err != nil {
				return err
			}
			log.Printf("Seeded disease: %s", disease.Name)
		}
	}

	// Get Kidney Disease for creating template
	var kidneyDisease models.Disease
	if err := db.Where("name = ?", "โรคไตเรื้อรัง").First(&kidneyDisease).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			log.Println("Warning: Kidney Disease not found, skipping template creation")
		}
	} else {
		// Create disease template if none exists
		var templateCount int64
		if err := db.Model(&models.DiseaseTemplate{}).Where("disease_id = ?", kidneyDisease.ID).Count(&templateCount).Error; err != nil {
			return err
		}

		if templateCount == 0 {
			// Create simplified template
			template := models.DiseaseTemplate{
				DiseaseID:    kidneyDisease.ID,
				TemplateName: "Default CKD Tracking",
				Description:  "Template for tracking Chronic Kidney Disease",
				IsDefault:    true,
				Version:      1,
			}

			if err := db.Create(&template).Error; err != nil {
				return err
			}

			// Link to relevant activity types by name_en
			activityNames := []string{"Saline", "Weight", "Food Intake", "Water Intake", "Medication", "Urination", "Defecation"}
			for i, name := range activityNames {
				var activityType models.ActivityType
				if err := db.Where("name_en = ?", name).First(&activityType).Error; err == nil {
					link := models.DiseaseTemplateActivityType{
						TemplateID:     template.ID,
						ActivityTypeID: activityType.ID,
						IsRequired:     name == "Saline" || name == "Weight",
						SortOrder:      i,
					}
					db.Create(&link)
				}
			}

			log.Println("Created default tracking template for Kidney Disease with activity type links")
		}
	}

	// Seed species standards if not exists
	var standardCount int64
	if err := db.Model(&models.SpeciesStandard{}).Count(&standardCount).Error; err != nil {
		return err
	}

	if standardCount == 0 {
		standards := []models.SpeciesStandard{
			{
				Species: "dog",
				NormalRanges: datatypes.JSON(mustMarshalJSON(map[string]interface{}{
					"weight_range_kg":        map[string]float64{"min": 2, "max": 80},
					"heart_rate_bpm":         map[string]int{"min": 60, "max": 140},
					"breathing_rate_rpm":     map[string]int{"min": 10, "max": 30},
					"water_intake_ml_per_kg": map[string]int{"min": 50, "max": 100},
				})),
			},
			{
				Species: "cat",
				NormalRanges: datatypes.JSON(mustMarshalJSON(map[string]interface{}{
					"weight_range_kg":        map[string]float64{"min": 2.5, "max": 8},
					"heart_rate_bpm":         map[string]int{"min": 120, "max": 180},
					"breathing_rate_rpm":     map[string]int{"min": 20, "max": 30},
					"water_intake_ml_per_kg": map[string]int{"min": 44, "max": 66},
				})),
			},
		}

		for _, std := range standards {
			if err := db.Create(&std).Error; err != nil {
				return err
			}
			log.Printf("Seeded species standard: %s", std.Species)
		}
	}

	// Seed demo user if not exists
	if err := seedDemoUser(db); err != nil {
		return err
	}

	// Seed admin user if not exists
	if err := seedAdminUser(db); err != nil {
		return err
	}

	return nil
}

// mustMarshalJSON marshals to JSON or panics
func mustMarshalJSON(v interface{}) []byte {
	b, err := json.Marshal(v)
	if err != nil {
		panic(err)
	}
	return b
}

// seedDemoUser creates a demo user if it doesn't exist
func seedDemoUser(db *gorm.DB) error {
	demoEmail := "demo@test.com"
	demoPassword := "password"
	demoUUID := uuid.MustParse("00000000-0000-0000-0000-000000000001")

	// Check if user with email already exists
	var existingUser models.User
	err := db.Where("email = ?", demoEmail).First(&existingUser).Error
	if err == nil {
		log.Printf("Demo User ID: %s", existingUser.ID.String())
		return nil
	}
	if err != gorm.ErrRecordNotFound {
		return err
	}

	// Check if UUID is already taken
	err = db.Where("id = ?", demoUUID).First(&existingUser).Error
	if err == nil {
		log.Printf("Demo User ID: %s", demoUUID.String())
		return nil
	}
	if err != gorm.ErrRecordNotFound {
		return err
	}

	// Hash the password using bcrypt
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(demoPassword), bcrypt.DefaultCost)
	if err != nil {
		log.Printf("Warning: Failed to hash password, using plain text for MVP")
		hashedPassword = []byte(demoPassword)
	}

	// Create demo user with free subscription
	demoUser := models.User{
		ID:               demoUUID,
		Email:            demoEmail,
		PasswordHash:     string(hashedPassword),
		FullName:         "Demo User",
		IsActive:         true,
		Role:             models.RoleUser,
		SubscriptionTier: models.SubscriptionFree,
	}

	if err := db.Create(&demoUser).Error; err != nil {
		return err
	}

	log.Printf("Seeded demo user with email: %s", demoEmail)
	log.Printf("Demo User ID: %s", demoUser.ID.String())

	return nil
}

// seedAdminUser creates an admin user if it doesn't exist
func seedAdminUser(db *gorm.DB) error {
	adminEmail := "admin@petcare.test"
	adminPassword := "admin123"
	adminUUID := uuid.MustParse("00000000-0000-0000-0000-000000000002")

	// Check if user with email already exists
	var existingUser models.User
	err := db.Where("email = ?", adminEmail).First(&existingUser).Error
	if err == nil {
		// Update to admin role if not already
		if existingUser.Role != models.RoleAdmin {
			existingUser.Role = models.RoleAdmin
			db.Save(&existingUser)
			log.Printf("Updated user %s to admin role", adminEmail)
		}
		log.Printf("Admin User ID: %s", existingUser.ID.String())
		return nil
	}
	if err != gorm.ErrRecordNotFound {
		return err
	}

	// Hash the password using bcrypt
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(adminPassword), bcrypt.DefaultCost)
	if err != nil {
		log.Printf("Warning: Failed to hash admin password")
		return err
	}

	// Create admin user
	adminUser := models.User{
		ID:               adminUUID,
		Email:            adminEmail,
		PasswordHash:     string(hashedPassword),
		FullName:         "Admin User",
		IsActive:         true,
		Role:             models.RoleAdmin,
		SubscriptionTier: models.SubscriptionPremium,
	}

	if err := db.Create(&adminUser).Error; err != nil {
		return err
	}

	log.Printf("Seeded admin user with email: %s", adminEmail)
	log.Printf("Admin User ID: %s", adminUser.ID.String())

	return nil
}

// seedActivityTypes seeds the initial activity types with their units
func seedActivityTypes(db *gorm.DB) error {
	// Check if already seeded
	var count int64
	if err := db.Model(&models.ActivityType{}).Count(&count).Error; err != nil {
		return err
	}
	if count > 0 {
		log.Printf("Activity types already seeded (%d found)", count)
		return nil
	}

	// Step 1: Seed Units
	units := []models.Unit{
		// Volume
		{Name: "ml", NameEN: "Milliliter", Symbol: "ml", Category: "volume"},
		{Name: "bag", NameEN: "Bag", Symbol: "bag", Category: "volume"},
		// Weight
		{Name: "g", NameEN: "Gram", Symbol: "g", Category: "weight"},
		{Name: "kg", NameEN: "Kilogram", Symbol: "kg", Category: "weight"},
		// Count
		{Name: "times", NameEN: "Times", Symbol: "times", Category: "count"},
		{Name: "portion", NameEN: "Portion", Symbol: "portion", Category: "count"},
		// Medical units
		{Name: "tabs", NameEN: "Tablets", Symbol: "tabs", Category: "medical"},
		{Name: "IM", NameEN: "Intramuscular", Symbol: "IM", Category: "medical"},
		{Name: "SC", NameEN: "Subcutaneous", Symbol: "SC", Category: "medical"},
		{Name: "IV", NameEN: "Intravenous", Symbol: "IV", Category: "medical"},
		{Name: "drops", NameEN: "Drops", Symbol: "drops", Category: "medical"},
		// Time
		{Name: "min", NameEN: "Minutes", Symbol: "min", Category: "time"},
		{Name: "hrs", NameEN: "Hours", Symbol: "hrs", Category: "time"},
		// Scale
		{Name: "/10", NameEN: "Scale 1-10", Symbol: "/10", Category: "scale"},
		// Rate
		{Name: "bpm", NameEN: "Breaths per Minute", Symbol: "bpm", Category: "rate"},
	}

	unitMap := make(map[string]*models.Unit) // name -> Unit
	for i := range units {
		if err := db.Create(&units[i]).Error; err != nil {
			return err
		}
		unitMap[units[i].Name] = &units[i]
	}
	log.Printf("Seeded %d units", len(units))

	// Step 2: Define activity types with their unit mappings
	type activityDef struct {
		activity models.ActivityType
		units    []string // unit names, first one is default
	}

	definitions := []activityDef{
		// Intake
		{models.ActivityType{Name: "น้ำดื่ม", NameEN: "Water Intake", InputType: models.InputTypeNumber, Category: models.CategoryIntake, SortOrder: 1}, []string{"ml", "times"}},
		{models.ActivityType{Name: "อาหาร", NameEN: "Food Intake", InputType: models.InputTypeNumber, Category: models.CategoryIntake, SortOrder: 2}, []string{"g", "ml", "portion"}},
		{models.ActivityType{Name: "น้ำเกลือ", NameEN: "Saline", InputType: models.InputTypeNumber, Category: models.CategoryIntake, SortOrder: 3}, []string{"ml", "bag"}},

		// Excretion
		{models.ActivityType{Name: "ปัสสาวะ", NameEN: "Urination", InputType: models.InputTypeNumber, Category: models.CategoryExcretion, SortOrder: 10}, []string{"times"}},
		{models.ActivityType{Name: "อุจจาระ", NameEN: "Defecation", InputType: models.InputTypeNumber, Category: models.CategoryExcretion, SortOrder: 11}, []string{"times"}},
		{models.ActivityType{Name: "อาเจียน", NameEN: "Vomiting", InputType: models.InputTypeNumber, Category: models.CategoryExcretion, SortOrder: 12}, []string{"times"}},

		// Vital
		{models.ActivityType{Name: "น้ำหนัก", NameEN: "Weight", InputType: models.InputTypeNumber, Category: models.CategoryVital, SortOrder: 20}, []string{"kg"}},
		{models.ActivityType{Name: "อัตราการหายใจ", NameEN: "Breathing Rate", InputType: models.InputTypeNumber, Category: models.CategoryVital, SortOrder: 21}, []string{"bpm"}},

		// Medical
		{models.ActivityType{Name: "ยา", NameEN: "Medication", InputType: models.InputTypeMedication, Category: models.CategoryMedical, SortOrder: 30}, []string{"tabs", "ml", "IM", "SC", "IV", "drops"}},
		{models.ActivityType{Name: "อาการ", NameEN: "Symptom", InputType: models.InputTypeText, Category: models.CategoryMedical, SortOrder: 31}, nil},

		// Behavior
		{models.ActivityType{Name: "ออกกำลังกาย", NameEN: "Exercise", InputType: models.InputTypeNumber, Category: models.CategoryBehavior, SortOrder: 40}, []string{"min"}},
		{models.ActivityType{Name: "นอน", NameEN: "Sleep", InputType: models.InputTypeNumber, Category: models.CategoryBehavior, SortOrder: 41}, []string{"hrs"}},
		{models.ActivityType{Name: "ความอยากอาหาร", NameEN: "Appetite Level", InputType: models.InputTypeNumber, Category: models.CategoryBehavior, SortOrder: 42}, []string{"/10"}},
		{models.ActivityType{Name: "อารมณ์", NameEN: "Mood", InputType: models.InputTypeNumber, Category: models.CategoryBehavior, SortOrder: 43}, []string{"/10"}},
		{models.ActivityType{Name: "ระดับพลังงาน", NameEN: "Energy Level", InputType: models.InputTypeNumber, Category: models.CategoryBehavior, SortOrder: 44}, []string{"/10"}},
		{models.ActivityType{Name: "ระดับความเจ็บปวด", NameEN: "Pain Level", InputType: models.InputTypeNumber, Category: models.CategoryBehavior, SortOrder: 45}, []string{"/10"}},
		{models.ActivityType{Name: "ความวิตกกังวล", NameEN: "Anxiety", InputType: models.InputTypeNumber, Category: models.CategoryBehavior, SortOrder: 46}, []string{"/10"}},
		{models.ActivityType{Name: "พฤติกรรม", NameEN: "Behavior Note", InputType: models.InputTypeText, Category: models.CategoryBehavior, SortOrder: 47}, nil},

		// Other
		{models.ActivityType{Name: "อื่นๆ", NameEN: "Other", InputType: models.InputTypePhoto, Category: models.CategoryOther, SortOrder: 99}, nil},
	}

	// Step 3: Create activity types and link to units
	for _, def := range definitions {
		def.activity.IsActive = true
		if err := db.Create(&def.activity).Error; err != nil {
			return err
		}

		// Link units
		for i, unitName := range def.units {
			if unit, ok := unitMap[unitName]; ok {
				link := models.ActivityTypeUnit{
					ActivityTypeID: def.activity.ID,
					UnitID:         unit.ID,
					IsDefault:      i == 0, // First unit is default
					SortOrder:      i,
				}
				if err := db.Create(&link).Error; err != nil {
					return err
				}
			}
		}
	}

	log.Printf("Seeded %d activity types with unit mappings", len(definitions))
	return nil
}
