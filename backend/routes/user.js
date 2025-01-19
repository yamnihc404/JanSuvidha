const { Router } = require('express');
const UserRouter = Router();
const usermd = require(__dirname + '/../db.js');
const {z} = require('zod');
const jwt = require('jsonwebtoken');
const SECRECT_KEY = 'chinmay123';
const bcrypt = require("bcryptjs");

function auth(req, res, next) {
const token = req.headers.authorization;
const isValid = jwt.verify(token, SECRECT_KEY);
if(isValid){
    req.body.id = isValid.id;
    console.log(isValid.id);
    next();  
}
else{
    res.status(400).json({message: "Invalid Token"});
}
}



const signupschema = z.object({
    username: z.string().min(2,"Atleast 2 Characters needed").max(10,'Username is too long').refine((val)=>/[A-Za-z]/.test(val), 'Password should contain at least one Alphabet Character.'),
    email: z.string().email('Invalid email address'),
    password: z.string().min(8,'Password should contain atleast 8 characters').refine((val)=>/[!@#$%^&*(){}+-.<>]/.test(val),'Password should contain atleast one special character').refine((val)=>/[A-Z]/.test(val), 'Password should contain at least one Uppercase Character.'),
    contactnumber: z.string().regex(/^\d{10}$/, { message: "Contact number must be exactly 10 digits" }),
    aadharnumber: z.string().regex(/^\d{12}$/, { message: "Invalid Aadhar Number" }),
})

UserRouter.post('/signup', async function (req, res) {
    try{
const validatedData = signupschema.parse(req.body);
const {username: username, contactnumber: contactnumber, email : email, password: password, aadharnumber : aadharnumber} = validatedData;

const hashedPassword = await bcrypt.hash(password, 10);
    await usermd.create(
        {
            username: username,
            contactnumber: contactnumber,
            aadharnumber: aadharnumber,
            email: email,
            password: hashedPassword
        }
    );

    res.json({message: 'User Signed up successfully'})

    }catch(error){
        if(error instanceof z.ZodError){
            res.status(400).json({error:error})
        }
        else{
            res.status(400).json({message: "User already Signed up"})
        }
    }
})




UserRouter.post('/signin', async function (req, res) {

    try{

    const {username : username, password : password} = req.body;

    const response = await usermd.findOne({ username: username});
    if (!response) {
        return res.status(404).json({ message: "User not found" });
    }

    const user = await bcrypt.compare(password, response.password);
    if (!user) {
        return res.status(401).json({ message: "Invalid credentials" });
    }
    
        const token = jwt.sign({id:response._id.toString()}, SECRECT_KEY,{ expiresIn: "1h" });
        res.json({token:token});
    } 
    catch(error){
        console.error("Sign-in error:", error);
    }   
    })

 
module.exports = {UserRouter:UserRouter};