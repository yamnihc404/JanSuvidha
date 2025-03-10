import 'package:flutter/material.dart';
import 'widgets/common_widgets.dart';
import 'contact.dart';
import 'myacount.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';


class Addcomplain extends StatefulWidget {
  const Addcomplain({super.key});

  @override
  _AddcomplainState createState() => _AddcomplainState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _AddcomplainState extends State<Addcomplain> {
  // Add these variables at the top of your class
  File? _image;
  final ImagePicker _picker = ImagePicker();
  
  // Add the image source action sheet function
  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 254, 232, 179),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: Color.fromARGB(255, 14, 66, 170),
                ),
                title: const Text(
                  'Gallery',
                  style: TextStyle(
                    color: Color.fromARGB(255, 14, 66, 170),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  _getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_camera,
                  color: Color.fromARGB(255, 14, 66, 170),
                ),
                title: const Text(
                  'Camera',
                  style: TextStyle(
                    color: Color.fromARGB(255, 14, 66, 170),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  _getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Add the image picker function
  Future<void> _getImage(ImageSource source) async {
    final status = source == ImageSource.camera
        ? await Permission.camera.request()
        : await Permission.photos.request();

    if (status.isGranted) {
      try {
        final XFile? pickedFile = await _picker.pickImage(source: source);
        if (pickedFile != null) {
          setState(() {
            _image = File(pickedFile.path);
          });
        }
      } catch (e) {
        // Show error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 254, 232, 179),
              title: const Text(
                'Error',
                style: TextStyle(
                  color: Color.fromARGB(255, 14, 66, 170),
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                'Failed to access ${source == ImageSource.camera ? "camera" : "gallery"}: $e',
                style: const TextStyle(
                  color: Color.fromARGB(255, 14, 66, 170),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Color.fromARGB(255, 14, 66, 170),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    } else if (status.isDenied) {
      // Show permission denied dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 254, 232, 179),
            title: const Text(
              'Permission Denied',
              style: TextStyle(
                color: Color.fromARGB(255, 14, 66, 170),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Please grant permission to access your ${source == ImageSource.camera ? "camera" : "gallery"}.',
              style: const TextStyle(
                color: Color.fromARGB(255, 14, 66, 170),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: Color.fromARGB(255, 14, 66, 170),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else if (status.isPermanentlyDenied) {
      // Show open app settings dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 254, 232, 179),
            title: const Text(
              'Permission Permanently Denied',
              style: TextStyle(
                color: Color.fromARGB(255, 14, 66, 170),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'You need to go to app settings to grant ${source == ImageSource.camera ? "camera" : "gallery"} permission.',
              style: const TextStyle(
                color: Color.fromARGB(255, 14, 66, 170),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color.fromARGB(255, 14, 66, 170),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  openAppSettings();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Open Settings',
                  style: TextStyle(
                    color: Color.fromARGB(255, 14, 66, 170),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
  child: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,  // Changed direction
        end: Alignment.bottomRight, // Changed direction
        colors: [
          Color.fromARGB(255, 255, 215, 140),  // Lighter saffron
          Colors.white,
          Color.fromARGB(255, 170, 255, 173),  // Lighter green
        ],
        stops: [0.0, 0.4, 0.8],  // Adjusted stops for wider spread
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
          color: Colors.grey.withOpacity(0.3),  // Lighter separator
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 14, 66, 170), // Matching blue color
                ),
                title: const Text(
                  'Account',
                  style: TextStyle(
                    color: Color.fromARGB(255, 14, 66, 170), // Matching blue color
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Myacc()),
                  );
                },
              ),
              // Rest of your list tiles with the same color styling
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
                    MaterialPageRoute(builder: (context) => const Contact()),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),
        
        


              
        body: Stack(
          children: [
            const GradientBackground(),
            Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Transform.scale(
                    scale: 1.5,
                    child: Image.asset(
                      'images/Logo.png',
                      width: 250,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Column(
                    children: [
                      const StyledContainer(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Enter Username",
                            hintStyle: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 14, 66, 170),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const StyledContainer(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Enter Contact Number",
                            hintStyle: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 14, 66, 170),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      StyledContainer(
                        child: DropdownButton<String>(
                          hint: const Text(
                            'Road Maintainence',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 14, 66, 170),
                            ),
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
                      const SizedBox(height: 20),
                      const StyledContainer(
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: "Describe Your Complaint Here.",
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 14, 66, 170),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StyledContainer(
                            width: 100,
                            height: 100,
                            child: IconButton(
                              icon: const Icon(Icons.add_photo_alternate),
                              iconSize: 50,
                              color: const Color.fromARGB(255, 5, 6, 6),
                              onPressed: () {
                                // Action to add images
                                 _showImageSourceActionSheet(context);
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          StyledContainer(
                            width: 100,
                            height: 100,
                            child: IconButton(
                              icon: const Icon(Icons.location_on),
                              iconSize: 50,
                              color: const Color.fromARGB(255, 5, 6, 6),
                              onPressed: () {
                                // Action to select location
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Center(
                        child: Container(
                          width: 149,
                          height: 55,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 254, 232, 179),
                            borderRadius:
                                BorderRadius.circular(20), // Rounded edges
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                    0.3), // Shadow color with opacity
                                offset: const Offset(5,
                                    5), // Shadow offset (light coming from top left)
                                blurRadius: 10, // Blur radius of the shadow
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () async {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .transparent, // Make the ElevatedButton background transparent
                              shadowColor:
                                  Colors.transparent, // Remove default shadow
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Color.fromARGB(255, 14, 66, 170),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 40,
              left: 10,
              child: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, size: 30, color: Colors.black),
                  onPressed: () {
                    if (_scaffoldKey.currentState != null) {
                      Scaffold.of(context).openDrawer();
                    } else {
                      print(
                          "_scaffoldKey.currentState: ${_scaffoldKey.currentState}");
                    }
                  },
                ),
              ),
            ),
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomRoundedBar(),
            ),
            // Back Button
            Positioned(
              bottom: 20,
              left: 20,
              child: SizedBox(
                width: 50,
                height: 60,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  shape: const CircleBorder(),
                  backgroundColor: const Color.fromARGB(255, 254, 183, 101),
                  mini: true,
                  child: const Icon(
                    Icons.arrow_back_ios_new_sharp,
                    color: Color.fromARGB(255, 14, 66, 170),
                    size: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
