import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // For Google Fonts

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Good Doctor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.comfortaaTextTheme(),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _titleController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  late AnimationController _cardController;
  late Animation<double> _cardFadeAnimation;
  late Animation<double> _cardScaleAnimation;

  late AnimationController _navController;
  late Animation<double> _navPulseAnimation;

  @override
  void initState() {
    super.initState();

    // Title Animation Controller
    _titleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeInOutSine),
    );

    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeInOutQuad),
    );

    // Card Animation Controller
    _cardController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _cardFadeAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeInOut),
    );

    _cardScaleAnimation = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeInOut),
    );

    // Navigation Bar Animation Controller
    _navController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _navPulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _navController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _cardController.dispose();
    _navController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF6DD5FA), const Color(0xFFFBC2EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const SizedBox(height: 70), // Existing SizedBox
            const SizedBox(
                height: 50), // New SizedBox to push "GOOD DOCTOR" down
            // Animated "GOOD DOCTOR" Title
            AnimatedBuilder(
              animation: _titleController,
              builder: (context, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: "GOOD".split("").asMap().entries.map((entry) {
                          int index = entry.key;
                          String char = entry.value;
                          return Transform(
                            transform: Matrix4.identity()
                              ..translate(
                                0.0,
                                _bounceAnimation.value *
                                    (index % 2 == 0 ? 1 : -1),
                              )
                              ..scale(_scaleAnimation.value),
                            child: PuzzleLetter(
                              char: char,
                              animation: _glowAnimation,
                              index: index,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            "DOCTOR".split("").asMap().entries.map((entry) {
                          int index = entry.key;
                          String char = entry.value;
                          return Transform(
                            transform: Matrix4.identity()
                              ..translate(
                                0.0,
                                _bounceAnimation.value *
                                    (index % 2 == 0 ? 1 : -1),
                              )
                              ..scale(_scaleAnimation.value),
                            child: PuzzleLetter(
                              char: char,
                              animation: _glowAnimation,
                              index: index,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: MainContent(
                  cardFadeAnimation: _cardFadeAnimation,
                  cardScaleAnimation: _cardScaleAnimation),
            ),
          ],
        ),
        floatingActionButton: AnimatedBuilder(
          animation: _navController,
          builder: (context, child) {
            return Transform.scale(
              scale: _navPulseAnimation.value,
              child: FloatingNavigationBar(
                selectedIndex: 0,
                onTap: (index) {},
              ),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class PuzzleLetter extends StatelessWidget {
  final String char;
  final Animation<double> animation;
  final int index;

  const PuzzleLetter({
    required this.char,
    required this.animation,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(animation.value),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(animation.value * 0.5),
                blurRadius: 15 * animation.value,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Text(
            char,
            style: GoogleFonts.comfortaa(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 12.0 * animation.value,
                  color: Colors.black.withOpacity(0.4),
                  offset: const Offset(3.0, 3.0),
                ),
                Shadow(
                  blurRadius: 8.0 * animation.value,
                  color: Colors.blueAccent.withOpacity(0.6),
                  offset: const Offset(-2.0, -2.0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MainContent extends StatelessWidget {
  final Animation<double> cardFadeAnimation;
  final Animation<double> cardScaleAnimation;

  const MainContent({
    required this.cardFadeAnimation,
    required this.cardScaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedBuilder(
          animation: Listenable.merge([cardFadeAnimation, cardScaleAnimation]),
          builder: (context, child) {
            return GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                FeatureCard(
                  title: 'VR World',
                  icon: Icons.vrpano,
                  image: 'assets/images/vr_kid.jpeg',
                  color: const Color(0xFFFF6F61),
                  fadeAnimation: cardFadeAnimation,
                  scaleAnimation: cardScaleAnimation,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VRWorldScreen()),
                    );
                  },
                ),
                FeatureCard(
                  title: 'Speech',
                  icon: Icons.record_voice_over,
                  image: 'assets/images/speech.jpeg',
                  color: const Color(0xFF6B5B95),
                  fadeAnimation: cardFadeAnimation,
                  scaleAnimation: cardScaleAnimation,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SpeechTherapyScreen()),
                    );
                  },
                ),
                FeatureCard(
                  title: 'Heart Info',
                  icon: Icons.warning,
                  image: 'assets/images/heart_rate.jpeg',
                  color: const Color(0xFF88B04B),
                  fadeAnimation: cardFadeAnimation,
                  scaleAnimation: cardScaleAnimation,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PanicAttacksInfoScreen()),
                    );
                  },
                ),
                FeatureCard(
                  title: 'Role Play Quiz',
                  icon: Icons.location_on,
                  image: 'assets/images/puzzle.jpeg',
                  color: const Color(0xFFF7CAC9),
                  fadeAnimation: cardFadeAnimation,
                  scaleAnimation: cardScaleAnimation,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NearbyCentresScreen()),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String image;
  final Color color;
  final Animation<double> fadeAnimation;
  final Animation<double> scaleAnimation;
  final VoidCallback onPressed;

  const FeatureCard({
    required this.title,
    required this.icon,
    required this.image,
    required this.color,
    required this.fadeAnimation,
    required this.scaleAnimation,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([fadeAnimation, scaleAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: scaleAnimation.value,
          child: Opacity(
            opacity: fadeAnimation.value,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: InkWell(
                onTap: onPressed,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: color.withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 10 * fadeAnimation.value,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          title,
                          style: GoogleFonts.comfortaa(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 5.0,
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(1.0, 1.0),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class FloatingNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const FloatingNavigationBar({
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
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
            color:
                selectedIndex == index ? const Color(0xFF6DD5FA) : Colors.grey,
            size: 30,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.comfortaa(
              fontSize: 12,
              color: selectedIndex == index
                  ? const Color(0xFF6DD5FA)
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder screens for navigation
class VRWorldScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VR World')),
      body: const Center(child: Text('VR World Screen')),
    );
  }
}

class SpeechTherapyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Speech Therapy')),
      body: const Center(child: Text('Speech Therapy Screen')),
    );
  }
}

class PanicAttacksInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panic Attacks Info')),
      body: const Center(child: Text('Panic Attacks Info Screen')),
    );
  }
}

class NearbyCentresScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Autism Centres')),
      body: const Center(child: Text('Nearby Autism Centres Screen')),
    );
  }
}
