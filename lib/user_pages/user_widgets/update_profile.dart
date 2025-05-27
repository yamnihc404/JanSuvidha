import 'package:jansuvidha/user_pages/config/app_config.dart';
import 'package:jansuvidha/user_pages/config/userauthservice.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      final authservice = AuthService();
      final token = await authservice.getToken();

      if (token == null) {
        setState(() {
          _errorMessage = 'Authentication error. Please login again.';
          _isLoading = false;
        });
        return;
      }

      final response = await http.patch(
        Uri.parse('${AppConfig.apiBaseUrl}/user/update-${widget.fieldName}'),
        headers: {
          'Authorization': 'Bearer $token',
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
          _errorMessage =
              errorData['error'] ?? 'Failed to update ${widget.fieldName}';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final baseColor = const Color.fromARGB(255, 14, 66, 170);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: baseColor,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.045,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: baseColor,
          size: screenWidth * 0.06,
        ),
      ),
      extendBodyBehindAppBar: true,
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
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Enter new ${widget.fieldName}:',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                      color: baseColor,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: screenWidth * 0.002,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset:
                              Offset(screenWidth * 0.005, screenWidth * 0.005),
                          blurRadius: screenWidth * 0.01,
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _controller,
                      keyboardType: widget.keyboardType,
                      validator: widget.validator,
                      style: TextStyle(fontSize: screenWidth * 0.04),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.02,
                        ),
                        border: InputBorder.none,
                        hintText: 'Enter your ${widget.fieldName}',
                        hintStyle: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.01),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                    ),
                  SizedBox(height: screenHeight * 0.03),
                  Center(
                    child: Container(
                      width: screenWidth * 0.4,
                      height: screenHeight * 0.07,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 254, 232, 179),
                        borderRadius: BorderRadius.circular(screenWidth * 0.05),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: Offset(
                              screenWidth * 0.01,
                              screenWidth * 0.01,
                            ),
                            blurRadius: screenWidth * 0.02,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _updateField,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.05),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: screenWidth * 0.06,
                                height: screenWidth * 0.06,
                                child: CircularProgressIndicator(
                                  color: baseColor,
                                  strokeWidth: screenWidth * 0.005,
                                ),
                              )
                            : Text(
                                'Update',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  color: baseColor,
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
