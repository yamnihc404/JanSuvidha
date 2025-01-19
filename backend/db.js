const mongoose = require('mongoose');


mongoose.connect("mongodb+srv://kamblechinmay8:Chinmay%408@cluster0.kgcnr.mongodb.net/JanSuvidha").then(()=>{console.log("Database Connected")});


const userSchema = new mongoose.Schema({
    username: { type: String, required: true, unique: true, unique: true},
    email: { type: String, required: true, unique: true},
    aadharnumber: { type: String, required: true, unique: true},
    contactnumber: { type: String, required: true,unique: true},
    password: { type: String, required: true },
  });


const usermd = mongoose.model('User', userSchema);

module.exports = usermd;

