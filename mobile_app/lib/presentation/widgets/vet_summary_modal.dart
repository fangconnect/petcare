import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../data/models/models.dart';

class VetSummaryModal extends StatelessWidget {
  final List<ActivityLog> logs;
  final String petName;
  final DateTime? startDate;
  final DateTime? endDate;

  const VetSummaryModal({
    super.key,
    required this.logs,
    required this.petName,
    this.startDate,
    this.endDate,
  });

  // Calculate date range from logs
  String _getDateRangeHeader() {
    if (startDate != null && endDate != null) {
       final startStr = DateFormat('d MMM').format(startDate!);
       final endStr = DateFormat('d MMM yyyy').format(endDate!);
       return '$startStr - $endStr';
    }
    if (logs.isEmpty) return 'Health Summary';
    
    final dates = logs.map((log) => log.loggedAt).toList();
    dates.sort();
    
    final logStartDate = dates.first;
    final logEndDate = dates.last;
    
    final startStr = DateFormat('d MMM').format(logStartDate);
    final endStr = DateFormat('d MMM yyyy').format(logEndDate);
    
    return '$startStr - $endStr';
  }

  // Get number of unique days
  int _getUniqueDays() {
    if (startDate != null && endDate != null) {
       final days = endDate!.difference(startDate!).inDays + 1;
       return days > 0 ? days : 1;
    }
    if (logs.isEmpty) return 1;
    
    final uniqueDates = logs.map((log) {
      final date = log.loggedAt;
      return DateTime(date.year, date.month, date.day);
    }).toSet();
    
    return uniqueDates.length > 0 ? uniqueDates.length : 1;
  }

  // Helper: Get logs by activity type - supports flexible matching for both English and Thai names
  List<ActivityLog> _getLogsByType(String type) {
    return logs.where((log) => _matchesActivityType(log.activityType, type)).toList();
  }
  
  // Match activity type with flexible logic for template names
  bool _matchesActivityType(String logType, String searchType) {
    final logTypeLower = logType.toLowerCase();
    final searchTypeLower = searchType.toLowerCase();
    
    // Exact match first
    if (logTypeLower == searchTypeLower) return true;
    
    // Flexible matching map: searchType -> list of alternative names/patterns
    final Map<String, List<String>> typeMatches = {
      'food_intake': ['food', 'อาหาร', 'feed'],
      'water_intake': ['water', 'น้ำ', 'drink', 'น้ำดื่ม'],
      'saline': ['saline', 'น้ำเกลือ', 'iv', 'fluid'],
      'urination': ['urination', 'urine', 'ปัสสาวะ', 'pee'],
      'defecation': ['defecation', 'stool', 'อุจจาระ', 'poop'],
      'vomiting': ['vomiting', 'vomit', 'อาเจียน'],
      'weight': ['weight', 'น้ำหนัก'],
      'medication': ['medication', 'med', 'ยา', 'medicine'],
      'symptom': ['symptom', 'อาการ'],
      'exercise': ['exercise', 'ออกกำลังกาย', 'activity'],
      'sleep': ['sleep', 'นอน', 'rest'],
      'appetite': ['appetite', 'กินอาหาร', 'ความอยากอาหาร'],
      'mood': ['mood', 'อารมณ์'],
      'energy_level': ['energy', 'พลังงาน', 'activity level'],
      'pain_level': ['pain', 'เจ็บ', 'ปวด'],
      'anxiety': ['anxiety', 'กังวล', 'stress'],
      'breathing': ['breathing', 'หายใจ', 'respiration'],
      'behavior': ['behavior', 'พฤติกรรม', 'note'],
    };
    
    final patterns = typeMatches[searchTypeLower];
    if (patterns != null) {
      for (var pattern in patterns) {
        if (logTypeLower.contains(pattern.toLowerCase())) {
          return true;
        }
      }
    }
    
    return false;
  }

  // Helper: Calculate average for numeric logs
  double _calculateAverage(List<ActivityLog> logs, int days) {
    double total = 0;
    for (var log in logs) {
      if (log.value != null) {
        total += log.value!;
      }
    }
    return days > 0 ? total / days : 0;
  }

  // Helper: Calculate total for numeric logs
  double _calculateTotal(List<ActivityLog> logs) {
    double total = 0;
    for (var log in logs) {
      if (log.value != null) {
        total += log.value!;
      }
    }
    return total;
  }

  // Helper: Group logs by unit type
  Map<String, List<ActivityLog>> _groupLogsByUnit(List<ActivityLog> logs) {
    final grouped = <String, List<ActivityLog>>{};
    for (var log in logs) {
      final unit = log.unit ?? 'unknown';
      grouped.putIfAbsent(unit, () => []).add(log);
    }
    return grouped;
  }

  // Helper: Calculate total from list of logs
  double _calculateTotalFromList(List<ActivityLog> logs) {
    double total = 0;
    for (var log in logs) {
      if (log.value != null) {
        total += log.value!;
      }
    }
    return total;
  }

  // Generate clinical report sections
  Map<String, _ReportSection> _generateClinicalSections() {
    final days = _getUniqueDays();
    final sections = <String, _ReportSection>{};

    // 1. Nutrition Assessment
    final foodLogs = _getLogsByType('food_intake');
    final waterLogs = _getLogsByType('water_intake');
    final salineLogs = _getLogsByType('saline');
    final appetiteLogs = _getLogsByType('appetite');

    final nutritionSection = _ReportSection(
      icon: Icons.restaurant_menu,
      color: Colors.orange,
    );

    if (foodLogs.isNotEmpty) {
      // Group food by unit type
      final foodByUnit = _groupLogsByUnit(foodLogs);
      
      for (var entry in foodByUnit.entries) {
        final unit = entry.key;
        final unitLogs = entry.value;
        final total = _calculateTotalFromList(unitLogs);
        final avg = total / days;
        
        nutritionSection.items.add(_ReportItem(
          label: 'Food Intake ($unit)',
          value: '${total.toStringAsFixed(1)} $unit total',
          detail: '(Avg: ${avg.toStringAsFixed(1)} $unit/day, ${unitLogs.length} entries)',
        ));
      }
    } else {
      nutritionSection.items.add(_ReportItem(
        label: 'Food Intake',
        value: 'No data',
        isWarning: true,
      ));
    }

    if (appetiteLogs.isNotEmpty) {
      double totalAppetite = 0;
      for (var log in appetiteLogs) {
        if (log.value != null) totalAppetite += log.value!;
      }
      final avgAppetite = totalAppetite / appetiteLogs.length;
      String status = 'Normal';
      if (avgAppetite < 4) status = 'Poor';
      if (avgAppetite >= 7) status = 'Good';
      nutritionSection.items.add(_ReportItem(
        label: 'Appetite Score',
        value: '${avgAppetite.toStringAsFixed(1)}/10',
        detail: '($status)',
      ));
    }

    sections['Nutrition Assessment'] = nutritionSection;

    // 2. Hydration Status
    final hydrationSection = _ReportSection(
      icon: Icons.water_drop,
      color: Colors.blue,
    );

    if (waterLogs.isNotEmpty) {
      // Group water by unit type
      final waterByUnit = _groupLogsByUnit(waterLogs);
      
      for (var entry in waterByUnit.entries) {
        final unit = entry.key;
        final unitLogs = entry.value;
        final total = _calculateTotalFromList(unitLogs);
        final avg = total / days;
        
        hydrationSection.items.add(_ReportItem(
          label: 'Water Intake ($unit)',
          value: '${total.toStringAsFixed(1)} $unit total',
          detail: '(Avg: ${avg.toStringAsFixed(1)} $unit/day, ${unitLogs.length} entries)',
        ));
      }
    }

    if (salineLogs.isNotEmpty) {
      // Group saline by unit type
      final salineByUnit = _groupLogsByUnit(salineLogs);
      
      for (var entry in salineByUnit.entries) {
        final unit = entry.key;
        final unitLogs = entry.value;
        final total = _calculateTotalFromList(unitLogs);
        final avg = total / days;
        
        hydrationSection.items.add(_ReportItem(
          label: 'Subcutaneous Fluids ($unit)',
          value: '${total.toStringAsFixed(0)} $unit total',
          detail: '(Avg: ${avg.toStringAsFixed(0)} $unit/day)',
        ));
      }
    }

    if (hydrationSection.items.isEmpty) {
      hydrationSection.items.add(_ReportItem(
        label: 'Hydration Data',
        value: 'No data recorded',
        isWarning: true,
      ));
    }

    sections['Hydration Status'] = hydrationSection;

    // 3. Elimination Pattern
    final urineLogs = _getLogsByType('urination');
    final defecationLogs = _getLogsByType('defecation');
    final vomitLogs = _getLogsByType('vomiting');

    final eliminationSection = _ReportSection(
      icon: Icons.wc,
      color: Colors.teal,
    );

    if (urineLogs.isNotEmpty) {
      final totalUrinations = _calculateTotal(urineLogs);
      final avgPerDay = totalUrinations / days;
      eliminationSection.items.add(_ReportItem(
        label: 'Urination',
        value: '${totalUrinations.toStringAsFixed(0)} times',
        detail: '(Avg: ${avgPerDay.toStringAsFixed(1)}/day)',
      ));
      
      // Check for notes
      final notesWithContent = urineLogs.where((l) => l.notes?.isNotEmpty == true).toList();
      if (notesWithContent.isNotEmpty) {
        final uniqueNotes = notesWithContent.map((l) => l.notes!).toSet().take(3).join(', ');
        eliminationSection.items.add(_ReportItem(
          label: 'Urination Notes',
          value: uniqueNotes,
        ));
      }
    }

    if (defecationLogs.isNotEmpty) {
      final totalDefecations = _calculateTotal(defecationLogs);
      final avgPerDay = totalDefecations / days;
      eliminationSection.items.add(_ReportItem(
        label: 'Defecation',
        value: '${totalDefecations.toStringAsFixed(0)} times',
        detail: '(Avg: ${avgPerDay.toStringAsFixed(1)}/day)',
      ));
      
      final notesWithContent = defecationLogs.where((l) => l.notes?.isNotEmpty == true).toList();
      if (notesWithContent.isNotEmpty) {
        final uniqueNotes = notesWithContent.map((l) => l.notes!).toSet().take(3).join(', ');
        eliminationSection.items.add(_ReportItem(
          label: 'Stool Notes',
          value: uniqueNotes,
        ));
      }
    }

    if (vomitLogs.isNotEmpty) {
      final totalVomits = _calculateTotal(vomitLogs);
      eliminationSection.items.add(_ReportItem(
        label: 'Vomiting Episodes',
        value: '${totalVomits.toStringAsFixed(0)} times',
        isWarning: totalVomits > 2,
      ));
    }

    if (eliminationSection.items.isEmpty) {
      eliminationSection.items.add(_ReportItem(
        label: 'Elimination Data',
        value: 'No data recorded',
        isWarning: true,
      ));
    }

    sections['Elimination Pattern'] = eliminationSection;

    // 4. Medication Compliance
    final medLogs = _getLogsByType('medication');
    final medicationSection = _ReportSection(
      icon: Icons.medication,
      color: Colors.purple,
    );

    if (medLogs.isNotEmpty) {
      // Group medications by name
      final medMap = <String, _MedicationEntry>{};
      for (var log in medLogs) {
        final medName = log.activityData['medication_name'] as String? ?? 'Unknown';
        final value = log.value ?? 0;
        final unit = log.unit ?? 'tabs';
        
        if (!medMap.containsKey(medName)) {
          medMap[medName] = _MedicationEntry(name: medName, unit: unit);
        }
        medMap[medName]!.count++;
        medMap[medName]!.totalValue += value;
      }

      medicationSection.items.add(_ReportItem(
        label: 'Medications Administered',
        value: '${medMap.length} medication(s)',
      ));

      for (var entry in medMap.entries) {
        final med = entry.value;
        String displayValue = '${med.count} doses';
        if (med.totalValue > 0) {
          // Smart formatting: show whole number if integer, otherwise show fraction/decimal without unnecessary zeros
          String valueStr;
          if (med.totalValue == med.totalValue.truncateToDouble()) {
            valueStr = med.totalValue.toInt().toString();
          } else {
            // Remove trailing zeros from decimal
            valueStr = med.totalValue.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
          }
          displayValue = '$valueStr ${med.unit} (${med.count}x)';
        }
        medicationSection.items.add(_ReportItem(
          label: '• ${med.name}',
          value: displayValue,
        ));
      }
    } else {
      medicationSection.items.add(_ReportItem(
        label: 'Medications',
        value: 'No medications recorded',
      ));
    }

    sections['Medication Compliance'] = medicationSection;

    // 5. Weight Monitoring
    final weightLogs = _getLogsByType('weight');
    final weightSection = _ReportSection(
      icon: Icons.monitor_weight,
      color: Colors.green,
    );

    if (weightLogs.isNotEmpty) {
      final sortedWeights = weightLogs.toList()
        ..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
      
      final firstWeight = sortedWeights.first.value!;
      final lastWeight = sortedWeights.last.value!;
      final change = lastWeight - firstWeight;

      weightSection.items.add(_ReportItem(
        label: 'Current Weight',
        value: '${lastWeight.toStringAsFixed(2)} kg',
      ));

      if (sortedWeights.length > 1) {
        String trend = 'Stable';
        if (change > 0.1) trend = 'Increasing';
        if (change < -0.1) trend = 'Decreasing';
        
        weightSection.items.add(_ReportItem(
          label: 'Weight Change',
          value: '${change >= 0 ? "+" : ""}${change.toStringAsFixed(2)} kg',
          detail: '($trend)',
          isWarning: change < -0.2,
        ));
      }
    } else {
      weightSection.items.add(_ReportItem(
        label: 'Weight',
        value: 'No data recorded',
        isWarning: true,
      ));
    }

    sections['Weight Monitoring'] = weightSection;

    // 6. Behavioral Assessment
    final behaviorLogs = _getLogsByType('behavior');
    final moodLogs = _getLogsByType('mood');
    final symptomLogs = _getLogsByType('symptom');
    final sleepLogs = _getLogsByType('sleep');
    final exerciseLogs = _getLogsByType('exercise');
    // appetiteLogs already declared in Nutrition Assessment section above
    final energyLogs = _getLogsByType('energy_level');
    final painLogs = _getLogsByType('pain_level');
    final anxietyLogs = _getLogsByType('anxiety');
    final breathingLogs = _getLogsByType('breathing');

    final behaviorSection = _ReportSection(
      icon: Icons.psychology,
      color: Colors.indigo,
    );

    // Mood
    if (moodLogs.isNotEmpty) {
      double totalMood = 0;
      for (var log in moodLogs) {
        if (log.value != null) totalMood += log.value!;
      }
      final avgMood = totalMood / moodLogs.length;
      String status = 'Normal';
      if (avgMood < 4) status = 'Low';
      if (avgMood >= 7) status = 'Good';
      behaviorSection.items.add(_ReportItem(
        label: 'Mood Score',
        value: '${avgMood.toStringAsFixed(1)}/10',
        detail: '($status)',
      ));
    }

    // Appetite
    if (appetiteLogs.isNotEmpty) {
      double totalAppetite = 0;
      for (var log in appetiteLogs) {
        if (log.value != null) totalAppetite += log.value!;
      }
      final avgAppetite = totalAppetite / appetiteLogs.length;
      String status = 'Normal';
      if (avgAppetite < 4) status = 'Poor';
      if (avgAppetite >= 7) status = 'Good';
      behaviorSection.items.add(_ReportItem(
        label: 'Appetite',
        value: '${avgAppetite.toStringAsFixed(1)}/10',
        detail: '($status)',
        isWarning: avgAppetite < 4,
      ));
    }

    // Energy Level
    if (energyLogs.isNotEmpty) {
      double totalEnergy = 0;
      for (var log in energyLogs) {
        if (log.value != null) totalEnergy += log.value!;
      }
      final avgEnergy = totalEnergy / energyLogs.length;
      String status = 'Normal';
      if (avgEnergy < 4) status = 'Low';
      if (avgEnergy >= 7) status = 'Active';
      behaviorSection.items.add(_ReportItem(
        label: 'Energy Level',
        value: '${avgEnergy.toStringAsFixed(1)}/10',
        detail: '($status)',
        isWarning: avgEnergy < 3,
      ));
    }

    // Pain Level
    if (painLogs.isNotEmpty) {
      double totalPain = 0;
      for (var log in painLogs) {
        if (log.value != null) totalPain += log.value!;
      }
      final avgPain = totalPain / painLogs.length;
      String status = 'None';
      if (avgPain >= 1 && avgPain < 4) status = 'Mild';
      if (avgPain >= 4 && avgPain < 7) status = 'Moderate';
      if (avgPain >= 7) status = 'Severe';
      behaviorSection.items.add(_ReportItem(
        label: 'Pain Level',
        value: '${avgPain.toStringAsFixed(1)}/10',
        detail: '($status)',
        isWarning: avgPain >= 4,
      ));
    }

    // Anxiety
    if (anxietyLogs.isNotEmpty) {
      double totalAnxiety = 0;
      for (var log in anxietyLogs) {
        if (log.value != null) totalAnxiety += log.value!;
      }
      final avgAnxiety = totalAnxiety / anxietyLogs.length;
      String status = 'Calm';
      if (avgAnxiety >= 3 && avgAnxiety < 6) status = 'Mild';
      if (avgAnxiety >= 6) status = 'High';
      behaviorSection.items.add(_ReportItem(
        label: 'Anxiety',
        value: '${avgAnxiety.toStringAsFixed(1)}/10',
        detail: '($status)',
        isWarning: avgAnxiety >= 6,
      ));
    }

    // Breathing Rate
    if (breathingLogs.isNotEmpty) {
      double totalBreathing = 0;
      for (var log in breathingLogs) {
        if (log.value != null) totalBreathing += log.value!;
      }
      final avgBreathing = totalBreathing / breathingLogs.length;
      String status = 'Normal';
      if (avgBreathing < 15) status = 'Low';
      if (avgBreathing > 30) status = 'Elevated';
      if (avgBreathing > 40) status = 'High';
      behaviorSection.items.add(_ReportItem(
        label: 'Breathing Rate',
        value: '${avgBreathing.toStringAsFixed(0)} bpm',
        detail: '($status)',
        isWarning: avgBreathing > 30,
      ));
    }

    // Sleep
    if (sleepLogs.isNotEmpty) {
      final totalSleep = _calculateTotal(sleepLogs);
      final avgSleep = _calculateAverage(sleepLogs, days);
      behaviorSection.items.add(_ReportItem(
        label: 'Sleep',
        value: '${totalSleep.toStringAsFixed(1)} hrs total',
        detail: '(Avg: ${avgSleep.toStringAsFixed(1)} hrs/day)',
      ));
    }

    // Exercise
    if (exerciseLogs.isNotEmpty) {
      final totalExercise = _calculateTotal(exerciseLogs);
      final avgExercise = _calculateAverage(exerciseLogs, days);
      behaviorSection.items.add(_ReportItem(
        label: 'Exercise',
        value: '${totalExercise.toStringAsFixed(0)} min total',
        detail: '(Avg: ${avgExercise.toStringAsFixed(0)} min/day)',
      ));
    }

    // Behavior Notes
    if (behaviorLogs.isNotEmpty) {
      // Get text from activityData
      final behaviorTexts = behaviorLogs
          .map((l) => l.activityData['text'] as String?)
          .where((s) => s != null && s.isNotEmpty)
          .toSet()
          .take(3);
      if (behaviorTexts.isNotEmpty) {
        behaviorSection.items.add(_ReportItem(
          label: 'Behavioral Notes',
          value: behaviorTexts.join(', '),
        ));
      }
    }

    // Symptoms
    if (symptomLogs.isNotEmpty) {
      final symptoms = symptomLogs
          .map((l) => l.notes ?? l.activityData['text'])
          .where((s) => s != null && s.toString().isNotEmpty)
          .map((s) => s.toString())
          .toSet()
          .take(5);
      if (symptoms.isNotEmpty) {
        behaviorSection.items.add(_ReportItem(
          label: 'Symptoms Reported',
          value: symptoms.join(', '),
          isWarning: true,
        ));
      }
    }

    if (behaviorSection.items.isEmpty) {
      behaviorSection.items.add(_ReportItem(
        label: 'Behavioral Data',
        value: 'No data recorded',
      ));
    }

    sections['Behavioral Assessment'] = behaviorSection;

    return sections;
  }

  String _formatForClipboard() {
    final period = _getDateRangeHeader();
    final days = _getUniqueDays();
    final sections = _generateClinicalSections();

    final buffer = StringBuffer();
    buffer.writeln('═══════════════════════════════════════');
    buffer.writeln('       CLINICAL HEALTH SUMMARY');
    buffer.writeln('═══════════════════════════════════════');
    buffer.writeln();
    buffer.writeln('Patient: $petName');
    buffer.writeln('Report Period: $period');
    buffer.writeln('Days Monitored: $days');
    buffer.writeln();
    buffer.writeln('───────────────────────────────────────');

    sections.forEach((title, section) {
      buffer.writeln();
      buffer.writeln('▸ $title');
      for (var item in section.items) {
        String line = '  ${item.label}: ${item.value}';
        if (item.detail != null) {
          line += ' ${item.detail}';
        }
        if (item.isWarning) {
          line += ' ⚠';
        }
        buffer.writeln(line);
      }
    });

    buffer.writeln();
    buffer.writeln('───────────────────────────────────────');
    buffer.writeln('Generated: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}');
    buffer.writeln('═══════════════════════════════════════');

    return buffer.toString();
  }

  void _copyToClipboard(BuildContext context) {
    final text = _formatForClipboard();
    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Build summary stat cards
  List<Widget> _buildSummaryStats() {
    final days = _getUniqueDays();
    
    // Food intake - grouped by unit
    final foodLogs = _getLogsByType('food_intake');
    final foodByUnit = _groupLogsByUnit(foodLogs);
    
    // Hydration (water + saline) - grouped by unit
    final waterLogs = _getLogsByType('water_intake');
    final salineLogs = _getLogsByType('saline');
    final waterByUnit = _groupLogsByUnit(waterLogs);
    final salineByUnit = _groupLogsByUnit(salineLogs);

    // Weight
    final weightLogs = _getLogsByType('weight');
    double currentWeight = 0;
    double weightChange = 0;
    String weightTrend = '--';
    if (weightLogs.isNotEmpty) {
      final sorted = weightLogs.toList()..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
      currentWeight = sorted.last.value ?? 0;
      if (sorted.length > 1) {
        weightChange = currentWeight - (sorted.first.value ?? 0);
        if (weightChange.abs() < 0.1) {
          weightTrend = 'Stable';
        } else {
          weightTrend = weightChange > 0 ? '↑' : '↓';
        }
      }
    }

    // Build food intake breakdown strings
    final foodBreakdown = <String>[];
    for (var entry in foodByUnit.entries) {
      final unit = entry.key;
      final total = _calculateTotalFromList(entry.value);
      final avg = total / days;
      foodBreakdown.add('${avg.toStringAsFixed(1)} $unit/day');
    }

    // Build hydration breakdown strings
    final hydrationBreakdown = <String>[];
    for (var entry in waterByUnit.entries) {
      final unit = entry.key;
      final total = _calculateTotalFromList(entry.value);
      final avg = total / days;
      hydrationBreakdown.add('💧 ${avg.toStringAsFixed(1)} $unit/day');
    }
    for (var entry in salineByUnit.entries) {
      final unit = entry.key;
      final total = _calculateTotalFromList(entry.value);
      final avg = total / days;
      hydrationBreakdown.add('💉 ${avg.toStringAsFixed(0)} $unit/day');
    }

    return [
      // Food and Hydration row
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _MultiUnitStatCard(
              icon: Icons.restaurant_menu,
              label: 'Food Intake',
              items: foodBreakdown.isEmpty ? ['No data'] : foodBreakdown,
              color: Colors.orange,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: _MultiUnitStatCard(
              icon: Icons.water_drop,
              label: 'Hydration',
              items: hydrationBreakdown.isEmpty ? ['No data'] : hydrationBreakdown,
              color: Colors.blue,
            ),
          ),
        ],
      ),
      SizedBox(height: 8),
      // Weight card
      _ClinicStatCard(
        icon: Icons.monitor_weight,
        label: 'Body Weight',
        value: currentWeight > 0 ? currentWeight.toStringAsFixed(2) : '--',
        unit: 'kg',
        subtitle: weightChange != 0 
            ? 'Change: ${weightChange >= 0 ? "+" : ""}${weightChange.toStringAsFixed(2)} kg ($weightTrend)'
            : null,
        color: Colors.green,
        fullWidth: true,
      ),
    ];
  }

  // Build daily activity count chart
  Widget _buildIntakeChart() {
    final foodLogs = _getLogsByType('food_intake');
    final waterLogs = _getLogsByType('water_intake');
    final salineLogs = _getLogsByType('saline');
    final medLogs = _getLogsByType('medication');

    // Group by date - count entries instead of summing values
    final Map<DateTime, _DailyActivityCount> dailyData = {};

    void addToDaily(List<ActivityLog> logs, String type) {
      for (var log in logs) {
        final date = DateTime(log.loggedAt.year, log.loggedAt.month, log.loggedAt.day);
        dailyData.putIfAbsent(date, () => _DailyActivityCount(date: date));
        switch (type) {
          case 'food':
            dailyData[date]!.foodCount++;
            break;
          case 'water':
            dailyData[date]!.waterCount++;
            break;
          case 'saline':
            dailyData[date]!.salineCount++;
            break;
          case 'medication':
            dailyData[date]!.medicationCount++;
            break;
        }
      }
    }

    addToDaily(foodLogs, 'food');
    addToDaily(waterLogs, 'water');
    addToDaily(salineLogs, 'saline');
    addToDaily(medLogs, 'medication');

    if (dailyData.isEmpty) {
      return SizedBox.shrink();
    }

    // Determine date range
    List<DateTime> allDates;
    if (startDate != null && endDate != null) {
      allDates = [];
      final start = DateTime(startDate!.year, startDate!.month, startDate!.day);
      final end = DateTime(endDate!.year, endDate!.month, endDate!.day);
      for (var d = start; d.isBefore(end) || d.isAtSameMomentAs(end); d = d.add(const Duration(days: 1))) {
        allDates.add(d);
      }
    } else {
      allDates = dailyData.keys.toList()..sort();
    }

    // Calculate max for scaling
    int maxCount = 0;
    for (var d in allDates) {
      final data = dailyData[d];
      if (data != null) {
        final total = data.foodCount + data.waterCount + data.salineCount + data.medicationCount;
        if (total > maxCount) maxCount = total;
      }
    }
    if (maxCount == 0) maxCount = 1;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart, color: Colors.blue.shade700, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Daily Activity Count',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            'Number of log entries per day',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
          SizedBox(height: 12),
          // Legend
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              _LegendItem(color: Colors.orange, label: 'Food'),
              _LegendItem(color: Colors.lightBlue, label: 'Water'),
              _LegendItem(color: Colors.blue.shade700, label: 'Saline'),
              _LegendItem(color: Colors.purple, label: 'Meds'),
            ],
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: allDates.length,
              itemBuilder: (context, index) {
                final date = allDates[index];
                final data = dailyData[date] ?? _DailyActivityCount(date: date);
                
                // Calculate heights based on count
                const maxHeight = 80.0;
                final scale = maxHeight / maxCount;
                final foodH = (data.foodCount * scale).clamp(0.0, maxHeight);
                final waterH = (data.waterCount * scale).clamp(0.0, maxHeight);
                final salineH = (data.salineCount * scale).clamp(0.0, maxHeight);
                final medH = (data.medicationCount * scale).clamp(0.0, maxHeight);
                
                final totalCount = data.foodCount + data.waterCount + data.salineCount + data.medicationCount;
                
                return Container(
                  width: 60,
                  margin: EdgeInsets.only(right: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Total count label
                      if (totalCount > 0)
                        Text(
                          '$totalCount',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      SizedBox(height: 2),
                      // Bars side by side
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (data.foodCount > 0)
                            _BarSegment(height: foodH, color: Colors.orange),
                          if (data.waterCount > 0)
                            _BarSegment(height: waterH, color: Colors.lightBlue),
                          if (data.salineCount > 0)
                            _BarSegment(height: salineH, color: Colors.blue.shade700),
                          if (data.medicationCount > 0)
                            _BarSegment(height: medH, color: Colors.purple),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        DateFormat('d/M').format(date),
                        style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final period = _getDateRangeHeader();
    final days = _getUniqueDays();
    final sections = _generateClinicalSections();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 12, 0),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.medical_information, color: Colors.blue.shade700, size: 24),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Clinical Health Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      Text(
                        petName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          
          // Period badge
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.blue.shade700),
                      SizedBox(width: 6),
                      Text(
                        period,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$days days',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Summary Stats
                  ..._buildSummaryStats(),
                  
                  SizedBox(height: 16),
                  
                  // Intake Chart
                  _buildIntakeChart(),
                  
                  SizedBox(height: 20),
                  
                  // Clinical Sections
                  Text(
                    'Detailed Clinical Report',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 12),
                  
                  ...sections.entries.map((entry) => _buildSectionCard(entry.key, entry.value)),
                  
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
          
          // Bottom action
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: SafeArea(
              child: ElevatedButton.icon(
                onPressed: () => _copyToClipboard(context),
                icon: Icon(Icons.copy),
                label: Text('Copy Report to Clipboard'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, _ReportSection section) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: section.color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: section.color.withOpacity(0.08),
              borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              children: [
                Icon(section.icon, color: section.color, size: 18),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: section.color,
                  ),
                ),
              ],
            ),
          ),
          // Section items
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: section.items.map((item) => _buildReportItem(item)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportItem(_ReportItem item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              item.label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    item.value,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: item.isWarning ? Colors.orange.shade700 : Colors.grey.shade800,
                    ),
                  ),
                ),
                if (item.detail != null) ...[
                  SizedBox(width: 4),
                  Text(
                    item.detail!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
                if (item.isWarning) ...[
                  SizedBox(width: 4),
                  Icon(Icons.warning_amber_rounded, size: 14, color: Colors.orange),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Helper classes
class _ReportSection {
  final IconData icon;
  final Color color;
  final List<_ReportItem> items = [];

  _ReportSection({required this.icon, required this.color});
}

class _ReportItem {
  final String label;
  final String value;
  final String? detail;
  final bool isWarning;

  _ReportItem({
    required this.label,
    required this.value,
    this.detail,
    this.isWarning = false,
  });
}

class _MedicationEntry {
  final String name;
  final String unit;
  int count = 0;
  double totalValue = 0;

  _MedicationEntry({required this.name, required this.unit});
}

class _DailyIntake {
  final DateTime date;
  double food = 0;
  double water = 0;
  double saline = 0;

  _DailyIntake({required this.date});
}

class _DailyActivityCount {
  final DateTime date;
  int foodCount = 0;
  int waterCount = 0;
  int salineCount = 0;
  int medicationCount = 0;

  _DailyActivityCount({required this.date});
}

class _BarSegment extends StatelessWidget {
  final double height;
  final Color color;

  const _BarSegment({required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: height,
      margin: EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
      ),
    );
  }
}

class _MultiUnitStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<String> items;
  final Color color;

  const _MultiUnitStatCard({
    required this.icon,
    required this.label,
    required this.items,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.08), color.withOpacity(0.04)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          ...items.map((item) => Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Text(
              item,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),
          )),
        ],
      ),
    );
  }
}

class _ClinicStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final String? subtitle;
  final Color color;
  final bool fullWidth;

  const _ClinicStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    this.subtitle,
    required this.color,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.08), color.withOpacity(0.04)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: color.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 12,
                  color: color.withOpacity(0.7),
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
