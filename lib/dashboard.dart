import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jansuvidha/filecomplain.dart';
import 'inquiry.dart';
import 'contact.dart';
import 'myaccount.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config/app_config.dart';
import 'config/auth_service.dart';
import 'package:jansuvidha/widgets/logout_dialog.dart';
import 'package:jansuvidha/widgets/notification_dialog.dart';

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
  int _notificationCount = 0;
  List<dynamic> _notifications = [];
  bool _notificationsLoading = true;
  late Timer _notificationTimer;
  bool _isDataFetched = false;

  Future<void> fetchNotifications() async {
    try {
      final authService = AuthService();
      final token = await authService.getToken();

      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/notifications'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            _notifications = data['data'];
            _notificationCount = _notifications.length;
            _notificationsLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    _notificationTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      fetchNotifications();
    });
  }

  @override
  void deactivate() {
    _isDataFetched = false;
    print(_isDataFetched);
    super.deactivate();
  }

  @override
  void dispose() {
    _notificationTimer.cancel();
    super.dispose();
  }

  Future<void> fetchComplaintCounts() async {
    try {
      final authservice = AuthService();
      final token = await authservice.getToken();

      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/complaints/counts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
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
    // Get screen dimensions for responsive layout
    if (!_isDataFetched) {
      print(_isDataFetched);
      fetchComplaintCounts();
      fetchNotifications();
      _isDataFetched = true;
    }
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen =
        screenSize.width < 350; // For Nexus S and similar devices

    // Calculate responsive scaling factors
    final double logoScale = isSmallScreen ? 1.2 : 1.5;
    final double cardHeight = isSmallScreen ? 60 : 70;
    final double buttonWidth = isSmallScreen ? screenSize.width * 0.8 : 300;
    final double fontSize = isSmallScreen ? 16 : 18;

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient
            Container(
              height: screenSize.height,
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

            // Main content area with scroll capability
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenSize.height -
                      MediaQuery.of(context).padding.vertical,
                ),
                child: Column(
                  children: [
                    // Top section with menu button and logo
                    Stack(
                      children: [
                        // Logo
                        Align(
                          alignment: Alignment.topCenter,
                          child: Transform.scale(
                            scale: logoScale,
                            child: Image.asset(
                              'images/Logo.png',
                              width: 180,
                              height: 180,
                            ),
                          ),
                        ),

                        // Menu button
                        Positioned(
                          top: 30,
                          left: 10,
                          child: Builder(
                            builder: (context) => IconButton(
                              icon: const Icon(Icons.menu,
                                  size: 30, color: Colors.black),
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Stats cards section
                    SizedBox(height: isSmallScreen ? 10 : 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  height: cardHeight,
                                  child: _buildStatusCard(
                                    count: isLoading ? 0 : pendingCount,
                                    label: 'Total Complaints',
                                    color: const Color(0xFFF9EFC7),
                                    textColor: const Color(0xFF6B5900),
                                    isSmall: isSmallScreen,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  height: cardHeight,
                                  child: _buildStatusCard(
                                    count: isLoading ? 0 : disputeCount,
                                    label: 'Disputes',
                                    color: const Color(0xFFF8D7DA),
                                    textColor: const Color(0xFF721C24),
                                    isSmall: isSmallScreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: cardHeight,
                            width: double.infinity,
                            child: _buildStatusCard(
                              count: isLoading ? 0 : resolvedCount,
                              label: 'Resolved',
                              color: const Color(0xFFD4EDDA),
                              textColor: const Color(0xFF155724),
                              isSmall: isSmallScreen,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Action buttons section
                    SizedBox(height: isSmallScreen ? 20 : 30),
                    _buildActionButton(
                      context,
                      'File new complaint',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Addcomplain()),
                        );
                      },
                      buttonWidth,
                      fontSize,
                    ),
                    const SizedBox(height: 15),
                    _buildActionButton(
                      context,
                      'Complaint Inquiry',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Inquiry()),
                        );
                      },
                      buttonWidth,
                      fontSize,
                    ),

                    // Bottom spacing to ensure content doesn't get hidden behind bottom bar
                    SizedBox(height: isSmallScreen ? 120 : 150),
                  ],
                ),
              ),
            ),

            // Bottom bar - fixed at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding:
                    EdgeInsets.symmetric(vertical: isSmallScreen ? 20 : 25),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 15, 62, 129),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(13),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 30,
              right: 10,
              child: NotificationBadge(
                count: _notificationCount,
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => NotificationDialog(
                        notifications: _notifications,
                        loading: _notificationsLoading,
                        onActionPerformed: fetchNotifications),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a status card
  Widget _buildStatusCard({
    required int count,
    required String label,
    required Color color,
    required Color textColor,
    required bool isSmall,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: color,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: isSmall ? 3.0 : 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: isSmall ? 18 : 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: isSmall ? 11 : 13,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build an action button
  Widget _buildActionButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
    double width,
    double fontSize,
  ) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 255, 230, 160),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  // Helper method to build the drawer
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
                      () => Navigator.of(context).pop(),
                      drawerFontSize,
                      isSmallScreen,
                    ),
                    _buildDrawerItem(
                      context,
                      Icons.edit,
                      'Edit Profile',
                      () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Myacc()),
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
                        Navigator.pop(context);
                        Navigator.push(
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

  // Helper method to build a drawer item
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

  // Helper method to build an expandable drawer item
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
}

class NotificationBadge extends StatelessWidget {
  final int count;
  final VoidCallback onPressed;

  const NotificationBadge({
    super.key,
    required this.count,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Badge(
        label: Text(count.toString()),
        child: const Icon(Icons.notifications, color: Colors.black),
      ),
      onPressed: onPressed,
    );
  }
}
