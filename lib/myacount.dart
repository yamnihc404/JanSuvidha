import 'package:flutter/material.dart';
import 'dashboard.dart';  // Add import for Dashboard
import 'contact.dart';    // Add import for Contact

class Myacc extends StatefulWidget {
  const Myacc({super.key});

  @override
  State<Myacc> createState() => _MyaccState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _MyaccState extends State<Myacc> {
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
            // Background container with gradient
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
            // Add menu button
            Positioned(
              top: 40,
              left: 10,
              child: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, size: 30, color: Colors.black),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
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
                            const EdgeInsets.only(top: 45, left: 20, right: 20),
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
                              offset: const Offset(
                                  0, 3), // changes position of shadow
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
                                            hintText: "", // Placeholder text
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
                                            hintText: "", // Placeholder text
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
                                            hintText: "", // Placeholder text
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
                                            hintText: "", // Placeholder text
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
                                          "", // Label
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
                                            hintText: "", // Placeholder text
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
              ],
            ),
            // Bottom rectangle with rounded corners
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
