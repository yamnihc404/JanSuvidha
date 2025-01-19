import 'package:flutter/material.dart';

void main() {
  runApp(const Addcomplain());
}

class Addcomplain extends StatelessWidget {
  const Addcomplain({super.key});

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
            Column(
              children: [
                // Container for dropdown buttons
                Align(
                  alignment: Alignment.topCenter,
                  child: Transform.scale(
                    scale: 1.5, // Scale the widget by 130%
                    child: Image.asset(
                      'images/Logo.png',
                      width: 250,

                      // Adjust size as needed
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Column(
                    children: [
                      // User Name Field
                      Container(
                        width: 284,
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 254, 232, 179),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: "Enter Username", // Placeholder text
                            hintStyle: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 14, 66,
                                    170) // Color of the placeholder text
                                ),
                            border: InputBorder
                                .none, // Remove the default underline
                          ),
                        ),
                      ),

                      const SizedBox(height: 20), // Space between dropdowns

                      Container(
                        width: 284,
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 254, 232, 179),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText:
                                "Enter Contact Number", // Placeholder text
                            hintStyle: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 14, 66,
                                    170) // Color of the placeholder text
                                ),
                            border: InputBorder
                                .none, // Remove the default underline
                          ),
                          style: TextStyle(
                            fontSize: 18,
                            color:
                                Color.fromARGB(255, 14, 66, 170), // Text color
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        width: 284,
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 254, 232, 179),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: DropdownButton<String>(
                          hint: const Text(
                            'Road Maintainence',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 14, 66, 170)),
                          ),
                          isExpanded: true,
                          underline: const SizedBox.shrink(),
                          items: <String>['Date 1', 'Date 2', 'Date 3']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            // Handle dropdown change
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        width: 284,
                        height: 72,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 254, 232, 179),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: const Center(
                          child: TextField(
                            textAlign: TextAlign
                                .center, // Center-align the text and placeholder
                            decoration: InputDecoration(
                              hintText:
                                  "Describe Your Complaint Here.", // Placeholder text
                              hintStyle: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 14, 66,
                                    170), // Color of the placeholder text
                              ),
                              border: InputBorder
                                  .none, // Remove the default underline
                            ),
                            style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(
                                  255, 14, 66, 170), // Text color
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Image button
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 254, 232, 179),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ], // Rounded corners
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.add_photo_alternate),
                              iconSize: 50,
                              color: const Color.fromARGB(255, 5, 6, 6),
                              onPressed: () {
                                // Action to add images
                              },
                            ),
                          ),

                          const SizedBox(
                              width: 20), // Space between the two buttons

                          // Location button
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 254, 232, 179),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.location_on),
                              iconSize: 50,
                              color: const Color.fromARGB(255, 5, 6, 6),
                              onPressed: () {
                                // Action to select location
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Code to execute when the button is pressed
                            // ignore: avoid_print
                            print('Button Pressed!');
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                const Color.fromARGB(255, 254, 232, 179)),
                            elevation: WidgetStateProperty.all<double>(
                                10), // Box shadow effect
                            shadowColor:
                                WidgetStateProperty.all<Color>(Colors.grey),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 14, 66, 170)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),

            // Positioned call button in top-right corner
            Positioned(
              top: 40,
              right: 13,
              child: Column(
                children: [
                  // User Button
                  SizedBox(
                    width: 40,
                    height: 50,
                    child: FloatingActionButton(
                      onPressed: () {},
                      // No const here
                      shape: const CircleBorder(),
                      backgroundColor: const Color.fromARGB(255, 72, 113, 73),
                      mini: true,
                      child: const Icon(Icons.person,
                          color: Colors.white, size: 30),
                    ),
                  ),
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
            ),
          ],
        ),
      ),
    );
  }
}
