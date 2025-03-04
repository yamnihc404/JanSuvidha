import 'package:flutter/material.dart';
import 'widgets/common_widgets.dart';
import 'contact.dart';


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
                      const SizedBox(height: 10),
                      Center(
                        child: StyledContainer(
                          child: ElevatedButton(
                            onPressed: () {
                              // Code to execute when the button is pressed
                              // ignore: avoid_print
                              print('Button Pressed!');
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  const Color.fromARGB(255, 254, 232, 179)),
                              elevation: WidgetStateProperty.all<double>(10),
                              shadowColor:
                                  WidgetStateProperty.all<Color>(Colors.grey),
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 14, 66, 170),
                              ),
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
                    onPressed: () {Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Contact(),
                          ),
                        );}
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
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
