import 'dart:math';
import 'package:flutter/material.dart';

class GlitterOverlay extends StatefulWidget {
  const GlitterOverlay({super.key});

  @override
  State<GlitterOverlay> createState() => _GlitterOverlayState();
}

class _GlitterOverlayState extends State<GlitterOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _rnd = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return CustomPaint(
          painter: _GlitterPainter(_controller.value, _rnd),
          size: Size.infinite,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _GlitterPainter extends CustomPainter {
  final double progress;
  final Random rnd;

  _GlitterPainter(this.progress, this.rnd);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.cyanAccent;

    for (int i = 0; i < 30; i++) {
      final dx = rnd.nextDouble() * size.width;
      final dy = size.height * progress;
      canvas.drawCircle(Offset(dx, dy), 2 + rnd.nextDouble() * 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
