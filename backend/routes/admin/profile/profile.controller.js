const { adminModel, VerificationRequest } = require('../../../db');
const nodemailer = require('nodemailer');

module.exports = {
  getProfile: async (req, res) => { try {
    const adminId = req.user.id;

    //  Fetch user from the database
    const admin = await adminModel.findById(adminId).select('-password'); // Exclude password field

    if (!admin) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.status(200).json({
      id: admin._id,
      username : admin.fullName,
      email: admin.email,
      phone: admin.contactNumber,
    });

  } catch (error) {
    console.error(error.message);
    res.status(500).json({ message: 'Server Error' });
  } },
    updateEmail: async (req, res) => { },
    confirmEmail: async (req, res) => { }
};