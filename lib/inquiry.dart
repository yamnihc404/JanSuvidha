import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

void main() {
  runApp(const Dashboard());
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            const GradientBackground(),
            Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 50),
                    child: Image.asset('images/Logo.png'),
                  ),
                ),
                const SizedBox(height: 10),
                Positioned(
                  bottom: 100,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 254, 232, 179),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: DropdownButton<String>(
                            hint: const Text(
                              'Select Category',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 14, 66, 170)),
                            ),
                            isExpanded: true,
                            underline: const SizedBox.shrink(),
                            items: <String>[
                              'Category 1',
                              'Category 2',
                              'Category 3'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              // Handle dropdown change
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 254, 232, 179),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: DropdownButton<String>(
                            hint: const Text(
                              'Select Date',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 14, 66, 170)),
                            ),
                            isExpanded: true,
                            underline: const SizedBox.shrink(),
                            items: <String>['Date 1', 'Date 2', 'Date 3']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              // Handle dropdown change
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const TopNavButtons(),
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomRoundedBar(),
            ),
            Positioned(
              bottom: 62,
              left: 14,
              child: SizedBox(
                width: 50,
                height: 50,
                child: FloatingActionButton(
                  onPressed: () {
                    // Handle settings button action
                  },
                  shape: const CircleBorder(),
                  backgroundColor: const Color.fromARGB(255, 72, 113, 73),
                  child:
                      const Icon(Icons.settings, color: Colors.white, size: 35),
                ),
              ),
            ),
            Positioned(
              bottom: 62,
              right: 14,
              child: SizedBox(
                width: 50,
                height: 50,
                child: FloatingActionButton(
                  onPressed: () {
                    // Handle button action
                  },
                  shape: const CircleBorder(),
                  backgroundColor: const Color.fromARGB(255, 72, 113, 73),
                  child: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 30),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
