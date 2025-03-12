import 'package:flutter/material.dart';
import 'widgets/common_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dashboard.dart';
import 'myacount.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _ContactState extends State<Contact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, // Changed direction
              end: Alignment.bottomRight, // Changed direction
              colors: [
                Color.fromARGB(255, 255, 215, 140), // Lighter saffron
                Colors.white,
                Color.fromARGB(255, 170, 255, 173), // Lighter green
              ],
              stops: [0.0, 0.4, 0.8], // Adjusted stops for wider spread
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
                color: Colors.grey.withOpacity(0.3), // Lighter separator
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
                          MaterialPageRoute(
                              builder: (context) => const Dashboard()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.person,
                        color: Color.fromARGB(
                            255, 14, 66, 170), // Matching blue color
                      ),
                      title: const Text(
                        'Account',
                        style: TextStyle(
                          color: Color.fromARGB(
                              255, 14, 66, 170), // Matching blue color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Myacc()),
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 65),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Transform.scale(
                      scale: 3.0,
                      child: Image.asset('images/Logo.png', height: 100),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Our Contacts',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 14, 66, 170),
                    ),
                  ),
                  const SizedBox(height: 25),
                  // Contact Info Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 238, 186),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color: Color.fromARGB(255, 14, 66, 170),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Contact Info',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 14, 66, 170),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '+91 7788223548\n+91 9963217856',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Email Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 238, 186),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.email,
                              color: Color.fromARGB(255, 14, 66, 170),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Mail',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 14, 66, 170),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'jansuvidha24@gmail.com',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Website Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 238, 186),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.language,
                              color: Color.fromARGB(255, 14, 66, 170),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Website',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 14, 66, 170),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'www.jansuvidha24.com',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Social Media Section
                  Column(
                    children: [
                      const Text(
                        'Follow us on our socials',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 14, 66, 170),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _socialIcon(FontAwesomeIcons.instagram),
                          const SizedBox(width: 15),
                          _socialIcon(FontAwesomeIcons.facebook),
                          const SizedBox(width: 15),
                          _socialIcon(FontAwesomeIcons.linkedin),
                          const SizedBox(width: 15),
                          _socialIcon(FontAwesomeIcons.xTwitter),
                        ],
                      ),
                    ],
                  ),
                  // Add extra space at bottom to ensure content doesn't get hidden behind the bottom bar
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          // Bottom Blue Bar
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
    );
  }

  Widget _socialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 238, 186),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: FaIcon(
        icon,
        color: const Color.fromARGB(255, 14, 66, 170),
        size: 20,
      ),
    );
  }
}
