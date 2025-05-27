import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'myaccount.dart';

class Contact extends StatelessWidget {
  const Contact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      drawer: _buildDrawer(context),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 255, 215, 140), // Lighter saffron
              Colors.white,
              Color.fromARGB(255, 170, 255, 173), // Lighter green
            ],
            stops: [0.0, 0.4, 0.8],
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 60),
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
                  _buildContactCard(
                    Icons.phone,
                    'Contact Info',
                    '+91 7796547668\n+91 8830768914',
                  ),
                  const SizedBox(height: 10),
                  // Email Card
                  _buildContactCard(
                    Icons.email,
                    'Mail',
                    'jansuvidha24@gmail.com',
                  ),
                  const SizedBox(height: 10),
                  // Website Card
                  _buildContactCard(
                    Icons.language,
                    'Website',
                    'www.jansuvidha24.com',
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
                ],
              ),
            ),
            // Bottom Bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 50,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 14, 66, 170),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(IconData icon, String title, String content) {
    return Container(
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
          Row(
            children: [
              Icon(
                icon,
                color: const Color.fromARGB(255, 14, 66, 170),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 14, 66, 170),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black.withOpacity(0.7),
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

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 255, 215, 140), // Lighter saffron
              Colors.white,
              Color.fromARGB(255, 170, 255, 173), // Lighter green
            ],
            stops: [0.0, 0.4, 0.8],
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
              color: Colors.grey.withOpacity(0.3),
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
                      Navigator.pop(context);
                      // Navigate to home - you can add your navigation code here
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.edit,
                      color: Color.fromARGB(255, 14, 66, 170),
                    ),
                    title: const Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Color.fromARGB(255, 14, 66, 170),
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
                  ExpansionTile(
                    leading: const Icon(
                      Icons.language,
                      color: Color.fromARGB(255, 14, 66, 170),
                    ),
                    title: const Text(
                      'Language Preference',
                      style: TextStyle(
                        color: Color.fromARGB(255, 14, 66, 170),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 72),
                        title: const Text(
                          'English',
                          style: TextStyle(
                            color: Color.fromARGB(255, 14, 66, 170),
                          ),
                        ),
                        onTap: () {
                          // Change language to English
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 72),
                        title: const Text(
                          'हिंदी',
                          style: TextStyle(
                            color: Color.fromARGB(255, 14, 66, 170),
                          ),
                        ),
                        onTap: () {
                          // Change language to Hindi
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 72),
                        title: const Text(
                          'मराठी',
                          style: TextStyle(
                            color: Color.fromARGB(255, 14, 66, 170),
                          ),
                        ),
                        onTap: () {
                          // Change language to Marathi
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.notifications,
                      color: Color.fromARGB(255, 14, 66, 170),
                    ),
                    title: const Text(
                      'Notifications',
                      style: TextStyle(
                        color: Color.fromARGB(255, 14, 66, 170),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      // Navigate to notifications page
                      Navigator.pop(context);
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
                      Navigator.pop(context);
                      // Already on Contact page
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.star,
                      color: Color.fromARGB(255, 14, 66, 170),
                    ),
                    title: const Text(
                      'Rate Us',
                      style: TextStyle(
                        color: Color.fromARGB(255, 14, 66, 170),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      // Implement rating functionality
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Color.fromARGB(255, 14, 66, 170),
                    ),
                    title: const Text(
                      'Log Out',
                      style: TextStyle(
                        color: Color.fromARGB(255, 14, 66, 170),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      // Show logout dialog
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Simple logout dialog function
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add logout logic here
                // For example, navigate to login page
                // Navigator.pushAndRemoveUntil(...)
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
