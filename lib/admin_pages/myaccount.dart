import 'package:flutter/material.dart';
import './Admin_dashboard.dart';
import 'Contact.dart';

class Myacc extends StatefulWidget {
  const Myacc({Key? key}) : super(key: key);

  @override
  State<Myacc> createState() => _MyaccState();
}

class _MyaccState extends State<Myacc> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> userProfile = {
    'username': 'John Doe',
    'email': 'john@example.com',
    'phone': '+1 234 567 890',
    'isEmailVerified': false,
    'isPhoneVerified': false,
  };

  // Define primary blue color constant for consistency
  static const Color primaryBlue = Color.fromARGB(255, 14, 66, 170);

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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/Logo.png',
                      height: 70,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Jan Suvidha',
                      style: TextStyle(
                        color: primaryBlue,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
                      color: primaryBlue,
                    ),
                    title: const Text(
                      'Home',
                      style: TextStyle(
                        color: primaryBlue,
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
                      Icons.person,
                      color: primaryBlue,
                    ),
                    title: const Text(
                      'My Profile',
                      style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  // Added Language Preference ExpansionTile
                  ExpansionTile(
                    leading: Icon(Icons.language, color: primaryBlue),
                    title: Text(
                      'Language Preference',
                      style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 72),
                        title: Text('English',
                            style: TextStyle(color: primaryBlue)),
                        onTap: () => Navigator.pop(context),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 72),
                        title:
                            Text('हिंदी', style: TextStyle(color: primaryBlue)),
                        onTap: () => Navigator.pop(context),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 72),
                        title:
                            Text('मराठी', style: TextStyle(color: primaryBlue)),
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.notifications,
                      color: primaryBlue,
                    ),
                    title: const Text(
                      'Notifications',
                      style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.phone,
                      color: primaryBlue,
                    ),
                    title: const Text(
                      'Contact Us',
                      style: TextStyle(
                        color: primaryBlue,
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
                      color: primaryBlue,
                    ),
                    title: const Text(
                      'Rate Us',
                      style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: primaryBlue,
                    ),
                    title: const Text(
                      'Log Out',
                      style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      // Show logout dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            title: const Text(
                              'Logout',
                              style: TextStyle(
                                color: primaryBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content:
                                const Text('Are you sure you want to logout?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Implement your logout functionality here
                                  Navigator.of(context).pop();
                                  // Navigate to login screen
                                },
                                child: const Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: primaryBlue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
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

      appBar: null, // No AppBar to prevent white space
      drawer: _buildDrawer(),
      body: Container(
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
        child: SafeArea(
          child: Stack(
            children: [
              // Menu button and title in a Row for proper positioning
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu,
                            size: 30, color: primaryBlue),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'My Profile',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
              // Logo positioned at top center with adjusted size and position
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Transform.scale(
                    scale: 1.4, // Slightly smaller than before (was 1.6)
                    child: Image.asset(
                      'images/Logo.png',
                      width: 230, // Slightly reduced size
                      height: 230, // Slightly reduced size
                    ),
                  ),
                ),
              ),
              // Main content with adjusted padding to accommodate logo and text
              SingleChildScrollView(
                padding: const EdgeInsets.only(
                    top: 220,
                    left: 16,
                    right: 16), // Adjusted top padding (was 240)
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildProfileSection(),
                    const SizedBox(height: 20),
                    _buildAccountSettings(),
                    const SizedBox(height: 20),
                    _buildVerificationSection(),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 15, 62, 129),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(13),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 255, 226, 172),
            Colors.white,
            Color.fromARGB(255, 196, 255, 199),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor: primaryBlue.withOpacity(0.1),
                child: const Icon(
                  Icons.account_circle,
                  size: 85,
                  color: primaryBlue,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: primaryBlue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            userProfile['username'],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 20),
          _buildProfileDetail(
            Icons.email,
            userProfile['email'],
            userProfile['isEmailVerified'],
          ),
          const SizedBox(height: 12),
          _buildProfileDetail(
            Icons.phone,
            userProfile['phone'],
            userProfile['isPhoneVerified'],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetail(IconData icon, String text, bool isVerified) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: primaryBlue),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: primaryBlue,
          ),
        ),
        const SizedBox(width: 10),
        isVerified
            ? const Icon(Icons.verified, color: Colors.green, size: 20)
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Verify',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
      ],
    );
  }

  Widget _buildAccountSettings() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 255, 226, 172),
            Colors.white,
            Color.fromARGB(255, 196, 255, 199),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 16),
          _buildAccountOption('Update Username', Icons.person_outline),
          _buildAccountOption('Change Password', Icons.lock_outline),
          _buildAccountOption('Update Phone Number', Icons.phone_outlined),
          _buildAccountOption('Update Email', Icons.email_outlined),
        ],
      ),
    );
  }

  Widget _buildVerificationSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 255, 226, 172),
            Colors.white,
            Color.fromARGB(255, 196, 255, 199),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Verification Status',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 16),
          _buildVerificationStatus(
              'Email Verification', userProfile['isEmailVerified']),
          const SizedBox(height: 12),
          _buildVerificationStatus(
              'Phone Verification', userProfile['isPhoneVerified']),
        ],
      ),
    );
  }

  Widget _buildVerificationStatus(String text, bool isVerified) {
    return Row(
      children: [
        Icon(
          isVerified ? Icons.check_circle : Icons.error,
          color: isVerified ? Colors.green : Colors.orange,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: primaryBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildAccountOption(String title, IconData icon) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: primaryBlue, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: primaryBlue,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: primaryBlue,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
