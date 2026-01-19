package models

import "github.com/google/uuid"

// RegisterRequest represents a user registration request (public - always creates regular user)
type RegisterRequest struct {
	Email    string `json:"email" validate:"required,email"`
	Password string `json:"password" validate:"required,min=8"`
	FullName string `json:"full_name"`
}

// CreateUserRequest represents admin request to create a user with any role
type CreateUserRequest struct {
	Email    string `json:"email" validate:"required,email"`
	Password string `json:"password" validate:"required,min=8"`
	FullName string `json:"full_name"`
	Role     string `json:"role"` // "user", "admin", or "clinic_staff"
}

// UpdateUserRequest represents admin request to update a user
type UpdateUserRequest struct {
	Email    string `json:"email,omitempty"`
	FullName string `json:"full_name,omitempty"`
	Phone    string `json:"phone,omitempty"`
	Role     string `json:"role,omitempty"`
}

// LoginRequest represents a user login request
type LoginRequest struct {
	Email    string `json:"email" validate:"required,email"`
	Password string `json:"password" validate:"required"`
}

// AuthResponse represents the response after successful authentication
type AuthResponse struct {
	User         UserResponse `json:"user"`
	AccessToken  string       `json:"access_token"`
	RefreshToken string       `json:"refresh_token"`
	ExpiresIn    int64        `json:"expires_in"` // seconds until access token expires
}

// UserResponse represents user data in auth responses (without sensitive fields)
type UserResponse struct {
	ID               uuid.UUID        `json:"id"`
	Email            string           `json:"email"`
	FullName         string           `json:"full_name,omitempty"`
	Phone            string           `json:"phone,omitempty"`
	AvatarURL        string           `json:"avatar_url,omitempty"`
	IsActive         bool             `json:"is_active"`
	Role             UserRole         `json:"role"`
	SubscriptionTier SubscriptionTier `json:"subscription_tier"`
}

// ToUserResponse converts a User to UserResponse
func (u *User) ToUserResponse() UserResponse {
	return UserResponse{
		ID:               u.ID,
		Email:            u.Email,
		FullName:         u.FullName,
		Phone:            u.Phone,
		AvatarURL:        u.AvatarURL,
		IsActive:         u.IsActive,
		Role:             u.Role,
		SubscriptionTier: u.SubscriptionTier,
	}
}

// RefreshTokenRequest represents a token refresh request
type RefreshTokenRequest struct {
	RefreshToken string `json:"refresh_token" validate:"required"`
}

// ErrorResponse represents an error response
type ErrorResponse struct {
	Error   string `json:"error"`
	Message string `json:"message,omitempty"`
}
