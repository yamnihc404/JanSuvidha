import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'widgets/common_widgets.dart';
import 'contact.dart';
import 'myaccount.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dashboard.dart';
import 'config/app_config.dart';
import 'map_screen.dart';

class Addcomplain extends StatefulWidget {
  const Addcomplain({super.key});

  @override
  _AddcomplainState createState() => _AddcomplainState();
}

class _AddcomplainState extends State<Addcomplain> {
  // Permission tracking variables
  bool _cameraPermissionDeniedOnce = false;
  bool _galleryPermissionDeniedOnce = false;
  bool _locationPermissionDeniedOnce = false;

  // Image variables
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Text controllers
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Road Maintenance';

  // Form validation variables
  bool _isImageError = false;
  bool _isLocationError = false;
  bool _isDescriptionError = false;

  // Form submission attempted flag
  bool _submissionAttempted = false;

  // Location variables
  LatLng? _selectedLocation;
  String? _humanReadableAddress;

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(_checkDescriptionField);
    _selectedLocation = LatLng(19.0760, 72.8777);
  }

  @override
  void dispose() {
    _descriptionController.removeListener(_checkDescriptionField);
    _descriptionController.dispose();
    _locationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Check if description field is filled
  void _checkDescriptionField() {
    if (_submissionAttempted) {
      final bool isEmpty = _descriptionController.text.trim().isEmpty;
      if (isEmpty != _isDescriptionError) {
        setState(() {
          _isDescriptionError = isEmpty;
        });
      }
    }
  }

  // Required field indicator
  Widget requiredIndicator() {
    return const Text(
      ' *',
      style: TextStyle(
        color: Colors.red,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Image source selection
  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
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

  // Image selection with permissions handling
  Future<void> _getImage(ImageSource source) async {
    try {
      PermissionStatus status;

      if (source == ImageSource.camera) {
        status = await Permission.camera.status;
      } else {
        if (Platform.isAndroid) {
          final androidInfo = await DeviceInfoPlugin().androidInfo;
          status = androidInfo.version.sdkInt >= 33
              ? await Permission.photos.status
              : await Permission.storage.status;
        } else {
          status = await Permission.photos.status;
        }
      }

      if (status.isGranted) {
        final XFile? pickedFile = await _picker.pickImage(source: source);
        if (pickedFile != null) {
          setState(() {
            _image = File(pickedFile.path);
            _isImageError = false;
          });
        }
        return;
      }

      if (status.isPermanentlyDenied) {
        _showSettingsDialog(source);
        return;
      }

      bool isDeniedOnce = source == ImageSource.camera
          ? _cameraPermissionDeniedOnce
          : _galleryPermissionDeniedOnce;

      if (isDeniedOnce) {
        _showSettingsDialog(source);
        return;
      }

      if (source == ImageSource.camera) {
        status = await Permission.camera.request();
      } else {
        if (Platform.isAndroid) {
          final androidInfo = await DeviceInfoPlugin().androidInfo;
          if (androidInfo.version.sdkInt >= 33) {
            status = await Permission.photos.request();
          } else {
            status = await Permission.storage.request();
          }
        } else {
          status = await Permission.photos.status;
        }
      }

      if (status.isDenied) {
        setState(() {
          if (source == ImageSource.camera) {
            _cameraPermissionDeniedOnce = true;
          } else {
            _galleryPermissionDeniedOnce = true;
          }
        });
        return;
      }

      if (status.isGranted) {
        final XFile? pickedFile = await _picker.pickImage(source: source);
        if (pickedFile != null) {
          setState(() {
            _image = File(pickedFile.path);
            _isImageError = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image uploaded successfully')),
          );
        }
      }
    } catch (e) {
      _showErrorDialog('Access error: ${e.toString()}');
    }
  }

  // Get current location
  Future<void> _getCurrentLocation() async {
    try {
      PermissionStatus locationStatus = await Permission.location.status;

      if (locationStatus.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        _updateLocation(LatLng(position.latitude, position.longitude));
        return;
      }

      if (locationStatus.isPermanentlyDenied) {
        _showLocationSettingsDialog();
        return;
      }

      if (_locationPermissionDeniedOnce) {
        _showLocationSettingsDialog();
        return;
      }

      locationStatus = await Permission.location.request();

      if (locationStatus.isDenied) {
        setState(() {
          _locationPermissionDeniedOnce = true;
        });
        return;
      }

      if (locationStatus.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        _updateLocation(LatLng(position.latitude, position.longitude));
      }
    } catch (e) {
      _showErrorDialog('Location error: ${e.toString()}');
    }
  }

  // Search address
  Future<void> _searchAddress(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        LatLng newLocation =
            LatLng(locations.first.latitude, locations.first.longitude);
        _updateLocation(newLocation);
      } else {
        _showErrorDialog('No location found for the provided address');
      }
    } catch (e) {
      _showErrorDialog('Search error: ${e.toString()}');
    }
  }

  Future<void> _updateLocation(LatLng location) async {
    setState(() {
      _selectedLocation = location;
      _isLocationError = false;
    });

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String formattedAddress =
            "${place.street}, ${place.locality}, ${place.country}";

        setState(() {
          _humanReadableAddress = formattedAddress;
          _locationController.text = formattedAddress;
        });
      }
    } catch (e) {
      _humanReadableAddress =
          'Lat: ${location.latitude}, Long: ${location.longitude}';
      _locationController.text = _humanReadableAddress!;
    }
  }

  void _showLocationSelectionDialog() async {
    final LatLng defaultLocation =
        LatLng(19.0760, 72.8777); // Mumbai as default

    final LatLng? selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MapScreen(
          initialLocation:
              _selectedLocation != null ? _selectedLocation! : defaultLocation,
        ),
      ),
    );

    if (selectedLocation != null) {
      _updateLocation(selectedLocation);
    }
  }

  // Settings dialog for permissions
  void _showSettingsDialog(ImageSource source) {
    final permissionType = source == ImageSource.camera
        ? "Camera"
        : Platform.isAndroid
            ? "Storage"
            : "Photos";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          '$permissionType Permission Required',
          style: const TextStyle(
            color: Color.fromARGB(255, 14, 66, 170),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'You have permanently denied access. Please allow $permissionType access to continue. Please enable it in app settings.',
          style: const TextStyle(color: Color.fromARGB(255, 14, 66, 170)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
              await Future.delayed(const Duration(seconds: 1));
              if (context.mounted) {
                _getImage(source);
              }
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  // Location settings dialog
  void _showLocationSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Location Permission Required',
          style: TextStyle(
            color: Color.fromARGB(255, 14, 66, 170),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'You need to allow location access to share your location. Please enable it in app settings.',
          style: TextStyle(color: Color.fromARGB(255, 14, 66, 170)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
              await Future.delayed(const Duration(seconds: 1));
              if (context.mounted) {
                _getCurrentLocation();
              }
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  // Error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Error',
          style: TextStyle(
            color: Color.fromARGB(255, 14, 66, 170),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Color.fromARGB(255, 14, 66, 170)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Submit complaint
  Future<void> _submitComplaint() async {
    setState(() {
      _submissionAttempted = true;
      _isImageError = _image == null;
      _isLocationError = _selectedLocation == null;
      _isDescriptionError = _descriptionController.text.trim().isEmpty;
    });

    if (_isImageError || _isLocationError || _isDescriptionError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final uri = Uri.parse(
          '${AppConfig.apiBaseUrl}/complaints'); // Change to your actual backend URL
      final request = http.MultipartRequest('POST', uri);

      // Headers (assuming you have token based auth)
      request.headers['Authorization'] =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY4MTExNjRjN2VlZDZkZmRlNTlhMWYwMCIsImlhdCI6MTc0Njg2ODAxNiwiZXhwIjoxNzQ2ODcxNjE2fQ.XatQQ0Is5kIyoDLq1oGhcdcMG2P3J11fmpO3tPhzQF4'; // Replace with actual token

      // Add fields
      request.fields['complaintType'] = _selectedCategory;
      request.fields['description'] = _descriptionController.text.trim();
      request.fields['latitude'] = _selectedLocation!.latitude.toString();
      request.fields['longitude'] = _selectedLocation!.longitude.toString();
      request.fields['address'] = _humanReadableAddress ?? "";

      // Add image file
      if (_image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            _image!.path,
          ),
        );
      }

      // Send request
      final response = await request.send();

      // Handle response
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Complaint submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear fields
        setState(() {
          _descriptionController.clear();
          _locationController.clear();
          _image = null;
          _selectedLocation = null;
          _humanReadableAddress = null;
          _submissionAttempted = false;
        });
      } else {
        final responseBody = await response.stream.bytesToString();
        final errorData = jsonDecode(responseBody);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorData['error'] is List
                  ? (errorData['error'] as List).join(', ')
                  : (errorData['error'] ?? 'Failed to submit complaint'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting complaint: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildPhotoContainer() {
    return Container(
      height: 100,
      width: 120,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _submissionAttempted && _isImageError
              ? Colors.red
              : Colors.grey.shade300,
          width: _submissionAttempted && _isImageError ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(3, 3),
            blurRadius: 5,
          ),
        ],
      ),
      child: Stack(
        children: [
          _image != null
              ? InkWell(
                  onTap: () => _showImageOptions(context),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _image!,
                      width: double.infinity,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : InkWell(
                  onTap: () => _showImageSourceActionSheet(context),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.photo,
                          size: 40,
                          color: Colors.grey,
                        ),
                        if (_submissionAttempted && _isImageError)
                          const Text(
                            'Required',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
          if (_image != null)
            Positioned(
              top: 5,
              right: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Uploaded',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showImageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
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
                  'Replace Image',
                  style: TextStyle(
                    color: Color.fromARGB(255, 14, 66, 170),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _showImageSourceActionSheet(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                title: const Text(
                  'Remove Image',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _image = null;
                    if (_submissionAttempted) {
                      _isImageError = true;
                    }
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Image removed')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 255, 215, 140),
                  Colors.white,
                  Color.fromARGB(255, 170, 255, 173),
                ],
                stops: [0.0, 0.4, 0.8],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildCategorySection(),
                    const SizedBox(height: 20),
                    _buildDescriptionSection(),
                    const SizedBox(height: 20),
                    _buildPhotoAndLocationSection(),
                    const SizedBox(height: 20),
                    _buildLocationField(),
                    const SizedBox(height: 20),
                    _buildSubmitButton(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: Container(
        width: 130,
        height: 55,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 254, 232, 179),
          borderRadius: BorderRadius.circular(20), // Rounded edges
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // Shadow color with opacity
              offset: const Offset(
                  5, 5), // Shadow offset (light coming from top left)
              blurRadius: 10, // Blur radius of the shadow
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () async {
            _submitComplaint();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors
                .transparent, // Make the ElevatedButton background transparent
            shadowColor: Colors.transparent, // Remove default shadow
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
    );
  }

  // Drawer
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
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Dashboard()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.edit,
                      color: Color.fromARGB(255, 14, 66, 170),
                    ),
                    title: const Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Color.fromARGB(255, 14, 66, 170),
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
                          // Change language to English
                          // You'll need to implement language change functionality here
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
                          // Change language to Hindi
                          // You'll need to implement language change functionality here
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
                          // Change language to Marathi
                          // You'll need to implement language change functionality here
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
                      // Navigate to notifications page
                      Navigator.pop(context);
                      // Add your navigation code here
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
                      // Implement rating functionality
                      Navigator.pop(context);
                      // Consider using a package like url_launcher to open app store
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
                      // Implement logout functionality
                      Navigator.pop(context);
                      // Add your logout code here
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

  // Header
  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(
            Icons.menu,
            color: Color.fromARGB(255, 0, 0, 0),
            size: 30,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        const Spacer(),
        const Text(
          'Jan Suvidha',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 14, 66, 170),
          ),
        ),
        const Spacer(),
      ],
    );
  }

  // Category dropdown
  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Category',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
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
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCategory,
              icon: const Icon(Icons.keyboard_arrow_down),
              iconSize: 24,
              elevation: 16,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
              items: <String>[
                'Road Maintenance',
                'Water Supply',
                'Electricity',
                'Garbage Collection',
                'Others'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  // Description field
  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            requiredIndicator(),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _submissionAttempted && _isDescriptionError
                  ? Colors.red
                  : Colors.grey.shade300,
              width: _submissionAttempted && _isDescriptionError ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: TextField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "Describe your complaint here...",
              contentPadding: EdgeInsets.all(12),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  // Photo and location section
  Widget _buildPhotoAndLocationSection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Photo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  requiredIndicator(),
                ],
              ),
              const SizedBox(height: 6),
              _buildPhotoContainer(),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Select Location',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  requiredIndicator(),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                height: 100,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _submissionAttempted && _isLocationError
                        ? Colors.red
                        : Colors.grey.shade300,
                    width: _submissionAttempted && _isLocationError ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      offset: const Offset(3, 3),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: _showLocationSelectionDialog,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 40,
                          color: Colors.grey,
                        ),
                        if (_submissionAttempted && _isLocationError)
                          const Text(
                            'Required',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Location field
  Widget _buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Location',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            requiredIndicator(),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _submissionAttempted && _isLocationError
                  ? Colors.red
                  : Colors.grey.shade300,
              width: _submissionAttempted && _isLocationError ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Text(
            _humanReadableAddress ?? "No location selected",
            style: TextStyle(
              fontSize: 14, // Reduced size
              color:
                  _humanReadableAddress != null ? Colors.black87 : Colors.grey,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
