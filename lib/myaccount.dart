import 'package:flutter/material.dart';
import 'package:jansuvidha/config/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dashboard.dart';
import 'contact.dart';
import 'config/app_config.dart';
import 'widgets/logout_dialog.dart';


class Myacc extends StatefulWidget {
  const Myacc({super.key});

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
      String? token = prefs.getString('token');
      
      if (token == null) {
        // If no token, try to use cached data
        _loadCachedUserData();
        return;
      }
      
      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/user/profile'),
        headers: {
          'Authorization': token,
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
                          const SizedBox(height: 4),
                          Text(
                            phone,
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
  VoidCallback onTap;
  
  // Assign the correct navigation function based on title
  if (title == 'Update Username') {
    onTap = _navigateToUpdateUsername;
  } else if (title == 'Change Password') {
    onTap = _navigateToChangePassword;
  } else if (title == 'Update Phone Number') {
    onTap = _navigateToUpdatePhone;
  } else if (title == 'Update Email') {
    onTap = _navigateToUpdateEmail;
  } else {
    // Default empty callback
    onTap = () {};
  }
  
  return Material(
    color: Colors.transparent,
    child: InkWell(
      splashColor: const Color.fromARGB(255, 14, 66, 170).withOpacity(0.3),
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
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
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Color.fromARGB(255, 14, 66, 170),
            size: 16,
          ),
        ),
      ),
    ),
  );
}
  
  // Navigation methods for update screens
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
        builder: (context) => UpdateProfileField(
          title: 'Update Email',
          fieldName: 'email',
          initialValue: email,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email cannot be empty';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email address';
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
}

// Generic screen for updating profile fields
class UpdateProfileField extends StatefulWidget {
  final String title;
  final String fieldName;
  final String initialValue;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const UpdateProfileField({
    Key? key,
    required this.title,
    required this.fieldName,
    required this.initialValue,
    this.keyboardType = TextInputType.text,
    this.validator,
  }) : super(key: key);

  @override
  State<UpdateProfileField> createState() => _UpdateProfileFieldState();
}

class _UpdateProfileFieldState extends State<UpdateProfileField> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controller;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _updateField() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      
      if (token == null) {
        setState(() {
          _errorMessage = 'Authentication error. Please login again.';
          _isLoading = false;
        });
        return;
      }
      
      final response = await http.patch(
        Uri.parse('${AppConfig.apiBaseUrl}/user/profile'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          widget.fieldName: _controller.text.trim(),
        }),
      );
      
      if (response.statusCode == 200) {
        // Update local cache
        await prefs.setString(widget.fieldName, _controller.text.trim());
        
        if (mounted) {
          Navigator.pop(context, true);
        }
      } else {
        final errorData = json.decode(response.body);
        setState(() {
          _errorMessage = errorData['error'] ?? 'Failed to update ${widget.fieldName}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Color.fromARGB(255, 14, 66, 170),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 14, 66, 170)),
      ),
      extendBodyBehindAppBar: true,
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Enter new ${widget.fieldName}:',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 14, 66, 170),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _controller,
                      keyboardType: widget.keyboardType,
                      validator: widget.validator,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        border: InputBorder.none,
                        hintText: 'Enter your ${widget.fieldName}',
                      ),
                    ),
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      width: 130,
                      height: 55,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 254, 232, 179),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(5, 5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _updateField,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Color.fromARGB(255, 14, 66, 170),
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Update',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Color.fromARGB(255, 14, 66, 170),
                                  fontWeight: FontWeight.bold,
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
      ),
    );
  }
}

// Specialized screen for changing password
// Specialized screen for changing password
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController     = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  bool _showCurrentPassword = false;
  bool _showNewPassword     = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token == null) {
        setState(() {
          _errorMessage = 'Authentication error. Please login again.';
          _isLoading = false;
        });
        return;
      }

      final response = await http.patch(
        Uri.parse('${AppConfig.apiBaseUrl}/user/change-password'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'currentPassword': _currentPasswordController.text.trim(),
          'newPassword':     _newPasswordController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) Navigator.pop(context, true);
      } else {
        final errorData = json.decode(response.body);
        setState(() {
          _errorMessage = errorData['error'] ?? 'Failed to update password';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback toggleVisibility,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: const Color.fromARGB(255, 14, 66, 170),
          ),
          onPressed: toggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(
            color: Color.fromARGB(255, 14, 66, 170),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 14, 66, 170),
        ),
      ),
      extendBodyBehindAppBar: true,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildPasswordField(
                  label: 'Current Password',
                  controller: _currentPasswordController,
                  obscureText: _showCurrentPassword,
                  toggleVisibility: () => setState(() => _showCurrentPassword = !_showCurrentPassword),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildPasswordField(
                  label: 'New Password',
                  controller: _newPasswordController,
                  obscureText: _showNewPassword,
                  toggleVisibility: () => setState(() => _showNewPassword = !_showNewPassword),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildPasswordField(
                  label: 'Confirm New Password',
                  controller: _confirmPasswordController,
                  obscureText: _showConfirmPassword,
                  toggleVisibility: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your new password';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updatePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 14, 66, 170),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Update Password',
                            style: TextStyle(fontSize: 16, color: Colors.white),
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
}
