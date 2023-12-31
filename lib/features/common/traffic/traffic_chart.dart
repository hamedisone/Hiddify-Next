import 'package:dartx/dartx.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hiddify/domain/connectivity/connectivity.dart';
import 'package:hiddify/features/common/traffic/traffic_notifier.dart';
import 'package:hiddify/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// TODO: test implementation, rewrite
class TrafficChart extends HookConsumerWidget {
  const TrafficChart({
    super.key,
    this.chartSteps = 20,
  });

  final int chartSteps;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTraffics = ref.watch(trafficNotifierProvider);

    switch (asyncTraffics) {
      case AsyncData(value: final traffics):
        return _Chart(traffics, chartSteps);
      case AsyncLoading(:final value):
        if (value == null) return const SizedBox();
        return _Chart(value, chartSteps);
      default:
        return const SizedBox();
    }
  }
}

class _Chart extends StatelessWidget {
  const _Chart(this.records, this.steps);

  final List<Traffic> records;
  final int steps;

  @override
  Widget build(BuildContext context) {
    final latest = records.lastOrNull ?? const Traffic(upload: 0, download: 0);
    final latestUploadData = formatByteSpeed(latest.upload);
    final latestDownloadData = formatByteSpeed(latest.download);

    final uploadChartSpots = records.takeLast(steps).mapIndexed(
          (index, p) => FlSpot(index.toDouble(), p.upload.toDouble()),
        );
    final downloadChartSpots = records.takeLast(steps).mapIndexed(
          (index, p) => FlSpot(index.toDouble(), p.download.toDouble()),
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 68,
          child: LineChart(
            LineChartData(
              minY: 0,
              borderData: FlBorderData(show: false),
              titlesData: const FlTitlesData(show: false),
              gridData: const FlGridData(show: false),
              lineTouchData: const LineTouchData(enabled: false),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  preventCurveOverShooting: true,
                  dotData: const FlDotData(show: false),
                  spots: uploadChartSpots.toList(),
                ),
                LineChartBarData(
                  color: Theme.of(context).colorScheme.tertiary,
                  isCurved: true,
                  preventCurveOverShooting: true,
                  dotData: const FlDotData(show: false),
                  spots: downloadChartSpots.toList(),
                ),
              ],
            ),
            duration: Duration.zero,
          ),
        ),
        const Gap(16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("↑"),
            Text(latestUploadData.size),
            Text(latestUploadData.unit),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("↓"),
            Text(latestDownloadData.size),
            Text(latestDownloadData.unit),
          ],
        ),
        const Gap(16),
      ],
    );
  }
}
