const jwt = require('jsonwebtoken');
require('dotenv').config();

REFRESH_TOKEN_SECRET = process.env.REFRESH_TOKEN_SECRET;
ACCESS_TOKEN_SECRET = process.env.ACCESS_TOKEN_SECRET;


const verifyToken = (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader) return res.status(401).json({ message: 'No token provided.' });

  const token = authHeader.split(' ')[1];
  jwt.verify(token, ACCESS_TOKEN_SECRET, (err, user) => {
    if (err) return res.status(403).json({ message: 'Invalid or expired token.' });
    req.user = user;
    next();
  });
};

const verifyRefreshToken = (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (!authHeader) return res.status(401).json({ message: 'No token provided.' });

  const token = authHeader.split(' ')[1];


  jwt.verify(token, REFRESH_TOKEN_SECRET, (err, user) => {
    if (err) return res.status(403).json({ message: 'Invalid or expired refresh token.' });
    req.user = user;
    next();
  });
};

module.exports = { verifyToken, verifyRefreshToken };
