import 'package:flutter/material.dart';

/// Data model for report items
class ReportItem {
  /// Creates a report item
  const ReportItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  /// Report title
  final String title;

  /// Report subtitle/description
  final String subtitle;

  /// Report icon
  final IconData icon;

  /// Report theme color
  final Color color;
}

/// Reports page for viewing various farm and livestock reports
class ReportsPage extends StatefulWidget {
  /// Creates a reports page
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();

  /// Creates a route for the ReportsPage
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ReportsPage());
  }
}

class _ReportsPageState extends State<ReportsPage> {
  String _selectedTimePeriod = 'Today';

  final List<String> _timePeriods = [
    'Today',
    'Yesterday',
    'Last Week',
    'Last Month',
    'Custom',
  ];

  final List<ReportItem> _reportItems = [
    const ReportItem(
      title: 'Profit & Loss',
      subtitle: 'Overall financial performance',
      icon: Icons.trending_up,
      color: Colors.green,
    ),
    const ReportItem(
      title: 'Income Report',
      subtitle: 'Revenue from sales and services',
      icon: Icons.attach_money,
      color: Colors.blue,
    ),
    const ReportItem(
      title: 'Expenses Report',
      subtitle: 'All farm related expenses',
      icon: Icons.money_off,
      color: Colors.red,
    ),
    const ReportItem(
      title: 'Feed Report',
      subtitle: 'Animal feed consumption and costs',
      icon: Icons.grass,
      color: Colors.orange,
    ),
    const ReportItem(
      title: 'Milk Sale Report',
      subtitle: 'Daily milk production and sales',
      icon: Icons.opacity,
      color: Colors.indigo,
    ),
    const ReportItem(
      title: 'Fixed Investment',
      subtitle: 'Infrastructure and equipment costs',
      icon: Icons.home_work,
      color: Colors.purple,
    ),
    const ReportItem(
      title: 'Breeding Report',
      subtitle: 'Animal breeding records and outcomes',
      icon: Icons.pets,
      color: Colors.pink,
    ),
    const ReportItem(
      title: 'Health Report',
      subtitle: 'Animal health monitoring and treatments',
      icon: Icons.health_and_safety,
      color: Colors.teal,
    ),
    const ReportItem(
      title: 'Deworming Report',
      subtitle: 'Deworming schedule and treatments',
      icon: Icons.medical_services,
      color: Colors.cyan,
    ),
    const ReportItem(
      title: 'Bio Security Spray',
      subtitle: 'Bio security measures and spraying',
      icon: Icons.sanitizer,
      color: Colors.amber,
    ),
    const ReportItem(
      title: 'Milk Output Report',
      subtitle: 'Detailed milk production analysis',
      icon: Icons.local_drink,
      color: Colors.lightBlue,
    ),
    const ReportItem(
      title: 'Breeding History',
      subtitle: 'Complete breeding lineage records',
      icon: Icons.history,
      color: Colors.deepOrange,
    ),
    const ReportItem(
      title: 'View All Reports',
      subtitle: 'Comprehensive report dashboard',
      icon: Icons.dashboard,
      color: Colors.grey,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Period Dropdown
            _buildTimePeriodDropdown(),

            const SizedBox(height: 24),

            // Reports List
            Expanded(
              child: ListView.separated(
                itemCount: _reportItems.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final report = _reportItems[index];
                  return _buildReportListTile(report);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a report list tile
  Widget _buildReportListTile(ReportItem report) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: report.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            report.icon,
            color: report.color,
            size: 24,
          ),
        ),
        title: Text(
          report.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          report.subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[400],
        ),
        onTap: () => _navigateToReport(report),
      ),
    );
  }

  /// Builds the time period selection dropdown
  Widget _buildTimePeriodDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Time Period',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedTimePeriod,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              hint: const Text('Select time period'),
              items: _timePeriods.map((String period) {
                return DropdownMenuItem<String>(
                  value: period,
                  child: Row(
                    children: [
                      Icon(
                        _getTimePeriodIcon(period),
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(period),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedTimePeriod = newValue;
                  });

                  if (newValue == 'Custom') {
                    _showCustomDatePicker();
                  }
                }
              },
            ),
          ),
        ),

        // Show selected period info
        if (_selectedTimePeriod.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Reports for: $_selectedTimePeriod',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  /// Exports the report (placeholder functionality)
  void _exportReport(ReportItem report) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${report.title} exported successfully!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () {
            // Open exported file
          },
        ),
      ),
    );
  }

  /// Formats date range for display
  String _formatDateRange(DateTimeRange range) {
    final startDate = '${range.start.day}/${range.start.month}/${range.start.year}';
    final endDate = '${range.end.day}/${range.end.month}/${range.end.year}';
    return '$startDate - $endDate';
  }

  /// Gets the appropriate icon for time period
  IconData _getTimePeriodIcon(String period) {
    switch (period) {
      case 'Today':
        return Icons.today;
      case 'Yesterday':
        return Icons.history;
      case 'Last Week':
        return Icons.date_range;
      case 'Last Month':
        return Icons.calendar_month;
      case 'Custom':
        return Icons.edit_calendar;
      default:
        return Icons.access_time;
    }
  }

  /// Navigates to specific report page
  void _navigateToReport(ReportItem report) {
    // Show loading dialog
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text('Generating ${report.title}...'),
            ],
          ),
        );
      },
    );

    // Simulate report generation
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Close loading dialog

      // Show report preview
      _showReportPreview(report);
    });
  }

  /// Shows custom date picker for custom time period
  Future<void> _showCustomDatePicker() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 7)),
        end: DateTime.now(),
      ),
      helpText: 'Select Custom Date Range',
      cancelText: 'Cancel',
      confirmText: 'Apply',
    );

    if (picked != null) {
      setState(() {
        _selectedTimePeriod = 'Custom (${_formatDateRange(picked)})';
      });
    } else {
      // Reset to Today if user cancels
      setState(() {
        _selectedTimePeriod = 'Today';
      });
    }
  }

  /// Shows a preview of the selected report
  void _showReportPreview(ReportItem report) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: report.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        report.icon,
                        color: report.color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report.title,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Period: $_selectedTimePeriod',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Report content placeholder
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.analytics,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Report Preview',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'This is a preview of the ${report.title} for the selected period. '
                              'The actual report will contain detailed data and analytics.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.close),
                              label: const Text('Close'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _exportReport(report),
                              icon: const Icon(Icons.download),
                              label: const Text('Export'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
