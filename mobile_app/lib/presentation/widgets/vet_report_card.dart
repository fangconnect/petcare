import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../data/models/models.dart';

class VetReportCard extends StatelessWidget {
  final List<ActivityLog> logs;
  final Pet pet;

  const VetReportCard({
    super.key,
    required this.logs,
    required this.pet,
  });

  // Calculate date range from logs
  String _getDateRangeHeader() {
    if (logs.isEmpty) return 'Health Summary';
    
    final dates = logs.map((log) => log.loggedAt).toList();
    dates.sort();
    
    final startDate = dates.first;
    final endDate = dates.last;
    
    final startStr = DateFormat('MMM dd').format(startDate);
    final endStr = DateFormat('MMM dd').format(endDate);
    
    return 'Health Summary ($startStr - $endStr)';
  }

  // Group logs by activity name
  Map<String, List<ActivityLog>> _groupLogsByActivity() {
    final Map<String, List<ActivityLog>> grouped = {};
    
    for (var log in logs) {
      if (log.activityType.isNotEmpty) {
        final activityName = log.activityType;
        if (!grouped.containsKey(activityName)) {
          grouped[activityName] = [];
        }
        grouped[activityName]!.add(log);
      }
    }
    
    return grouped;
  }

  // Calculate statistics for each activity
  List<Map<String, dynamic>> _calculateStats() {
    final groupedLogs = _groupLogsByActivity();
    final List<Map<String, dynamic>> stats = [];
    
    groupedLogs.forEach((activityName, activityLogs) {
      if (activityLogs.isEmpty) return;
      
      final firstLog = activityLogs.first;
      
      // Special handling for Medication - show list of medications
      final lowerName = activityName.toLowerCase();
      if (lowerName.contains('medication') || 
          lowerName.contains('medicine') || 
          lowerName.contains('ยา')) {
        // Get list of medications with their dates
        final medEntries = activityLogs
            .where((log) => log.notes != null && log.notes!.isNotEmpty)
            .map((log) => log.notes!)
            .toList();
        
        final medList = medEntries.isNotEmpty 
            ? medEntries.join(', ') 
            : 'No medications recorded';
        
        stats.add({
          'name': activityName,
          'display': '$activityName:\n$medList',
          'type': 'medication',
          'value': activityLogs.length,
          'medications': medList,
        });
        return;
      }
      
      // For checkboxes, count completions
      final inputType = firstLog.inputType;
      if (inputType == 'checkbox') {
        final completedCount = activityLogs.where((log) => log.isChecked).length;
        stats.add({
          'name': activityName,
          'display': 'Completed: $completedCount times',
          'type': 'count',
          'value': completedCount,
        });
      }
      // For numeric inputs
      else if (inputType == 'number') {
        final numericLogs = activityLogs.where((log) => log.value != null).toList();
        
        if (numericLogs.isEmpty) return;
        
        final values = numericLogs.map((log) => log.value!).toList();
        final unit = firstLog.unit ?? '';
        
        // Determine if this is a sum or average type
        final isSum = lowerName.contains('saline') || 
                      lowerName.contains('fluid') || 
                      lowerName.contains('food') ||
                      lowerName.contains('water');
        
        if (isSum) {
          // Calculate sum and daily average
          final total = values.reduce((a, b) => a + b);
          final dailyAvg = total / _getUniqueDays();
          
          stats.add({
            'name': activityName,
            'display': 'Total $activityName: ${total.toStringAsFixed(1)} $unit (Daily Avg: ${dailyAvg.toStringAsFixed(1)} $unit)',
            'type': 'sum',
            'value': total,
            'dailyAvg': dailyAvg,
            'unit': unit,
          });
        } else {
          // Calculate average, min, max
          final avg = values.reduce((a, b) => a + b) / values.length;
          final min = values.reduce((a, b) => a < b ? a : b);
          final max = values.reduce((a, b) => a > b ? a : b);
          
          stats.add({
            'name': activityName,
            'display': 'Avg $activityName: ${avg.toStringAsFixed(1)} $unit (Min: ${min.toStringAsFixed(1)}, Max: ${max.toStringAsFixed(1)})',
            'type': 'avg',
            'value': avg,
            'min': min,
            'max': max,
            'unit': unit,
          });
        }
      }
    });
    
    return stats;
  }

  // Get number of unique days in the log range
  int _getUniqueDays() {
    if (logs.isEmpty) return 1;
    
    final uniqueDates = logs.map((log) {
      final date = log.loggedAt;
      return DateTime(date.year, date.month, date.day);
    }).toSet();
    
    return uniqueDates.length > 0 ? uniqueDates.length : 1;
  }

  // Find the most frequent numeric activity for charting
  Map<String, dynamic>? _getMostFrequentNumericActivity() {
    final groupedLogs = _groupLogsByActivity();
    
    String? mostFrequentActivity;
    int maxCount = 0;
    
    groupedLogs.forEach((activityName, activityLogs) {
      if (activityLogs.isNotEmpty) {
        final inputType = activityLogs.first.inputType;
        if (inputType == 'number') {
          final numericCount = activityLogs.where((log) => log.value != null).length;
          if (numericCount > maxCount) {
            maxCount = numericCount;
            mostFrequentActivity = activityName;
          }
        }
      }
    });
    
    if (mostFrequentActivity == null) return null;
    
    final activityLogs = groupedLogs[mostFrequentActivity]!
        .where((log) => log.value != null)
        .toList();
    
    activityLogs.sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
    
    return {
      'name': mostFrequentActivity,
      'logs': activityLogs,
      'unit': activityLogs.first.unit ?? '',
    };
  }

  // Get saline activity data for charting
  Map<String, dynamic>? _getSalineData() {
    final groupedLogs = _groupLogsByActivity();
    
    for (var entry in groupedLogs.entries) {
      if (entry.key.toLowerCase().contains('saline')) {
        final salineLogs = entry.value
            .where((log) => log.value != null)
            .toList();
        
        if (salineLogs.isEmpty) return null;
        
        salineLogs.sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
        
        return {
          'name': entry.key,
          'logs': salineLogs,
          'unit': salineLogs.first.unit ?? 'ml',
        };
      }
    }
    return null;
  }

  // Get food activity data for charting
  Map<String, dynamic>? _getFoodData() {
    final groupedLogs = _groupLogsByActivity();
    
    // Combine all food-related activities
    final foodLogs = <ActivityLog>[];
    
    for (var entry in groupedLogs.entries) {
      final lowerName = entry.key.toLowerCase();
      if (lowerName.contains('food') || lowerName.contains('อาหาร')) {
        foodLogs.addAll(entry.value.where((log) => log.value != null));
      }
    }
    
    if (foodLogs.isEmpty) return null;
    
    foodLogs.sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
    
    return {
      'name': 'Food Intake',
      'logs': foodLogs,
      'unit': foodLogs.first.unit ?? 'ml',
    };
  }

  // Generate chart data
  List<FlSpot> _generateChartData(List<ActivityLog> activityLogs) {
    if (activityLogs.isEmpty) return [];
    
    activityLogs.sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
    
    // Group by date and sum values per day
    final dailyData = <DateTime, double>{};
    for (var log in activityLogs) {
      final dateOnly = DateTime(log.loggedAt.year, log.loggedAt.month, log.loggedAt.day);
      dailyData[dateOnly] = (dailyData[dateOnly] ?? 0) + (log.value ?? 0);
    }
    
    print('DEBUG: Total logs: ${activityLogs.length}');
    print('DEBUG: Unique dates: ${dailyData.length}');
    
    // Sort dates and create chart spots
    final sortedDates = dailyData.keys.toList()..sort();
    
    final spots = sortedDates.asMap().entries.map((entry) {
      final index = entry.key;
      final date = entry.value;
      final value = dailyData[date]!;
      print('DEBUG: Day $index -> $value (date: $date)');
      return FlSpot(index.toDouble(), value);
    }).toList();
    
    return spots;
  }



  // Format report for clipboard
  String _formatReportForClipboard() {
    final stats = _calculateStats();
    final petName = pet.name;
    
    if (logs.isEmpty) return 'No data available for $petName';
    
    final dates = logs.map((log) => log.loggedAt).toList();
    dates.sort();
    
    final startDate = DateFormat('d MMM').format(dates.first);
    final endDate = DateFormat('d MMM').format(dates.last);
    
    final buffer = StringBuffer();
    buffer.writeln('รายงานน้อง$petName ($startDate-$endDate)');
    
    for (var stat in stats) {
      final name = stat['name'] as String;
      final type = stat['type'] as String;
      
      if (type == 'medication') {
        final meds = stat['medications'] as String;
        buffer.writeln('- ${_translateActivityName(name)}:\n  $meds');
      } else if (type == 'sum') {
        final total = stat['value'] as double;
        final unit = stat['unit'] as String;
        buffer.writeln('- ${_translateActivityName(name)}: รวม ${total.toStringAsFixed(1)} $unit');
      } else if (type == 'avg') {
        final avg = stat['value'] as double;
        final unit = stat['unit'] as String;
        buffer.writeln('- ${_translateActivityName(name)}: เฉลี่ย ${avg.toStringAsFixed(1)} $unit');
      } else if (type == 'count') {
        final count = stat['value'] as int;
        buffer.writeln('- ${_translateActivityName(name)}: $count ครั้ง');
      }
    }
    
    return buffer.toString();
  }

  // Simple translation helper (can be extended)
  String _translateActivityName(String name) {
    final lowerName = name.toLowerCase();
    
    if (lowerName.contains('saline') || lowerName.contains('fluid')) {
      return 'น้ำเกลือ';
    } else if (lowerName.contains('weight')) {
      return 'น้ำหนัก';
    } else if (lowerName.contains('food')) {
      return 'อาหาร';
    } else if (lowerName.contains('medication') || lowerName.contains('medicine')) {
      return 'ยา';
    }
    
    return name;
  }

  // Copy to clipboard
  void _copyToClipboard(BuildContext context) {
    final report = _formatReportForClipboard();
    Clipboard.setData(ClipboardData(text: report));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Report copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stats = _calculateStats();
    final salineData = _getSalineData();
    final foodData = _getFoodData();
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Text(
            _getDateRangeHeader(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          // Stats Grid
          if (stats.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: stats.map((stat) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Text(
                    stat['display'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ] else ...[
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No statistics available'),
              ),
            ),
          ],
          
          // Saline Chart
          if (salineData != null) ...[
            const Divider(),
            const SizedBox(height: 8),
            Text(
              '${salineData['name']} Trend',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(0),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        interval: 1.0,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            'Day ${value.toInt()}',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _generateChartData(salineData['logs'] as List<ActivityLog>),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Food Chart
          if (foodData != null) ...[
            const Divider(),
            const SizedBox(height: 8),
            Text(
              '${foodData['name']} Trend',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(0),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        interval: 1.0,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            'Day ${value.toInt()}',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _generateChartData(foodData['logs'] as List<ActivityLog>),
                      isCurved: true,
                      color: Colors.orange,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.orange.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Copy Button
          ElevatedButton.icon(
            onPressed: () => _copyToClipboard(context),
            icon: const Icon(Icons.copy),
            label: const Text('Copy Report to Clipboard'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
