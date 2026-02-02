import 'dart:async';
import 'dart:math';

class TelemetryData {
  final double rpm;
  final double tps; // Throttle Position Sensor (0.0 to 1.0 or 0-100)
  final double oilTemp;
  final double waterTemp;
  final double batteryVoltage;

  TelemetryData({
    this.rpm = 0,
    this.tps = 0,
    this.oilTemp = 0,
    this.waterTemp = 0,
    this.batteryVoltage = 0,
  });
}

abstract class TelemetryService {
  Stream<TelemetryData> get telemetryStream;
  void dispose();
}

class MockTelemetryService implements TelemetryService {
  final _controller = StreamController<TelemetryData>.broadcast();
  Timer? _timer;
  double _currentRpm = 1000;
  double _currentTps = 0;
  bool _accelerating = true;

  MockTelemetryService() {
    // Simulate 60Hz data update
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      _updateSimulation();
      _controller.add(TelemetryData(
        rpm: _currentRpm,
        tps: _currentTps,
        oilTemp: 95 + sin(timer.tick * 0.01) * 5,
        waterTemp: 85 + cos(timer.tick * 0.01) * 5,
        batteryVoltage: 13.8 + sin(timer.tick * 0.1) * 0.2,
      ));
    });
  }

  void _updateSimulation() {
    // Simple simulation logic
    if (_accelerating) {
      _currentTps += 2.0;
      if (_currentTps > 100) _currentTps = 100;
      
      _currentRpm += 100;
      if (_currentRpm > 7500) {
        _currentRpm = 5000; // Shift gear / drop RPM
      }
      
      // Randomly let off gas
      if (Random().nextInt(100) > 98) _accelerating = false;
    } else {
      _currentTps -= 5.0;
      if (_currentTps < 0) _currentTps = 0;
      
      _currentRpm -= 150;
      if (_currentRpm < 1000) {
        _currentRpm = 1000;
        _accelerating = true; // Start accelerating again
      }
    }
  }

  @override
  Stream<TelemetryData> get telemetryStream => _controller.stream;

  @override
  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}
