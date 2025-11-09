const express = require('express');
const rateLimit = require('express-rate-limit');
const router = express.Router();
// Use Prisma controller with PostgreSQL
const { sendOTP, verifyOTP, getMe } = require('../controllers/authController');
const { protect } = require('../middleware/auth');

// Rate limiter for OTP sending - max 3 requests per 15 minutes per IP
const otpLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 3, // Limit each IP to 3 OTP requests per windowMs
  message: {
    success: false,
    message: 'Too many OTP requests from this IP, please try again after 15 minutes'
  },
  standardHeaders: true, // Return rate limit info in the `RateLimit-*` headers
  legacyHeaders: false, // Disable the `X-RateLimit-*` headers
});

// Rate limiter for OTP verification - max 5 attempts per 15 minutes per IP
const verifyLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // Limit each IP to 5 verification attempts per windowMs
  message: {
    success: false,
    message: 'Too many verification attempts, please try again after 15 minutes'
  },
  standardHeaders: true,
  legacyHeaders: false,
});

router.post('/send-otp', otpLimiter, sendOTP);
router.post('/verify-otp', verifyLimiter, verifyOTP);
router.get('/me', protect, getMe);

module.exports = router;
