import 'package:flutter/material.dart';
import '../admin_pages/myaccount.dart';
import '../admin_pages/Contact.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Mock data for demonstration
  int pendingCount = 5;
  int disputeCount = 2;
  int resolvedCount = 10;

  Widget _buildDrawer() {
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminDashboard()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.edit,
                      color: Color.fromARGB(255, 14, 66, 170),
                    ),
                    title: Text(
                      'Edit Profile',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 14, 66, 170),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context); // Close the drawer first
                      Navigator.push(
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
                      Navigator.pop(context); // Close the drawer first
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Contact()),
                      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.vertical,
            ),
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
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
                      scale: 1.6,
                      child: Image.asset(
                        'images/Logo.png',
                        width: 250,
                        height: 250,
                      ),
                    ),
                  ),
                ]),
                Positioned(
                  top: 30,
                  left: 10,
                  child: Builder(
                    builder: (context) => IconButton(
                      icon:
                          const Icon(Icons.menu, size: 30, color: Colors.black),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                ),

                // Status cards
                Positioned(
                  top: 200,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 70,
                                child: _buildStatusCard(
                                  count: pendingCount,
                                  label: 'Pending',
                                  color: const Color(0xFFF9EFC7),
                                  textColor: const Color(0xFF6B5900),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 70,
                                child: _buildStatusCard(
                                  count: disputeCount,
                                  label: 'Dispute',
                                  color: const Color(0xFFF8D7DA),
                                  textColor: const Color(0xFF721C24),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 70,
                          width: double.infinity,
                          child: _buildStatusCard(
                            count: resolvedCount,
                            label: 'Resolved',
                            color: const Color(0xFFD4EDDA),
                            textColor: const Color(0xFF155724),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Admin Dashboard Specific Button - View Inquiries
                Positioned(
                  top: 380,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/inquiries');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 230, 160),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 5,
                          ),
                          child: const Text(
                            'View Inquiries',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),

                // Bottom bar
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

                // Back button
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
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard({
    required int count,
    required String label,
    required Color color,
    required Color textColor,
    bool isSmall = false,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: isSmall ? 20 : 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: isSmall ? 12 : 13,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
