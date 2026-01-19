package usecase

import (
	"errors"
	"strings"

	"pet-care-backend/internal/config"
	"pet-care-backend/internal/models"
	"pet-care-backend/internal/repository"

	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"
)

// Common auth errors
var (
	ErrEmailAlreadyExists = errors.New("email already exists")
	ErrUserNotFound       = errors.New("user not found")
	ErrInvalidCredentials = errors.New("invalid credentials")
	ErrInvalidToken       = errors.New("invalid token")
	ErrUserInactive       = errors.New("user account is inactive")
)

// AuthUsecase defines auth business logic
type AuthUsecase interface {
	Register(req *models.RegisterRequest) (*models.AuthResponse, error)
	Login(req *models.LoginRequest) (*models.AuthResponse, error)
	RefreshToken(refreshToken string) (*models.AuthResponse, error)
	GetUserByID(id uuid.UUID) (*models.User, error)
	ValidateToken(token string) (*config.Claims, error)
	// Admin user management
	CreateUser(req *models.CreateUserRequest) (*models.User, error)
	GetAllUsers() ([]models.User, error)
	UpdateUser(id uuid.UUID, req *models.UpdateUserRequest) (*models.User, error)
	ToggleUserActive(id uuid.UUID) (*models.User, error)
}

type authUsecase struct {
	authRepo  repository.AuthRepository
	jwtConfig *config.JWTConfig
}

// NewAuthUsecase creates a new auth usecase
func NewAuthUsecase(authRepo repository.AuthRepository, jwtConfig *config.JWTConfig) AuthUsecase {
	return &authUsecase{
		authRepo:  authRepo,
		jwtConfig: jwtConfig,
	}
}

// Register creates a new user account (always as regular user)
func (u *authUsecase) Register(req *models.RegisterRequest) (*models.AuthResponse, error) {
	// Normalize email
	email := strings.ToLower(strings.TrimSpace(req.Email))

	// Check if email exists
	exists, err := u.authRepo.EmailExists(email)
	if err != nil {
		return nil, err
	}
	if exists {
		return nil, ErrEmailAlreadyExists
	}

	// Hash password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		return nil, err
	}

	// Create user (always as regular user - admin must use CreateUser endpoint)
	user := &models.User{
		Email:        email,
		PasswordHash: string(hashedPassword),
		FullName:     strings.TrimSpace(req.FullName),
		IsActive:     true,
		Role:         models.RoleUser,
	}

	if err := u.authRepo.CreateUser(user); err != nil {
		return nil, err
	}

	// Generate tokens
	return u.generateAuthResponse(user)
}

// Login authenticates a user and returns tokens
func (u *authUsecase) Login(req *models.LoginRequest) (*models.AuthResponse, error) {
	// Normalize email
	email := strings.ToLower(strings.TrimSpace(req.Email))

	// Find user by email
	user, err := u.authRepo.GetUserByEmail(email)
	if err != nil {
		return nil, err
	}
	if user == nil {
		return nil, ErrUserNotFound
	}

	// Check if user is active
	if !user.IsActive {
		return nil, ErrUserInactive
	}

	// Verify password
	err = bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(req.Password))
	if err != nil {
		return nil, ErrInvalidCredentials
	}

	// Generate tokens
	return u.generateAuthResponse(user)
}

// RefreshToken generates new tokens from a refresh token
func (u *authUsecase) RefreshToken(refreshToken string) (*models.AuthResponse, error) {
	// Validate refresh token
	claims, err := u.jwtConfig.ValidateRefreshToken(refreshToken)
	if err != nil {
		return nil, ErrInvalidToken
	}

	// Parse user ID
	userID, err := uuid.Parse(claims.UserID)
	if err != nil {
		return nil, ErrInvalidToken
	}

	// Get user
	user, err := u.authRepo.GetUserByID(userID)
	if err != nil {
		return nil, err
	}
	if user == nil {
		return nil, ErrUserNotFound
	}

	// Check if user is active
	if !user.IsActive {
		return nil, ErrUserInactive
	}

	// Generate new tokens
	return u.generateAuthResponse(user)
}

// GetUserByID retrieves a user by ID
func (u *authUsecase) GetUserByID(id uuid.UUID) (*models.User, error) {
	return u.authRepo.GetUserByID(id)
}

// ValidateToken validates an access token
func (u *authUsecase) ValidateToken(token string) (*config.Claims, error) {
	return u.jwtConfig.ValidateAccessToken(token)
}

// generateAuthResponse creates tokens and auth response
func (u *authUsecase) generateAuthResponse(user *models.User) (*models.AuthResponse, error) {
	// Generate access token
	accessToken, err := u.jwtConfig.GenerateAccessToken(user.ID, user.Email, string(user.Role))
	if err != nil {
		return nil, err
	}

	// Generate refresh token
	refreshToken, err := u.jwtConfig.GenerateRefreshToken(user.ID)
	if err != nil {
		return nil, err
	}

	return &models.AuthResponse{
		User:         user.ToUserResponse(),
		AccessToken:  accessToken,
		RefreshToken: refreshToken,
		ExpiresIn:    u.jwtConfig.GetAccessTokenExpirySeconds(),
	}, nil
}

// ========================================
// Admin User Management Methods
// ========================================

// CreateUser creates a new user with any role (admin only)
func (u *authUsecase) CreateUser(req *models.CreateUserRequest) (*models.User, error) {
	// Normalize email
	email := strings.ToLower(strings.TrimSpace(req.Email))

	// Check if email exists
	exists, err := u.authRepo.EmailExists(email)
	if err != nil {
		return nil, err
	}
	if exists {
		return nil, ErrEmailAlreadyExists
	}

	// Hash password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		return nil, err
	}

	// Determine role
	role := models.RoleUser
	switch req.Role {
	case "admin":
		role = models.RoleAdmin
	case "clinic_staff":
		role = models.RoleClinicStaff
	}

	user := &models.User{
		Email:        email,
		PasswordHash: string(hashedPassword),
		FullName:     strings.TrimSpace(req.FullName),
		IsActive:     true,
		Role:         role,
	}

	if err := u.authRepo.CreateUser(user); err != nil {
		return nil, err
	}

	return user, nil
}

// GetAllUsers retrieves all users (admin only)
func (u *authUsecase) GetAllUsers() ([]models.User, error) {
	return u.authRepo.GetAllUsers()
}

// UpdateUser updates a user's information (admin only)
func (u *authUsecase) UpdateUser(id uuid.UUID, req *models.UpdateUserRequest) (*models.User, error) {
	user, err := u.authRepo.GetUserByID(id)
	if err != nil {
		return nil, err
	}
	if user == nil {
		return nil, ErrUserNotFound
	}

	// Update fields if provided
	if req.Email != "" {
		user.Email = strings.ToLower(strings.TrimSpace(req.Email))
	}
	if req.FullName != "" {
		user.FullName = strings.TrimSpace(req.FullName)
	}
	if req.Phone != "" {
		user.Phone = strings.TrimSpace(req.Phone)
	}
	if req.Role != "" {
		switch req.Role {
		case "admin":
			user.Role = models.RoleAdmin
		case "clinic_staff":
			user.Role = models.RoleClinicStaff
		default:
			user.Role = models.RoleUser
		}
	}

	if err := u.authRepo.UpdateUser(user); err != nil {
		return nil, err
	}

	return user, nil
}

// ToggleUserActive toggles a user's active status (admin only)
func (u *authUsecase) ToggleUserActive(id uuid.UUID) (*models.User, error) {
	user, err := u.authRepo.GetUserByID(id)
	if err != nil {
		return nil, err
	}
	if user == nil {
		return nil, ErrUserNotFound
	}

	user.IsActive = !user.IsActive

	if err := u.authRepo.UpdateUser(user); err != nil {
		return nil, err
	}

	return user, nil
}
