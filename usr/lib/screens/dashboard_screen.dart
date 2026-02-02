import 'package:flutter/material.dart';
import 'package:couldai_user_app/services/telemetry_service.dart';
import 'package:couldai_user_app/widgets/telemetry_widgets.dart';
import 'package:couldai_user_app/widgets/video_feed.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late TelemetryService _telemetryService;
  late Stream<TelemetryData> _telemetryStream;

  @override
  void initState() {
    super.initState();
    _telemetryService = MockTelemetryService();
    _telemetryStream = _telemetryService.telemetryStream;
  }

  @override
  void dispose() {
    _telemetryService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Layer 1: Video Feed
          const Positioned.fill(
            child: VideoFeedPlaceholder(),
          ),

          // Layer 2: Telemetry Overlay
          Positioned.fill(
            child: StreamBuilder<TelemetryData>(
              stream: _telemetryStream,
              builder: (context, snapshot) {
                final data = snapshot.data ?? TelemetryData();
                
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top Bar: Temps and Voltage
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              DataCard(
                                label: "OIL TEMP",
                                value: data.oilTemp.toStringAsFixed(1),
                                unit: "°C",
                              ),
                              const SizedBox(width: 16),
                              DataCard(
                                label: "H2O TEMP",
                                value: data.waterTemp.toStringAsFixed(1),
                                unit: "°C",
                              ),
                            ],
                          ),
                          DataCard(
                            label: "BATT",
                            value: data.batteryVoltage.toStringAsFixed(1),
                            unit: "V",
                          ),
                        ],
                      ),

                      // Bottom Bar: RPM and TPS
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // TPS on the left
                          TpsBar(tps: data.tps),
                          
                          const SizedBox(width: 24),
                          
                          // RPM in the middle/bottom
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RpmGauge(currentRpm: data.rpm),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Layer 3: Close/Settings Button
          Positioned(
            top: 24,
            right: 24,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white54),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
              tooltip: "Disconnect & Exit",
            ),
          ),
        ],
      ),
    );
  }
}
