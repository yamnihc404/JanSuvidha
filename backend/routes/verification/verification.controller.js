const { VerificationRequest } = require('../../db');
const nodemailer = require('nodemailer');
const twilio = require('twilio');

module.exports = {
  sendEmailOTP: async (req, res) => { const { email } = req.body;
    const otp = Math.floor(10000 * Math.random() ).toString();
    const otpExpiry = Date.now() + 60000 * 5; 
  
    try {
      await VerificationRequest.findOneAndUpdate(
        { email },
        { emailOtp: otp, emailOtpExpiry: otpExpiry },
        { upsert: true, new: true }
      );
  
      // Send OTP via Email (using nodemailer)
      const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: { user: process.env.EMAIL_USER, pass: process.env.EMAIL_PASS }
      });
  
      await transporter.sendMail({
        from: process.env.EMAIL_USER,
        to: email,
        subject: 'Email Verification OTP',
        html: `Your OTP is <b>${otp}</b>`
      });
  
      res.status(200).json({ message: 'OTP sent to email' });
    } catch (error) {
      res.status(500).json({ message: 'Error sending OTP' });
    } },
    
  verifyEmailOTP: async (req, res) => { const { email, otp } = req.body;
  try {
    const request = await VerificationRequest.findOne({ email });
    if (!request || request.emailOtp !== otp || request.emailOtpExpiry < Date.now()) {
      return res.status(400).json({ message: 'Invalid or expired OTP' });
    }
    request.emailVerified = true;
    await request.save();
    res.status(200).json({ message: 'Email verified successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Error verifying OTP' });
  } },

  sendPhoneOTP: async (req, res) => { const { phone } = req.body;
  const otp = Math.floor(100000 + Math.random() * 900000).toString();
  const otpExpiry = Date.now() + 60000; // 1 minute

  try {
    // Validate phone number format
    if (!/^\d{10}$/.test(phone)) {
      return res.status(400).json({ message: 'Invalid phone number format' });
    }

    await VerificationRequest.findOneAndUpdate(
      { phone },
      { phoneOtp: otp, phoneOtpExpiry: otpExpiry },
      { upsert: true, new: true }
    );

    // Send OTP via SMS (using Twilio)
    const accountSid = process.env.TWILIO_ACCOUNT_SID;
    const authToken = process.env.TWILIO_AUTH_TOKEN;
    const client = require('twilio')(accountSid, authToken);

    await client.messages.create({
      body: `Your OTP is ${otp}`,
      from: process.env.TWILIO_PHONE_NUMBER,
      to: `+91${phone}` // Assuming Indian numbers
    });

    res.status(200).json({ message: 'OTP sent to phone' });
  } catch (error) {
    console.error('SMS Error:', error);
    res.status(500).json({ message: 'Error sending OTP' });
  } },

  verifyPhoneOTP: async (req, res) => { const { phone, otp } = req.body;
  try {
    const request = await VerificationRequest.findOne({ phone });
    if (!request || request.phoneOtp !== otp || request.phoneOtpExpiry < Date.now()) {
      return res.status(400).json({ message: 'Invalid or expired OTP' });
    }
    request.phoneVerified = true;
    await request.save();
    res.status(200).json({ message: 'Phone verified successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Error verifying OTP' });
  } }
};