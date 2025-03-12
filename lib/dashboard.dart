import 'package:flutter/material.dart';
import 'package:jansuvidha/filecomplain.dart';
import 'inquiry.dart';
import 'contact.dart';
import 'myacount.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
     drawer: Drawer(
  child: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,  // Changed direction
        end: Alignment.bottomRight, // Changed direction
        colors: [
          Color.fromARGB(255, 255, 215, 140),  // Lighter saffron
          Colors.white,
          Color.fromARGB(255, 170, 255, 173),  // Lighter green
        ],
        stops: [0.0, 0.4, 0.8],  // Adjusted stops for wider spread
      ),
    ),
    child: Column(
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).padding.top + 20),
        Container(
          height: 150,
          width: double.infinity,
          color: Colors.transparent,
          child: const Center(
            child: Text(
              'Jan Suvidha',
              style: TextStyle(
                color: Color.fromARGB(255, 14, 66, 170),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Container(
          height: 0.5,
          width: double.infinity,
          color: Colors.grey.withOpacity(0.3),  // Lighter separator
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 14, 66, 170), // Matching blue color
                ),
                title: const Text(
                  'Account',
                  style: TextStyle(
                    color: Color.fromARGB(255, 14, 66, 170), // Matching blue color
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Myacc()),
                  );
                },
              ),
              // Rest of your list tiles with the same color styling
             
              ListTile(
                leading: const Icon(
                  Icons.phone,
                  color: Color.fromARGB(255, 14, 66, 170),
                ),
                title: const Text(
                  'Contact Us',
                  style: TextStyle(
                    color: Color.fromARGB(255, 14, 66, 170),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Contact()),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),
      body: Stack(
        children: [
          Container(
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
            left: 10,
            child: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, size: 30, color: Colors.black),
                onPressed: () {
                  if (_scaffoldKey.currentState != null) {
                    Scaffold.of(context).openDrawer();
                  } else {
                    print(
                        "_scaffoldKey.currentState: ${_scaffoldKey.currentState}");
                  }
                },
              ),
            ),
          ),
          Positioned(
            top: 220,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Complaints Registered counter
                const Column(
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
                const Column(
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
          Positioned(
            top: 400,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Container(
                  width: 300,
                  margin: const EdgeInsets.only(bottom: 15),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Addcomplain()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 230, 160),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'File new complaint',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Inquiry()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 230, 160),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
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
                color: Color.fromARGB(255, 15, 62, 129),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(13),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: SizedBox(
              width: 50,
              height: 60,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context);
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
