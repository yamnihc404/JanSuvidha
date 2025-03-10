import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';
import 'contact.dart';
import 'myacount.dart';
import "dashboard.dart";

class Inquiry extends StatefulWidget {
  const Inquiry({super.key});

  @override
  _InquiryState createState() => _InquiryState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _InquiryState extends State<Inquiry> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                  Icons.home,
                  color: Color.fromARGB(255, 14, 66, 170),
                ),
                title: const Text(
                  'Home',
                  style: TextStyle(
                    color: Color.fromARGB(255, 14, 66, 170),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                   Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Dashboard()),
                  );
                },
              ),
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
            const GradientBackground(),
            Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 50),
                    child: Image.asset('images/Logo.png'),
                  ),
                ),
                const SizedBox(height: 10),
                Positioned(
                  bottom: 100,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 254, 232, 179),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: DropdownButton<String>(
                            hint: const Text(
                              'Select Category',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 14, 66, 170)),
                            ),
                            isExpanded: true,
                            underline: const SizedBox.shrink(),
                            items: <String>[
                              'Category 1',
                              'Category 2',
                              'Category 3'
                            ].map<DropdownMenuItem<String>>((String value) {
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
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 254, 232, 179),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: DropdownButton<String>(
                            hint: const Text(
                              'Select Date',
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomRoundedBar(),
            ),
            // Back Button
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
                  child: const Icon(
                    Icons.arrow_back_ios_new_sharp,
                    color: Color.fromARGB(255, 14, 66, 170),
                    size: 25,
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
