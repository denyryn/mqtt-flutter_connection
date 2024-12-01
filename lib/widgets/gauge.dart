import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class Gauge extends StatelessWidget {
  final String label;
  final RxDouble value;
  final double min;
  final double max;

  const Gauge(
      {super.key,
      required this.value,
      required this.min,
      required this.max,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                    fontSize: context.textTheme.bodyLarge!.fontSize,
                    fontWeight: context.textTheme.bodyLarge!.fontWeight),
              ),
              const SizedBox(height: 20),
              AnimatedRadialGauge(
                duration: const Duration(seconds: 1),
                curve: Curves.easeOutQuad,
                radius: 100,
                axis: GaugeAxis(
                    min: min,
                    max: max,
                    degrees: 270,
                    style: GaugeAxisStyle(
                      thickness: 30,
                      background: Colors.transparent,
                      segmentSpacing: 2,
                      blendColors: true,
                      cornerRadius: Radius.circular(80),
                    ),

                    /// Define the progress bar (optional).
                    progressBar: GaugeProgressBar.rounded(
                      color: Colors.transparent,
                    ),

                    /// Define axis segments (optional).
                    segments: [
                      GaugeSegment(
                        from: min,
                        to: max / 3,
                        color: Colors.blue[300]!,
                        cornerRadius: const Radius.circular(8),
                      ),
                      GaugeSegment(
                        from: max / 3 + 1,
                        to: (max / 3) * 2,
                        color: Colors.yellow[300]!,
                        cornerRadius: const Radius.circular(8),
                      ),
                      GaugeSegment(
                        from: (max / 3) * 2 + 1,
                        to: max,
                        color: Colors.red[300]!,
                        cornerRadius: const Radius.circular(8),
                      ),
                    ]),
                value: value.value,
                builder: (context, child, value) => RadialGaugeLabel(
                  value: value,
                  style: TextStyle(
                    color: context.textTheme.headlineSmall!.color,
                    fontSize: context.textTheme.headlineSmall!.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('°C'),
              ),
            ],
          ),
        ));
  }
}
