import 'package:flutter/material.dart';
import './user_pages/user_widgets/common_widgets.dart';

class CommonLandingPage extends StatelessWidget {
  const CommonLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: GradientBackground()),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header Section
                Expanded(
                  flex: 2, // Changed to Expanded with flex
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Transform.scale(
                          scale: 1.8,
                          child: Image.asset(
                            'images/Logo.png',
                            width: screenWidth * 0.6,
                            height: screenHeight * 0.25,
                          ),
                        ),
                      ),
                      const Text(
                        'Welcome!',
                        style: TextStyle(
                          fontSize: 32,
                          color: Color.fromARGB(255, 14, 66, 170),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Buttons Section
                Expanded(
                  flex: 2, // Added flex value
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: screenHeight * 0.02, // Reduced bottom padding
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.start, // Changed alignment
                      children: [
                        _buildResponsiveButton(
                          context,
                          'Continue as User',
                          () => Navigator.pushNamed(context, '/user-landing'),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        _buildResponsiveButton(
                          context,
                          'Continue as Admin',
                          () => Navigator.pushNamed(context, '/admin-landing'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width * 0.7,
        maxWidth: 400,
        minHeight: 55,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 255, 230, 160),
            foregroundColor: const Color.fromARGB(255, 14, 66, 170),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
