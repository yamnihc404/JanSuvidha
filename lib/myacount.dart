import 'package:flutter/material.dart';

class Myacc extends StatelessWidget {
  const Myacc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        backgroundColor: Color.fromARGB(
            255, 255, 214, 161), // Updated to match previous theme
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    AssetImage('assets/images/user_placeholder.png'),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Username',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 30, 90, 220), // Theme Color Update
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'user.email@example.com',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 24),

            // Account Settings
            const Text(
              'Account Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 30, 90, 220), // Theme Color Update
              ),
            ),
            const SizedBox(height: 10),
            _buildAccountOption(context, 'Edit Profile', Icons.person),
            _buildAccountOption(context, 'Change Password', Icons.lock),
            _buildAccountOption(context, 'Update Phone Number', Icons.phone),
            _buildAccountOption(context, 'Update Email', Icons.email),
            const SizedBox(height: 24),

            // Preferences
            const Text(
              'Preferences',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 30, 90, 220), // Theme Color Update
              ),
            ),
            const SizedBox(height: 10),
            _buildAccountOption(context, 'Language Preference', Icons.language),
            _buildAccountOption(context, 'Notifications', Icons.notifications),
            _buildAccountOption(context, 'Contact Us', Icons.phone_in_talk),
            _buildAccountOption(context, 'Rate Us', Icons.star),
            const SizedBox(height: 24),

            // Logout
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () {
                  // TODO: Implement Logout
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  'Log Out',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountOption(
      BuildContext context, String title, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon,
            color: Color.fromARGB(255, 30, 90, 220)), // Theme Color Update
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Handle navigation
        },
      ),
    );
  }
}
