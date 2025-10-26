const prisma = require('../config/prisma');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
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
    const hashedOtp = await bcrypt.hash(otpCode, 10);
    const expiresAt = new Date(Date.now() + 10 * 60 * 1000); // 10 minutes

    // Upsert user (create if doesn't exist, update if exists)
    await prisma.user.upsert({
      where: { phoneNumber },
      update: {
        otpCode: hashedOtp,
        otpExpiresAt: expiresAt
      },
      create: {
        phoneNumber,
        role,
        otpCode: hashedOtp,
        otpExpiresAt: expiresAt
      }
    });

    // Send OTP via SMS
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

    const user = await prisma.user.findUnique({
      where: { phoneNumber }
    });

    if (!user || !user.otpCode) {
      return res.status(400).json({
        success: false,
        message: 'Invalid phone number or OTP'
      });
    }

    // Check if OTP expired
    if (new Date() > user.otpExpiresAt) {
      return res.status(400).json({
        success: false,
        message: 'OTP has expired'
      });
    }

    // Verify OTP
    const isMatch = await bcrypt.compare(otp, user.otpCode);

    if (!isMatch) {
      return res.status(400).json({
        success: false,
        message: 'Invalid OTP'
      });
    }

    // Mark user as verified and clear OTP
    await prisma.user.update({
      where: { phoneNumber },
      data: {
        isVerified: true,
        otpCode: null,
        otpExpiresAt: null
      }
    });

    // Generate token
    const token = generateToken(user.id);

    res.status(200).json({
      success: true,
      token,
      user: {
        id: user.id,
        phoneNumber: user.phoneNumber,
        role: user.role,
        isVerified: true
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
    const user = await prisma.user.findUnique({
      where: { id: req.user.id },
      select: {
        id: true,
        phoneNumber: true,
        role: true,
        isVerified: true,
        createdAt: true
      }
    });

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found'
      });
    }

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
