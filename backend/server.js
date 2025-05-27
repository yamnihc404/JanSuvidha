const express = require('express');
const app = express();
const PORT = 3000;
const cors = require("cors");
const {ComplaintRouter} = require('./routes/complaint');
const path = require('path');
const { NotificationRouter } = require('./routes/notification');
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

app.get('/reset-password/:token', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'reset-password.html'));
});
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
app.use('/complaints', ComplaintRouter);
app.use('/notifications', NotificationRouter);



app.use('/user/auth', require('./routes/user/auth/auth.router'));
app.use('/user/profile', require('./routes/user/profile/profile.router'));
app.use('/user/password', require('./routes/user/password/password.router'));
app.use('/user/verify', require('./routes/user/verification/verification.router'));



app.use('/admin/auth', require('./routes/admin/auth/auth.router'));
app.use('/admin/profile', require('./routes/admin/profile/profile.router'));


app.listen(PORT, ()=>{console.log(`Server is live at ${PORT}`)})
