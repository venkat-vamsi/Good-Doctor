import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';

// Converted to a StatefulWidget to use the initState lifecycle method.
class ARScreen extends StatefulWidget {
  const ARScreen({super.key});

  @override
  State<ARScreen> createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  @override
  void initState() {
    super.initState();
    // Automatically trigger the app launch when this screen is first built.
    _launchARApp();
  }

  // Moved the launch logic into its own function.
  Future<void> _launchARApp() async {
    // --- IMPORTANT ---
    // This is the package name you provided.
    const String androidPackageName = 'com.example.ar';

    // The launch action is wrapped in a try-catch block to handle errors.
    try {
      await LaunchApp.openApp(
        androidPackageName: androidPackageName,
        // If the app is not installed, this will open the Google Play Store page.
        openStore: true,
      );
    } catch (e) {
      // Log the error for debugging and handle it gracefully.
      print('Error launching app: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Failed to open app. Please make sure it is installed.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // The UI is now a simple loading screen.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redirecting to AR'),
        backgroundColor:
            const Color(0xFF0A0A3E), // Matching your home screen theme
      ),
      body: Container(
        // Matching gradient from your home screen for a consistent look
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0A3E),
              Color(0xFF311B92),
              Color(0xFF4A148C),
            ],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Opening AR experience...',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
