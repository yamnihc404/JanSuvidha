const { usermd, RefreshTokenModel ,VerificationRequest} = require('../../../db.js');
const { z } = require('zod');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { signupschema } = require('./auth.validators.js');
require('dotenv').config();


module.exports = {
  signup: async (req, res) => {  try{
  const validatedData = signupschema.parse(req.body);
  const { fullName, contactNumber, email, password } = validatedData;
  
      // Check if email and phone are verified
      const emailVerification = await VerificationRequest.findOne({ email, emailVerified: true });
      const phoneVerification = await VerificationRequest.findOne({ contactNumber, phoneVerified: true });
  
      if (!emailVerification) return res.status(400).json({ message: 'Email not verified' });
      if (!phoneVerification) return res.status(400).json({ message: 'Phone not verified' });
  
      // Proceed with user creation
      const hashedPassword = await bcrypt.hash(password, 10);
      await usermd.create({ fullName, contactNumber, email, password: hashedPassword });
  
      res.json({ message: 'User signed up successfully' });
  
      }catch(error){
          if(error instanceof z.ZodError){
             return  res.status(400).json({error: error.issues.map(issue => issue.message)})
          }
          else if (error.code === 11000) {  
              return res.status(400).json({ message: "User with this email or Aadhaar number already exists" });
          }
          else{
              return res.status(500).json({ message: "Internal Server Error", error: error.message });
          }
  }},

  signin: async (req, res) => {const { email, password } = req.body;
   
    try {
      // Find the user
      const user = await usermd.findOne({ email });
      if (!user) {
        return res.status(400).json({ message: 'User not found.' });
      }
  
      // Validate password
      const isValidPassword = await bcrypt.compare(password, user.password);
      if (!isValidPassword) {
        return res.status(400).json({ message: 'Invalid password.' });
      }
  
      // Generate Access Token and Refresh Token
      const accessToken = jwt.sign({ id: user._id, role: user.role  }, process.env.ACCESS_TOKEN_SECRET, {
        expiresIn: process.env.ACCESS_TOKEN_EXPIRY,
      });
  
      const refreshToken = jwt.sign({ id: user._id, role: user.role }, process.env.REFRESH_TOKEN_SECRET, {
        expiresIn: process.env.REFRESH_TOKEN_EXPIRY,
      });
  
      // Store the refresh token
      await RefreshTokenModel.create({
          token: refreshToken,
          userId : user._id
      })
  
      res.status(200).json({
        accessToken: accessToken,
        refreshToken: refreshToken,
        user: {
          id: user._id,
          name: user.username,
          email: user.email,
          contactnumber: user.contactnumber,
          role: user.role
        },
      });
  
    } catch (error) {
      console.error(error.message);
      res.status(500).json({ message: 'Server Error' });
    } },

  refreshToken: async (req, res) => { const  refreshToken  = req.headers.authorization;
       if (!refreshToken) return res.status(401).json({ message: 'No token provided.' });
    try {
      const token = refreshToken.split(' ')[1];
  
      const storedToken = await RefreshTokenModel.findOne({ token: token });
  
      if (!storedToken) {
        return res.status(403).json({ message: 'Invalid or expired refresh token' });
      }
      
      const payload = jwt.verify(token, process.env.REFRESH_TOKEN_SECRET);
      const newAccessToken = jwt.sign({ id: payload.id }, process.env.ACCESS_TOKEN_SECRET, {
        expiresIn: '1h',
      });
  
      res.status(200).json({ accessToken: newAccessToken });
    } catch (error) {
      res.status(403).json({ message: 'Invalid or expired refresh token' });
    } },

  logout: async (req, res) => { const { refreshToken } = req.body;
  try {
    await RefreshTokenModel.findOneAndDelete({ token: refreshToken });
    res.status(200).json({ message: 'User logged out and token removed' });
  } catch (error) {
    res.status(500).json({ message: 'Error during logout' });
  } }
};