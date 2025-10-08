import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:good_doctor/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0a0a2e),
              Color(0xFF1a1a5e),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background stars
            ..._buildBackgroundStars(),

            // Golden stars randomly placed
            ..._buildGoldenStars(),

            // Title at top
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              left: 0,
              right: 0,
              child: const Center(
                child: Text(
                  'Auraverse',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.amber,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Decorative stars around center
            ..._buildDecorativeStars(context),

            // Kid image at center
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/kid.png', // Replace with your kid image path
                      width: 200,
                      height: 200,
                    ),
                  ],
                ),
              ),
            ),

            // Bottom text
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.1,
              left: 0,
              right: 0,
              child: const Center(
                child: Text(
                  'Bridging Gaps With Personalized and Accessible Care',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.amber,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Generate small background stars
  List<Widget> _buildBackgroundStars() {
    List<Widget> stars = [];
    final random = Random();

    for (int i = 0; i < 100; i++) {
      stars.add(Positioned(
        left: random.nextDouble() *
            MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                .size
                .width,
        top: random.nextDouble() *
            MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                .size
                .height,
        child: Container(
          width: 2,
          height: 2,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ));
    }
    return stars;
  }

  // Generate decorative stars around center
  List<Widget> _buildDecorativeStars(BuildContext context) {
    List<Widget> stars = [];
    final random = Random();
    final centerX = MediaQuery.of(context).size.width / 2;
    final centerY = MediaQuery.of(context).size.height / 2;

    for (int i = 0; i < 8; i++) {
      final angle = random.nextDouble() * 2 * pi;
      final radius =
          100 + random.nextDouble() * 100; // 100-200 pixels from center

      stars.add(Positioned(
        left: centerX + radius * cos(angle) - 4, // -4 to center the star
        top: centerY + radius * sin(angle) - 4,
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ));
    }
    return stars;
  }

  // Generate golden stars randomly placed
  List<Widget> _buildGoldenStars() {
    List<Widget> stars = [];
    final random = Random();

    for (int i = 0; i < 20; i++) {
      stars.add(Positioned(
        left: random.nextDouble() *
            MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                .size
                .width,
        top: random.nextDouble() *
            MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                .size
                .height,
        child: Container(
          width: random.nextInt(5) + 3, // Random size between 3-8
          height: random.nextInt(5) + 3,
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(random.nextDouble() * 0.8 +
                0.2), // Random opacity between 0.2-1.0
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.5),
                blurRadius: random.nextDouble() * 5 + 2,
                spreadRadius: random.nextDouble() * 2,
              ),
            ],
          ),
        ),
      ));
    }
    return stars;
  }
}
