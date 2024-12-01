import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/gauge.dart';
import '../view_models/observ_viewmodel.dart';

class ObservPage extends StatelessWidget {
  const ObservPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ObservViewModel _viewModel = Get.put(ObservViewModel());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Observation Page'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // Make the content scrollable
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.count(
                    childAspectRatio: 1,
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    children: [
                      Obx(
                        () => Gauge(
                          label: "Temperature (C)",
                          value: _viewModel
                              .dhtController.dhtValue.value.temperature.obs,
                          min: 0,
                          max: 60,
                        ),
                      ),
                      Obx(() => Gauge(
                            label: "Humidity (%)",
                            value: _viewModel
                                .dhtController.dhtValue.value.humidity.obs,
                            min: 0,
                            max: 100,
                          )),
                      Obx(() => Gauge(
                            label: "Intensity (cd)",
                            value: _viewModel
                                .ldrController.ldrValue.value.intensity.obs,
                            min: 0,
                            max: 1000,
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() => AspectRatio(
                      aspectRatio: 2.0,
                      child: LineChart(
                          curve: Curves.ease,
                          LineChartData(
                              minY: 0,
                              maxY: 100,
                              gridData: const FlGridData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  isStrokeCapRound: false,
                                  dotData: const FlDotData(
                                    show: false,
                                  ),
                                  barWidth: 3,
                                  color: Colors.orangeAccent,
                                  isCurved: true,
                                  spots:
                                      _viewModel.dhtController.temperatureData,
                                ),
                                LineChartBarData(
                                  isStrokeCapRound: false,
                                  dotData: const FlDotData(show: false),
                                  barWidth: 3,
                                  color: Colors.blueAccent,
                                  isCurved: true,
                                  spots: _viewModel.dhtController.humidityData,
                                ),
                              ])),
                    )),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
