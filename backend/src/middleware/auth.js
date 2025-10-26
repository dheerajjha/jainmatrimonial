const jwt = require('jsonwebtoken');
const prisma = require('../config/prisma');

exports.protect = async (req, res, next) => {
  let token;

  console.log('🔐 Auth Middleware - Authorization Header:', req.headers.authorization);

  // Check for token in headers
  if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
    token = req.headers.authorization.split(' ')[1];
    console.log('✅ Token extracted:', token.substring(0, 20) + '...');
  }

  if (!token) {
    console.log('❌ No token found');
    return res.status(401).json({
      success: false,
      message: 'Not authorized to access this route'
    });
  }

  try {
    // Verify token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    // Get user from token
    req.user = await prisma.user.findUnique({
      where: { id: decoded.id },
      select: {
        id: true,
        phoneNumber: true,
        role: true,
        isVerified: true
      }
    });

    if (!req.user) {
      return res.status(401).json({
        success: false,
        message: 'User not found'
      });
    }

    next();
  } catch (error) {
    return res.status(401).json({
      success: false,
      message: 'Not authorized to access this route'
    });
  }
};
