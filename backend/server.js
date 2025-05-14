const express = require('express');
const app = express();
const {UserRouter} = require('./routes/user');
const PORT = 3000;
const cors = require("cors");
const {ComplaintRouter} = require('./routes/complaint');
const path = require('path');
require('dotenv').config();


app.use(cors());
app.use(express.urlencoded({extended: true}));
app.use(express.json());
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({
      success: false,
      message: 'Something went wrong!'
    });
});

app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
app.use('/user', UserRouter);
app.use('/complaints', ComplaintRouter);


app.listen(PORT, ()=>{console.log(`Server is live at ${PORT}`)})
