const { Router } = require('express');
const ComplaintRouter = Router();
const {Complaint, Notification, adminModel} = require('../db');
const { z } = require('zod');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const jwt = require('jsonwebtoken');
const {verifyToken} = require("./middleware");


// Configure storage for multer
const storage = multer.diskStorage({
  destination: function(req, file, cb) {
    const dir = path.join(__dirname, '../uploads/complaints');
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }
    cb(null, dir);
  },
  filename: function(req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, uniqueSuffix + path.extname(file.originalname));
  }
});


// Configure upload
const upload = multer({
  storage: storage,
  limits: { fileSize: 5 * 1024 * 1024 }, // 5MB limit
  fileFilter: function(req, file, cb) {
    if (!file.originalname.match(/\.(jpg|jpeg|png|gif)$/)) {
      return cb(new Error('Only image files are allowed!'), false);
    }
    cb(null, true);
  }
});

// Define Zod schema for validation
const complaintSchema = z.object({
  complaintType: z.string().min(1, "Complaint type is required"),
  description: z.string().min(10, "Description must be at least 10 characters"),
  latitude: z.preprocess((val) => parseFloat(val), z.number({
    invalid_type_error: "Latitude must be a valid number",
  })),
  longitude: z.preprocess((val) => parseFloat(val), z.number({
    invalid_type_error: "Longitude must be a valid number",
  })),
  address: z.string().optional()
});

ComplaintRouter.post('/', verifyToken, upload.single('image'), async (req, res) => {
  try {

    const userId = req.user.id;
 
    if (!req.file) {
      return res.status(400).json({
        success: false,
        error: ['Image is required']
      });
    }

    // Validate body
    const validatedData = complaintSchema.parse(req.body);

    // Generate short description (first three words)
    const shortDescription = validatedData.description.split(' ').slice(0, 3).join(' ');

    const newComplaint = await Complaint.create({
      complaintType: validatedData.complaintType,
      description: validatedData.description,
      shortDescription: shortDescription, // <-- New field
      image: `/uploads/complaints/${req.file.filename}`,
      location: {
        type: 'Point',
        coordinates: [validatedData.longitude, validatedData.latitude],
        address: validatedData.address || null,
      },
      userId: userId,
      status: "Pending"
    });

    res.status(201).json({
      success: true,
      message: 'Complaint submitted successfully',
      data: {
        complaintId: newComplaint._id,
        status: newComplaint.status,
        shortDescription: newComplaint.shortDescription
      }
    });

  } catch (error) {
    console.error('Error creating complaint:', error);

    if (error instanceof z.ZodError) {
      return res.status(400).json({
        success: false,
        error: error.issues.map(issue => issue.message)
      });
    }

    res.status(500).json({
      success: false,
      message: 'Failed to submit complaint'
    });
  }
});


// Get all complaints for a user
ComplaintRouter.get('/', verifyToken, async function(req, res) {
  try {
   
    const userId = req.user.id;
    const complaints = await Complaint.find({ userId: userId }).sort({ createdAt: -1 });
    console.log(complaints);
    
    res.status(200).json({
      success: true,
      count: complaints.length,
      data: complaints
    });
  } catch (error) {
    console.log('Error fetching complaints:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch complaints'
    });
  }
});



ComplaintRouter.get('/counts',verifyToken, async (req, res) => {
  try {
    const userId = req.user.id;
    
    const totalComplaints = await Complaint.countDocuments({ userId: userId });

    const resolvedComplaints = await Complaint.countDocuments({ userId: userId, status: 'Resolved' });

    const disputes = await Complaint.countDocuments({ userId: userId, status: 'Dispute' });

    console.log(totalComplaints);
    res.status(200).json({
      success: true,
      data: {
        total: totalComplaints,
        resolved: resolvedComplaints,
        disputes: disputes,
      },
    });
  } catch (error) {
    console.error('Error fetching complaint counts:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch complaint counts',
    });
  }
});

ComplaintRouter.put('/update-status', verifyToken, async (req, res) => {
  try {
    const complaint = await Complaint.findById(req.body.complaintId);
    const newStatus = req.body.status;
    const remark = req.body.remark;

    if (complaint.status !== newStatus) {
      const message = newStatus === 'Resolved' 
        ? `Please confirm if your complaint "${complaint.shortDescription}" has been resolved.${remark}`
        : `Your complaint "${complaint.shortDescription}" status changed to ${newStatus}.${remark}`;

      const notification = new Notification({
        userId: complaint.userId,
        complaintId: complaint._id,
        message: message,
        actionRequired: newStatus === 'Resolved'
      });
      
      await notification.save();
    }

    complaint.status = newStatus;
    await complaint.save();

    res.status(200).json({ success: true, data: complaint });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Status update failed' });
  }
});


ComplaintRouter.get('/department-complaints', verifyToken, async (req, res) => {
  try {
    const adminId = req.user.id; // Set by verifyToken

    // 1. Get full admin record from DB
    const admin = await adminModel.findById(adminId);
    if (!admin || admin.role !== 'admin') {
      return res.status(403).json({ success: false, message: 'Access denied' });
    }

    const department = admin.department;

    // 2. Fetch complaints by department
    const complaints = await Complaint.find({ complaintType: department }).sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      count: complaints.length,
      data: complaints
    });
  } catch (error) {
    console.error('Error fetching department complaints:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});


ComplaintRouter.get('/complaint-stats', verifyToken, async (req, res) => {
  try {
    const adminId = req.user.id;

    // 1. Get admin info from DB
    const admin = await adminModel.findById(adminId);
    if (!admin || admin.role !== 'admin') {
      return res.status(403).json({ success: false, message: 'Access denied' });
    }

    const department = admin.department;

    // 2. Count complaints for that department
    const [total, resolved, dispute] = await Promise.all([
      Complaint.countDocuments({ complaintType: department }),
      Complaint.countDocuments({ complaintType: department, status: 'Resolved' }),
      Complaint.countDocuments({ complaintType: department, status: 'Dispute' }),
    ]);

    // 3. Return the counts
    res.status(200).json({
      success: true,
      stats: {
        total,
        resolved,
        dispute,
      },
    });

  } catch (err) {
    console.error('Error fetching complaint stats:', err);
    res.status(500).json({ success: false, message: 'Server error while fetching stats' });
  }
});


module.exports = { ComplaintRouter };