-- =====================================================
-- Pet Care Super App - Seed Master Data
-- Run after initial migration to populate lookup tables
-- =====================================================

-- Insert common diseases with recommended monitoring
INSERT INTO diseases (name, name_en, category, description, symptoms, recommended_monitoring, is_active) VALUES
    ('โรคไตเรื้อรัง', 'Chronic Kidney Disease', 'kidney', 
     'โรคที่ไตทำงานลดลงอย่างต่อเนื่อง', 
     '["ดื่มน้ำมาก", "ปัสสาวะบ่อย", "น้ำหนักลด", "เบื่ออาหาร", "อาเจียน"]'::jsonb,
     '{"daily": ["water_intake", "food_intake", "urine_output"], "weekly": ["weight", "activity_level"], "monthly": ["blood_test"]}'::jsonb,
     true),
    
    ('เบาหวาน', 'Diabetes Mellitus', 'endocrine',
     'ร่างกายไม่สามารถควบคุมระดับน้ำตาลในเลือดได้',
     '["ดื่มน้ำมาก", "ปัสสาวะบ่อย", "น้ำหนักลดทั้งที่กินเยอะ", "อ่อนแรง"]'::jsonb,
     '{"daily": ["blood_glucose", "insulin_dose", "food_intake"], "weekly": ["weight", "exercise"]}'::jsonb,
     true),
    
    ('โรคหัวใจ', 'Heart Disease', 'cardiovascular',
     'ภาวะที่หัวใจทำงานผิดปกติ',
     '["หายใจลำบาก", "ไอ", "อ่อนแรง", "ท้องบวม", "เป็นลม"]'::jsonb,
     '{"daily": ["breathing_rate", "medication", "activity_level"], "weekly": ["weight"]}'::jsonb,
     true),
    
    ('โรคตับ', 'Liver Disease', 'hepatic',
     'ภาวะที่ตับทำงานผิดปกติ',
     '["ตัวเหลือง", "เบื่ออาหาร", "อาเจียน", "ท้องบวม", "ซึม"]'::jsonb,
     '{"daily": ["food_intake", "medication"], "weekly": ["weight", "stool_quality"], "monthly": ["blood_test"]}'::jsonb,
     true),
    
    ('โรคข้อต่ออักเสบ', 'Arthritis', 'musculoskeletal',
     'ภาวะข้อต่ออักเสบทำให้เจ็บปวด',
     '["เดินกะเผลก", "ไม่อยากขยับ", "ข้อบวม", "หงุดหงิด"]'::jsonb,
     '{"daily": ["pain_level", "mobility_score", "medication"], "weekly": ["activity_duration"]}'::jsonb,
     true),
    
    ('โรคผิวหนัง', 'Skin Disease', 'dermatology',
     'ปัญหาเกี่ยวกับผิวหนังและขน',
     '["คัน", "ขนร่วง", "ผิวแดง", "ตุ่ม", "สะเก็ด"]'::jsonb,
     '{"daily": ["itching_level", "medication"], "weekly": ["skin_condition_photos"]}'::jsonb,
     true);

-- Insert species standards for normal ranges
INSERT INTO species_standards (species, breed, normal_ranges) VALUES
    ('dog', NULL, '{
        "weight_range_kg": {"min": 2, "max": 80},
        "heart_rate_bpm": {"min": 60, "max": 140},
        "breathing_rate_rpm": {"min": 10, "max": 30},
        "temperature_c": {"min": 38.0, "max": 39.2},
        "water_intake_ml_per_kg": {"min": 50, "max": 100}
    }'::jsonb),
    
    ('cat', NULL, '{
        "weight_range_kg": {"min": 2.5, "max": 8},
        "heart_rate_bpm": {"min": 120, "max": 180},
        "breathing_rate_rpm": {"min": 20, "max": 30},
        "temperature_c": {"min": 38.0, "max": 39.2},
        "water_intake_ml_per_kg": {"min": 44, "max": 66}
    }'::jsonb),
    
    ('rabbit', NULL, '{
        "weight_range_kg": {"min": 1, "max": 6},
        "heart_rate_bpm": {"min": 180, "max": 250},
        "breathing_rate_rpm": {"min": 30, "max": 60},
        "temperature_c": {"min": 38.5, "max": 40.0}
    }'::jsonb);

-- Insert default calculation rules for health scoring
INSERT INTO calculation_rules (rule_name, rule_type, conditions, formula, parameters, is_active) VALUES
    ('water_intake_score', 'vital_score', 
     '{"applies_to": ["water_intake"]}'::jsonb,
     'IF value BETWEEN species_min AND species_max THEN 100 ELSE MAX(0, 100 - ABS(value - species_avg) * 2)',
     '{"weight_factor": 0.15}'::jsonb,
     true),
    
    ('weight_change_score', 'vital_score',
     '{"applies_to": ["weight"]}'::jsonb,
     'IF percent_change < 5 THEN 100 ELSE MAX(0, 100 - percent_change * 5)',
     '{"weight_factor": 0.20}'::jsonb,
     true),
    
    ('activity_consistency_score', 'behavior_score',
     '{"applies_to": ["activity_level"]}'::jsonb,
     'AVG(daily_scores) * consistency_multiplier',
     '{"weight_factor": 0.15}'::jsonb,
     true),
    
    ('overall_health_score', 'aggregate',
     '{"combines": ["vital_score", "behavior_score", "symptom_score"]}'::jsonb,
     'SUM(scores * weights) / SUM(weights)',
     '{"min_data_points": 7}'::jsonb,
     true);

-- =====================================================
-- End of Seed Data Script
-- =====================================================
