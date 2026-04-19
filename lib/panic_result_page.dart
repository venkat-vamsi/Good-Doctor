import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PanicResultPage extends StatefulWidget {
  final double heartRate, skinResistance, temperature, lux, sound, humidity;
  PanicResultPage(
      {required this.heartRate,
      required this.skinResistance,
      required this.temperature,
      required this.lux,
      required this.sound,
      required this.humidity});

  @override
  _PanicResultPageState createState() => _PanicResultPageState();
}

class _PanicResultPageState extends State<PanicResultPage>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  bool isPanic = false;
  String? cause;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    _animation = Tween<double>(begin: 0, end: 0.1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    callAPI();
  }

  Future<void> callAPI() async {
    try {
      final url = Uri.parse(
          "https://auraverse-ml-deployment-1.onrender.com/gradio_api/call/predict");
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "data": [
              widget.heartRate,
              widget.skinResistance,
              widget.temperature,
              widget.lux,
              widget.sound,
              widget.humidity
            ]
          }));

      final eventId = jsonDecode(response.body)["event_id"];
      final resultResponse = await http.get(Uri.parse(
          "https://auraverse-ml-deployment-1.onrender.com/gradio_api/call/predict/$eventId"));

      String rawData = resultResponse.body;
      setState(() {
        // Direct string search to match your Gradio output exactly
        isPanic = rawData.contains("Panic Detected!");

        if (rawData.contains("Cause: ")) {
          int start = rawData.indexOf("Cause: ") + 7;
          cause = rawData
              .substring(start)
              .split('"')
              .first
              .split('\\')
              .first
              .trim();
        } else {
          cause = "Environmental Trigger";
        }

        isLoading = false;
        _animation = Tween<double>(begin: 0, end: isPanic ? 0.85 : 0.15)
            .animate(
                CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
        _controller.forward();
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0A3E), Color(0xFF311B92), Color(0xFF4A148C)],
          ),
        ),
        child: SafeArea(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white))
              : Column(
                  children: [
                    const SizedBox(height: 30),
                    // Header using your HomeScreen Font style
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isPanic
                            ? Colors.red.withOpacity(0.2)
                            : Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                            color: isPanic
                                ? Colors.redAccent
                                : Colors.greenAccent),
                      ),
                      child: Column(
                        children: [
                          Text(isPanic ? "PANIC DETECTED" : "CALM & RELAXED",
                              style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text(
                              isPanic
                                  ? "Immediate assistance recommended"
                                  : "Biometrics are in normal range",
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 14)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 60),

                    // GAUGE
                    SizedBox(
                      width: 250,
                      height: 250,
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) => CustomPaint(
                            painter: OdometerPainter(
                                value: _animation.value, isPanic: isPanic)),
                      ),
                    ),

                    const SizedBox(height: 40),

                    if (isPanic) ...[
                      const Text("PRIMARY CAUSE",
                          style: TextStyle(
                              color: Colors.white54,
                              letterSpacing: 1.5,
                              fontSize: 12)),
                      const SizedBox(height: 8),
                      Text(cause?.toUpperCase() ?? "",
                          style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 30),

                      // ALERT BOX
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: Colors.orangeAccent.withOpacity(0.5))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.warning_amber_rounded,
                                color: Colors.orangeAccent),
                            SizedBox(width: 10),
                            Text("TWILIO ALERT SENT TO PARENTS",
                                style: TextStyle(
                                    color: Colors.orangeAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                    ],

                    const Spacer(),

                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text("DISMISS & RE-SCAN",
                            style: TextStyle(
                                color: Color(0xFF0A0A3E),
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class OdometerPainter extends CustomPainter {
  final double value;
  final bool isPanic;
  OdometerPainter({required this.value, required this.isPanic});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final bgPaint = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        math.pi * 0.8, math.pi * 1.4, false, bgPaint);

    final activePaint = Paint()
      ..color = isPanic ? Colors.redAccent : Colors.cyanAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        math.pi * 0.8, (math.pi * 1.4) * value, false, activePaint);

    final needlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    double needleAngle = (math.pi * 0.8) + (math.pi * 1.4) * value;
    Offset needleEnd = Offset(center.dx + (radius - 25) * math.cos(needleAngle),
        center.dy + (radius - 25) * math.sin(needleAngle));
    canvas.drawLine(center, needleEnd, needlePaint);
    canvas.drawCircle(center, 10, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
