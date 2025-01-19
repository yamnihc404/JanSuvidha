import 'package:flutter/material.dart';

void main() {
  runApp(const Myacc());
}

class Myacc extends StatelessWidget {
  const Myacc({super.key});

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
            Stack(
              children: [
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topCenter, // Align at the top center
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 60), // Push down by 50 pixels
                        child: Transform.scale(
                          scale: 3, // Scale the widget by 140%
                          child: Image.asset('images/Logo.png', height: 100),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Stack(alignment: Alignment.center, children: [
                      Container(
                        padding:
                            const EdgeInsets.only(top: 72, left: 20, right: 20),
                        width: 284,
                        height: 380,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 254, 232, 179),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 0, 0, 0)
                                  .withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  width: 284,
                                  height:
                                      45, // Adjusted the height for more space
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 254, 183, 101),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(
                                            0.3), // Shadow color with opacity
                                        offset:
                                            const Offset(5, 5), // Shadow offset
                                        blurRadius:
                                            10, // Blur radius of the shadow
                                      ),
                                    ],
                                  ),
                                  child: const Column(
                                    // Align to the left
                                    children: [
                                      // Username label aligned to the top left
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "Username", // Label
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                255, 14, 66, 170),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText:
                                                "Chinmayloveshens", // Placeholder text
                                            hintStyle: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(255, 14, 66,
                                                  170), // Placeholder color
                                            ),
                                            border: InputBorder
                                                .none, // Remove the default underline
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  width: 284,
                                  height:
                                      45, // Adjusted the height for more space
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 254, 183, 101),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(
                                            0.3), // Shadow color with opacity
                                        offset:
                                            const Offset(5, 5), // Shadow offset
                                        blurRadius:
                                            10, // Blur radius of the shadow
                                      ),
                                    ],
                                  ),
                                  child: const Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // Align to the left
                                    children: [
                                      // Username label aligned to the top left
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "Change Password", // Label
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                255, 14, 66, 170),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText:
                                                "Chinmayhateskofta", // Placeholder text
                                            hintStyle: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(255, 14, 66,
                                                  170), // Placeholder color
                                            ),
                                            border: InputBorder
                                                .none, // Remove the default underline
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  width: 284,
                                  height:
                                      45, // Adjusted the height for more space
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 254, 183, 101),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(
                                            0.3), // Shadow color with opacity
                                        offset:
                                            const Offset(5, 5), // Shadow offset
                                        blurRadius:
                                            10, // Blur radius of the shadow
                                      ),
                                    ],
                                  ),
                                  child: const Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // Align to the left
                                    children: [
                                      // Username label aligned to the top left
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "Update Phone Number", // Label
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                255, 14, 66, 170),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText:
                                                "88307141", // Placeholder text
                                            hintStyle: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(255, 14, 66,
                                                  170), // Placeholder color
                                            ),
                                            border: InputBorder
                                                .none, // Remove the default underline
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  width: 284,
                                  height:
                                      45, // Adjusted the height for more space
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 254, 183, 101),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(
                                            0.3), // Shadow color with opacity
                                        offset:
                                            const Offset(5, 5), // Shadow offset
                                        blurRadius:
                                            10, // Blur radius of the shadow
                                      ),
                                    ],
                                  ),
                                  child: const Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // Align to the left
                                    children: [
                                      // Username label aligned to the top left
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "Update E-mail", // Label
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                255, 14, 66, 170),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText:
                                                "kamblechinmay@gmail.com", // Placeholder text
                                            hintStyle: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(255, 14, 66,
                                                  170), // Placeholder color
                                            ),
                                            border: InputBorder
                                                .none, // Remove the default underline
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  width: 284,
                                  height:
                                      45, // Adjusted the height for more space
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 254, 183, 101),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(
                                            0.3), // Shadow color with opacity
                                        offset:
                                            const Offset(5, 5), // Shadow offset
                                        blurRadius:
                                            10, // Blur radius of the shadow
                                      ),
                                    ],
                                  ),
                                  child: const Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // Align to the left
                                    children: [
                                      // Username label aligned to the top left
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "Username", // Label
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                255, 14, 66, 170),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText:
                                                "Chinmayloveshens", // Placeholder text
                                            hintStyle: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(255, 14, 66,
                                                  170), // Placeholder color
                                            ),
                                            border: InputBorder
                                                .none, // Remove the default underline
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ])
                  ],
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 150, right: 150),
                    child: ProfilePhoto(),
                  ),
                ),
              ],
            ),

            Positioned(
              top: 40,
              right: 13,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  // Home Button
                  SizedBox(
                    width: 40,
                    height: 50,
                    child: FloatingActionButton(
                      onPressed: () {},
                      // No const here
                      shape: const CircleBorder(),
                      backgroundColor: const Color.fromARGB(255, 72, 113, 73),
                      mini: true,
                      child:
                          const Icon(Icons.home, color: Colors.white, size: 30),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Phone Button
                  SizedBox(
                    width: 40,
                    height: 50,
                    child: FloatingActionButton(
                      onPressed: () {},
                      // No const here
                      shape: const CircleBorder(),
                      backgroundColor: const Color.fromARGB(255, 72, 113, 73),
                      mini: true,
                      child: const Icon(Icons.phone,
                          color: Colors.white, size: 30),
                    ),
                  ),
                ],
              ),
            ),
            // Bottom rectangle with rounded corners
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

            Positioned(
              bottom: 62, // Adjust as needed
              left: 14,
              child: SizedBox(
                width: 50,
                height: 50,
                child: FloatingActionButton(
                  onPressed: () {
                    // Handle settings button action
                  },
                  shape: const CircleBorder(),
                  backgroundColor: const Color.fromARGB(255, 72, 113, 73),
                  child:
                      const Icon(Icons.settings, color: Colors.white, size: 35),
                ),
              ),
            ),
            Positioned(
              bottom: 62, // Adjust this value for vertical positioning
              right: 14,
              child: SizedBox(
                width: 50,
                height: 50,
                child: FloatingActionButton(
                  onPressed: () {
                    // Handle button action
                  },
                  shape: const CircleBorder(),
                  backgroundColor: const Color.fromARGB(255, 72, 113, 73),
                  child: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 30), // "<" Icon
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProfilePhoto extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePhoto>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0; // Default scale
  bool _isZoomed = false; // Track if the photo is zoomed

  void _zoomPhoto() {
    setState(() {
      _isZoomed = !_isZoomed;
      _scale = _isZoomed ? 2 : 1.0; // Scale to 1.5 when zoomed
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _zoomPhoto, // Trigger zoom on tap
      child: AnimatedScale(
        scale: _scale, // Apply scale transformation
        duration: const Duration(milliseconds: 300), // Animation duration
        curve: Curves.easeInOut, // Smooth zoom-in and zoom-out
        child: const CircleAvatar(
          radius: 50, // Avatar size
          backgroundImage: AssetImage('images/pfp.webp'), // Profile image
        ),
      ),
    );
  }
}
