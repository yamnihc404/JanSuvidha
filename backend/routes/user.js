const { Router } = require('express');
const UserRouter = Router();
const {usermd,RefreshTokenModel} = require(__dirname + '/../db.js');
const {z} = require('zod');
const jwt = require('jsonwebtoken');
const bcrypt = require("bcryptjs");
const {verifyToken, verifyRefreshToken} = require('./middleware');
require('dotenv').config();


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
const {username: username, contactnumber: contactnumber, email : email, password: password} = validatedData;

const hashedPassword = await bcrypt.hash(password, 10);
    await usermd.create(
        {
            username: username,
            contactnumber: contactnumber,
            email: email,
            password: hashedPassword
        }
    );

    res.json({message: 'User Signed up successfully'})

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
  const { username, password } = req.body;

  try {
    // Find the user
    const user = await usermd.findOne({ username });
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

 
module.exports = {UserRouter};