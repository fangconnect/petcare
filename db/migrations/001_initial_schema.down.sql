-- =====================================================
-- Pet Care Super App - Database Rollback
-- Reverts to original schema from backup tables
-- =====================================================

-- Drop new tables
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

-- Restore old tables
ALTER TABLE IF EXISTS users_old RENAME TO users;
ALTER TABLE IF EXISTS pets_old RENAME TO pets;
ALTER TABLE IF EXISTS logs_old RENAME TO logs;
ALTER TABLE IF EXISTS diseases_old RENAME TO diseases;
ALTER TABLE IF EXISTS activities_old RENAME TO activities;
ALTER TABLE IF EXISTS disease_activities_old RENAME TO disease_activities;

-- Drop ENUMs
DROP TYPE IF EXISTS subscription_tier;
DROP TYPE IF EXISTS user_role;

-- =====================================================
-- End of Rollback Script
-- =====================================================
