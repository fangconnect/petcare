-- =====================================================
-- Pet Care Super App - Fresh Install Script
-- Drops ALL existing tables and creates new schema
-- =====================================================

-- Drop all existing tables (cascade to handle dependencies)
DROP TABLE IF EXISTS appointments CASCADE;
DROP TABLE IF EXISTS clinic_pets CASCADE;
DROP TABLE IF EXISTS clinic_staff CASCADE;
DROP TABLE IF EXISTS clinics CASCADE;
DROP TABLE IF EXISTS species_standards CASCADE;
DROP TABLE IF EXISTS calculation_rules CASCADE;
DROP TABLE IF EXISTS health_summaries CASCADE;
DROP TABLE IF EXISTS reminder_logs CASCADE;
DROP TABLE IF EXISTS reminders CASCADE;
DROP TABLE IF EXISTS activity_photos CASCADE;
DROP TABLE IF EXISTS activity_logs CASCADE;
DROP TABLE IF EXISTS disease_tracking_config CASCADE;
DROP TABLE IF EXISTS pet_diseases CASCADE;
DROP TABLE IF EXISTS disease_templates CASCADE;
DROP TABLE IF EXISTS pets CASCADE;
DROP TABLE IF EXISTS diseases CASCADE;
DROP TABLE IF EXISTS payment_transactions CASCADE;
DROP TABLE IF EXISTS user_preferences CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Drop old tables too (if they exist)
DROP TABLE IF EXISTS logs CASCADE;
DROP TABLE IF EXISTS disease_activities CASCADE;
DROP TABLE IF EXISTS activities CASCADE;
DROP TABLE IF EXISTS logs_old CASCADE;
DROP TABLE IF EXISTS disease_activities_old CASCADE;
DROP TABLE IF EXISTS pets_old CASCADE;
DROP TABLE IF EXISTS activities_old CASCADE;
DROP TABLE IF EXISTS diseases_old CASCADE;
DROP TABLE IF EXISTS users_old CASCADE;

-- Drop ENUMs
DROP TYPE IF EXISTS subscription_tier CASCADE;
DROP TYPE IF EXISTS user_role CASCADE;

-- =====================================================
-- Now run the fresh schema creation
-- =====================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create ENUMs
CREATE TYPE subscription_tier AS ENUM ('free', 'premium');
CREATE TYPE user_role AS ENUM ('user', 'admin', 'clinic_staff');

-- Users table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255),
    phone VARCHAR(50),
    avatar_url TEXT,
    is_active BOOLEAN DEFAULT true,
    role user_role DEFAULT 'user',
    subscription_tier subscription_tier DEFAULT 'free',
    subscription_expires_at TIMESTAMP,
    is_trial_used BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);

-- User Preferences
CREATE TABLE user_preferences (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    notification_settings JSONB DEFAULT '{}',
    display_preferences JSONB DEFAULT '{}',
    language VARCHAR(10) DEFAULT 'th',
    timezone VARCHAR(50) DEFAULT 'Asia/Bangkok',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_user_preferences_user_id ON user_preferences(user_id);
CREATE INDEX idx_user_preferences_notification ON user_preferences USING GIN (notification_settings);

-- Payment Transactions
CREATE TABLE payment_transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    provider VARCHAR(50) NOT NULL,
    transaction_id VARCHAR(255) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'THB',
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_payment_transactions_user_id ON payment_transactions(user_id);

-- Diseases table
CREATE TABLE diseases (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    name_en VARCHAR(255),
    category VARCHAR(100),
    description TEXT,
    symptoms JSONB DEFAULT '[]',
    recommended_monitoring JSONB DEFAULT '{}',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_diseases_name ON diseases(name);
CREATE INDEX idx_diseases_symptoms ON diseases USING GIN (symptoms);

-- Disease Templates
CREATE TABLE disease_templates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    disease_id UUID NOT NULL REFERENCES diseases(id) ON DELETE CASCADE,
    template_name VARCHAR(255) NOT NULL,
    tracking_fields JSONB NOT NULL DEFAULT '[]',
    default_values JSONB DEFAULT '{}',
    validation_rules JSONB DEFAULT '{}',
    version INTEGER DEFAULT 1,
    is_default BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_disease_templates_disease_id ON disease_templates(disease_id);
CREATE INDEX idx_disease_templates_fields ON disease_templates USING GIN (tracking_fields);

-- Pets table
CREATE TABLE pets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    owner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    species VARCHAR(100),
    breed VARCHAR(100),
    birth_date DATE,
    current_weight DECIMAL(10, 2),
    gender VARCHAR(20),
    photo_url TEXT,
    microchip_id VARCHAR(100),
    medical_history JSONB DEFAULT '{}',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_pets_owner_id ON pets(owner_id);
CREATE INDEX idx_pets_medical_history ON pets USING GIN (medical_history);

-- Pet Diseases
CREATE TABLE pet_diseases (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pet_id UUID NOT NULL REFERENCES pets(id) ON DELETE CASCADE,
    disease_id UUID NOT NULL REFERENCES diseases(id) ON DELETE RESTRICT,
    diagnosed_date DATE,
    severity VARCHAR(50),
    notes TEXT,
    is_active BOOLEAN DEFAULT true,
    recovery_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(pet_id, disease_id)
);

CREATE INDEX idx_pet_diseases_pet_id ON pet_diseases(pet_id);
CREATE INDEX idx_pet_diseases_disease_id ON pet_diseases(disease_id);

-- Disease Tracking Config
CREATE TABLE disease_tracking_config (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pet_disease_id UUID NOT NULL REFERENCES pet_diseases(id) ON DELETE CASCADE,
    template_id UUID REFERENCES disease_templates(id) ON DELETE SET NULL,
    custom_fields JSONB DEFAULT '{}',
    tracking_schedule JSONB DEFAULT '{}',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_disease_tracking_pet_disease ON disease_tracking_config(pet_disease_id);

-- Activity Logs
CREATE TABLE activity_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pet_id UUID NOT NULL REFERENCES pets(id) ON DELETE CASCADE,
    pet_disease_id UUID REFERENCES pet_diseases(id) ON DELETE SET NULL,
    activity_type VARCHAR(100) NOT NULL,
    logged_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    activity_data JSONB NOT NULL DEFAULT '{}',
    notes TEXT,
    logged_by UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_activity_logs_pet_id ON activity_logs(pet_id);
CREATE INDEX idx_activity_logs_type ON activity_logs(activity_type);
CREATE INDEX idx_activity_logs_logged_at ON activity_logs(logged_at);
CREATE INDEX idx_activity_logs_data ON activity_logs USING GIN (activity_data);

-- Activity Photos
CREATE TABLE activity_photos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    activity_log_id UUID NOT NULL REFERENCES activity_logs(id) ON DELETE CASCADE,
    photo_url TEXT NOT NULL,
    thumbnail_url TEXT,
    caption TEXT,
    file_size INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_activity_photos_log_id ON activity_photos(activity_log_id);

-- Reminders
CREATE TABLE reminders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pet_id UUID NOT NULL REFERENCES pets(id) ON DELETE CASCADE,
    pet_disease_id UUID REFERENCES pet_diseases(id) ON DELETE SET NULL,
    reminder_type VARCHAR(100) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    scheduled_time TIME NOT NULL,
    frequency VARCHAR(50) NOT NULL DEFAULT 'daily',
    frequency_config JSONB DEFAULT '{}',
    is_active BOOLEAN DEFAULT true,
    start_date DATE NOT NULL,
    end_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_reminders_pet_id ON reminders(pet_id);
CREATE INDEX idx_reminders_is_active ON reminders(is_active);

-- Reminder Logs
CREATE TABLE reminder_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    reminder_id UUID NOT NULL REFERENCES reminders(id) ON DELETE CASCADE,
    scheduled_for TIMESTAMP NOT NULL,
    completed_at TIMESTAMP,
    status VARCHAR(50) DEFAULT 'pending',
    completed_by UUID REFERENCES users(id) ON DELETE SET NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_reminder_logs_reminder_id ON reminder_logs(reminder_id);

-- Health Summaries
CREATE TABLE health_summaries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pet_id UUID NOT NULL REFERENCES pets(id) ON DELETE CASCADE,
    summary_date DATE NOT NULL,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    metrics JSONB NOT NULL DEFAULT '{}',
    health_score DECIMAL(5, 2),
    score_breakdown JSONB DEFAULT '{}',
    assessment TEXT,
    recommendations JSONB DEFAULT '[]',
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    generated_by UUID REFERENCES users(id) ON DELETE SET NULL
);

CREATE INDEX idx_health_summaries_pet_id ON health_summaries(pet_id);
CREATE INDEX idx_health_summaries_date ON health_summaries(summary_date);

-- Calculation Rules
CREATE TABLE calculation_rules (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    rule_name VARCHAR(255) NOT NULL,
    rule_type VARCHAR(100) NOT NULL,
    conditions JSONB DEFAULT '{}',
    formula TEXT,
    parameters JSONB DEFAULT '{}',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Species Standards
CREATE TABLE species_standards (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    species VARCHAR(100) NOT NULL,
    breed VARCHAR(100),
    normal_ranges JSONB NOT NULL DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(species, breed)
);

CREATE INDEX idx_species_standards_species ON species_standards(species);

-- Clinics
CREATE TABLE clinics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    clinic_name VARCHAR(255) NOT NULL,
    license_number VARCHAR(100),
    address TEXT,
    phone VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Clinic Staff
CREATE TABLE clinic_staff (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    clinic_id UUID NOT NULL REFERENCES clinics(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role VARCHAR(100) DEFAULT 'staff',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(clinic_id, user_id)
);

-- Clinic Pets
CREATE TABLE clinic_pets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    clinic_id UUID NOT NULL REFERENCES clinics(id) ON DELETE CASCADE,
    pet_id UUID NOT NULL REFERENCES pets(id) ON DELETE CASCADE,
    patient_id VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(clinic_id, pet_id)
);

-- Appointments
CREATE TABLE appointments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    clinic_id UUID NOT NULL REFERENCES clinics(id) ON DELETE CASCADE,
    pet_id UUID NOT NULL REFERENCES pets(id) ON DELETE CASCADE,
    vet_id UUID REFERENCES users(id) ON DELETE SET NULL,
    appointment_time TIMESTAMP NOT NULL,
    purpose VARCHAR(255),
    status VARCHAR(50) DEFAULT 'scheduled',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_appointments_clinic_id ON appointments(clinic_id);
CREATE INDEX idx_appointments_pet_id ON appointments(pet_id);

-- =====================================================
-- Done! Tables are ready for fresh data
-- =====================================================
SELECT 'Fresh database schema created successfully!' AS status;
