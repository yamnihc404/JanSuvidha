const { Router } = require('express');
const router = Router();
const controller = require('./password.controller');
const { verifyToken } = require('../../middleware');

router.post('/update', verifyToken, controller.updatePassword);
router.post('/forgot', controller.forgotPassword);
router.post('/reset/:token', controller.resetPassword);

module.exports = router;