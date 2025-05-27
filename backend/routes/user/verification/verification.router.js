const { Router } = require('express');
const router = Router();
const controller = require('./verification.controller');

router.post('/email-otp', controller.sendEmailOTP);
router.post('/verify-email', controller.verifyEmailOTP);
router.post('/phone-otp', controller.sendPhoneOTP);
router.post('/verify-phone', controller.verifyPhoneOTP);

module.exports = router;