import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/appconfig.dart';
import 'user_widgets/common_widgets.dart';

class OtpVerification extends StatefulWidget {
  final String verificationType;
  final String contactInfo;
  const OtpVerification(
      {super.key, required this.verificationType, required this.contactInfo});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );
  late Timer _resendTimer;
  int _resendTimeout = 60;
  bool _canResend = false;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_resendTimeout > 0) {
        setState(() => _resendTimeout--);
      } else {
        _canResend = true;
        timer.cancel();
      }
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating, // Makes it float above content
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 100, // Positions near top
        left: 20,
        right: 20,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(10), // Rounded bottom corners
        ),
      ),
    ));
  }

  void _resendOtp() {
    // Call send-otp API
    http.post(
      Uri.parse(
          '${AppConfig.apiBaseUrl}/user/verify/verify-${widget.verificationType}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({widget.verificationType: widget.contactInfo}),
    );
    _startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final baseColor = const Color.fromARGB(255, 14, 66, 170);

    return Scaffold(
      body: Stack(
        children: [
          const GradientBackground(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'OTP Verification',
                  style: TextStyle(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.bold,
                    color: baseColor,
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                Text(
                  'Enter the OTP sent to ${widget.contactInfo}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: const Color.fromARGB(255, 88, 88, 88),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    4,
                    (index) => SizedBox(
                      width: screenWidth * 0.15,
                      height: screenWidth * 0.15,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: TextStyle(fontSize: screenWidth * 0.06),
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.025),
                            borderSide: BorderSide(color: baseColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.025),
                            borderSide: BorderSide(color: baseColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.025),
                            borderSide: BorderSide(
                              color: baseColor,
                              width: screenWidth * 0.005,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.length == 1 && index < 3) {
                            _focusNodes[index + 1].requestFocus();
                          }
                          if (value.isEmpty && index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                StyledContainer(
                  height: screenHeight * 0.07,
                  width: screenWidth * 0.5,
                  child: ElevatedButton(
                    onPressed: () async {
                      String otp = _controllers.map((c) => c.text).join();
                      if (otp.length != 4) {
                        _showErrorSnackBar('Enter complete OTP');
                        return;
                      }

                      try {
                        final endpoint = widget.verificationType == 'email'
                            ? 'verify-email'
                            : 'verify-phone';

                        final response = await http.post(
                          Uri.parse(
                              '${AppConfig.apiBaseUrl}/user/verify/$endpoint'),
                          headers: {'Content-Type': 'application/json'},
                          body: jsonEncode({
                            widget.verificationType: widget.contactInfo,
                            'otp': otp
                          }),
                        );

                        if (response.statusCode == 200) {
                          Navigator.pop(context, true);
                        } else {
                          final error = jsonDecode(response.body)['message'] ??
                              'Verification failed';
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error)),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Text(
                      'Verify',
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        color: baseColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                TextButton(
                  onPressed: _canResend ? _resendOtp : null,
                  child: Text(
                    _canResend ? 'Resend OTP' : 'Resend in $_resendTimeout',
                    style: TextStyle(
                      color: baseColor,
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomRoundedBar(),
          ),
          Positioned(
            bottom: screenHeight * 0.03,
            left: screenWidth * 0.05,
            child: SizedBox(
              width: screenWidth * 0.12,
              height: screenWidth * 0.12,
              child: FloatingActionButton(
                onPressed: () => Navigator.pop(context),
                shape: const CircleBorder(),
                backgroundColor: const Color.fromARGB(255, 254, 183, 101),
                mini: true,
                child: Icon(
                  Icons.arrow_back_ios_new_sharp,
                  color: const Color.fromARGB(255, 15, 62, 129),
                  size: screenWidth * 0.06,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
