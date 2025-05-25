const { Router } = require('express');
const router = Router();
const controller = require('./profile.controller');
const { verifyToken } = require('../middleware');

router.get('/', verifyToken, controller.getProfile);
router.post('/update-email', verifyToken, controller.updateEmail);
router.post('/confirm-email', verifyToken, controller.confirmEmail);

module.exports = router;