import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../config/appconfig.dart';
import '../../config/auth_service.dart';

class NotificationDialog extends StatefulWidget {
  final List<dynamic> notifications;
  final bool loading;
  final VoidCallback onActionPerformed;

  const NotificationDialog({
    super.key,
    required this.notifications,
    required this.loading,
    required this.onActionPerformed,
  });

  @override
  _NotificationDialogState createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog> {
  late List<dynamic> _currentNotifications;
  final GlobalKey<ScaffoldMessengerState> _dialogScaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _currentNotifications = widget.notifications;
  }

  Future<void> _handleResponse(String notificationId, bool confirm) async {
    try {
      final authService = AuthService();
      final token = await authService.getAccessToken();

      final endpoint = confirm ? 'confirm' : 'reject';
      final response = await http.put(
        Uri.parse(
            '${AppConfig.apiBaseUrl}/notifications/$notificationId/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Show snackbar with overlay
        _showSnackbarOverlay(
          confirm
              ? 'Complaint confirmed as resolved'
              : 'Complaint marked as disputed',
          isSuccess: true,
        );

        setState(() {
          _currentNotifications = _currentNotifications.map((n) {
            if (n['_id'] == notificationId) {
              return {...n, 'actionRequired': false};
            }
            return n;
          }).toList();
        });
        widget.onActionPerformed();
      }
    } catch (e) {
      _showSnackbarOverlay('Failed to update status', isSuccess: false);
    }
  }

  // Function to show snackbar as an overlay above the dialog
  void _showSnackbarOverlay(String message, {bool isSuccess = true}) {
    // Remove any existing overlays first
    OverlayState? overlayState = Overlay.of(context);

    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.9,
        left: MediaQuery.of(context).size.width * 0.05,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSuccess ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  isSuccess ? Icons.check_circle : Icons.error,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);

    // Remove the overlay after a delay
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  Future<void> _markSingleAsRead(String notificationId) async {
    try {
      final authService = AuthService();
      final token = await authService.getAccessToken();

      await http.put(
        Uri.parse(
            '${AppConfig.apiBaseUrl}/notifications/$notificationId/mark-read'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      setState(() {
        _currentNotifications = _currentNotifications
            .where((n) => n['_id'] != notificationId)
            .toList();
      });

      widget.onActionPerformed();
    } catch (e) {
      print('Error marking notification as read: $e');
      _showSnackbarOverlay('Failed to mark as read', isSuccess: false);
    }
  }

  Widget _buildNotificationItem(BuildContext context, dynamic notification) {
    final isActionRequired = notification['actionRequired'] == true;
    final isUnread = !notification['read'];
    final userAction = notification['userAction'];
    List<Widget> actionRows = [];

    // Get screen width to adjust layouts
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen =
        screenWidth < 360; // Threshold for extra small screens like Nexus S

    if (userAction != null) {
      actionRows.add(
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                userAction == 'confirmed' ? Icons.check_circle : Icons.warning,
                color: userAction == 'confirmed' ? Colors.green : Colors.orange,
                size: 16,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  userAction == 'confirmed'
                      ? 'You confirmed this resolution'
                      : 'You disputed this resolution',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (isActionRequired) {
      // Add Confirm/Reject buttons - adapt for small screens
      actionRows.add(
        isSmallScreen
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      icon: const Icon(Icons.close, size: 16),
                      label:
                          const Text('Reject', style: TextStyle(fontSize: 13)),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      onPressed: () async =>
                          await _handleResponse(notification['_id'], false),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      icon: const Icon(Icons.check, size: 16),
                      label:
                          const Text('Confirm', style: TextStyle(fontSize: 13)),
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.green),
                      onPressed: () async =>
                          await _handleResponse(notification['_id'], true),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Reject'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: () async =>
                        await _handleResponse(notification['_id'], false),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Confirm'),
                    style: TextButton.styleFrom(foregroundColor: Colors.green),
                    onPressed: () async =>
                        await _handleResponse(notification['_id'], true),
                  ),
                ],
              ),
      );
    }

    if (isUnread) {
      // Add Mark Read button
      actionRows.add(
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.mark_email_read, size: 16),
                label: Text(
                  'Mark as Read',
                  style: TextStyle(fontSize: isSmallScreen ? 13 : 14),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                  padding: isSmallScreen
                      ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
                      : null,
                ),
                onPressed: () => _markSingleAsRead(notification['_id']),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      margin:
          EdgeInsets.symmetric(vertical: 4, horizontal: isSmallScreen ? 4 : 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isActionRequired ? Icons.warning_amber : Icons.notifications,
                  color: isActionRequired ? Colors.orange : Colors.blue,
                  size: isSmallScreen ? 20 : 24,
                ),
                SizedBox(width: isSmallScreen ? 8 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification['message'],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: isSmallScreen ? 13 : 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('MMM dd, yyyy - hh:mm a')
                            .format(DateTime.parse(notification['createdAt'])),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: isSmallScreen ? 11 : 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (actionRows.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: isSmallScreen ? 8 : 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: actionRows,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    // Calculate adaptive dialog width based on screen size
    final dialogWidth = screenSize.width > 600
        ? screenSize.width * 0.8
        : screenSize.width * 0.95;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.05,
        vertical: screenSize.height * 0.03,
      ),
      child: Container(
        width: dialogWidth,
        constraints: BoxConstraints(
          maxHeight: screenSize.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: isSmallScreen ? 16.0 : 25.0,
                horizontal: isSmallScreen ? 16.0 : 25.0,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.notifications_active,
                    color: Colors.blue,
                    size: isSmallScreen ? 20 : 24,
                  ),
                  SizedBox(width: isSmallScreen ? 10 : 20),
                  Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Flexible(
              child: widget.loading
                  ? const Center(child: CircularProgressIndicator())
                  : _currentNotifications.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('No new notifications',
                              style: TextStyle(color: Colors.grey)),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 12.0 : 20.0),
                          itemCount: _currentNotifications.length,
                          itemBuilder: (context, index) =>
                              _buildNotificationItem(
                                  context, _currentNotifications[index]),
                        ),
            ),
            Padding(
              padding: EdgeInsets.all(isSmallScreen ? 8.0 : 12.0),
              child: isSmallScreen
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () async {
                              // Mark all as read
                              final authService = AuthService();
                              final token = await authService.getAccessToken();
                              await http.put(
                                Uri.parse(
                                    '${AppConfig.apiBaseUrl}/notifications/mark-all-read'),
                                headers: {
                                  'Content-Type': 'application/json',
                                  'Authorization': 'Bearer $token',
                                },
                              );
                              widget.onActionPerformed();
                              setState(() => _currentNotifications = []);
                              _showSnackbarOverlay(
                                  'All notifications marked as read');
                            },
                            child: const Text('Mark All Read'),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {
                            // Mark all as read
                            final authService = AuthService();
                            final token = await authService.getAccessToken();
                            await http.put(
                              Uri.parse(
                                  '${AppConfig.apiBaseUrl}/notifications/mark-all-read'),
                              headers: {
                                'Content-Type': 'application/json',
                                'Authorization': 'Bearer $token',
                              },
                            );
                            widget.onActionPerformed();
                            setState(() => _currentNotifications = []);
                            _showSnackbarOverlay(
                                'All notifications marked as read');
                          },
                          child: const Text('Mark All Read'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
