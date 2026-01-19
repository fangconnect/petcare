package models

import (
	"time"

	"github.com/google/uuid"
)

// Clinic represents a veterinary clinic
type Clinic struct {
	ID            uuid.UUID `gorm:"type:uuid;primary_key;default:gen_random_uuid()" json:"id"`
	ClinicName    string    `gorm:"column:clinic_name;not null;size:255" json:"clinic_name"`
	LicenseNumber string    `gorm:"column:license_number;size:100" json:"license_number,omitempty"`
	Address       string    `gorm:"type:text" json:"address,omitempty"`
	Phone         string    `gorm:"size:50" json:"phone,omitempty"`
	CreatedAt     time.Time `gorm:"autoCreateTime" json:"created_at"`

	// Relations
	Staff        []ClinicStaff `gorm:"foreignKey:ClinicID" json:"staff,omitempty"`
	Pets         []ClinicPet   `gorm:"foreignKey:ClinicID" json:"pets,omitempty"`
	Appointments []Appointment `gorm:"foreignKey:ClinicID" json:"appointments,omitempty"`
}

func (Clinic) TableName() string {
	return "clinics"
}

// ClinicStaff links users to clinics as staff members
type ClinicStaff struct {
	ID        uuid.UUID `gorm:"type:uuid;primary_key;default:gen_random_uuid()" json:"id"`
	ClinicID  uuid.UUID `gorm:"type:uuid;not null;index" json:"clinic_id"`
	UserID    uuid.UUID `gorm:"type:uuid;not null;index" json:"user_id"`
	Role      string    `gorm:"size:100;default:'staff'" json:"role"` // vet, nurse, receptionist, admin
	CreatedAt time.Time `gorm:"autoCreateTime" json:"created_at"`

	// Relations
	Clinic Clinic `gorm:"foreignKey:ClinicID" json:"clinic,omitempty"`
	User   User   `gorm:"foreignKey:UserID" json:"user,omitempty"`
}

func (ClinicStaff) TableName() string {
	return "clinic_staff"
}

// ClinicPet links pets to clinics as patients
type ClinicPet struct {
	ID        uuid.UUID `gorm:"type:uuid;primary_key;default:gen_random_uuid()" json:"id"`
	ClinicID  uuid.UUID `gorm:"type:uuid;not null;index" json:"clinic_id"`
	PetID     uuid.UUID `gorm:"type:uuid;not null;index" json:"pet_id"`
	PatientID string    `gorm:"column:patient_id;size:100" json:"patient_id,omitempty"` // Clinic's internal patient number
	CreatedAt time.Time `gorm:"autoCreateTime" json:"created_at"`

	// Relations
	Clinic Clinic `gorm:"foreignKey:ClinicID" json:"clinic,omitempty"`
	Pet    Pet    `gorm:"foreignKey:PetID" json:"pet,omitempty"`
}

func (ClinicPet) TableName() string {
	return "clinic_pets"
}

// Appointment represents a scheduled clinic visit
type Appointment struct {
	ID              uuid.UUID  `gorm:"type:uuid;primary_key;default:gen_random_uuid()" json:"id"`
	ClinicID        uuid.UUID  `gorm:"type:uuid;not null;index" json:"clinic_id"`
	PetID           uuid.UUID  `gorm:"type:uuid;not null;index" json:"pet_id"`
	VetID           *uuid.UUID `gorm:"type:uuid" json:"vet_id,omitempty"`
	AppointmentTime time.Time  `gorm:"column:appointment_time;not null;index" json:"appointment_time"`
	Purpose         string     `gorm:"size:255" json:"purpose,omitempty"`
	Status          string     `gorm:"size:50;default:'scheduled'" json:"status"` // scheduled, confirmed, completed, cancelled, no_show
	Notes           string     `gorm:"type:text" json:"notes,omitempty"`
	CreatedAt       time.Time  `gorm:"autoCreateTime" json:"created_at"`

	// Relations
	Clinic Clinic `gorm:"foreignKey:ClinicID" json:"clinic,omitempty"`
	Pet    Pet    `gorm:"foreignKey:PetID" json:"pet,omitempty"`
	Vet    *User  `gorm:"foreignKey:VetID" json:"vet,omitempty"`
}

func (Appointment) TableName() string {
	return "appointments"
}

// Appointment statuses
const (
	AppointmentStatusScheduled = "scheduled"
	AppointmentStatusConfirmed = "confirmed"
	AppointmentStatusCompleted = "completed"
	AppointmentStatusCancelled = "cancelled"
	AppointmentStatusNoShow    = "no_show"
)

// Clinic staff roles
const (
	ClinicRoleVet          = "vet"
	ClinicRoleNurse        = "nurse"
	ClinicRoleReceptionist = "receptionist"
	ClinicRoleAdmin        = "admin"
)
