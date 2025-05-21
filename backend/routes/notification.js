const { Router } = require('express');
const NotificationRouter = Router();
const { Notification } = require('../db');
const { verifyToken } = require("./middleware");
const {Complaint} = require("../db");
const { Console } = require('console');

NotificationRouter.get('/', verifyToken, async (req, res) => {
  try {
    const notifications = await Notification.find({
      userId: req.user.id,
      read: false
    }).sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      data: notifications
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Failed to fetch notifications' });
  }
});

NotificationRouter.put('/mark-all-read', verifyToken, async (req, res) => {
  try {
    await Notification.updateMany(
      { userId: req.user.id, read: false },
      { $set: { read: true } }
    );
    res.status(200).json({ success: true, message: 'All notifications marked as read' });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Failed to update notifications' });
  }
});

NotificationRouter.put('/:id/mark-read', verifyToken, async (req, res) => {
  try {
    console.log('Read');
    await Notification.findByIdAndUpdate(req.params.id, { read: true });
    res.status(200).json({ success: true, message: 'Notification marked as read' });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Failed to mark notification as read' });
  }
});

NotificationRouter.put('/:id/confirm', verifyToken, async (req, res) => {
  try {
   
    const notification = await Notification.findById(req.params.id);
    console.log('confrim');
    await Complaint.findByIdAndUpdate(notification.complaintId, { status: 'Resolved' });
    
    await Notification.findByIdAndUpdate(req.params.id, {
      userAction: 'confirmed',
      actionRequired: false
    });

    res.status(200).json({ success: true, message: 'Complaint confirmed as resolved' });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Confirmation failed' });
  }
});

NotificationRouter.put('/:id/reject', verifyToken, async (req, res) => {
  try {
    
    const notification = await Notification.findById(req.params.id);
   
    await Complaint.findByIdAndUpdate(notification.complaintId, { status: 'Dispute' });
    
    await Notification.findByIdAndUpdate(req.params.id, {
      userAction: 'disputed',
      actionRequired: false
    });

    res.status(200).json({ success: true, message: 'Complaint marked as disputed' });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Rejection failed' });
  }
});

module.exports = { NotificationRouter };