import 'package:flutter/material.dart';

class VRWorldScreen extends StatelessWidget {
  const VRWorldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The main container that holds the background gradient
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0A3E), // Deep navy blue top
              Color(0xFF311B92), // Subtle purple midpoint
              Color(0xFF4A148C), // Indigo/violet bottom
            ],
          ),
        ),
        // Use SafeArea to avoid overlapping with system UI (like status bar)
        child: SafeArea(
          child: Column(
            children: [
              // A simple, clean AppBar that blends with the background
              AppBar(
                title: const Text('VR World'),
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
              ),
              // Expanded takes up the remaining space to center the content
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // A large, stylized icon to represent the VR world
                      Icon(
                        Icons.vrpano_outlined,
                        size: 120,
                        color: Colors.white.withOpacity(0.8),
                        shadows: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.5),
                            blurRadius: 25,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      // Descriptive text with a clean style
                      const Text(
                        'Adventure Awaits',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Put on your headset to begin.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
