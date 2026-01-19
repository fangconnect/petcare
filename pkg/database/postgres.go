package database

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	"strings"

	_ "github.com/jackc/pgx/v5/stdlib"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

// Connect initializes and returns a GORM database connection
func Connect() (*gorm.DB, error) {
	var dsn string
	var usingDatabaseURL bool

	// Database connection config (for auto-creation if needed)
	host := getEnv("DB_HOST", "localhost")
	user := getEnv("DB_USER", "postgres")
	password := os.Getenv("DB_PASSWORD") // Not required when using DATABASE_URL
	dbname := getEnv("DB_NAME", "petcare")
	port := getEnv("DB_PORT", "5432")
	sslmode := getEnv("DB_SSLMODE", "disable")

	// Check for DATABASE_URL first (Render.com and other cloud providers)
	if databaseURL := os.Getenv("DATABASE_URL"); databaseURL != "" {
		log.Println("Using DATABASE_URL for database connection")
		dsn = databaseURL
		usingDatabaseURL = true
	} else {
		// Require password when using individual env vars
		if password == "" {
			log.Fatal("Required environment variable 'DB_PASSWORD' is not set. Please check your .env file.")
		}
		// Build DSN for target database
		dsn = fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=%s",
			host, user, password, dbname, port, sslmode)
	}

	// Try to connect to the target database
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Info),
	})
	if err != nil {
		// If database doesn't exist and NOT using DATABASE_URL, try to create it
		// (Cloud providers like Render pre-create the database)
		if !usingDatabaseURL && isDatabaseNotExistError(err) {
			log.Printf("Database '%s' does not exist, creating it...", dbname)
			if err := createDatabase(host, user, password, dbname, port, sslmode); err != nil {
				return nil, fmt.Errorf("failed to create database: %w", err)
			}
			log.Printf("Database '%s' created successfully", dbname)
			// Try connecting again after creating the database
			db, err = gorm.Open(postgres.Open(dsn), &gorm.Config{
				Logger: logger.Default.LogMode(logger.Info),
			})
			if err != nil {
				return nil, fmt.Errorf("failed to connect to database after creation: %w", err)
			}
		} else {
			return nil, fmt.Errorf("failed to connect to database: %w", err)
		}
	}

	// Test the connection
	sqlDB, err := db.DB()
	if err != nil {
		return nil, fmt.Errorf("failed to get database instance: %w", err)
	}

	if err := sqlDB.Ping(); err != nil {
		return nil, fmt.Errorf("failed to ping database: %w", err)
	}

	// Initialize ENUMs before AutoMigrate
	if err := InitEnums(db); err != nil {
		return nil, fmt.Errorf("failed to initialize enums: %w", err)
	}

	return db, nil
}

// InitEnums creates PostgreSQL ENUM types if they don't exist
func InitEnums(db *gorm.DB) error {
	enums := []struct {
		name   string
		values []string
	}{
		{"subscription_tier", []string{"free", "premium"}},
		{"user_role", []string{"user", "admin", "clinic_staff"}},
	}

	for _, enum := range enums {
		// Check if enum exists
		var exists bool
		err := db.Raw("SELECT EXISTS(SELECT 1 FROM pg_type WHERE typname = ?)", enum.name).Scan(&exists).Error
		if err != nil {
			return fmt.Errorf("failed to check if enum %s exists: %w", enum.name, err)
		}

		if !exists {
			// Create the enum
			valuesSQL := "'" + strings.Join(enum.values, "', '") + "'"
			createSQL := fmt.Sprintf("CREATE TYPE %s AS ENUM (%s)", enum.name, valuesSQL)
			if err := db.Exec(createSQL).Error; err != nil {
				return fmt.Errorf("failed to create enum %s: %w", enum.name, err)
			}
			log.Printf("Created ENUM type: %s", enum.name)
		}
	}

	return nil
}

// createDatabase creates the database if it doesn't exist
func createDatabase(host, user, password, dbname, port, sslmode string) error {
	// Connect to default postgres database to create the target database
	defaultDSN := fmt.Sprintf("host=%s user=%s password=%s dbname=postgres port=%s sslmode=%s",
		host, user, password, port, sslmode)

	sqlDB, err := sql.Open("pgx", defaultDSN)
	if err != nil {
		return fmt.Errorf("failed to connect to postgres database: %w", err)
	}
	defer sqlDB.Close()

	// Check if database already exists
	var exists bool
	err = sqlDB.QueryRow(
		"SELECT EXISTS(SELECT 1 FROM pg_database WHERE datname = $1)",
		dbname,
	).Scan(&exists)
	if err != nil {
		return fmt.Errorf("failed to check if database exists: %w", err)
	}

	if exists {
		return nil // Database already exists
	}

	// Create the database
	// Note: Database names cannot be parameterized in PostgreSQL, but dbname comes from env var
	_, err = sqlDB.Exec(fmt.Sprintf(`CREATE DATABASE "%s"`, dbname))
	if err != nil {
		return fmt.Errorf("failed to create database: %w", err)
	}

	return nil
}

// isDatabaseNotExistError checks if the error is due to database not existing
func isDatabaseNotExistError(err error) bool {
	if err == nil {
		return false
	}
	errStr := err.Error()
	return contains(errStr, "does not exist") || contains(errStr, "SQLSTATE 3D000")
}

// contains checks if a string contains a substring
func contains(s, substr string) bool {
	return strings.Contains(s, substr)
}

// getEnv retrieves an environment variable or returns a default value
func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}

// getEnvRequired retrieves an environment variable and returns an error if it's not set
func getEnvRequired(key string) string {
	value := os.Getenv(key)
	if value == "" {
		log.Fatalf("Required environment variable '%s' is not set. Please check your .env file.", key)
	}
	return value
}
