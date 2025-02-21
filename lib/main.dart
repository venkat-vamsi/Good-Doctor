import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // For Google Fonts

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autism Support App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.comfortaaTextTheme(), // Use Google Fonts
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = [
    MainContent(),
    NearbyCentresScreen(),
    ChatbotScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class FloatingNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  FloatingNavigationBar({
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white, // White background for the button itself
        borderRadius: BorderRadius.circular(30), // Curved corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', 0),
          _buildNavItem(Icons.location_on, 'Centres', 1),
          _buildNavItem(Icons.chat, 'Chatbot', 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: selectedIndex == index ? Color(0xFF6DD5FA) : Colors.grey,
            size: 30,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.comfortaa(
              fontSize: 12,
              color: selectedIndex == index ? Color(0xFF6DD5FA) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6DD5FA), Color(0xFFFBC2EB)], // Same gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Your content here
          ],
        ),
      ),
    );
  }
}

// Placeholder screens for navigation
class VRWorldScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('VR World')),
      body: Center(child: Text('VR World Screen')),
    );
  }
}

class SpeechTherapyScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Speech Therapy')),
      body: Center(child: Text('Speech Therapy Screen')),
    );
  }
}

class PanicAttacksInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Panic Attacks Info')),
      body: Center(child: Text('Panic Attacks Info Screen')),
    );
  }
}

class ChatbotScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Autism Trained Chatbot')),
      body: Center(child: Text('Chatbot Screen')),
    );
  }
}

class NearbyCentresScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nearby Autism Centres')),
      body: Center(child: Text('Nearby Autism Centres Screen')),
    );
  }
}
