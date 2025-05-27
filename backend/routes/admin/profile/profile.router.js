const { Router } = require('express');
const router = Router();
const controller = require('./profile.controller');
const { verifyToken } = require('../../middleware');

router.get('/', verifyToken, controller.getProfile);


module.exports = router;