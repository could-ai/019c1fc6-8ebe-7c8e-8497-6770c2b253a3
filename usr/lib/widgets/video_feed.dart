import 'package:flutter/material.dart';

class VideoFeedPlaceholder extends StatefulWidget {
  const VideoFeedPlaceholder({super.key});

  @override
  State<VideoFeedPlaceholder> createState() => _VideoFeedPlaceholderState();
}

class _VideoFeedPlaceholderState extends State<VideoFeedPlaceholder> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Simulated moving background to represent video
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: GridPainter(_controller.value),
              );
            },
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.redAccent),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.videocam_off, color: Colors.white54, size: 48),
                  SizedBox(height: 8),
                  Text(
                    "Blackmagic Input Source\n(Hardware Not Detected)",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Simulating Video Feed",
                    style: TextStyle(color: Colors.redAccent, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final double progress;
  GridPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;

    final double spacing = 50;
    final double offset = progress * spacing;

    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i - offset + (offset > 0 ? 0 : spacing), 0),
        Offset(i - offset + (offset > 0 ? 0 : spacing), size.height),
        paint,
      );
    }
    
    // Horizontal lines to simulate forward motion
    for (double i = 0; i < size.height; i += spacing) {
       canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) => true;
}
