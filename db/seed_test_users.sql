-- Test Users for Pet Care Super App
-- Run this after migration to create demo accounts

-- Admin user: admin@petcare.test / password: admin123
INSERT INTO users (id, email, password_hash, full_name, role, subscription_tier, is_active, created_at, updated_at)
VALUES (
    '00000000-0000-0000-0000-000000000002',
    'admin@petcare.test',
    '$2a$10$8K1p/a0dL1LXMIZoC5sK3u.lQcGhZXjKZ7F1G9Y7A6C2k4hN8Y6Pm', -- admin123
    'Admin User',
    'admin',
    'premium',
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
) ON CONFLICT (email) DO UPDATE SET role = 'admin', password_hash = '$2a$10$8K1p/a0dL1LXMIZoC5sK3u.lQcGhZXjKZ7F1G9Y7A6C2k4hN8Y6Pm';

-- Regular user: user@petcare.test / password: user123
INSERT INTO users (id, email, password_hash, full_name, role, subscription_tier, is_active, created_at, updated_at)
VALUES (
    '00000000-0000-0000-0000-000000000003',
    'user@petcare.test',
    '$2a$10$N5e7g.W8oEjP1sKj0F2X/OKC3xYqH8RzS5B4D9VnM7L1wXyJ0TgKe', -- user123
    'Test User',
    'user',
    'free',
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
) ON CONFLICT (email) DO UPDATE SET role = 'user', password_hash = '$2a$10$N5e7g.W8oEjP1sKj0F2X/OKC3xYqH8RzS5B4D9VnM7L1wXyJ0TgKe';

-- Premium user: premium@petcare.test / password: premium123
INSERT INTO users (id, email, password_hash, full_name, role, subscription_tier, subscription_expires_at, is_active, created_at, updated_at)
VALUES (
    '00000000-0000-0000-0000-000000000004',
    'premium@petcare.test',
    '$2a$10$QrS7p.X9vGjK2tLk1H3Y/PKD4yZrI9SzT6C5E0WoN8M2xYzK1UhLf', -- premium123
    'Premium User',
    'user',
    'premium',
    CURRENT_TIMESTAMP + INTERVAL '365 days',
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
) ON CONFLICT (email) DO UPDATE SET 
    role = 'user', 
    subscription_tier = 'premium',
    subscription_expires_at = CURRENT_TIMESTAMP + INTERVAL '365 days',
    password_hash = '$2a$10$QrS7p.X9vGjK2tLk1H3Y/PKD4yZrI9SzT6C5E0WoN8M2xYzK1UhLf';

-- Verify inserted users
SELECT id, email, full_name, role, subscription_tier FROM users WHERE email LIKE '%@petcare.test';
