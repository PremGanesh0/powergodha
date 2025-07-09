import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:powergodha/home/bloc/bloc.dart';

import 'package:powergodha/shared/shared.dart';

/// User information card
class RecordInfoCard extends StatelessWidget {
  const RecordInfoCard({super.key, this.profitLossReport});

  final Map<String, dynamic>? profitLossReport;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias, // Ensures image respects border radius
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset('assets/profit_back.png', fit: BoxFit.cover),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(AppTypography.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppTypography.space32),
                const SizedBox(height: AppTypography.space32),
                const SizedBox(height: AppTypography.space32),
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    // Extract date from API response if available
                    var displayDate = DateFormat(
                      'yyyy-MM-dd',
                    ).format(DateTime.now());

                    if (state.profitLossReport != null) {
                      final report = state.profitLossReport!;
                      if (report.containsKey('data') && report['data'] is Map) {
                        final data = report['data'] as Map<String, dynamic>;
                        final dateString = data['date'] as String?;
                        if (dateString != null) {
                          try {
                            final parsedDate = DateTime.parse(dateString);
                            displayDate = DateFormat(
                              'yyyy-MM-dd',
                            ).format(parsedDate);
                          } catch (e) {
                            print('Error parsing date: $e');
                          }
                        }
                      }
                    }

                    return Text(
                      'Latest profit/loss of your farm \n $displayDate',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                ),
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state.status == HomeStatus.loading) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }

                    if (state.status == HomeStatus.error) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Error: ${state.errorMessage}',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(color: Colors.red),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              context.read<HomeBloc>().add(
                                const GetProfitLossReport(),
                              );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      );
                    }

                    var profitAmount = '₹0/-';
                    var profitType = '';

                    // Handle the API response structure
                    if (state.profitLossReport != null) {
                      final report = state.profitLossReport!;

                      // Check if we have the nested data structure
                      if (report.containsKey('data') && report['data'] is Map) {
                        final data = report['data'] as Map<String, dynamic>;
                        final amount = data['profit_loss'] ?? '0';
                        final key = data['key'] ?? '';

                        // Convert string to number for formatting
                        final numericAmount =
                            double.tryParse(amount.toString()) ?? 0.0;
                        final absoluteAmount = numericAmount.abs();

                        profitAmount =
                            '₹${absoluteAmount.toStringAsFixed(0)}/-';
                        profitType = key == 'loss' ? ' (Loss)' : ' (Profit)';
                      }
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profitAmount,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: profitType.contains('Loss')
                                    ? Colors.red
                                    : Colors.green,
                              ),
                        ),
                        if (profitType.isNotEmpty)
                          Text(
                            profitType,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: profitType.contains('Loss')
                                      ? Colors.red
                                      : Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppTypography.space16),
                const SizedBox(height: AppTypography.space8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Write Record',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                    ),
                    const Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
