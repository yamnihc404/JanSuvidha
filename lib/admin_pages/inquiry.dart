import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Admin_Dashboard.dart';
import 'myaccount.dart';
import 'Contact.dart';

// Data model for inquiries
class Complaint {
  final String id;
  final String title;
  final String location;
  final DateTime date;
  String status;
  final String category;
  final String description;

  Complaint({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.status,
    required this.category,
    required this.description,
  });
}

class InquiryPage extends StatefulWidget {
  const InquiryPage({Key? key}) : super(key: key);

  @override
  _InquiryPageState createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  // Filter options
  final List<String> statusOptions = ['All', 'Pending', 'In Progress', 'Resolved', 'Dispute'];
  String currentFilter = 'All';
  final List<String> categoryOptions = ['All Categories', 'Water Supply', 'Road Maintenance', 'Power Outage', 'Waste Management'];
  String selectedCategory = 'All Categories';
  DateTime? startDate;
  DateTime? endDate;
  bool isFilterExpanded = false;

  // Hard-coded sample data
  late List<Complaint> inquiries;
  late List<Complaint> filteredInquiries;

  // Color constants
  final Color primaryBlue = const Color.fromARGB(255, 14, 66, 170);
  final Color saffron = const Color.fromARGB(255, 255, 215, 140);
  final Color lightGreen = const Color.fromARGB(255, 170, 255, 173);

  @override
  void initState() {
    super.initState();
    inquiries = [
      Complaint(
        id: '1',
        title: 'Water leak on Main St',
        location: 'Sector 5',
        date: DateTime.now().subtract(Duration(days: 2)),
        status: 'Pending',
        category: 'Water Supply',
        description: 'There is a water leakage near the main crossroad.',
      ),
      Complaint(
        id: '2',
        title: 'Potholes on road',
        location: 'Sector 3',
        date: DateTime.now().subtract(Duration(days: 5)),
        status: 'Resolved',
        category: 'Road Maintenance',
        description: 'Multiple potholes causing traffic issues.',
      ),
      Complaint(
        id: '3',
        title: 'Power outage',
        location: 'Sector 1',
        date: DateTime.now().subtract(Duration(days: 1)),
        status: 'In Progress',
        category: 'Power Outage',
        description: 'Electricity has been down since morning.',
      ),
    ];
    filteredInquiries = List.from(inquiries);
  }

  void applyFilters() {
    setState(() {
      filteredInquiries = inquiries.where((c) {
        // Status filter
        if (currentFilter != 'All' && c.status != currentFilter) return false;
        // Text search
        if (_searchController.text.isNotEmpty) {
          final query = _searchController.text.toLowerCase();
          if (!c.title.toLowerCase().contains(query) && !c.location.toLowerCase().contains(query)) {
            return false;
          }
        }
        // Category filter
        if (selectedCategory != 'All Categories' && c.category != selectedCategory) return false;
        // Date range filters
        if (startDate != null && c.date.isBefore(startDate!)) return false;
        if (endDate != null && c.date.isAfter(endDate!)) return false;
        return true;
      }).toList();
    });
  }

  void resetFilters() {
    setState(() {
      currentFilter = 'All';
      _searchController.clear();
      selectedCategory = 'All Categories';
      startDate = null;
      endDate = null;
      filteredInquiries = List.from(inquiries);
    });
  }

  void _showInquiryDialog(Complaint c) {
    showDialog(
      context: context,
      builder: (_) {
        String tempStatus = c.status;
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 255, 228, 179),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(c.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${c.id}'),
                SizedBox(height: 8),
                Text('Location: ${c.location}'),
                SizedBox(height: 8),
                Text('Date: ${DateFormat('MMM d, yyyy').format(c.date)}'),
                SizedBox(height: 8),
                Text('Category: ${c.category}'),
                SizedBox(height: 8),
                Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(c.description),
                SizedBox(height: 16),
                Text('Change Status:', style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: tempStatus,
                  items: statusOptions
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        c.status = val;
                        applyFilters();
                      });
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Status updated to $val')));
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close', style: TextStyle(color: primaryBlue)),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
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
          color: isSelected ? primaryBlue : Colors.grey[200],
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

  Color getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.amber;
      case 'In Progress':
        return Colors.blue;
      case 'Resolved':
        return Colors.green;
      case 'Dispute':
        return Color.fromARGB(255, 255, 99, 87);
      default:
        return Colors.grey;
    }
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
                child: Center(
                  child: Text(
                    'Jan Suvidha',
                    style: TextStyle(
                      color: primaryBlue,
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
                      leading: Icon(Icons.home, color: primaryBlue),
                      title: Text(
                        'Home',
                        style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => AdminDashboard()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.edit, color: primaryBlue),
                      title: Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context); // Close the drawer first
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Myacc()),
                        );
                      },
                    ),
                    ExpansionTile(
                      leading: Icon(Icons.language, color: primaryBlue),
                      title: Text(
                        'Language Preference',
                        style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.only(left: 72),
                          title: Text('English', style: TextStyle(color: primaryBlue)),
                          onTap: () => Navigator.pop(context),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.only(left: 72),
                          title: Text('हिंदी', style: TextStyle(color: primaryBlue)),
                          onTap: () => Navigator.pop(context),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.only(left: 72),
                          title: Text('मराठी', style: TextStyle(color: primaryBlue)),
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    ListTile(
                      leading: Icon(Icons.notifications, color: primaryBlue),
                      title: Text(
                        'Notifications',
                        style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone, color: primaryBlue),
                      title: Text(
                        'Contact Us',
                        style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                       onTap: () {
    Navigator.pop(context); // Close the drawer first
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Contact()),
    );
  },
                    ),
                    ListTile(
                      leading: Icon(Icons.star, color: primaryBlue),
                      title: Text(
                        'Rate Us',
                        style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                    ListTile(
                      leading: Icon(Icons.logout, color: primaryBlue),
                      title: Text(
                        'Log Out',
                        style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () => Navigator.pop(context),
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
            colors: [saffron, Colors.white, lightGreen],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App logo - centered and in blue
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Center(
                      child: Text(
                        'Jan Suvidha',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
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
                      onChanged: (_) => applyFilters(),
                    ),
                  ),
                  SizedBox(height: 8),
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
                                  color: primaryBlue,
                                  fontSize: 16,
                                ),
                              ),
                              value: selectedCategory,
                              items: categoryOptions.map((category) {
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
                                            color: primaryBlue,
                                          ),
                                        ),
                                        Icon(
                                          Icons.calendar_today,
                                          color: primaryBlue,
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
                                            color: primaryBlue,
                                          ),
                                        ),
                                        Icon(
                                          Icons.calendar_today,
                                          color: primaryBlue,
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
                                    backgroundColor: primaryBlue,
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
                                    foregroundColor: primaryBlue,
                                    side: BorderSide(color: primaryBlue),
                                  ),
                                  onPressed: resetFilters,
                                  child: Text('Reset Filters'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        // Simulate refresh by showing some delay
                        await Future.delayed(Duration(milliseconds: 800));
                        applyFilters();
                      },
                      child: filteredInquiries.isEmpty
                          ? Center(
                              child: Text(
                                'No inquiries found',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[600]),
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              itemCount: filteredInquiries.length,
                              itemBuilder: (context, index) {
                                final c = filteredInquiries[index];
                                return GestureDetector(
                                  onTap: () => _showInquiryDialog(c),
                                  child: Card(
                                    elevation: 2,
                                    margin: EdgeInsets.only(bottom: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  c.title,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: getStatusColor(c.status),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  c.status,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: c.status == 'Pending'
                                                        ? Colors.black87
                                                        : Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            DateFormat('MMM d, yyyy').format(c.date),
                                            style: TextStyle(color: Colors.grey[600]),
                                          ),
                                          SizedBox(height: 4),
                                          Text(c.location, style: TextStyle(fontSize: 14)),
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