import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'contact.dart';
import 'myaccount.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/appconfig.dart';
import '../config/auth_service.dart';
import 'user_widgets/map_screen.dart';
import 'package:jansuvidha/user_pages/user_widgets/logout_dialog.dart';

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
    _selectedLocation = const LatLng(19.0760, 72.8777);
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
        // Find the most detailed placemark
        Placemark detailedPlace = placemarks.firstWhere(
          (place) => place.street != null && place.locality != null,
          orElse: () => placemarks.first,
        );

        String formattedAddress = "${detailedPlace.street ?? ''}, "
            "${detailedPlace.subLocality ?? ''}, "
            "${detailedPlace.locality ?? ''}, "
            "${detailedPlace.administrativeArea ?? ''}, "
            "${detailedPlace.country ?? ''}";

        // Remove any extra commas or spaces
        formattedAddress =
            formattedAddress.replaceAll(RegExp(r'\s+,|,\s+'), ', ').trim();
        if (formattedAddress.endsWith(',')) {
          formattedAddress =
              formattedAddress.substring(0, formattedAddress.length - 1);
        }

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
    const LatLng defaultLocation =
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
      final authservice = AuthService();
      final token = await authservice.getAccessToken();
      // Headers (assuming you have token based auth)
      request.headers['Authorization'] = 'Bearer $token';
      // Replace with actual token

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
      drawer: _buildDrawer(context),
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
          onPressed: () async {
            _submitComplaint();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
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

  // Drawer
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
                      () {
                        Navigator.of(context).pop();

                        Navigator.pop(context);
                      },
                      drawerFontSize,
                      isSmallScreen,
                    ),
                    _buildDrawerItem(
                      context,
                      Icons.edit,
                      'Edit Profile',
                      () {
                        Navigator.pushReplacement(
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
                        Navigator.pushReplacement(
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

  // Category dropdown
  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
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
              items: <String>['Road Maintenance', 'Water Supply']
                  .map<DropdownMenuItem<String>>((String value) {
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
