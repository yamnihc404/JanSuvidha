// ignore: file_names
import 'package:flutter/material.dart';
import 'package:jansuvidha/login.dart';
import 'package:jansuvidha/signup.dart';

void main() {
  runApp(const Landing());
}

class Landing extends StatelessWidget {
  const Landing({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            // Background container with gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(
                        255, 255, 196, 107), // Starting color of the gradient
                    Colors.white,
                    Color.fromARGB(
                        255, 143, 255, 147), // Ending color of the gradient
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Transform.scale(
                scale: 1.2, // Scale the widget by 130%
                child: Image.asset(
                  'images/Logo.png',
                  // Adjust size as needed
                ),
              ),
            ),
            // Positioned call button in top-right corner
            Positioned(
              top: 40,
              right: 15,
              child: SizedBox(
                width: 50,
                height: 60,
                child: FloatingActionButton(
                  onPressed: () {
                    print('Call button pressed');
                  },
                  // No const here
                  shape: const CircleBorder(),
                  backgroundColor: const Color.fromARGB(255, 72, 113, 73),
                  mini: true,
                  child: const Icon(Icons.phone, color: Colors.white, size: 30),
                ),
              ),
            ),
            Positioned(
              bottom: 130, // Position the buttons lower on the screen
              left: 50,
              right: 50,
              child: Column(
                children: [
                  // Login Button
                  Container(
                    width: 149, // Square shape (width and height are equal)
                    height: 100, // Square shape
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          255, 254, 232, 179), // Button color
                      borderRadius: BorderRadius.circular(15), // Rounded edges
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.3), // Shadow color with opacity
                          offset: const Offset(5,
                              5), // Shadow offset (light coming from top left)
                          blurRadius: 10, // Blur radius of the shadow
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Login()), // Use your LoginPage here
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .transparent, // Make the ElevatedButton background transparent
                        shadowColor:
                            Colors.transparent, // Remove default shadow
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 24,
                            color: Color.fromARGB(255, 14, 66, 170)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40), // Space between buttons

                  // Sign-Up Button
                  Container(
                    width: 149, // Square shape (width and height are equal)
                    height: 100, // Square shape
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          255, 254, 232, 179), // Button color
                      borderRadius: BorderRadius.circular(15), // Rounded edges
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.3), // Shadow color with opacity
                          offset: const Offset(5,
                              5), // Shadow offset (light coming from top left)
                          blurRadius: 10, // Blur radius of the shadow
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Signup()), // Use your LoginPage here
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .transparent, // Make the ElevatedButton background transparent
                        shadowColor:
                            Colors.transparent, // Remove default shadow
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 24,
                            color: Color.fromARGB(255, 14, 66, 170)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 25),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(
                      255, 15, 62, 129), // Background color of the rectangle
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(13), // Circular radius for top corners
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
