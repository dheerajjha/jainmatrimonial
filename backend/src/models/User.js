const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
  phoneNumber: {
    type: String,
    required: true,
    unique: true,
    trim: true
  },
  isVerified: {
    type: Boolean,
    default: false
  },
  otp: {
    code: String,
    expiresAt: Date
  },
  role: {
    type: String,
    enum: ['parent', 'self', 'admin'],
    required: true
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
}, {
  timestamps: true
});

// Hash OTP before saving
userSchema.pre('save', async function(next) {
  if (this.isModified('otp.code')) {
    this.otp.code = await bcrypt.hash(this.otp.code, 10);
  }
  next();
});

// Method to compare OTP
userSchema.methods.compareOTP = async function(enteredOTP) {
  return await bcrypt.compare(enteredOTP, this.otp.code);
};

module.exports = mongoose.model('User', userSchema);
