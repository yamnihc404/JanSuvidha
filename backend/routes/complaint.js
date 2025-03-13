const { Router } = require('express');
const ComplaintRouter = Router();
const {Complaint} = require('../db');
const { z } = require('zod');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const jwt = require('jsonwebtoken');
const SECRECT_KEY = 'chinmay123';

// Auth middleware (reusing your existing auth function)
function auth(req, res, next) {
  const token = req.headers.authorization;
  try {
    const isValid = jwt.verify(token, SECRECT_KEY);
    if (isValid) {
      req.user = { id: isValid.id };
      next();
    } else {
      res.status(401).json({ message: "Invalid Token" });
    }
  } catch (error) {
    res.status(401).json({ message: "Authentication failed" });
  }
}

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
  phoneNumber: z.string().regex(/^\d{10}$/, { message: "Phone number must be exactly 10 digits" }),
  latitude: z.string().refine((val) => !isNaN(parseFloat(val)), "Latitude must be a valid number"),
  longitude: z.string().refine((val) => !isNaN(parseFloat(val)), "Longitude must be a valid number"),
  address: z.string().optional(),
  
});

// Create complaint endpoint
ComplaintRouter.post('/', auth, upload.single('image'), async function(req, res) {
  try {
    // Extract username from authenticated user
    const userId = req.user.id;
    console.log("Received file:", req.file);
    console.log("User ID from token:", userId);
    // Validate request data
    const validatedData = complaintSchema.parse(req.body);
  
    // Create new complaint
     const newComplaint = await Complaint.create({
      username: req.body.username,
      phoneNumber: validatedData.phoneNumber,
      complaintType: validatedData.complaintType,
      description: validatedData.description,
      image: req.file ? `/uploads/complaints/${req.file.filename}` : null,
      location: {
        type: 'Point',
        coordinates: [parseFloat(validatedData.longitude), parseFloat(validatedData.latitude)],
        address: validatedData.address || null
      },
      userId: userId,
      status : "Pending"
    });
    res.status(201).json({
      success: true,
      message: 'Complaint submitted successfully',
      data: {
        complaintId: newComplaint._id,
        status: newComplaint.status
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
ComplaintRouter.get('/my-complaints', auth, async function(req, res) {
  try {
    const userId = req.body.userId;
    const complaints = await Complaint.find({ userId: userId }).sort({ createdAt: -1 });
    
    res.status(200).json({
      success: true,
      count: complaints.length,
      data: complaints
    });
  } catch (error) {
    console.error('Error fetching complaints:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch complaints'
    });
  }
});

// Get complaint by ID
ComplaintRouter.get('/:id', auth, async function(req, res) {
  try {
    const complaint = await Complaint.findById(req.params.id);
    
    if (!complaint) {
      return res.status(404).json({
        success: false,
        message: 'Complaint not found'
      });
    }
    
    // Check if complaint belongs to requesting user
    if (complaint.userId.toString() !== req.body.userId) {
      return res.status(403).json({
        success: false,
        message: 'Not authorized to access this complaint'
      });
    }
    
    res.status(200).json({
      success: true,
      data: complaint
    });
  } catch (error) {
    console.error('Error fetching complaint:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch complaint details'
    });
  }
});

module.exports = { ComplaintRouter };