import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../config/appconfig.dart';
import '../../config/auth_service.dart';
import '../admininquiry.dart';

class ComplaintDetailPage extends StatefulWidget {
  final Complaint complaint;

  const ComplaintDetailPage({super.key, required this.complaint});

  @override
  State<ComplaintDetailPage> createState() => _ComplaintDetailPageState();
}

class _ComplaintDetailPageState extends State<ComplaintDetailPage> {
  String? selectedStatus;
  final TextEditingController _remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.complaint.status;
  }

  Future<void> _updateStatus() async {
    if (selectedStatus == widget.complaint.status &&
        _remarksController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No changes detected')));
      return;
    }

    try {
      final appConfig = AuthService();
      final token = await appConfig.getAccessToken();

      final response = await http.put(
        Uri.parse('${AppConfig.apiBaseUrl}/complaints/update-status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'complaintId': widget.complaint.id,
          'status': selectedStatus,
          'remarks': _remarksController.text,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true); // Return refresh flag
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Update failed: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Widget _buildImagePreview() {
    return widget.complaint.imageUrl.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.complaint.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color.fromARGB(255, 255, 230, 160),
                child: const Icon(
                  Icons.broken_image,
                  size: 50,
                  color: Color.fromARGB(255, 14, 66, 170),
                ),
              ),
            ),
          )
        : Container(
            color: const Color.fromARGB(255, 255, 230, 160),
            child: const Icon(
              Icons.image,
              size: 50,
              color: Color.fromARGB(255, 14, 66, 170),
            ),
          );
  }

  void _showFullScreenImage(BuildContext context) {
    if (widget.complaint.imageUrl.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black.withOpacity(0.9),
        child: Stack(
          children: [
            InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 5.0,
              child: Center(
                child: Image.network(
                  widget.complaint.imageUrl,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Complaint Details',
          style: TextStyle(
            color: Color.fromARGB(255, 14, 66, 170),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 215, 140),
                Colors.white,
                Color.fromARGB(255, 170, 255, 173),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 215, 140),
              Colors.white,
              Color.fromARGB(255, 170, 255, 173),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Complaint Details Card
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 230, 160),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailSection('Title', widget.complaint.title),
                    _buildDetailSection('Category', widget.complaint.category),
                    _buildDetailSection('Location', widget.complaint.location),
                    _buildDetailSection(
                      'Date',
                      DateFormat('MMM d, yyyy').format(widget.complaint.date),
                    ),
                    _buildDetailSection('Status', widget.complaint.status),
                    _buildDetailSection(
                      'Description',
                      widget.complaint.description,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Image Container
              GestureDetector(
                onTap: () => _showFullScreenImage(context),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                    minHeight: 200,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _buildImagePreview(),
                ),
              ),
              const SizedBox(height: 20),

              // Update Section Card
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 230, 160),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Update Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 14, 66, 170),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      items: const [
                        'Pending',
                        'In Progress',
                        'Resolved',
                        'Dispute',
                      ]
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(
                                status,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 14, 66, 170),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedStatus = value),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 14, 66, 170),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 14, 66, 170),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _remarksController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Remarks',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 14, 66, 170),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 14, 66, 170),
                          ),
                        ),
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 14, 66, 170),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateStatus,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 14, 66, 170),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Update Status',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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

  Widget _buildDetailSection(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color.fromARGB(255, 14, 66, 170),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const Divider(
            color: Color.fromARGB(255, 14, 66, 170),
            height: 16,
            thickness: 0.5,
          ),
        ],
      ),
    );
  }
}
