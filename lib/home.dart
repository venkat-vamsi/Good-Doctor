import 'package:flutter/material.dart';
import 'package:good_doctor/ar.dart';
import 'package:good_doctor/centers.dart';
import 'package:good_doctor/heart.dart';
import 'package:good_doctor/quiz.dart';
import 'package:good_doctor/speech.dart';
import 'package:good_doctor/vr.dart'; // Ensure path is correct

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2; // Default to Home

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // We define the widget options here inside build to pass the context down
    final List<Widget> widgetOptions = <Widget>[
      const NearbyCentersScreen(),
      const ARScreen(),
      _buildHomeScreenContent(context), // Pass the build context here
      SessionsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0A0A3E),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on), label: 'Centres'),
          BottomNavigationBarItem(
              icon: Icon(Icons.view_in_ar), label: 'AR World'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.mic), label: 'Speech'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

// --- HOME SCREEN CONTENT ---
Widget _buildHomeScreenContent(BuildContext context) {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF0A0A3E), // Deep navy
          Color(0xFF311B92), // Purple midpoint
          Color(0xFF4A148C), // Indigo/violet
        ],
        stops: [0.0, 0.5, 1.0],
      ),
    ),
    child: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with logo (left) + cartoon (right)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  height: 60, // Give the header a fixed height
                  child: Stack(
                    children: [
                      Positioned(
                        top: -8,
                        left: -16,
                        child: ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcATop,
                          ),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 170,
                            height: 80,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Image.asset(
                          'assets/images/doraemonn.png',
                          height: 50,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Greeting
              const Center(
                child: Text(
                  'Hello, Billy 👋',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Category icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCategoryIcon(
                      Icons.view_in_ar, 'AR', const Color(0xFF9C27B0), () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ARScreen()));
                  }),
                  _buildCategoryIcon(
                      Icons.vrpano, 'VR', const Color(0xFFE91E63), () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VRWorldScreen()));
                  }),
                  _buildCategoryIcon(
                      Icons.favorite, 'Heart', const Color(0xFF00BCD4), () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Heart()));
                  }),
                  _buildCategoryIcon(
                      Icons.quiz, 'Quiz', const Color(0xFF4CAF50), () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => QuizScreen()));
                  }),
                ],
              ),
              const SizedBox(height: 30),
              // Feature Cards
              _buildFeatureCard('VR World', 'assets/images/vr_world_bg.png',
                  const Color(0xFF9C27B0), () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => VRWorldScreen()));
              }),
              const SizedBox(height: 16),
              _buildFeatureCard('Speech', 'assets/images/speech_bg.png',
                  const Color(0xFFE91E63), () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SessionsScreen()));
              }),
              const SizedBox(height: 16),
              _buildFeatureCard(
                  'Heart Rate Monitoring',
                  'assets/images/heart_rate_bg.png',
                  const Color(0xFF00BCD4), () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Heart()));
              }),
              const SizedBox(height: 16),
              _buildFeatureCard(
                  'Role Play Quiz',
                  'assets/images/role_play_quiz_bg.png',
                  const Color(0xFF4CAF50), () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => QuizScreen()));
              }),
            ],
          ),
        ),
      ),
    ),
  );
}

// --- CATEGORY ICON ---
Widget _buildCategoryIcon(
    IconData icon, String label, Color color, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(40),
    child: Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, size: 32, color: color),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    ),
  );
}

// --- FEATURE CARD ---
// ** UPDATED to accept an onTap callback **
Widget _buildFeatureCard(
    String title, String imagePath, Color accentColor, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(24),
    child: Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          alignment: Alignment.center,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Screen')),
    );
  }
}
