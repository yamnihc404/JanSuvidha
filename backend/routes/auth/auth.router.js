const { Router } = require('express');
const router = Router();
const controller = require('./auth.controller');
const { verifyRefreshToken } = require('../middleware');

router.post('/signup', controller.signup);
router.post('/signin', controller.signin);
router.post('/refresh-token', verifyRefreshToken, controller.refreshToken);
router.post('/logout', controller.logout);

module.exports = router;