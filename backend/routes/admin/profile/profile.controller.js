const { adminModel, VerificationRequest } = require('../../../db');
const nodemailer = require('nodemailer');

module.exports = {
  getProfile: async (req, res) => { try {
    const adminId = req.user.id;

    //  Fetch user from the database
    const admin = await adminModel.findById(adminId).select('-password'); // Exclude password field

    if (!admin) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.status(200).json({
      id: admin._id,
      username : admin.fullName,
      email: admin.email,
      phone: admin.contactNumber,
    });

  } catch (error) {
    console.error(error.message);
    res.status(500).json({ message: 'Server Error' });
  } },
    updateEmail: async (req, res) => {try {
      const { newEmail } = req.body;
      const adminId = req.user.id;
  
      // Validate new email format
      if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(newEmail)) {
        return res.status(400).json({ message: 'Invalid email format' });
      }
  
      // Check if email exists
      const existingUser = await adminModel.findOne({ email: newEmail });
      if (existingUser) {
        return res.status(400).json({ message: 'Email already in use' });
      }
  
      // Generate and save verification OTP
      const otp = Math.floor(100000 + Math.random() * 900000).toString();
      const otpExpiry = Date.now() + 600000; // 10 minutes
      
      await VerificationRequest.findOneAndUpdate(
        { adminId, newEmail },
        { emailOtp: otp, emailOtpExpiry: otpExpiry, newEmail },
        { upsert: true, new: true }
      );
  
      // Send OTP via email
      const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
          user: process.env.EMAIL_USER,
          pass: process.env.EMAIL_PASS
        }
      });
  
      await transporter.sendMail({
        from: process.env.EMAIL_USER,
        to: newEmail,
        subject: 'Email Update Verification',
        html: `Your verification code is: <b>${otp}</b>`
      });
  
      res.status(200).json({ message: 'Verification OTP sent to new email' });
    } catch (error) {
      res.status(500).json({ message: 'Error initiating email update' });
    } },
    confirmEmail: async (req, res) => {try {
    const { otp, newEmail } = req.body;
    const adminId = req.user.id;

    // Find verification request
    const request = await VerificationRequest.findOne({
      adminId,
      newEmail,
      emailOtpExpiry: { $gt: Date.now() }
    });

    if (!request || request.emailOtp !== otp) {
      return res.status(400).json({ message: 'Invalid or expired OTP' });
    }

    // Update user email
    const user = await adminModel.findByIdAndUpdate(
      adminId,
      { email: newEmail },
      { new: true }
    );

    // Cleanup verification request
    await VerificationRequest.deleteOne({ _id: request._id });

    res.status(200).json({
      message: 'Email updated successfully',
      newEmail: user.email
    });
  } catch (error) {
    res.status(500).json({ message: 'Error confirming email update' });
  } }
};