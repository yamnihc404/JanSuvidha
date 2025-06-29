import 'package:flutter/material.dart';
import './admin_widgets/logoutdialog.dart';
import './admin_widgets/statuschange.dart';
import '../config/appconfig.dart';
import '../config/auth_service.dart';
import 'contact.dart';
import 'myaccount.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Complaint {
  final String id;
  final String title;
  final String location;
  final DateTime date;
  final String status; // "Pending", "In Progress", "Resolved"
  final String category;
  final String description; // Added description field
  final String imageUrl;

  Complaint({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.status,
    required this.category,
    required this.description,
    required this.imageUrl,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    print('Processing complaint: ${json['_id']}');

    String locationAddress = 'Unknown Location';
    if (json['location'] != null) {
      if (json['location'] is Map && json['location']['address'] != null) {
        locationAddress = json['location']['address'].toString();
      }
    }

    DateTime dateTime;
    try {
      dateTime = json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now();
    } catch (e) {
      print("Date parsing failed for ID ${json['_id']}: $e");
      dateTime = DateTime.now();
    }

    String imageUrl = '';
    if (json['image'] != null) {
      if (json['image'].toString().startsWith('/')) {
        imageUrl = '${AppConfig.apiBaseUrl}${json['image']}';
      } else {
        imageUrl = json['image'].toString();
      }
    }

    return Complaint(
      id: json['_id']?.toString() ?? '',
      title: json['shortDescription']?.toString() ?? 'Untitled Complaint',
      location: locationAddress,
      date: dateTime,
      status: json['status']?.toString() ?? 'Pending',
      category: json['complaintType']?.toString() ?? 'Unknown',
      description: json['description']?.toString() ?? 'No description provided',
      imageUrl: imageUrl, // Add the image URL
    );
  }
}

class InquiryPage extends StatefulWidget {
  const InquiryPage({super.key});

  @override
  _InquiryPageState createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  List<Complaint> complaints = [];
  bool isLoading = true;

  List<Complaint> filteredComplaints = [];
  String currentFilter = 'All';
  String searchQuery = '';
  String selectedCategory = 'All Categories';
  DateTime? startDate;
  DateTime? endDate;
  bool isFilterExpanded = false;

  @override
  void initState() {
    super.initState();
    fetchComplaints();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchComplaints() async {
    setState(() {
      isLoading = true;
    });

    try {
      final appConfig = AuthService();
      final token = await appConfig.getAccessToken();

      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/complaints/department-complaints'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true && data['data'] != null) {
          final complaintsData = data['data'];

          // Improved processing to handle potential errors
          List<Complaint> loadedComplaints = [];
          for (var complaintData in complaintsData) {
            try {
              loadedComplaints.add(Complaint.fromJson(complaintData));
            } catch (e) {
              print('Error processing complaint: $e');
              // Continue with other complaints even if one fails
            }
          }

          setState(() {
            complaints = loadedComplaints;
            // Apply filters after loading
            applyFilters();
            isLoading = false;
          });
        } else {
          setState(() {
            complaints = [];
            filteredComplaints = [];
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed to load complaints: ${response.body}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching complaints: $e');
    }
  }

  void applyFilters() {
    setState(() {
      filteredComplaints = complaints.where((complaint) {
        // Status filter
        if (currentFilter != 'All' && complaint.status != currentFilter) {
          return false;
        }

        // Text search filter - improved to handle case insensitivity more efficiently
        if (searchQuery.isNotEmpty) {
          final lowerQuery = searchQuery.toLowerCase();
          final titleMatch = complaint.title.toLowerCase().contains(
                lowerQuery,
              );
          final locationMatch = complaint.location.toLowerCase().contains(
                lowerQuery,
              );

          if (!titleMatch && !locationMatch) {
            return false;
          }
        }

        // Category filter - optimized to handle case sensitivity properly
        if (selectedCategory != 'All Categories' &&
            complaint.category.toLowerCase() !=
                selectedCategory.toLowerCase()) {
          return false;
        }

        // Date range filter - improved with proper date comparison
        final complaintDate = DateTime(
          complaint.date.year,
          complaint.date.month,
          complaint.date.day,
        );

        if (startDate != null) {
          final startDateNormalized = DateTime(
            startDate!.year,
            startDate!.month,
            startDate!.day,
          );

          if (complaintDate.isBefore(startDateNormalized)) {
            return false;
          }
        }

        if (endDate != null) {
          final endDateNormalized = DateTime(
            endDate!.year,
            endDate!.month,
            endDate!.day,
            23,
            59,
            59, // End of day
          );

          if (complaintDate.isAfter(endDateNormalized)) {
            return false;
          }
        }

        return true;
      }).toList();
    });
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.amber;
      case 'In Progress':
        return Colors.blue;
      case 'Resolved':
        return Colors.green;
      case 'Dispute':
        return const Color.fromARGB(255, 255, 99, 87);
      default:
        return Colors.grey;
    }
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

  Widget _buildFilterOption(String filter) {
    bool isSelected = currentFilter == filter;
    return InkWell(
      onTap: () {
        setState(() {
          currentFilter = filter;
          applyFilters();
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          filter,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  void _showComplaintDetails(BuildContext context, Complaint complaint) async {
    final shouldRefresh = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => ComplaintDetailPage(complaint: complaint),
      ),
    );

    if (shouldRefresh == true) {
      fetchComplaints();
    }
  }

  Widget _buildDrawer(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 350;
    final double drawerFontSize = isSmallScreen ? 13 : 19;

    // Make drawer width responsive
    final double drawerWidth =
        isSmallScreen ? screenSize.width * 0.75 : screenSize.width * 0.85;

    return SizedBox(
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
                    (isSmallScreen ? 8 : 15),
              ),
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
                            builder: (context) => const Myacc(),
                          ),
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
                            builder: (context) => const Contact(),
                          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 215, 140), // Lighter saffron
              Colors.white,
              Color.fromARGB(255, 170, 255, 173), // Light green
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App logo - centered and changed to blue
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 16.0),
                    child: const Center(
                      child: Text(
                        'Jan Suvidha',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 14, 66, 170),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      '',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search),
                        // Clear button that appears only when there's text
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    searchQuery = '';
                                    applyFilters();
                                  });
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                          applyFilters();
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildFilterOption('All'),
                                SizedBox(width: 8),
                                _buildFilterOption('Pending'),
                                SizedBox(width: 8),
                                _buildFilterOption('In Progress'),
                                SizedBox(width: 8),
                                _buildFilterOption('Resolved'),
                                SizedBox(width: 8),
                                _buildFilterOption('Dispute'),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isFilterExpanded
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: Colors.black54,
                          ),
                          onPressed: () {
                            setState(() {
                              isFilterExpanded = !isFilterExpanded;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  if (isFilterExpanded)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Filter Complaints',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 254, 232, 179),
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
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Category',
                                border: InputBorder.none,
                                labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 14, 66, 170),
                                  fontSize: 16,
                                ),
                              ),
                              value: selectedCategory,
                              items: [
                                'All Categories',
                                'Water Supply',
                                'Road Maintenance',
                              ].map((category) {
                                return DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    selectedCategory = value;
                                    applyFilters();
                                  });
                                }
                              },
                              dropdownColor: Color.fromARGB(255, 254, 232, 179),
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: startDate ?? DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime.now(),
                                    );
                                    if (date != null) {
                                      setState(() {
                                        startDate = date;
                                        applyFilters();
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 254, 232, 179),
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
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          startDate != null
                                              ? DateFormat(
                                                  'MMM d, yyyy',
                                                ).format(startDate!)
                                              : 'From Date',
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                              255,
                                              14,
                                              66,
                                              170,
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.calendar_today,
                                          color: Color.fromARGB(
                                            255,
                                            14,
                                            66,
                                            170,
                                          ),
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: endDate ?? DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime.now(),
                                    );
                                    if (date != null) {
                                      setState(() {
                                        endDate = date;
                                        applyFilters();
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 254, 232, 179),
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
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          endDate != null
                                              ? DateFormat(
                                                  'MMM d, yyyy',
                                                ).format(endDate!)
                                              : 'To Date',
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                              255,
                                              14,
                                              66,
                                              170,
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.calendar_today,
                                          color: Color.fromARGB(
                                            255,
                                            14,
                                            66,
                                            170,
                                          ),
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      14,
                                      66,
                                      170,
                                    ),
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: applyFilters,
                                  child: Text('Apply Filters'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color.fromARGB(
                                      255,
                                      14,
                                      66,
                                      170,
                                    ),
                                    side: const BorderSide(
                                      color: Color.fromARGB(255, 14, 66, 170),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      currentFilter = 'All';
                                      searchQuery = '';
                                      _searchController.clear();
                                      selectedCategory = 'All Categories';
                                      startDate = null;
                                      endDate = null;
                                      filteredComplaints = List.from(
                                        complaints,
                                      );
                                    });
                                  },
                                  child: Text('Reset Filters'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    // This is crucial - wrap ListView in Expanded
                    child: RefreshIndicator(
                      onRefresh: fetchComplaints,
                      child: isLoading
                          ? Center(child: CircularProgressIndicator())
                          : filteredComplaints.isEmpty
                              ? Center(
                                  child: Text(
                                    'No complaints found',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  shrinkWrap:
                                      true, // Ensure it takes only needed space
                                  physics:
                                      AlwaysScrollableScrollPhysics(), // Allow scrolling
                                  itemCount: filteredComplaints.length,
                                  itemBuilder: (context, index) {
                                    final complaint = filteredComplaints[index];
                                    return GestureDetector(
                                      onTap: () => _showComplaintDetails(
                                        context,
                                        complaint,
                                      ),
                                      child: Card(
                                        elevation: 2,
                                        margin: EdgeInsets.only(bottom: 12),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      complaint.title,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 10,
                                                      vertical: 4,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: getStatusColor(
                                                        complaint.status,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        12,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      complaint.status,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            complaint.status ==
                                                                    'Pending'
                                                                ? Colors.black87
                                                                : Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                DateFormat(
                                                  'MMM d, yyyy',
                                                ).format(complaint.date),
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                complaint.location,
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 16,
                left: 0,
                child: IconButton(
                  icon: const Icon(Icons.menu, size: 30, color: Colors.black),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
