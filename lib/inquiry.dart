import 'package:flutter/material.dart';
import 'widgets/common_widgets.dart';
import 'contact.dart';
import 'myaccount.dart';
import "dashboard.dart";
import 'package:intl/intl.dart';
import 'filecomplain.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config/app_config.dart';

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
        imageUrl = 'https://d8ae-103-185-109-76.ngrok-free.app${json['image']}';
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

class Inquiry extends StatefulWidget {
  const Inquiry({super.key});

  @override
  _InquiryState createState() => _InquiryState();
}

class _InquiryState extends State<Inquiry> {
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
      final appConfig = AppConfig();
      final token = await appConfig.getToken();

      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/complaints'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true && data['data'] != null) {
          final complaintsData = data['data'];

          setState(() {
            complaints = List<Complaint>.from(complaintsData
                .map((complaint) => Complaint.fromJson(complaint)));
            // ✅ Apply the filter immediately after refreshing:
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
        if (currentFilter != 'All' && complaint.status != currentFilter)
          return false;
        if (searchQuery.isNotEmpty &&
            !complaint.title
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) &&
            !complaint.location
                .toLowerCase()
                .contains(searchQuery.toLowerCase())) return false;
        if (selectedCategory != 'All Categories' &&
            complaint.category != selectedCategory) return false;
        if (startDate != null && complaint.date.isBefore(startDate!))
          return false;
        if (endDate != null &&
            complaint.date.isAfter(endDate!.add(Duration(days: 1))))
          return false;
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

  void _showComplaintPopup(BuildContext context, Complaint complaint) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Color.fromARGB(255, 255, 228, 179),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(complaint.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Display the actual image if available, otherwise show placeholder
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 210, 143),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: complaint.imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: FittedBox(
                          fit: BoxFit
                              .contain, // 🔥 This ensures the image fits without cropping
                          child: Image.network(
                            complaint.imageUrl,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              print("Error loading image: $error");
                              return Icon(Icons.image_not_supported,
                                  size: 50, color: Colors.white);
                            },
                          ),
                        ),
                      )
                    : Icon(Icons.image, size: 50, color: Colors.white),
              ),

              SizedBox(height: 12),
              Text('Status: ${complaint.status}'),
              Text("Category: ${complaint.category}"),
              Text("Location: ${complaint.location}"),
              Text("Date: ${DateFormat('MMM d, yyyy').format(complaint.date)}"),
              SizedBox(height: 12),
              Text("Description:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(complaint.description),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Close', style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
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
                              builder: (context) => const Dashboard()),
                        );
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
                          MaterialPageRoute(
                              builder: (context) => const Myacc()),
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Addcomplain()),
                        );
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
                        Navigator.pop(context);
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
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
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
                    child: Center(
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
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
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
                              decoration: InputDecoration(
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
                                'Power Outage',
                                'Waste Management'
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
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 12),
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
                                              ? DateFormat('MMM d, yyyy')
                                                  .format(startDate!)
                                              : 'From Date',
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 14, 66, 170),
                                          ),
                                        ),
                                        Icon(
                                          Icons.calendar_today,
                                          color:
                                              Color.fromARGB(255, 14, 66, 170),
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
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 12),
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
                                              ? DateFormat('MMM d, yyyy')
                                                  .format(endDate!)
                                              : 'To Date',
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 14, 66, 170),
                                          ),
                                        ),
                                        Icon(
                                          Icons.calendar_today,
                                          color:
                                              Color.fromARGB(255, 14, 66, 170),
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
                                    backgroundColor:
                                        Color.fromARGB(255, 14, 66, 170),
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: applyFilters,
                                  child: Text('Apply Filters'),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor:
                                        Color.fromARGB(255, 14, 66, 170),
                                    side: BorderSide(
                                        color:
                                            Color.fromARGB(255, 14, 66, 170)),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      currentFilter = 'All';
                                      searchQuery = '';
                                      _searchController.clear();
                                      selectedCategory = 'All Categories';
                                      startDate = null;
                                      endDate = null;
                                      filteredComplaints =
                                          List.from(complaints);
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
                                        fontSize: 16, color: Colors.grey[600]),
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
                                      onTap: () => _showComplaintPopup(
                                          context, complaint),
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
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: getStatusColor(
                                                          complaint.status),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
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
                                                  DateFormat('MMM d, yyyy')
                                                      .format(complaint.date),
                                                  style: TextStyle(
                                                      color: Colors.grey[600])),
                                              SizedBox(height: 4),
                                              Text(complaint.location,
                                                  style:
                                                      TextStyle(fontSize: 14)),
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
