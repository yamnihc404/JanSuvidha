const mongoose = require('mongoose');
require('dotenv').config();


DB_URL = process.env.DB_URL;


mongoose.connect(DB_URL).then(()=>{console.log("Database Connected")});


const userSchema = new mongoose.Schema({
    username: { type: String, required: true, unique: true},
    email: { type: String, required: true, unique: true},
    contactnumber: { type: String, required: true,unique: true},
    password: { type: String, required: true },
    resetToken: { type: String, default: null },              // ✅ Should be a String
  resetTokenExpiry: { type: Date, default: null },
  });

  const complaintSchema = new mongoose.Schema({
    complaintType: {
      type: String,
      required: true,
      enum: ['Water Supply', 'Road Maintenance', 'Power Outage', 'Waste Management'],
      trim: true
    },
    description: {
      type: String,
      required: true,
      trim: true,
      maxlength: 1000
    },
    shortDescription: {
      type : String,
      required: true,
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
      enum: ['Pending', 'In Progress', 'Resolved', 'Rejected', 'Dispute'],
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

const RefreshTokenSchema = new mongoose.Schema({
  token: { type: String, required: true },
  userId: { 
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',                         
    required: true 
  },
});
  
complaintSchema.index({ location: '2dsphere' });
  
const Complaint = mongoose.model('Complaint', complaintSchema);
const usermd = mongoose.model('User', userSchema);
const RefreshTokenModel = mongoose.model('RefreshToken', RefreshTokenSchema);

module.exports = { usermd, Complaint,  RefreshTokenModel};

