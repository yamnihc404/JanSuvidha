const express = require('express');
const app = express();
const {UserRouter} = require('./routes/user');
const PORT = 3000;
const cors = require("cors");

app.use(cors());
app.use(express.urlencoded({extended: true}));
app.use(express.json());
app.use('/user', UserRouter);

app.listen(PORT, ()=>{console.log(`Server is live at ${PORT}`)})
