import 'package:flutter/material.dart';
import 'package:jansuvidha/login.dart';
import '../services/auth_services.dart';

void main() {
  runApp(Signup());
}

class Signup extends StatelessWidget {
  Signup({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController aadharNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            // Background container with gradien
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(
                        255, 255, 196, 107), // Starting color of the gradient
                    Colors.white,
                    Color.fromARGB(
                        255, 143, 255, 147), // Ending color of the gradient
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            Column(children: [
              Align(
                alignment: Alignment.topCenter, // Align at the top center
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 60), // Push down by 50 pixels
                  child: Transform.scale(
                    scale: 3, // Scale the widget by 140%
                    child: Image.asset('images/Logo.png', height: 100),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(children: [
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      color: Color.fromARGB(
                          255, 14, 66, 170), // Change text color as needed
                      fontSize: 24, // Adjust font size
                      fontWeight: FontWeight.bold, // Optional: make text bold
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: 284,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 254, 183, 101),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.3), // Shadow color with opacity
                          offset: const Offset(5,
                              5), // Shadow offset (light coming from top left)
                          blurRadius: 10, // Blur radius of the shadow
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        hintText: "Username", // Placeholder text
                        hintStyle: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 14, 66,
                                170) // Color of the placeholder text
                            ),
                        border:
                            InputBorder.none, // Remove the default underline
                        prefixIcon: Icon(
                          Icons.person, // User icon
                          color: Color.fromARGB(255, 14, 66, 170), // Icon color
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: 284,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 254, 183, 101),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.3), // Shadow color with opacity
                          offset: const Offset(5,
                              5), // Shadow offset (light coming from top left)
                          blurRadius: 10, // Blur radius of the shadow
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: "Email", // Placeholder text
                        hintStyle: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 14, 66,
                                170) // Color of the placeholder text
                            ),
                        border:
                            InputBorder.none, // Remove the default underline
                        prefixIcon: Icon(
                          Icons.email, // User icon
                          color: Color.fromARGB(255, 14, 66, 170), // Icon color
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: 284,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 254, 183, 101),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.3), // Shadow color with opacity
                          offset: const Offset(5,
                              5), // Shadow offset (light coming from top left)
                          blurRadius: 10, // Blur radius of the shadow
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: contactNumberController,
                      decoration: const InputDecoration(
                        hintText: "Contact Number", // Placeholder text
                        hintStyle: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 14, 66,
                                170) // Color of the placeholder text
                            ),
                        border:
                            InputBorder.none, // Remove the default underline
                        prefixIcon: Icon(
                          Icons.call, // User icon
                          color: Color.fromARGB(255, 14, 66, 170), // Icon color
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: 284,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 254, 183, 101),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.3), // Shadow color with opacity
                          offset: const Offset(5,
                              5), // Shadow offset (light coming from top left)
                          blurRadius: 10, // Blur radius of the shadow
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: aadharNumberController,
                      decoration: const InputDecoration(
                        hintText: "Aadhar Number", // Placeholder text
                        hintStyle: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 14, 66,
                                170) // Color of the placeholder text
                            ),
                        border:
                            InputBorder.none, // Remove the default underline
                        prefixIcon: Icon(
                          Icons.credit_card, // User icon
                          color: Color.fromARGB(255, 14, 66, 170), // Icon color
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: 284,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 254, 183, 101),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.3), // Shadow color with opacity
                          offset: const Offset(5,
                              5), // Shadow offset (light coming from top left)
                          blurRadius: 10, // Blur radius of the shadow
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        hintText: "Password", // Placeholder text
                        hintStyle: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 14, 66,
                                170) // Color of the placeholder text
                            ),
                        border:
                            InputBorder.none, // Remove the default underline
                        prefixIcon: Icon(
                          Icons.lock, // User icon
                          color: Color.fromARGB(255, 14, 66, 170), // Icon color
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: 284,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 254, 183, 101),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.3), // Shadow color with opacity
                          offset: const Offset(5,
                              5), // Shadow offset (light coming from top left)
                          blurRadius: 10, // Blur radius of the shadow
                        ),
                      ],
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Confirm Password", // Placeholder text
                        hintStyle: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 14, 66,
                                170) // Color of the placeholder text
                            ),
                        border:
                            InputBorder.none, // Remove the default underline
                        prefixIcon: Icon(
                          Icons.lock, // User icon
                          color: Color.fromARGB(255, 14, 66, 170), // Icon color
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 149,
                    height: 55,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 254, 183, 101),
                      borderRadius: BorderRadius.circular(15), // Rounded edges
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.3), // Shadow color with opacity
                          offset: const Offset(5,
                              5), // Shadow offset (light coming from top left)
                          blurRadius: 10, // Blur radius of the shadow
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        final username = usernameController.text;
                        final password = passwordController.text;
                        final email = emailController.text;
                        final contactnumber = contactNumberController.text;
                        final aadharnumber = aadharNumberController.text;

                        await AuthService.signUp(
                          username,
                          password,
                          email,
                          contactnumber,
                          aadharnumber,
                          (message) {
                            // Success callback: Navigate to LoginPage
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ),
                            );
                          },
                          (errorMessage) {
                            // Error callback: Show error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(errorMessage)),
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .transparent, // Make the ElevatedButton background transparent
                        shadowColor:
                            Colors.transparent, // Remove default shadow
                      ),
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                            fontSize: 24,
                            color: Color.fromARGB(255, 14, 66, 170),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ]),
              ),
            ]),
            Positioned(
              top: 40,
              right: 15,
              child: SizedBox(
                width: 50,
                height: 60,
                child: FloatingActionButton(
                  onPressed: () {
                    print('Call button pressed');
                  },
                  // No const here
                  shape: const CircleBorder(),
                  backgroundColor: const Color.fromARGB(255, 72, 113, 73),
                  mini: true,
                  child: const Icon(Icons.phone, color: Colors.white, size: 30),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 25),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(
                      255, 15, 62, 129), // Background color of the rectangle
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(13), // Circular radius for top corners
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: SizedBox(
                width: 50,
                height: 60,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pop(
                        context); // Navigate back to the previous screen
                  },
                  // No const here
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
    );
  }
}
