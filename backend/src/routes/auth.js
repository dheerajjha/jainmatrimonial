const express = require('express');
const router = express.Router();
// Use Prisma controller with PostgreSQL
const { sendOTP, verifyOTP, getMe } = require('../controllers/authController');
const { protect } = require('../middleware/auth');

router.post('/send-otp', sendOTP);
router.post('/verify-otp', verifyOTP);
router.get('/me', protect, getMe);

module.exports = router;
