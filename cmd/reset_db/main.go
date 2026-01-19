package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"

	_ "github.com/jackc/pgx/v5/stdlib"
	"github.com/joho/godotenv"
)

func main() {
	// Load .env
	godotenv.Load()

	host := getEnv("DB_HOST", "localhost")
	user := getEnv("DB_USER", "postgres")
	password := os.Getenv("DB_PASSWORD")
	dbname := getEnv("DB_NAME", "pet_care_db")
	port := getEnv("DB_PORT", "5432")

	dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=disable",
		host, user, password, dbname, port)

	db, err := sql.Open("pgx", dsn)
	if err != nil {
		log.Fatalf("Failed to connect: %v", err)
	}
	defer db.Close()

	// Drop all tables
	tables := []string{
		"appointments", "clinic_pets", "clinic_staff", "clinics",
		"species_standards", "calculation_rules", "health_summaries",
		"reminder_logs", "reminders", "activity_photos", "activity_logs",
		"disease_tracking_config", "pet_diseases", "disease_templates",
		"pets", "diseases", "payment_transactions", "user_preferences", "users",
		// Old tables
		"logs", "disease_activities", "activities",
		"logs_old", "disease_activities_old", "pets_old", "activities_old", "diseases_old", "users_old",
	}

	for _, table := range tables {
		_, err := db.Exec(fmt.Sprintf("DROP TABLE IF EXISTS %s CASCADE", table))
		if err != nil {
			log.Printf("Warning: failed to drop %s: %v", table, err)
		} else {
			log.Printf("Dropped table: %s", table)
		}
	}

	// Drop ENUMs
	enums := []string{"subscription_tier", "user_role"}
	for _, enum := range enums {
		_, err := db.Exec(fmt.Sprintf("DROP TYPE IF EXISTS %s CASCADE", enum))
		if err != nil {
			log.Printf("Warning: failed to drop enum %s: %v", enum, err)
		} else {
			log.Printf("Dropped enum: %s", enum)
		}
	}

	log.Println("Database reset completed! Now run: go run cmd/server/main.go")
}

func getEnv(key, defaultVal string) string {
	if val := os.Getenv(key); val != "" {
		return val
	}
	return defaultVal
}
