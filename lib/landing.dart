// ignore: file_names
import 'package:flutter/material.dart';
import 'widgets/common_widgets.dart';
import 'login.dart';
import 'signup.dart';

void main() {
  runApp(const Landing());
}

class Landing extends StatelessWidget {
  const Landing({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            const GradientBackground(),
            Align(
              alignment: Alignment.topCenter,
              child: Transform.scale(
                scale: 1.2,
                child: Image.asset('images/Logo.png'),
              ),
            ),
            Positioned(
              bottom: 130,
              left: 50,
              right: 50,
              child: Column(
                children: [
                  StyledContainer(
                    height: 100,
                    width: 149,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 24,
                          color: Color.fromARGB(255, 14, 66, 170),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  StyledContainer(
                    height: 100,
                    width: 149,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Signup()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'Sign Up',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          color: Color.fromARGB(255, 14, 66, 170),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                  shape: const CircleBorder(),
                  backgroundColor: const Color.fromARGB(255, 72, 113, 73),
                  mini: true,
                  child: const Icon(Icons.phone, color: Colors.white, size: 30),
                ),
              ),
            ),
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomRoundedBar(),
            ),
          ],
        ),
      ),
    );
  }
}
