const { usermd } = require('../../db');
const bcrypt = require('bcryptjs');
const crypto = require('crypto');
const nodemailer = require('nodemailer');

module.exports = {
  updatePassword: async (req, res) => { try {
    
      const userId = req.user.id;
      const { currentPassword, newPassword } = req.body;
  
      // . Input Validation
      if (!currentPassword || !newPassword) {
        return res.status(400).json({ message: 'Both old and new passwords are required.' });
      }
  
      //  Fetch user from DB
      const user = await usermd.findById(userId);
  
      if (!user) {
        return res.status(404).json({ message: 'User not found' });
      }
  
      //  Check if old password matches
      const isMatch = await bcrypt.compare(currentPassword, user.password);
      if (!isMatch) {
        return res.status(401).json({ message: 'Old password is incorrect.' });
      }
  
      //  Hash the new password
      const salt = await bcrypt.genSalt(10);
      const hashedPassword = await bcrypt.hash(newPassword, salt);
  
      //  Update the password in the database
      user.password = hashedPassword;
      await user.save();
  
      // Send success response
      res.status(200).json({ message: 'Password updated successfully.' });
    } catch (error) {
      console.error('Password Update Error:', error.message);
      res.status(500).json({ message: 'Server Error' });
    } },
  forgotPassword: async (req, res) => { const { email } = req.body;
      try {
      const user = await usermd.findOne({ email });
      if (!user) {
        return res.status(404).json({ message: 'Email is not registered.' });
      }
      
      const resetToken = crypto.randomBytes(32).toString('hex');
      const tokenExpiry = Date.now() + 3600000; // 1 hour expiry
  
      // ✅ 3. Save token and expiry to the user record
      user.resetToken = resetToken;
      user.resetTokenExpiry = tokenExpiry;
      await user.save();

      // ✅ 4. Send the reset link to the user's email
      const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
          user: process.env.EMAIL_USER,
          pass: process.env.EMAIL_PASS,
        },
      });
  
      const resetUrl = `https://93e2-103-185-109-76.ngrok-free.app/reset-password/${resetToken}`;
    
      const mailOptions = {
        from: process.env.EMAIL_USER,
        to: user.email,
        title: 'JanSuvidha',
        subject: 'Password Reset Request',
        html: `<p>Click the link to reset your password: <a href="${resetUrl}">Reset Password</a></p>`,
      };
  
      await transporter.sendMail(mailOptions);
  
      res.status(200).json({ message: 'Password reset link sent to your email.' });
    } catch (error) {
      console.error(error.message);
      res.status(500).json({ message: 'Server Error' });
    } },
  resetPassword: async (req, res) => { const { token } = req.params;
    const { newPassword } = req.body;
  console.log(token)
    try {
      // ✅ 1. Find user with matching token and not expired
      const user = await usermd.findOne({
        resetToken: token,
        resetTokenExpiry: { $gt: Date.now() },
      });
  
      if (!user) {
        return res.status(400).json({ message: 'Invalid or expired reset token.' });
      }
  
      // ✅ 2. Hash the new password
      const salt = await bcrypt.genSalt(10);
      user.password = await bcrypt.hash(newPassword, salt);
  
      // ✅ 3. Clear the reset token
      user.resetToken = undefined;
      user.resetTokenExpiry = undefined;
      await user.save();
  
      res.status(200).json({ message: 'Password updated successfully!' });
    } catch (error) {
      console.error(error.message);
      res.status(500).json({ message: 'Server Error' });
    } }
};