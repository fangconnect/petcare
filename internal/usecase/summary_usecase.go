package usecase

import (
	"encoding/json"
	"fmt"
	"pet-care-backend/internal/models"
	"pet-care-backend/internal/repository"
	"sort"
	"time"

	"github.com/google/uuid"
)

// SummaryUsecase defines the interface for summary operations
type SummaryUsecase interface {
	GetPetSummary(petID uuid.UUID, days int) (*SummaryResponse, error)
}

// SummaryResponse represents the summary data
type SummaryResponse struct {
	Period        string                  `json:"period"`
	Stats         SummaryStats            `json:"stats"`
	ActivityStats []ActivityTypeStat      `json:"activity_stats"`
	RecentNotes   []string                `json:"recent_notes"`
	Disease       *models.Disease         `json:"disease,omitempty"`
	Template      *models.DiseaseTemplate `json:"template,omitempty"`
}

// SummaryStats contains aggregated statistics (legacy support)
type SummaryStats struct {
	NutritionDailyAvg float64     `json:"nutrition_daily_avg"`
	SalineDailyAvg    float64     `json:"saline_daily_avg"`
	Weight            WeightStats `json:"weight"`
}

// WeightStats contains weight-related metrics
type WeightStats struct {
	Current float64 `json:"current"`
	Start   float64 `json:"start"`
	Change  float64 `json:"change"`
	Trend   string  `json:"trend"`
}

// ActivityTypeStat contains stats for a single activity type
type ActivityTypeStat struct {
	ActivityType string  `json:"activity_type"`
	Name         string  `json:"name"`
	NameEN       string  `json:"name_en,omitempty"`
	InputType    string  `json:"input_type"`
	Category     string  `json:"category"`
	Unit         string  `json:"unit,omitempty"`
	Total        float64 `json:"total"`
	DailyAvg     float64 `json:"daily_avg"`
	Count        int     `json:"count"`
	Min          float64 `json:"min,omitempty"`
	Max          float64 `json:"max,omitempty"`
	Latest       float64 `json:"latest,omitempty"`
	Start        float64 `json:"start,omitempty"`
	Change       float64 `json:"change,omitempty"`
	Trend        string  `json:"trend,omitempty"`
}

type summaryUsecase struct {
	logRepo      repository.LogRepository
	trackingRepo repository.TrackingConfigRepository
}

// NewSummaryUsecase creates a new summary usecase instance
func NewSummaryUsecase(logRepo repository.LogRepository, trackingRepo repository.TrackingConfigRepository) SummaryUsecase {
	return &summaryUsecase{
		logRepo:      logRepo,
		trackingRepo: trackingRepo,
	}
}

// GetPetSummary generates a health summary for the pet over the specified period
func (u *summaryUsecase) GetPetSummary(petID uuid.UUID, days int) (*SummaryResponse, error) {
	// Calculate date range
	endDate := time.Now()
	startDate := endDate.AddDate(0, 0, -days)

	// Fetch all logs for the period
	logs, err := u.logRepo.GetLogsByPetID(petID)
	if err != nil {
		return nil, err
	}

	// Filter logs within date range
	var filteredLogs []models.ActivityLog
	for _, log := range logs {
		if log.LoggedAt.After(startDate) && log.LoggedAt.Before(endDate.Add(24*time.Hour)) {
			filteredLogs = append(filteredLogs, log)
		}
	}

	// Get pet's active disease and template
	var disease *models.Disease
	var template *models.DiseaseTemplate
	var templateActivityTypes []models.ActivityType

	petDisease, _ := u.trackingRepo.GetPetActiveDisease(petID)
	if petDisease != nil {
		disease = &petDisease.Disease

		config, _ := u.trackingRepo.GetByPetDiseaseID(petDisease.ID)
		if config != nil && config.TemplateID != nil {
			template = config.Template
			templateActivityTypes, _ = u.trackingRepo.GetTemplateActivityTypes(*config.TemplateID)
		}
	}

	// Calculate activity-type-specific stats
	var activityStats []ActivityTypeStat

	if len(templateActivityTypes) > 0 {
		// Use template activity types
		for _, at := range templateActivityTypes {
			stat := u.calculateActivityTypeStat(filteredLogs, at, days)
			activityStats = append(activityStats, stat)
		}
	} else {
		// Fallback: group by all activity types found in logs
		activityStats = u.calculateAllActivityStats(filteredLogs, days)
	}

	// Legacy stats for backward compatibility
	nutritionAvg := u.calculateNutritionAvg(filteredLogs, days)
	salineAvg := u.calculateSalineAvg(filteredLogs, days)
	weightStats := u.calculateWeightStats(filteredLogs)
	recentNotes := u.collectRecentNotes(filteredLogs)

	// Format period string
	periodStr := fmt.Sprintf("%s - %s",
		startDate.Format("2 Jan"),
		endDate.Format("2 Jan 2006"))

	return &SummaryResponse{
		Period: periodStr,
		Stats: SummaryStats{
			NutritionDailyAvg: nutritionAvg,
			SalineDailyAvg:    salineAvg,
			Weight:            weightStats,
		},
		ActivityStats: activityStats,
		RecentNotes:   recentNotes,
		Disease:       disease,
		Template:      template,
	}, nil
}

// calculateActivityTypeStat calculates stats for a specific activity type
func (u *summaryUsecase) calculateActivityTypeStat(logs []models.ActivityLog, activityType models.ActivityType, days int) ActivityTypeStat {
	stat := ActivityTypeStat{
		ActivityType: activityType.Name,
		Name:         activityType.Name,
		NameEN:       activityType.NameEN,
		InputType:    string(activityType.InputType),
		Category:     string(activityType.Category),
	}

	// Get unit from activity type
	if len(activityType.ActivityTypeUnits) > 0 {
		for _, atu := range activityType.ActivityTypeUnits {
			if atu.IsDefault {
				stat.Unit = atu.Unit.Symbol
				if stat.Unit == "" {
					stat.Unit = atu.Unit.Name
				}
				break
			}
		}
		if stat.Unit == "" && len(activityType.ActivityTypeUnits) > 0 {
			stat.Unit = activityType.ActivityTypeUnits[0].Unit.Symbol
			if stat.Unit == "" {
				stat.Unit = activityType.ActivityTypeUnits[0].Unit.Name
			}
		}
	}

	// Filter logs for this activity type
	var typeLogs []models.ActivityLog
	for _, log := range logs {
		if log.ActivityType == activityType.Name {
			typeLogs = append(typeLogs, log)
		}
	}

	stat.Count = len(typeLogs)
	if stat.Count == 0 {
		return stat
	}

	// Sort by date
	sort.Slice(typeLogs, func(i, j int) bool {
		return typeLogs[i].LoggedAt.Before(typeLogs[j].LoggedAt)
	})

	// Calculate stats based on input type
	switch activityType.InputType {
	case models.InputTypeNumber:
		var values []float64
		dailyTotals := make(map[string]float64)

		for _, log := range typeLogs {
			if val := getValueFromActivityData(log); val != nil {
				values = append(values, *val)
				date := log.LoggedAt.Format("2006-01-02")
				dailyTotals[date] += *val
			}
		}

		if len(values) > 0 {
			// Calculate total
			for _, v := range values {
				stat.Total += v
			}
			stat.DailyAvg = stat.Total / float64(days)

			// Min/Max
			stat.Min = values[0]
			stat.Max = values[0]
			for _, v := range values {
				if v < stat.Min {
					stat.Min = v
				}
				if v > stat.Max {
					stat.Max = v
				}
			}

			// Start/Latest/Change for weight-like metrics
			stat.Start = values[0]
			stat.Latest = values[len(values)-1]
			stat.Change = stat.Latest - stat.Start

			if stat.Change > 0.1 {
				stat.Trend = "Up"
			} else if stat.Change < -0.1 {
				stat.Trend = "Down"
			} else {
				stat.Trend = "Stable"
			}
		}

	case models.InputTypeCheckbox:
		checked := 0
		for _, log := range typeLogs {
			var data map[string]interface{}
			if err := json.Unmarshal(log.ActivityData, &data); err == nil {
				if data["checked"] == true || data["value"] == 1.0 {
					checked++
				}
			}
		}
		stat.Total = float64(checked)
		stat.DailyAvg = stat.Total / float64(days)
	}

	return stat
}

// calculateAllActivityStats calculates stats for all activity types in logs
func (u *summaryUsecase) calculateAllActivityStats(logs []models.ActivityLog, days int) []ActivityTypeStat {
	// Group logs by activity type
	grouped := make(map[string][]models.ActivityLog)
	for _, log := range logs {
		grouped[log.ActivityType] = append(grouped[log.ActivityType], log)
	}

	var stats []ActivityTypeStat
	for activityType, typeLogs := range grouped {
		stat := ActivityTypeStat{
			ActivityType: activityType,
			Name:         activityType,
			Count:        len(typeLogs),
		}

		// Calculate total and avg for numeric values
		var values []float64
		for _, log := range typeLogs {
			if val := getValueFromActivityData(log); val != nil {
				values = append(values, *val)
				stat.Total += *val
			}
		}

		if len(values) > 0 {
			stat.DailyAvg = stat.Total / float64(days)
			stat.Min = values[0]
			stat.Max = values[0]
			for _, v := range values {
				if v < stat.Min {
					stat.Min = v
				}
				if v > stat.Max {
					stat.Max = v
				}
			}
		}

		stats = append(stats, stat)
	}

	return stats
}

// getValueFromActivityData extracts value from JSONB activity_data
func getValueFromActivityData(log models.ActivityLog) *float64 {
	var data map[string]interface{}
	if err := json.Unmarshal(log.ActivityData, &data); err != nil {
		return nil
	}
	if val, ok := data["value"]; ok {
		if floatVal, ok := val.(float64); ok {
			return &floatVal
		}
	}
	return nil
}

// calculateNutritionAvg calculates average daily nutrition intake
func (u *summaryUsecase) calculateNutritionAvg(logs []models.ActivityLog, days int) float64 {
	dailyTotals := make(map[string]float64)

	nutritionTypes := map[string]bool{
		models.ActivityTypeFoodIntake: true,
		"wet_food":                    true,
		"dry_food":                    true,
		"renal_food":                  true,
	}

	for _, log := range logs {
		if nutritionTypes[log.ActivityType] {
			if val := getValueFromActivityData(log); val != nil {
				date := log.LoggedAt.Format("2006-01-02")
				dailyTotals[date] += *val
			}
		}
	}

	if len(dailyTotals) == 0 {
		return 0
	}

	total := 0.0
	for _, val := range dailyTotals {
		total += val
	}

	return total / float64(days)
}

// calculateSalineAvg calculates average daily saline intake
func (u *summaryUsecase) calculateSalineAvg(logs []models.ActivityLog, days int) float64 {
	dailyTotals := make(map[string]float64)

	for _, log := range logs {
		if log.ActivityType == "saline" || log.ActivityType == models.ActivityTypeWaterIntake {
			if val := getValueFromActivityData(log); val != nil {
				date := log.LoggedAt.Format("2006-01-02")
				dailyTotals[date] += *val
			}
		}
	}

	if len(dailyTotals) == 0 {
		return 0
	}

	total := 0.0
	for _, val := range dailyTotals {
		total += val
	}

	return total / float64(days)
}

// calculateWeightStats calculates weight statistics
func (u *summaryUsecase) calculateWeightStats(logs []models.ActivityLog) WeightStats {
	var weightLogs []models.ActivityLog

	for _, log := range logs {
		if log.ActivityType == models.ActivityTypeWeight {
			if getValueFromActivityData(log) != nil {
				weightLogs = append(weightLogs, log)
			}
		}
	}

	if len(weightLogs) == 0 {
		return WeightStats{
			Current: 0,
			Start:   0,
			Change:  0,
			Trend:   "No Data",
		}
	}

	// Sort by date (earliest first)
	sort.Slice(weightLogs, func(i, j int) bool {
		return weightLogs[i].LoggedAt.Before(weightLogs[j].LoggedAt)
	})

	start := *getValueFromActivityData(weightLogs[0])
	current := *getValueFromActivityData(weightLogs[len(weightLogs)-1])
	change := current - start

	trend := "Stable"
	if change > 0.1 {
		trend = "Up"
	} else if change < -0.1 {
		trend = "Down"
	}

	return WeightStats{
		Current: current,
		Start:   start,
		Change:  change,
		Trend:   trend,
	}
}

// collectRecentNotes collects notes from excretion logs
func (u *summaryUsecase) collectRecentNotes(logs []models.ActivityLog) []string {
	var notes []string

	excretionTypes := map[string]bool{
		models.ActivityTypeUrination:  true,
		models.ActivityTypeDefecation: true,
	}

	for _, log := range logs {
		if excretionTypes[log.ActivityType] && log.Notes != "" {
			dateStr := log.LoggedAt.Format("02/01")
			noteText := fmt.Sprintf("%s: %s", dateStr, log.Notes)
			notes = append(notes, noteText)
		}
	}

	return notes
}
