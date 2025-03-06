import 'package:flutter/material.dart';
import 'widgets/common_widgets.dart';
import 'contact.dart';
import 'myaccount.dart';

class Addcomplain extends StatefulWidget {
  const Addcomplain({Key? key}) : super(key: key);

  @override
  _AddcomplainState createState() => _AddcomplainState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _AddcomplainState extends State<Addcomplain> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 15, 62, 129),
                ),
                child: Text(
                  'Jan Suvidha',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Account'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Myacc()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('Contact Us'),
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
              left: 10,
              child: Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu, size: 30, color: Colors.black),
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
