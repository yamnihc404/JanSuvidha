const mongoose = require('mongoose');


mongoose.connect("mongodb+srv://kamblechinmay8:Chinmay%408@cluster0.kgcnr.mongodb.net/JanSuvidha").then(()=>{console.log("Database Connected")});


const userSchema = new mongoose.Schema({
    username: { type: String, required: true, unique: true},
    email: { type: String, required: true, unique: true},
    aadharnumber: { type: String, required: true, unique: true},
    contactnumber: { type: String, required: true,unique: true},
    password: { type: String, required: true },
  });

  const complaintSchema = new mongoose.Schema({
    username: {
      type: String,
      required: true,
      trim: true
    },
    phoneNumber: {
      type: String,
      required: true,
      trim: true,
      match: [/^\d{10}$/, 'Phone number must be exactly 10 digits']
    },
    complaintType: {
      type: String,
      required: true,
      enum: ['Water Supply', 'Road Maintainence', 'Power Outage', 'Waste Management'],
      trim: true
    },
    description: {
      type: String,
      required: true,
      trim: true,
      maxlength: 1000
    },
    image: {
      type: String, // Store the path to the uploaded image
      required: false
    },
    location: {
      type: {
        type: String,
        enum: ['Point'],
        default: 'Point'
      },
      coordinates: {
        type: [Number], // [longitude, latitude]
        required: true
      },
      address: {
        type: String,
        required: false
      }
    },
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true
    },
    status: {
      type: String,
      enum: ['Pending', 'In Progress', 'Resolved', 'Rejected'],
      default: 'Pending'
    },
    createdAt: {
      type: Date,
      default: Date.now
    },
    updatedAt: {
      type: Date,
      default: Date.now
    }
  });
  
complaintSchema.index({ location: '2dsphere' });
  
const Complaint = mongoose.model('Complaint', complaintSchema);
const usermd = mongoose.model('User', userSchema);

module.exports = { usermd, Complaint };

