import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  bool _isVideoConnected = false;
  bool _isTelemetryConnected = false;
  bool _isConnectingVideo = false;
  bool _isConnectingTelemetry = false;

  Future<void> _connectVideo() async {
    setState(() {
      _isConnectingVideo = true;
    });
    // Simulate hardware discovery delay
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isVideoConnected = true;
        _isConnectingVideo = false;
      });
    }
  }

  Future<void> _connectTelemetry() async {
    setState(() {
      _isConnectingTelemetry = true;
    });
    // Simulate network/bluetooth discovery delay
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isTelemetryConnected = true;
        _isConnectingTelemetry = false;
      });
    }
  }

  void _launchDashboard() {
    Navigator.of(context).pushReplacementNamed('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final bool readyToLaunch = _isVideoConnected && _isTelemetryConnected;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "SYSTEM SETUP",
                textAlign: TextAlign.center,
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 48),
              
              // Connection Cards
              Row(
                children: [
                  Expanded(
                    child: _buildConnectionCard(
                      title: "VIDEO SOURCE",
                      subtitle: "Blackmagic Capture",
                      icon: Icons.videocam,
                      isConnected: _isVideoConnected,
                      isConnecting: _isConnectingVideo,
                      onConnect: _connectVideo,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildConnectionCard(
                      title: "TELEMETRY",
                      subtitle: "RaceCapture / CAN Bus",
                      icon: Icons.speed,
                      isConnected: _isTelemetryConnected,
                      isConnecting: _isConnectingTelemetry,
                      onConnect: _connectTelemetry,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 48),
              
              // Launch Button
              SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: readyToLaunch ? _launchDashboard : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    disabledBackgroundColor: Colors.white10,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "LAUNCH DASHBOARD",
                    style: GoogleFonts.orbitron(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: readyToLaunch ? Colors.white : Colors.white38,
                    ),
                  ),
                ),
              ),
              
              if (!readyToLaunch)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    "Please connect both video and telemetry sources to proceed.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      color: Colors.white38,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isConnected,
    required bool isConnecting,
    required VoidCallback onConnect,
  }) {
    Color statusColor = isConnected ? Colors.greenAccent : Colors.redAccent;
    String statusText = isConnected ? "CONNECTED" : "DISCONNECTED";
    if (isConnecting) {
      statusColor = Colors.orangeAccent;
      statusText = "CONNECTING...";
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isConnected ? Colors.greenAccent.withOpacity(0.5) : Colors.white10,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.white70),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.roboto(
              color: Colors.white54,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: statusColor.withOpacity(0.5)),
            ),
            child: Text(
              statusText,
              style: GoogleFonts.orbitron(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (!isConnected && !isConnecting)
            ElevatedButton(
              onPressed: onConnect,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white10,
                foregroundColor: Colors.white,
              ),
              child: const Text("CONNECT"),
            )
          else if (isConnecting)
            const SizedBox(
              height: 36,
              width: 36,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          else
            const SizedBox(
              height: 36,
              child: Icon(Icons.check_circle, color: Colors.greenAccent, size: 36),
            ),
        ],
      ),
    );
  }
}
