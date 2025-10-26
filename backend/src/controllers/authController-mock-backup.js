const { userStorage } = require('../mock-storage');
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
    const expiresAt = new Date(Date.now() + 10 * 60 * 1000); // 10 minutes

    // Find or create user
    let user = userStorage.findByPhone(phoneNumber);

    if (!user) {
      user = userStorage.create({
        phoneNumber,
        role,
        isVerified: false,
        otp: {
          code: await bcrypt.hash(otpCode, 10),
          expiresAt
        }
      });
    } else {
      userStorage.update(phoneNumber, {
        otp: {
          code: await bcrypt.hash(otpCode, 10),
          expiresAt
        }
      });
      user = userStorage.findByPhone(phoneNumber);
    }

    // Send OTP via SMS (logs in development)
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

    const user = userStorage.findByPhone(phoneNumber);

    if (!user || !user.otp || !user.otp.code) {
      return res.status(400).json({
        success: false,
        message: 'Invalid phone number or OTP'
      });
    }

    // Check if OTP expired
    if (new Date() > new Date(user.otp.expiresAt)) {
      return res.status(400).json({
        success: false,
        message: 'OTP has expired'
      });
    }

    // Verify OTP
    const isMatch = await bcrypt.compare(otp, user.otp.code);

    if (!isMatch) {
      return res.status(400).json({
        success: false,
        message: 'Invalid OTP'
      });
    }

    // Mark user as verified
    userStorage.update(phoneNumber, {
      isVerified: true,
      otp: undefined
    });

    const updatedUser = userStorage.findByPhone(phoneNumber);

    // Generate token
    const token = generateToken(updatedUser._id);

    res.status(200).json({
      success: true,
      token,
      user: {
        id: updatedUser._id,
        phoneNumber: updatedUser.phoneNumber,
        role: updatedUser.role,
        isVerified: updatedUser.isVerified
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
    const user = userStorage.findById(req.user.id);

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found'
      });
    }

    // Remove OTP from response
    const { otp, ...userWithoutOtp } = user;

    res.status(200).json({
      success: true,
      user: userWithoutOtp
    });
  } catch (error) {
    console.error('Get Me Error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to get user'
    });
  }
};
