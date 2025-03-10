import 'package:flutter/material.dart';

// Common background gradient
class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 255, 196, 107),
            Colors.white,
            Color.fromARGB(255, 143, 255, 147),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}

// Common bottom navigation bar
class BottomRoundedBar extends StatelessWidget {
  const BottomRoundedBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 15, 62, 129),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(13),
        ),
      ),
    );
  }
}

// Reusable styled container
class StyledContainer extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final Color color;

  const StyledContainer({
    super.key,
    required this.child,
    this.width = 284,
    this.height = 42,
    this.color = const Color.fromARGB(255, 254, 232, 179),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}

class NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const NavButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 50,
      child: FloatingActionButton(
        onPressed: onPressed,
        shape: const CircleBorder(),
        backgroundColor: const Color.fromARGB(255, 72, 113, 73),
        mini: true,
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }
}

// Top navigation buttons group
class TopNavButtons extends StatelessWidget {
  const TopNavButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      right: 13,
      child: Column(
        children: [
          NavButton(
            icon: Icons.person,
            onPressed: () {},
          ),
          const SizedBox(height: 8),
          NavButton(
            icon: Icons.home,
            onPressed: () {},
          ),
          const SizedBox(height: 8),
          NavButton(
            icon: Icons.phone,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
