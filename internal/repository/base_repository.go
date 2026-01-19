package repository

import (
	"context"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

// BaseRepository provides common CRUD operations for all entities
type BaseRepository[T any] interface {
	Create(ctx context.Context, entity *T) error
	FindByID(ctx context.Context, id uuid.UUID) (*T, error)
	FindAll(ctx context.Context, opts ...QueryOption) ([]T, error)
	Update(ctx context.Context, entity *T) error
	Delete(ctx context.Context, id uuid.UUID) error
	Count(ctx context.Context, opts ...QueryOption) (int64, error)
}

// QueryOption defines options for filtering and pagination
type QueryOption func(*gorm.DB) *gorm.DB

// WithPagination adds limit and offset to query
func WithPagination(page, pageSize int) QueryOption {
	return func(db *gorm.DB) *gorm.DB {
		if page <= 0 {
			page = 1
		}
		if pageSize <= 0 {
			pageSize = 20
		}
		offset := (page - 1) * pageSize
		return db.Offset(offset).Limit(pageSize)
	}
}

// WithPreload preloads related entities
func WithPreload(relations ...string) QueryOption {
	return func(db *gorm.DB) *gorm.DB {
		for _, rel := range relations {
			db = db.Preload(rel)
		}
		return db
	}
}

// WithWhere adds a where condition
func WithWhere(query interface{}, args ...interface{}) QueryOption {
	return func(db *gorm.DB) *gorm.DB {
		return db.Where(query, args...)
	}
}

// WithOrder adds ordering
func WithOrder(order string) QueryOption {
	return func(db *gorm.DB) *gorm.DB {
		return db.Order(order)
	}
}

// WithActive filters for active records only
func WithActive() QueryOption {
	return func(db *gorm.DB) *gorm.DB {
		return db.Where("is_active = ?", true)
	}
}

// GormBaseRepository is a generic GORM implementation of BaseRepository
type GormBaseRepository[T any] struct {
	db *gorm.DB
}

// NewGormBaseRepository creates a new GormBaseRepository
func NewGormBaseRepository[T any](db *gorm.DB) *GormBaseRepository[T] {
	return &GormBaseRepository[T]{db: db}
}

// Create inserts a new entity
func (r *GormBaseRepository[T]) Create(ctx context.Context, entity *T) error {
	return r.db.WithContext(ctx).Create(entity).Error
}

// FindByID finds an entity by its UUID
func (r *GormBaseRepository[T]) FindByID(ctx context.Context, id uuid.UUID) (*T, error) {
	var entity T
	if err := r.db.WithContext(ctx).First(&entity, "id = ?", id).Error; err != nil {
		return nil, err
	}
	return &entity, nil
}

// FindAll finds all entities with optional query options
func (r *GormBaseRepository[T]) FindAll(ctx context.Context, opts ...QueryOption) ([]T, error) {
	var entities []T
	db := r.db.WithContext(ctx)
	for _, opt := range opts {
		db = opt(db)
	}
	if err := db.Find(&entities).Error; err != nil {
		return nil, err
	}
	return entities, nil
}

// Update updates an existing entity
func (r *GormBaseRepository[T]) Update(ctx context.Context, entity *T) error {
	return r.db.WithContext(ctx).Save(entity).Error
}

// Delete soft deletes an entity by ID (or hard delete if no DeletedAt field)
func (r *GormBaseRepository[T]) Delete(ctx context.Context, id uuid.UUID) error {
	var entity T
	return r.db.WithContext(ctx).Delete(&entity, "id = ?", id).Error
}

// Count returns the count of entities matching the options
func (r *GormBaseRepository[T]) Count(ctx context.Context, opts ...QueryOption) (int64, error) {
	var count int64
	var entity T
	db := r.db.WithContext(ctx).Model(&entity)
	for _, opt := range opts {
		db = opt(db)
	}
	if err := db.Count(&count).Error; err != nil {
		return 0, err
	}
	return count, nil
}

// GetDB returns the underlying gorm.DB for custom queries
func (r *GormBaseRepository[T]) GetDB() *gorm.DB {
	return r.db
}
