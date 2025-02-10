import 'package:flutter/material.dart';
import '../services/auth_services.dart';
import 'package:jansuvidha/filecomplain.dart';

void main() {
  runApp(Login());
}

class Login extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Login({super.key});

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
                alignment: Alignment.topCenter,
                child: Transform.scale(
                  scale: 1.8, // Scale the widget by 130%
                  child: Image.asset(
                    'images/Logo.png',
                    width: 250,
                    height: 250,
                  ),
                ),
              ),
              Center(
                child: Column(children: [
                  const Text(
                    'Log in',
                    style: TextStyle(
                      color: Color.fromARGB(
                          255, 14, 66, 170), // Change text color as needed
                      fontSize: 24, // Adjust font size
                      fontWeight: FontWeight.bold, // Optional: make text bold
                    ),
                  ),
                  const SizedBox(height: 27),
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
                        hintText: "Enter Username", // Placeholder text
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
                  const SizedBox(height: 20),
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
                        hintText: "Enter Password", // Placeholder text
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
                  const SizedBox(height: 35),
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

                        // Call the sign-in function
                        final result =
                            await AuthService.signIn(username, password);

                        if (result['success']) {
                          // On success, navigate to InquiryPage
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Addcomplain(),
                            ),
                          );
                        } else {
                          // On failure, show an error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result['message'])),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .transparent, // Make the ElevatedButton background transparent
                        shadowColor:
                            Colors.transparent, // Remove default shadow
                      ),
                      child: const Text(
                        'Login',
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
