-- =====================================================
-- Pet Care Super App - Database Migration
-- Version: 2.0 (New Schema with Data Migration)
-- =====================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- STEP 1: Create ENUMs
-- =====================================================
DO $$ BEGIN
    CREATE TYPE subscription_tier AS ENUM ('free', 'premium');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE user_role AS ENUM ('user', 'admin', 'clinic_staff');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- =====================================================
-- STEP 2: Backup existing tables (rename)
-- =====================================================
ALTER TABLE IF EXISTS users RENAME TO users_old;
ALTER TABLE IF EXISTS pets RENAME TO pets_old;
ALTER TABLE IF EXISTS logs RENAME TO logs_old;
ALTER TABLE IF EXISTS diseases RENAME TO diseases_old;
ALTER TABLE IF EXISTS activities RENAME TO activities_old;
ALTER TABLE IF EXISTS disease_activities RENAME TO disease_activities_old;

-- =====================================================
-- STEP 3: Create new tables
-- =====================================================

-- Users table (enhanced)
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
CREATE INDEX idx_users_subscription ON users(subscription_tier);

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
CREATE INDEX idx_user_preferences_display ON user_preferences USING GIN (display_preferences);

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
CREATE INDEX idx_payment_transactions_status ON payment_transactions(status);

-- Diseases table (enhanced)
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
CREATE INDEX idx_diseases_category ON diseases(category);
CREATE INDEX idx_diseases_symptoms ON diseases USING GIN (symptoms);
CREATE INDEX idx_diseases_monitoring ON diseases USING GIN (recommended_monitoring);

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

-- Pets table (enhanced)
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
CREATE INDEX idx_pets_species ON pets(species);
CREATE INDEX idx_pets_medical_history ON pets USING GIN (medical_history);

-- Pet Diseases (diagnosed diseases per pet)
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
CREATE INDEX idx_pet_diseases_is_active ON pet_diseases(is_active);

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
CREATE INDEX idx_disease_tracking_custom ON disease_tracking_config USING GIN (custom_fields);
CREATE INDEX idx_disease_tracking_schedule ON disease_tracking_config USING GIN (tracking_schedule);

-- Activity Logs (unified log with JSONB data)
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
CREATE INDEX idx_activity_logs_pet_disease ON activity_logs(pet_disease_id);
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
CREATE INDEX idx_reminders_pet_disease ON reminders(pet_disease_id);
CREATE INDEX idx_reminders_is_active ON reminders(is_active);
CREATE INDEX idx_reminders_frequency ON reminders USING GIN (frequency_config);

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
CREATE INDEX idx_reminder_logs_status ON reminder_logs(status);

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
CREATE INDEX idx_health_summaries_metrics ON health_summaries USING GIN (metrics);
CREATE INDEX idx_health_summaries_breakdown ON health_summaries USING GIN (score_breakdown);

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

CREATE INDEX idx_calculation_rules_type ON calculation_rules(rule_type);
CREATE INDEX idx_calculation_rules_conditions ON calculation_rules USING GIN (conditions);
CREATE INDEX idx_calculation_rules_parameters ON calculation_rules USING GIN (parameters);

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
CREATE INDEX idx_species_standards_ranges ON species_standards USING GIN (normal_ranges);

-- Clinics
CREATE TABLE clinics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    clinic_name VARCHAR(255) NOT NULL,
    license_number VARCHAR(100),
    address TEXT,
    phone VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_clinics_name ON clinics(clinic_name);

-- Clinic Staff
CREATE TABLE clinic_staff (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    clinic_id UUID NOT NULL REFERENCES clinics(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role VARCHAR(100) DEFAULT 'staff',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(clinic_id, user_id)
);

CREATE INDEX idx_clinic_staff_clinic_id ON clinic_staff(clinic_id);
CREATE INDEX idx_clinic_staff_user_id ON clinic_staff(user_id);

-- Clinic Pets
CREATE TABLE clinic_pets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    clinic_id UUID NOT NULL REFERENCES clinics(id) ON DELETE CASCADE,
    pet_id UUID NOT NULL REFERENCES pets(id) ON DELETE CASCADE,
    patient_id VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(clinic_id, pet_id)
);

CREATE INDEX idx_clinic_pets_clinic_id ON clinic_pets(clinic_id);
CREATE INDEX idx_clinic_pets_pet_id ON clinic_pets(pet_id);

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
CREATE INDEX idx_appointments_time ON appointments(appointment_time);
CREATE INDEX idx_appointments_status ON appointments(status);

-- =====================================================
-- STEP 4: Migrate existing data
-- =====================================================

-- Create temporary mapping table for disease ID conversion (int -> uuid)
CREATE TEMP TABLE disease_id_map (
    old_id INTEGER,
    new_id UUID
);

-- Create temporary mapping table for activity type conversion
CREATE TEMP TABLE activity_type_map (
    old_id INTEGER,
    activity_name VARCHAR(255),
    unit VARCHAR(50),
    input_type VARCHAR(50)
);

-- Migrate Users
INSERT INTO users (id, email, password_hash, created_at, updated_at)
SELECT id, email, password_hash, created_at, COALESCE(created_at, CURRENT_TIMESTAMP)
FROM users_old
ON CONFLICT (id) DO NOTHING;

-- Migrate Diseases and create ID mapping
INSERT INTO diseases (id, name, description, created_at, updated_at)
SELECT uuid_generate_v4(), name, description, created_at, COALESCE(updated_at, created_at)
FROM diseases_old;

-- Create disease ID mapping
INSERT INTO disease_id_map (old_id, new_id)
SELECT do.id, d.id
FROM diseases_old do
JOIN diseases d ON d.name = do.name;

-- Store activity type mapping for log migration
INSERT INTO activity_type_map (old_id, activity_name, unit, input_type)
SELECT id, name, unit, input_type
FROM activities_old;

-- Migrate Pets (with disease mapping)
INSERT INTO pets (id, owner_id, name, photo_url, birth_date, created_at, updated_at)
SELECT 
    p.id, 
    p.user_id, 
    p.name, 
    p.image_url, 
    p.birthdate, 
    p.created_at, 
    COALESCE(p.updated_at, p.created_at)
FROM pets_old p
ON CONFLICT (id) DO NOTHING;

-- Create pet_diseases entries from old pet.disease_id relationship
INSERT INTO pet_diseases (pet_id, disease_id, diagnosed_date, is_active, created_at)
SELECT 
    p.id,
    dm.new_id,
    p.created_at::date,
    true,
    p.created_at
FROM pets_old p
JOIN disease_id_map dm ON dm.old_id = p.disease_id
ON CONFLICT (pet_id, disease_id) DO NOTHING;

-- Migrate Logs to activity_logs
INSERT INTO activity_logs (id, pet_id, activity_type, logged_at, activity_data, notes, logged_by, created_at, updated_at)
SELECT 
    l.id,
    l.pet_id,
    COALESCE(atm.activity_name, 'unknown'),
    l.recorded_at,
    jsonb_build_object(
        'value', l.value,
        'unit', atm.unit,
        'input_type', atm.input_type,
        'legacy_activity_id', l.activity_id
    ),
    l.note,
    NULL, -- logged_by wasn't tracked before
    l.created_at,
    COALESCE(l.updated_at, l.created_at)
FROM logs_old l
LEFT JOIN activity_type_map atm ON atm.old_id = l.activity_id
ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- STEP 5: Create default disease templates from old disease_activities
-- =====================================================

INSERT INTO disease_templates (disease_id, template_name, tracking_fields, is_default, created_at)
SELECT 
    dm.new_id,
    d.name || ' - Default Template',
    (
        SELECT jsonb_agg(
            jsonb_build_object(
                'name', atm.activity_name,
                'type', atm.input_type,
                'unit', atm.unit,
                'required', da.is_required
            )
        )
        FROM disease_activities_old da
        JOIN activity_type_map atm ON atm.old_id = da.activity_id
        WHERE da.disease_id = do.id
    ),
    true,
    CURRENT_TIMESTAMP
FROM diseases_old do
JOIN disease_id_map dm ON dm.old_id = do.id
JOIN diseases d ON d.id = dm.new_id
WHERE EXISTS (SELECT 1 FROM disease_activities_old da WHERE da.disease_id = do.id);

-- =====================================================
-- STEP 6: Verify migration counts
-- =====================================================

DO $$
DECLARE
    old_users INTEGER;
    new_users INTEGER;
    old_pets INTEGER;
    new_pets INTEGER;
    old_logs INTEGER;
    new_logs INTEGER;
    old_diseases INTEGER;
    new_diseases INTEGER;
BEGIN
    SELECT COUNT(*) INTO old_users FROM users_old;
    SELECT COUNT(*) INTO new_users FROM users;
    SELECT COUNT(*) INTO old_pets FROM pets_old;
    SELECT COUNT(*) INTO new_pets FROM pets;
    SELECT COUNT(*) INTO old_logs FROM logs_old;
    SELECT COUNT(*) INTO new_logs FROM activity_logs;
    SELECT COUNT(*) INTO old_diseases FROM diseases_old;
    SELECT COUNT(*) INTO new_diseases FROM diseases;
    
    RAISE NOTICE '=== Migration Summary ===';
    RAISE NOTICE 'Users: % -> %', old_users, new_users;
    RAISE NOTICE 'Pets: % -> %', old_pets, new_pets;
    RAISE NOTICE 'Logs: % -> %', old_logs, new_logs;
    RAISE NOTICE 'Diseases: % -> %', old_diseases, new_diseases;
    
    IF old_users != new_users THEN
        RAISE WARNING 'User count mismatch!';
    END IF;
    IF old_pets != new_pets THEN
        RAISE WARNING 'Pet count mismatch!';
    END IF;
    IF old_logs != new_logs THEN
        RAISE WARNING 'Log count mismatch!';
    END IF;
    IF old_diseases != new_diseases THEN
        RAISE WARNING 'Disease count mismatch!';
    END IF;
END $$;

-- =====================================================
-- STEP 7: (Optional) Drop old tables after verification
-- Run this ONLY after confirming data migration is successful
-- =====================================================

-- DROP TABLE IF EXISTS logs_old CASCADE;
-- DROP TABLE IF EXISTS disease_activities_old CASCADE;
-- DROP TABLE IF EXISTS pets_old CASCADE;
-- DROP TABLE IF EXISTS activities_old CASCADE;
-- DROP TABLE IF EXISTS diseases_old CASCADE;
-- DROP TABLE IF EXISTS users_old CASCADE;

-- =====================================================
-- End of Migration Script
-- =====================================================
