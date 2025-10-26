const User = require('../models/User');
const jwt = require('jsonwebtoken');
const { sendOTP } = require('../utils/sms');

// Generate JWT Token
const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRE
  });
};

// @desc    Send OTP to phone number
// @route   POST /api/auth/send-otp
// @access  Public
exports.sendOTP = async (req, res) => {
  try {
    const { phoneNumber, role } = req.body;

    if (!phoneNumber || !role) {
      return res.status(400).json({
        success: false,
        message: 'Please provide phone number and role'
      });
    }

    // Generate 6-digit OTP
    const otpCode = Math.floor(100000 + Math.random() * 900000).toString();
    const expiresAt = new Date(Date.now() + 10 * 60 * 1000); // 10 minutes

    // Find or create user
    let user = await User.findOne({ phoneNumber });

    if (!user) {
      user = await User.create({
        phoneNumber,
        role,
        otp: {
          code: otpCode,
          expiresAt
        }
      });
    } else {
      user.otp = {
        code: otpCode,
        expiresAt
      };
      await user.save();
    }

    // Send OTP via SMS (implement with Twilio)
    await sendOTP(phoneNumber, otpCode);

    res.status(200).json({
      success: true,
      message: 'OTP sent successfully'
    });

  } catch (error) {
    console.error('Send OTP Error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to send OTP'
    });
  }
};

// @desc    Verify OTP and login
// @route   POST /api/auth/verify-otp
// @access  Public
exports.verifyOTP = async (req, res) => {
  try {
    const { phoneNumber, otp } = req.body;

    if (!phoneNumber || !otp) {
      return res.status(400).json({
        success: false,
        message: 'Please provide phone number and OTP'
      });
    }

    const user = await User.findOne({ phoneNumber });

    if (!user || !user.otp.code) {
      return res.status(400).json({
        success: false,
        message: 'Invalid phone number or OTP'
      });
    }

    // Check if OTP expired
    if (new Date() > user.otp.expiresAt) {
      return res.status(400).json({
        success: false,
        message: 'OTP has expired'
      });
    }

    // Verify OTP
    const isMatch = await user.compareOTP(otp);

    if (!isMatch) {
      return res.status(400).json({
        success: false,
        message: 'Invalid OTP'
      });
    }

    // Mark user as verified
    user.isVerified = true;
    user.otp = undefined;
    await user.save();

    // Generate token
    const token = generateToken(user._id);

    res.status(200).json({
      success: true,
      token,
      user: {
        id: user._id,
        phoneNumber: user.phoneNumber,
        role: user.role,
        isVerified: user.isVerified
      }
    });

  } catch (error) {
    console.error('Verify OTP Error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to verify OTP'
    });
  }
};

// @desc    Get current user
// @route   GET /api/auth/me
// @access  Private
exports.getMe = async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select('-otp');

    res.status(200).json({
      success: true,
      user
    });
  } catch (error) {
    console.error('Get Me Error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to get user'
    });
  }
};
