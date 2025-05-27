const jwt = require('jsonwebtoken');
const { adminSignupSchema } = require('./auth.validators.js');
const bcrypt = require('bcryptjs');
const {adminModel, RefreshTokenModel} = require('../../../db.js'); 



module.exports = {

  signup: async (req, res) => {
    try {
      // Validate input
      const validatedData = adminSignupSchema.parse(req.body);
      
      const { email, password, fullName, contactNumber, department } = validatedData;

      // Check if admin already exists
      const existingAdmin = await adminModel.findOne({ email });
      if (existingAdmin) {
        return res.status(400).json({ message: "Admin already exists with this email." });
      }

      // Hash password
      const hashedPassword = await bcrypt.hash(password, 10);

      // Create admin
      const newAdmin = new adminModel({
        fullName,
        email,
        password: hashedPassword,
        contactNumber,
        department,
        role: 'admin'
      });

      await newAdmin.save();

      // Respond with success
      res.status(201).json({ message: "Admin account created successfully!" });

    } catch (err) {
      if (err.name === 'ZodError') {
        return res.status(400).json({ message: err.errors[0].message });
      }
      console.error(err);
      res.status(500).json({ message: "Server error during admin signup." });
    }
  },
  signin: async (req, res) => {
    try {
      const { email, password } = req.body;

      if (!email || !password) {
        return res.status(400).json({ message: "Email and password are required." });
      }

      const admin = await adminModel.findOne({ email });
      if (!admin || admin.role !== "admin") {
        return res.status(401).json({ message: "Invalid admin credentials." });
      }

      const isPasswordValid = await bcrypt.compare(password, admin.password);
      if (!isPasswordValid) {
        return res.status(401).json({ message: "Incorrect password." });
      }
       
      const accessToken = jwt.sign({ id: admin._id, role: admin.role }, process.env.ACCESS_TOKEN_SECRET, {
              expiresIn: process.env.ACCESS_TOKEN_EXPIRY,
            });
        
      const refreshToken = jwt.sign({ id: admin._id, role: admin.role }, process.env.REFRESH_TOKEN_SECRET, {
              expiresIn: process.env.REFRESH_TOKEN_EXPIRY,
            });

      await RefreshTokenModel.create({
                token: refreshToken,
                userId : admin._id
            })

      res.status(200).json({
        message: "Login successful",
        accessToken: accessToken,
        refreshToken: refreshToken,
        user: {
          id: admin._id,
          name: admin.fullName,
          email: admin.email,
          department: admin.department,
          role: admin.role
        }
      });
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: "Server error during admin signin." });
    }
  },
  logout: async (req, res) => { const { refreshToken } = req.body;
    try {
      await RefreshTokenModel.findOneAndDelete({ token: refreshToken });
      res.status(200).json({ message: 'User logged out and token removed' });
    } catch (error) {
      res.status(500).json({ message: 'Error during logout' });
    } }
};
