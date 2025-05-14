import 'package:flutter/material.dart';
import 'package:jansuvidha/config/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';
import 'contact.dart';
import 'landing.dart';
import 'package:jansuvidha/widgets/logout_dialog.dart';

class Myacc extends StatefulWidget {
  const Myacc({super.key});

  @override
  State<Myacc> createState() => _MyaccState();
}

class _MyaccState extends State<Myacc> {
  String username = '';
  String email = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Username';
      email = prefs.getString('email') ?? 'user@example.com';
    });
  }

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
                            builder: (context) => const Dashboard()),
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
                      Navigator.pushReplacement(
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
                      LogoutDialog.showLogoutDialog(context);
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            'My Account',
            style: TextStyle(
              color: Color.fromARGB(255, 14, 66, 170),
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme:
              const IconThemeData(color: Color.fromARGB(255, 14, 66, 170)),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),
        drawer: _buildDrawer(),
        body: Container(
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App Logo
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                  ),
                  child: Transform.scale(
                    scale: 1.6,
                    child: Image.asset(
                      'images/Logo.png',
                      width: 250,
                      height: 220,
                    ),
                  ),
                ),

                // Profile Avatar
                Transform.translate(
                  offset: const Offset(0, -10),
                  child: const Icon(
                    Icons.account_circle,
                    size: 90,
                    color: Color.fromARGB(255, 14, 66, 170),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -10),
                  child: Column(
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 14, 66, 170),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 14, 66, 170),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Update Options
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 255, 215, 140),
                        Colors.white,
                        Color.fromARGB(255, 170, 255, 173),
                      ],
                      stops: [0.0, 0.4, 0.8],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
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
                          color: Color.fromARGB(255, 14, 66, 170),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildAccountOption(
                          context, 'Update Username', Icons.person_outline),
                      _buildAccountOption(
                          context, 'Change Password', Icons.lock_outline),
                      _buildAccountOption(
                          context, 'Update Phone Number', Icons.phone_outlined),
                      _buildAccountOption(
                          context, 'Update Email', Icons.email_outlined),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                  ),
                  onPressed: () {
                    LogoutDialog.showLogoutDialog(
                        context); // Show confirmation dialog
                  },
                  child: const Text(
                    'Log Out',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                // Bottom bar
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(top: 30),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 15, 62, 129),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(13),
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

  Widget _buildAccountOption(
      BuildContext context, String title, IconData icon) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: const Color.fromARGB(255, 14, 66, 170).withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title option selected'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            leading: Icon(
              icon,
              color: const Color.fromARGB(255, 14, 66, 170),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 14, 66, 170),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
