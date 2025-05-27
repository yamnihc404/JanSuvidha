const { VerificationRequest } = require('../../../db');
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
    console.log(req.body);
    
    
    if (!request || request.emailOtp !== otp || request.emailOtpExpiry < Date.now()) {
      return res.status(400).json({ message: 'Invalid or expired OTP' });
    }
    request.emailVerified = true;
    await request.save();
   console.log(request); 
    res.status(200).json({ message: 'Email verified successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Error verifying OTP' });
  } },

  sendPhoneOTP: async (req, res) => {
  const { phone } = req.body;
  try {
    if (!/^\d{10}$/.test(phone)) {
      return res.status(400).json({ message: 'Invalid phone number format' });
    }

    const accountSid = process.env.TWILIO_ACCOUNT_SID;
    const authToken = process.env.TWILIO_AUTH_TOKEN;
    const verifySid = process.env.TWILIO_VERIFY_SERVICE_SID;

    const client = require('twilio')(accountSid, authToken);

    await client.verify.v2.services(verifySid)
      .verifications
      .create({ to: `+91${phone}`, channel: 'sms' });

    res.status(200).json({ message: 'OTP sent via Twilio Verify' });
  } catch (error) {
    console.error('Verify Error:', error);
    res.status(500).json({ message: 'Error sending OTP' });
  }
},

verifyPhoneOTP: async (req, res) => {
  const { phone, otp } = req.body;
  try {
    const accountSid = process.env.TWILIO_ACCOUNT_SID;
    const authToken = process.env.TWILIO_AUTH_TOKEN;
    const verifySid = process.env.TWILIO_VERIFY_SERVICE_SID;

    const client = require('twilio')(accountSid, authToken);

    const verification_check = await client.verify.v2.services(verifySid)
      .verificationChecks
      .create({ to: `+91${phone}`, code: otp });

    if (verification_check.status === 'approved') {
      await VerificationRequest.findOneAndUpdate(
        { phone },
        { phoneVerified: true },
        { upsert: true, new: true }
      );
      return res.status(200).json({ message: 'Phone verified successfully' });
    } else {
      return res.status(400).json({ message: 'Invalid OTP' });
    }
  } catch (error) {
    console.error('Verification Error:', error);
    res.status(500).json({ message: 'Error verifying OTP' });
  }
}

};