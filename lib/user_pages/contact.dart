import 'package:flutter/material.dart';
import 'package:jansuvidha/user_pages/dashboard.dart';
import 'user_widgets/common_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'myaccount.dart';
import 'package:jansuvidha/user_pages/user_widgets/logout_dialog.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
Widget _buildDrawerItem(
  BuildContext context,
  IconData icon,
  String title,
  VoidCallback onTap,
  double fontSize,
  bool isSmallScreen,
) {
  return ListTile(
    dense: isSmallScreen, // Make list tiles more compact on small screens
    visualDensity: isSmallScreen
        ? const VisualDensity(horizontal: -2, vertical: -2)
        : const VisualDensity(horizontal: 0, vertical: 0),
    contentPadding: EdgeInsets.symmetric(
      horizontal: isSmallScreen ? 12.0 : 16.0,
      vertical: isSmallScreen ? 0.0 : 2.0,
    ),
    leading: Icon(
      icon,
      color: const Color.fromARGB(255, 14, 66, 170),
      size: isSmallScreen ? fontSize + 2 : fontSize + 4,
    ),
    title: Text(
      title,
      style: TextStyle(
        color: const Color.fromARGB(255, 14, 66, 170),
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
    ),
    onTap: onTap,
  );
}

Widget _buildExpandableDrawerItem(
  BuildContext context,
  IconData icon,
  String title,
  List<String> options,
  double fontSize,
  bool isSmallScreen,
) {
  final double subFontSize = fontSize - 1;

  return ExpansionTile(
    tilePadding: EdgeInsets.symmetric(
      horizontal: isSmallScreen ? 12.0 : 16.0,
      vertical: isSmallScreen ? 0.0 : 2.0,
    ),
    leading: Icon(
      icon,
      color: const Color.fromARGB(255, 14, 66, 170),
      size: isSmallScreen ? fontSize + 2 : fontSize + 4,
    ),
    title: Text(
      title,
      style: TextStyle(
        color: const Color.fromARGB(255, 14, 66, 170),
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
    ),
    childrenPadding: EdgeInsets.only(bottom: isSmallScreen ? 4.0 : 8.0),
    children: options.map((option) {
      return ListTile(
        dense: isSmallScreen,
        visualDensity: isSmallScreen
            ? const VisualDensity(horizontal: -2, vertical: -3)
            : const VisualDensity(horizontal: -1, vertical: -2),
        contentPadding: EdgeInsets.only(
          left: isSmallScreen ? fontSize * 3.5 : fontSize * 4.0,
        ),
        title: Text(
          option,
          style: TextStyle(
            color: const Color.fromARGB(255, 14, 66, 170),
            fontSize: subFontSize,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      );
    }).toList(),
  );
}

// Drawer
Widget _buildDrawer(BuildContext context) {
  final screenSize = MediaQuery.of(context).size;
  final isSmallScreen = screenSize.width < 350;
  final double drawerFontSize = isSmallScreen ? 13 : 19;

  // Make drawer width responsive
  final double drawerWidth =
      isSmallScreen ? screenSize.width * 0.75 : screenSize.width * 0.85;

  return Container(
    width: drawerWidth,
    child: Drawer(
      width: drawerWidth, // Set custom drawer width
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
            SizedBox(
                height: MediaQuery.of(context).padding.top +
                    (isSmallScreen ? 8 : 15)),
            Container(
              height: isSmallScreen ? 80 : 110,
              width: double.infinity,
              color: Colors.transparent,
              child: Center(
                child: Text(
                  'Jan Suvidha',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 14, 66, 170),
                    fontSize: isSmallScreen ? 22 : 26,
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
                  _buildDrawerItem(
                    context,
                    Icons.home,
                    'Home',
                    () {
                      // Close the drawer first
                      Navigator.of(context).pop();

                      // Navigate to dashboard and remove all previous routes
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserDashboard()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    drawerFontSize,
                    isSmallScreen,
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.edit,
                    'Edit Profile',
                    () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Myacc()),
                      );
                    },
                    drawerFontSize,
                    isSmallScreen,
                  ),
                  _buildExpandableDrawerItem(
                    context,
                    Icons.language,
                    'Language Preference',
                    ['English', 'हिंदी', 'मराठी'],
                    drawerFontSize,
                    isSmallScreen,
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.notifications,
                    'Notifications',
                    () {
                      Navigator.pop(context);
                    },
                    drawerFontSize,
                    isSmallScreen,
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.star,
                    'Rate Us',
                    () {
                      Navigator.pop(context);
                    },
                    drawerFontSize,
                    isSmallScreen,
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.logout,
                    'Log Out',
                    () {
                      LogoutDialog.showLogoutDialog(context);
                    },
                    drawerFontSize,
                    isSmallScreen,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ContactState extends State<Contact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 100),
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
                        '+91 7796547668\n+91 9963217856',
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
              ],
            ),
          ),
          // Bottom Blue Bar
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomRoundedBar(),
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
