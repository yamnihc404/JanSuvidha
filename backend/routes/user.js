const { Router } = require('express');
const UserRouter = Router();
const {usermd,RefreshTokenModel, VerificationRequest} = require(__dirname + '/../db.js');
const {z} = require('zod');
const jwt = require('jsonwebtoken');
const bcrypt = require("bcryptjs");
const {verifyToken, verifyRefreshToken} = require('./middleware');
const { title } = require('process');
require('dotenv').config();
const crypto = require('crypto');
const nodemailer = require('nodemailer');


const REFRESH_TOKEN_SECRET = process.env.REFRESH_TOKEN_SECRET;
const ACCESS_TOKEN_SECRET = process.env.ACCESS_TOKEN_SECRET;
const REFRESH_TOKEN_EXPIRY = '7d';                        
const ACCESS_TOKEN_EXPIRY = '1h';


UserRouter.post('/refresh-token', verifyRefreshToken,async (req, res) => {
    const  refreshToken  = req.headers.authorization;
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
  }
});



const signupschema = z.object({
    username: z.string().min(2,"Atleast 2 Characters needed").max(10,'Username is too long').refine((val)=>/[A-Za-z]/.test(val), 'Password should contain at least one Alphabet Character.'),
    email: z.string().email('Invalid email address'),
    password: z.string().min(8,'Password should contain atleast 8 characters').refine((val)=>/[!@#$%^&*(){}+-.<>]/.test(val),'Password should contain atleast one special character').refine((val)=>/[A-Z]/.test(val), 'Password should contain at least one Uppercase Character.'),
    contactnumber: z.string().regex(/^\d{10}$/, { message: "Contact number must be exactly 10 digits" })
})

UserRouter.post('/signup', async function (req, res) {
    try{
const validatedData = signupschema.parse(req.body);
    const { username, contactnumber, email, password } = validatedData;

    // Check if email and phone are verified
    const emailVerification = await VerificationRequest.findOne({ email, emailVerified: true });
    const phoneVerification = await VerificationRequest.findOne({ contactnumber, phoneVerified: true });

    if (!emailVerification) return res.status(400).json({ message: 'Email not verified' });
    if (!phoneVerification) return res.status(400).json({ message: 'Phone not verified' });

    // Proceed with user creation
    const hashedPassword = await bcrypt.hash(password, 10);
    await usermd.create({ username, contactnumber, email, password: hashedPassword });

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
}
})




UserRouter.post('/signin', async function (req, res) {
  const { email, password } = req.body;
  console.log(req.body)
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
    const accessToken = jwt.sign({ id: user._id }, ACCESS_TOKEN_SECRET, {
      expiresIn: ACCESS_TOKEN_EXPIRY,
    });

    const refreshToken = jwt.sign({ id: user._id }, REFRESH_TOKEN_SECRET, {
      expiresIn: REFRESH_TOKEN_EXPIRY,
    });

    // Store the refresh token
    await RefreshTokenModel.create({
        token: refreshToken,
        userId : user._id
    })

    res.status(200).json({
      token: accessToken,
      refreshToken: refreshToken,
      user: {
        id: user._id,
        username: user.username,
        email: user.email,
        contactnumber: user.contactnumber,
      },
    });

  } catch (error) {
    console.error(error.message);
    res.status(500).json({ message: 'Server Error' });
  }
});

UserRouter.post('/logout', async (req, res) => {
  const { refreshToken } = req.body;

  try {
    await RefreshTokenModel.findOneAndDelete({ token: refreshToken });
    res.status(200).json({ message: 'User logged out and token removed' });
  } catch (error) {
    res.status(500).json({ message: 'Error during logout' });
  }
});

 UserRouter.get('/profile', verifyToken, async (req, res) => {
  try {
    const userId = req.user.id;

    // ✅ Fetch user from the database
    const user = await usermd.findById(userId).select('-password'); // Exclude password field

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.status(200).json({
      id: user._id,
      username: user.username,
      email: user.email,
      phone: user.contactnumber,
    });

  } catch (error) {
    console.error(error.message);
    res.status(500).json({ message: 'Server Error' });
  }
});

UserRouter.post('/update-password', verifyToken, async (req, res) => {
  try {
  
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
  }
});

UserRouter.post('/forgot-password', async (req, res) => {
  const { email } = req.body;

  try {
  
    const user = await usermd.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: 'Email is not registered.' });
    }
console.log("User before update: ", user);
    
    const resetToken = crypto.randomBytes(32).toString('hex');
    const tokenExpiry = Date.now() + 3600000; // 1 hour expiry

    // ✅ 3. Save token and expiry to the user record
    user.resetToken = resetToken;
    user.resetTokenExpiry = tokenExpiry;
    await user.save();
console.log("User after update: ", user);
    // ✅ 4. Send the reset link to the user's email
    const transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS,
      },
    });

    const resetUrl = `https://93e2-103-185-109-76.ngrok-free.app/reset-password/${resetToken}`;
    console.log(resetUrl)
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
  }
});

UserRouter.post('/reset-password/:token', async (req, res) => {
  const { token } = req.params;
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
  }
});

UserRouter.post('/send-email-otp', async (req, res) => {
  const { email } = req.body;
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
  }
});

// Verify Email OTP
UserRouter.post('/verify-email-otp', async (req, res) => {
  const { email, otp } = req.body;
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
  }
});

UserRouter.post('/send-phone-otp', async (req, res) => {
  const { phone } = req.body;
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
  }
});

// Verify Phone OTP
UserRouter.post('/verify-phone-otp', async (req, res) => {
  const { phone, otp } = req.body;
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
  }
});

// Initiate email update
UserRouter.post('/request-email-update', verifyToken, async (req, res) => {
  try {
    const { newEmail } = req.body;
    const userId = req.user.id;

    // Validate new email format
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(newEmail)) {
      return res.status(400).json({ message: 'Invalid email format' });
    }

    // Check if email exists
    const existingUser = await usermd.findOne({ email: newEmail });
    if (existingUser) {
      return res.status(400).json({ message: 'Email already in use' });
    }

    // Generate and save verification OTP
    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    const otpExpiry = Date.now() + 600000; // 10 minutes
    
    await VerificationRequest.findOneAndUpdate(
      { userId, newEmail },
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
  }
});

// Verify and complete email update
UserRouter.post('/confirm-email-update', verifyToken, async (req, res) => {
  try {
    const { otp, newEmail } = req.body;
    const userId = req.user.id;

    // Find verification request
    const request = await VerificationRequest.findOne({
      userId,
      newEmail,
      emailOtpExpiry: { $gt: Date.now() }
    });

    if (!request || request.emailOtp !== otp) {
      return res.status(400).json({ message: 'Invalid or expired OTP' });
    }

    // Update user email
    const user = await usermd.findByIdAndUpdate(
      userId,
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
  }
});


module.exports = {UserRouter};