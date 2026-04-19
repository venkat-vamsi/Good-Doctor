import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';

// Converted to a StatefulWidget to use the initState lifecycle method.
class VRWorldScreen extends StatefulWidget {
  const VRWorldScreen({super.key});

  @override
  State<VRWorldScreen> createState() => _VRWorldScreenState();
}

class _VRWorldScreenState extends State<VRWorldScreen> {
  @override
  void initState() {
    super.initState();
    // Automatically trigger the app launch when this screen is first built.
    _launchVRApp();
  }

  // Launch logic adapted for the VR App
  Future<void> _launchVRApp() async {
    // --- IMPORTANT ---
    // Change this to the package name of your Unity VR application
    const String androidPackageName = 'com.unity3d.player.UnityPlayerActivity';

    try {
      await LaunchApp.openApp(
        androidPackageName: androidPackageName,
        // If the app is not installed, this will open the Google Play Store page.
        openStore: false,
      );
    } catch (e) {
      // Log the error for debugging and handle it gracefully.
      print('Error launching app: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to open VR app. Please make sure it is installed.',
            ),
          ),
        );
      }
    }
  }

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
                      // Added the CircularProgressIndicator from your AR logic
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      const SizedBox(height: 20),
                      // Descriptive text with a clean style
                      const Text(
                        'Opening VR experience...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              24, // Adjusted slightly to fit the loading context
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
