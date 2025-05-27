const { Router } = require('express');
const router = Router();
const controller = require('./auth.controller');

router.post('/signup', controller.signup);
router.post('/signin', controller.signin);


module.exports = router;