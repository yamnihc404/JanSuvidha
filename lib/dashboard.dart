import 'package:flutter/material.dart';
import 'package:jansuvidha/filecomplain.dart';
import 'inquiry.dart';
import 'contact.dart';
import 'myaccount.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config/app_config.dart';
import 'config/auth_service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Initialize complaint status counts to 0 (will be updated from backend later)
  int pendingCount = 0;
  int disputeCount = 0;
  int resolvedCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchComplaintCounts();
  }

  Future<void> fetchComplaintCounts() async {
    try {
      final authservice = AuthService();
      final token = await authservice.getToken();

      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/complaints/counts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            pendingCount = data['data']['total'];
            resolvedCount = data['data']['resolved'];
            disputeCount = data['data']['disputes'];
            isLoading = false;
          });
        }
      } else {
        print('Failed to fetch complaint counts');
      }
    } catch (e) {
      print('Error fetching complaint counts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
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
                        Navigator.of(context).pop();
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
                        Navigator.pop(context); // Close the drawer first
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Myacc()),
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
                            // You'll need to implement language change functionality here
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
                            // You'll need to implement language change functionality here
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
                            // You'll need to implement language change functionality here
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
                        Navigator.pop(context); // Close the drawer first
                        // Add your navigation code here
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
                        // Implement rating functionality
                        Navigator.pop(context); // Close the drawer first
                        // Consider using a package like url_launcher to open app store
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
                        // Implement logout functionality
                        Navigator.pop(context); // Close the drawer first
                        // Add your logout code here
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        // SafeArea to prevent overlap with system UI
        child: SingleChildScrollView(
          // Added SingleChildScrollView to make content scrollable
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.vertical,
            ),
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context)
                      .size
                      .height, // Set container to full screen height
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
                      scale: 1.6, // Restored to original scale
                      child: Image.asset(
                        'images/Logo.png',
                        width: 250, // Restored to original width
                        height: 250, // Restored to original height
                      ),
                    ),
                  ),
                ]),
                Positioned(
                  top: 30, // Reduced from 40
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

                // Status cards restored to original sizes with better spacing
                Positioned(
                  top: 200, // Good position below logo
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
                                  count: isLoading ? 0 : pendingCount,
                                  label: 'Total Complaints',
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
                                  count: isLoading ? 0 : disputeCount,
                                  label: 'Disputes',
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
                            count: isLoading ? 0 : resolvedCount,
                            label: 'Resolved',
                            color: const Color(0xFFD4EDDA),
                            textColor: const Color(0xFF155724),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Buttons positioned lower - moved down by 40 pixels
                Positioned(
                  top: 380, // Changed from 340 to 380 to move buttons down
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      Container(
                        width: 300, // Restored to original width
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
                            backgroundColor:
                                const Color.fromARGB(255, 255, 230, 160),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15), // Restored padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 5,
                          ),
                          child: const Text(
                            'File new complaint',
                            style: TextStyle(
                              fontSize: 18, // Restored font size
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 300, // Restored to original width
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Inquiry()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 230, 160),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15), // Restored padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 5,
                          ),
                          child: const Text(
                            'Complaint Inquiry',
                            style: TextStyle(
                              fontSize: 18, // Restored font size
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      // Added extra space at bottom to ensure scroll works properly
                      const SizedBox(height: 100),
                    ],
                  ),
                ),

                // Bottom bar with original dimensions
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25), // Restored original padding
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 15, 62, 129),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(13), // Restored radius
                      ),
                    ),
                  ),
                ),

                // Back button with original size
                Positioned(
                  bottom: 20, // Restored to original position
                  left: 20,
                  child: SizedBox(
                    width: 50, // Restored to original width
                    height: 60, // Restored to original height
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      shape: const CircleBorder(),
                      backgroundColor: const Color.fromARGB(255, 254, 183, 101),
                      mini: true,
                      child: const Icon(Icons.arrow_back_ios_new_sharp,
                          color: Color.fromARGB(255, 15, 62, 129),
                          size: 25), // Restored original size
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

  // Significantly redesigned helper method to build extremely compact status cards
  Widget _buildStatusCard({
    required int count,
    required String label,
    required Color color,
    required Color textColor,
    bool isSmall =
        false, // Added parameter to make text even smaller for the top row cards
  }) {
    return Card(
      elevation: 2, // Reduced from 3
      margin: const EdgeInsets.symmetric(vertical: 2), // Added minimal margin
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)), // Reduced from 10
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 5.0), // Further reduced from 8.0
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: isSmall ? 20 : 22, // Further reduced from 24
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            // Removed SizedBox height spacing
            Text(
              label,
              style: TextStyle(
                fontSize: isSmall ? 12 : 13, // Further reduced from 14
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
