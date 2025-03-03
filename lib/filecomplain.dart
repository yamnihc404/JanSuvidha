import 'package:flutter/material.dart';
import 'widgets/common_widgets.dart';

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
            const GradientBackground(),
            Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Transform.scale(
                    scale: 1.5,
                    child: Image.asset(
                      'images/Logo.png',
                      width: 250,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Column(
                    children: [
                      const StyledContainer(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Enter Username",
                            hintStyle: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 14, 66, 170),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const StyledContainer(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Enter Contact Number",
                            hintStyle: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 14, 66, 170),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      StyledContainer(
                        child: DropdownButton<String>(
                          hint: const Text(
                            'Road Maintainence',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 14, 66, 170),
                            ),
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
                      const StyledContainer(
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: "Describe Your Complaint Here.",
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 14, 66, 170),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StyledContainer(
                            width: 100,
                            height: 100,
                            child: IconButton(
                              icon: const Icon(Icons.add_photo_alternate),
                              iconSize: 50,
                              color: const Color.fromARGB(255, 5, 6, 6),
                              onPressed: () {
                                // Action to add images
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          StyledContainer(
                            width: 100,
                            height: 100,
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
                      const SizedBox(height: 15),
                      Center(
                        child: Container(
                          width: 149,
                          height: 55,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 254, 232, 179),
                            borderRadius:
                                BorderRadius.circular(20), // Rounded edges
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                    0.3), // Shadow color with opacity
                                offset: const Offset(5,
                                    5), // Shadow offset (light coming from top left)
                                blurRadius: 10, // Blur radius of the shadow
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () async {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .transparent, // Make the ElevatedButton background transparent
                              shadowColor:
                                  Colors.transparent, // Remove default shadow
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Color.fromARGB(255, 14, 66, 170),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
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
            ),
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomRoundedBar(),
            ),
            Positioned(
              bottom: 62,
              left: 14,
              child: NavButton(
                icon: Icons.settings,
                onPressed: () {},
              ),
            ),
            Positioned(
              bottom: 62,
              right: 14,
              child: NavButton(
                icon: Icons.arrow_back,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
