import 'package:flutter/material.dart';
import 'package:jansuvidha/user_widgets/emailupdate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dashboard.dart';
import 'contact.dart';
import '../config/app_config.dart';
import '../user_widgets/logout_dialog.dart';
import '../config/auth_service.dart';
import '../user_widgets/change_password.dart';
import '../user_widgets/update_profile.dart';

class Myacc extends StatefulWidget {
  const Myacc({Key? key}) : super(key: key);

  @override
  State<Myacc> createState() => _MyaccState();
}

class _MyaccState extends State<Myacc> {
  String username = '';
  String email = '';
  String phone = '';
  bool isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

// Fetch user data from backend
  Future<void> _fetchUserData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final appConfig = AuthService();
      final token = await appConfig.getToken();

      if (token == null) {
        // If no token, try to use cached data
        _loadCachedUserData();
        return;
      }

      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/user/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);

        // Save to state and cache
        setState(() {
          username = userData['username'] ?? 'Username';
          email = userData['email'] ?? 'user@example.com';
          phone = userData['phone'] ?? 'Not provided';
          isLoading = false;
        });

        // Cache data
        await prefs.setString('username', username);
        await prefs.setString('email', email);
        await prefs.setString('phone', phone);
      } else {
        // If API call fails, use cached data
        _loadCachedUserData();
      }
    } catch (e) {
      _loadCachedUserData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch user data: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

// Load data from cache if API call fails
  Future<void> _loadCachedUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Username';
      email = prefs.getString('email') ?? 'user@example.com';
      phone = prefs.getString('phone') ?? 'Not provided';
      isLoading = false;
    });
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

  Widget _buildDrawer(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 350;
    final double drawerFontSize = isSmallScreen ? 13 : 19;

    // Make drawer width responsive
    final double drawerWidth = screenSize.width * 0.85;

    return SizedBox(
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
                              builder: (context) => const Dashboard()),
                          (Route<dynamic> route) => false,
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
                      Icons.phone,
                      'Contact Us',
                      () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Contact()),
                        );
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

  void _navigateToUpdateUsername() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProfileField(
          title: 'Update Username',
          fieldName: 'username',
          initialValue: username,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Username cannot be empty';
            }
            if (value.length < 3) {
              return 'Username must be at least 3 characters';
            }
            return null;
          },
        ),
      ),
    );

    if (result == true) {
      _fetchUserData();
    }
  }

  void _navigateToChangePassword() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangePasswordScreen(),
      ),
    );

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _navigateToUpdatePhone() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProfileField(
          title: 'Update Phone Number',
          fieldName: 'phone',
          initialValue: phone,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Phone number cannot be empty';
            }
            if (!RegExp(r'^\d{10}$').hasMatch(value)) {
              return 'Please enter a valid 10-digit phone number';
            }
            return null;
          },
        ),
      ),
    );

    if (result == true) {
      _fetchUserData();
    }
  }

  void _navigateToUpdateEmail() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmailUpdateFlow(),
      ),
    );

    if (result == true) {
      _fetchUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 350;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(
              color: const Color.fromARGB(255, 14, 66, 170),
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.05,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme:
              const IconThemeData(color: Color.fromARGB(255, 14, 66, 170)),
          leading: IconButton(
            icon: Icon(Icons.menu, size: screenWidth * 0.07),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
        ),
        drawer: _buildDrawer(context),
        body: Container(
          height: screenHeight,
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
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 14, 66, 170),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.14),
                      Transform.translate(
                        offset: Offset(0, -screenHeight * 0.02),
                        child: Icon(
                          Icons.account_circle,
                          size: screenWidth * 0.2,
                          color: const Color.fromARGB(255, 14, 66, 170),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, -screenHeight * 0.02),
                        child: Column(
                          children: [
                            Text(
                              username,
                              style: TextStyle(
                                fontSize: screenWidth * 0.055,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 14, 66, 170),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              email,
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: const Color.fromARGB(255, 14, 66, 170),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              phone,
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: const Color.fromARGB(255, 14, 66, 170),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Container(
                        width: screenWidth * 0.9,
                        padding: EdgeInsets.all(screenWidth * 0.04),
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
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.03),
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
                            Text(
                              'Account Settings',
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 14, 66, 170),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            ..._buildAccountOptions(context),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Center(
                        child: SizedBox(
                          width:
                              screenWidth * 0.3, // Set to 50% of screen width
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 0.03),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.02,
                              ),
                            ),
                            onPressed: () =>
                                LogoutDialog.showLogoutDialog(context),
                            child: Text(
                              'Log Out',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.04,
                              ),
                            ),
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

  List<Widget> _buildAccountOptions(BuildContext context) {
    final options = [
      {
        'title': 'Update Username',
        'icon': Icons.person_outline,
        'action': _navigateToUpdateUsername
      },
      {
        'title': 'Change Password',
        'icon': Icons.lock_outline,
        'action': _navigateToChangePassword
      },
      {
        'title': 'Update Phone Number',
        'icon': Icons.phone_outlined,
        'action': _navigateToUpdatePhone
      },
      {
        'title': 'Update Email',
        'icon': Icons.email_outlined,
        'action': _navigateToUpdateEmail
      },
    ];
    return options
        .map((option) => _buildAccountOption(
              context,
              option['title'] as String,
              option['icon'] as IconData,
              option['action'] as VoidCallback,
            ))
        .toList();
  }

  Widget _buildAccountOption(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    const baseColor = Color.fromARGB(255, 14, 66, 170);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: baseColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.005),
          child: ListTile(
            leading: Icon(icon,
                color: baseColor,
                size: MediaQuery.of(context).size.width * 0.06),
            title: Text(
              title,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
                fontWeight: FontWeight.w500,
                color: baseColor,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: baseColor,
              size: MediaQuery.of(context).size.width * 0.04,
            ),
          ),
        ),
      ),
    );
  }

// Navigation methods remain the same as original...
// [Rest of the navigation methods and classes remain unchanged to preserve functionality]
}
