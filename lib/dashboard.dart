import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jansuvidha/filecomplain.dart';
import 'inquiry.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Column(children: [
            Align(
              alignment: Alignment.topCenter,
              child: Transform.scale(
                scale: 1.6, // Scale the widget by 130%
                child: Image.asset(
                  'images/Logo.png',
                  width: 250,
                  height: 250,
                ),
              ),
            ),
          ]),
          Positioned(
              top: 40,
              right: 10,
              child: Column(
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: FloatingActionButton(
                      onPressed: () {
                        print('Profile button pressed');
                      },
                      shape: const CircleBorder(),
                      backgroundColor: const Color.fromARGB(255, 72, 113, 73),
                      mini: true,
                      child: const Icon(Icons.person,
                          color: Colors.white, size: 30),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: FloatingActionButton(
                      onPressed: () {
                        print('Call button pressed');
                      },
                      shape: const CircleBorder(),
                      backgroundColor: const Color.fromARGB(255, 72, 113, 73),
                      mini: true,
                      child: const Icon(Icons.phone,
                          color: Colors.white, size: 30),
                    ),
                  ),
                ],
              )),
          Positioned(
            top: 220,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Complaints Registered counter
                Column(
                  children: [
                    Text(
                      "00",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      "Complaints\nRegisters",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                // Divider line
                Container(
                  height: 80,
                  width: 1,
                  color: Colors.grey,
                ),
                // Complaints Solved counter
                Column(
                  children: [
                    Text(
                      "00",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      "Complaints\nSolved",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Action buttons
          Positioned(
            top: 400,
            left: 20,
            right: 20,
            child: Column(
              children: [
                // File new complaint button
                Container(
                  width: 300,
                  margin: const EdgeInsets.only(bottom: 15),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Addcomplain()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 230, 160),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'File new complaint',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Inquiry()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 230, 160),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'Complaint Inquiry',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
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
          // Back button
          Positioned(
            bottom: 20,
            left: 20,
            child: SizedBox(
              width: 50,
              height: 60,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pop(
                      context); // Navigate back to the previous screen
                },
                shape: const CircleBorder(),
                backgroundColor: const Color.fromARGB(255, 254, 183, 101),
                mini: true,
                child: const Icon(Icons.arrow_back_ios_new_sharp,
                    color: Color.fromARGB(255, 15, 62, 129), size: 25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
